/**
 * Perform intersection checks using both bounding box subdivision and Fat Line clipping
 */

ViewPort main, fatline, subdiv;
Point[] points;
Bezier3 c1;
Bezier3 c2;
int boxsize = 200;

// REQUIRED METHOD
void setup()
{
	size(50 + 3*(boxsize+50),50+boxsize+50);
	noLoop();
	setupPoints();
	setupViewPorts();
	text("",0,0);
}

/**
 * Set up four points, to form a cubic curve, and a static curve that is used for intersection checks
 */
void setupPoints()
{
	points = new Point[8];
	points[0] = new Point(25,65);
	points[1] = new Point(155,20);
	points[2] = new Point(50,210);
	points[3] = new Point(180,130);

	points[4] = new Point(130,205);
	points[5] = new Point(190,60);
	points[6] = new Point(20,160);
	points[7] = new Point(60,15);

  Point[] c1points = new Point[4];
  c1points[0] = points[0];
  c1points[1] = points[1];
  c1points[2] = points[2];
  c1points[3] = points[3];
	c1 = new Bezier3();
	c1.points = c1points;

  Point[] c2points = new Point[4];
  c2points[0] = points[4];
  c2points[1] = points[5];
  c2points[2] = points[6];
  c2points[3] = points[7];
	c2 = new Bezier3();
	c2.points = c2points;
}


/**
 * Set up three 'view ports', because we'll be drawing three different things
 */
void setupViewPorts()
{
	main = new ViewPort(50+0,50,boxsize,boxsize);
	fatline = new ViewPort(50+250,50,boxsize,boxsize);
	subdiv = new ViewPort(50+500,50,boxsize,boxsize);
}

// REQUIRED METHOD
void draw()
{
	noFill();
	stroke(0);
	background(255);
	drawCurves();
	drawViewPorts();
	drawExtras();
}

float FL_duration;
float BB_duration;

/**
 * Draw all the viewport graphics
 * (axes, labels, numbering, etc)
 */
void drawViewPorts()
{
	main.drawText("curves", -20,-25, 0,0,0,255);
	main.drawLine(0,0,0,main.height,	0,0,0,255);
	main.drawLine(0,0,main.width,0,	0,0,0,255);

	fatline.drawText("fat line intersection ("+FL_duration+"ms)", -20,-25, 0,0,0,255);
	fatline.drawLine(0,0,0,main.height,	0,0,0,255);
	fatline.drawLine(0,0,main.width,0,	0,0,0,255);

	subdiv.drawText("bounding box intersection ("+BB_duration+"ms)", -20,-25, 0,0,0,255);
	subdiv.drawLine(0,0,0,main.height,	0,0,0,255);
	subdiv.drawLine(0,0,main.width,0,	0,0,0,255);
}

/**
 * Run through the entire interval [0,1] for 't', and generate
 * the corresponding fx(t) and fy(t) values at each 't' value.
 * Then draw those as points in three places: once as mixed
 * parametric curve, and twice as component single curves
 */
void drawCurves()
{
  c1.setShowControlPoints(true);
  c2.setShowControlPoints(true);

  c1.draw(main.ox, main.oy);
  c2.draw(main.ox, main.oy);

  c1.setShowControlPoints(false);
  c2.setShowControlPoints(false);

  float FL_start = millis();
  IntersectionFinder FL_finder = new FatLineIntersectionFinder();
  double[][] FL_intersections = FL_finder.findIntersectionsFor(new Bezier3(c1),new Bezier3(c2));
  FL_duration = millis() - FL_start;
  //println("intersections (time required: "+FL_duration+"ms):");
//  c1.draw(fatline.ox, fatline.oy);
//  c2.draw(fatline.ox, fatline.oy);
  for(double[] d: FL_intersections) {
    double x1 = c1.getX(d[0]);
    double y1 = c1.getY(d[0]);
    fatline.drawEllipse(x1,y1,4,4,  255,0,0,255);
    double x2 = c2.getX(d[1]);
    double y2 = c2.getY(d[1]);
    fatline.drawEllipse(x2,y2,4,4,  0,0,255,255);
  }

  float BB_start = millis();
  IntersectionFinder BB_finder = new BoundingBoxIntersectionFinder();
  double[][] BB_intersections = BB_finder.findIntersectionsFor(new Bezier3(c1),new Bezier3(c2));
  BB_duration = millis() - BB_start;
  //println("intersections (time required: "+BB_duration+"ms):");
  c1.draw(subdiv.ox, subdiv.oy);
  c2.draw(subdiv.ox, subdiv.oy);
  for(double[] d: BB_intersections) {
    double x1 = c1.getX(d[0]);
    double y1 = c1.getY(d[0]);
    subdiv.drawEllipse(x1,y1,4,4,  255,0,0,255);
    double x2 = c2.getX(d[1]);
    double y2 = c2.getY(d[1]);
    subdiv.drawEllipse(x2,y2,4,4,  0,0,255,255);
  }
}


/**
 * For nice visuals, make the curve's fixed points stand out,
 * and draw the lines connecting the start/end and control point.
 * Also, we label each coordinate with its x/y value, for clarity.
 */
void drawExtras()
{
	showPointsInViewPort(points,main);
	stroke(0,75);
	main.drawLine(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), 0,0,0,75);
	main.drawLine(points[2].getX(), points[2].getY(), points[3].getX(), points[3].getY(), 0,0,0,75);

	main.drawLine(points[4].getX(), points[4].getY(), points[5].getX(), points[5].getY(), 0,0,0,75);
	main.drawLine(points[6].getX(), points[6].getY(), points[7].getX(), points[7].getY(), 0,0,0,75);
}

// ================================
// ================================

interface IntersectionFinder
{
  double[][] findIntersectionsFor(Bezier3 c1, Bezier3 c2);
}

// ================================

class FatLineIntersectionFinder implements IntersectionFinder
{

  ArrayList<CurvePair> curvepairs;
  ArrayList<CurvePair> finals;

  /*

    Try iteration
       [clip] -> swap curves and recurse
       [noclip] -> split curves ---> try iteration
                                 `-> try iteration

  */

  double[][] findIntersectionsFor(Bezier3 c1, Bezier3 c2)
  {
    curvepairs = new ArrayList<CurvePair>();
    curvepairs.add(new CurvePair(c1,c2));
    finals = new ArrayList<CurvePair>();

    // run
//    while(!iterate()) {}

    iterate();
    iterate();
    iterate();

    // =======================================
    // FIND OUT WHY THIS DOESN'T WORK TOMORROW
    // =======================================


    for(CurvePair cp: curvepairs)
    {
      cp.curve1.draw(fatline.ox, fatline.oy);
      //println(cp.curve1.toString());
      cp.curve2.draw(fatline.ox, fatline.oy);
      //println(cp.curve2.toString());
    }

    // get the results
    ArrayList<Coordinate> intersections = new ArrayList<Coordinate>();
    for(CurvePair cp: finals){
      double[] intersection = cp.getIntersection();
      Coordinate c = new Coordinate(0,0, intersection[2],intersection[3]);
      if(!intersections.contains(c)) { intersections.add(c); }}

    // turn the values into a double[][] form
    double[][] values = new double[intersections.size()][2];
    for(int p=0, end=values.length; p<end; p++) {
      values[p][0] = intersections.get(p).getSubT1();
      values[p][1] = intersections.get(p).getSubT2(); }

    return values;
  }


  boolean iterate()
  {
    boolean finished = true;

    for(int cps=curvepairs.size()-1; cps>=0; cps--)
    {
      CurvePair curvepair = curvepairs.remove(cps);
      Bezier3 c1 = (Bezier3) curvepair.curve1;
      Bezier3 c2 = (Bezier3) curvepair.curve2;
      CurvePair clipped = runPair(c1, c2, c2.getStartT(), c2.getEndT());

      // if no clipping could be performed, try to chop up the curves.
      // if this fails, the curves intersect at subpixel level and
      // we're done.
      if(clipped==null)
      {
        Bezier3 nc2 = (Bezier3) curvepair.curve2;
        double midt = (nc2.getStartT() + nc2.getEndT())/2.0;
        Segment[] split = nc2.splitSegment(midt);

        for(int i=0; i<2; i++) {
          Bezier3 c3 = (Bezier3)split[i];
          c3.computeBoundingBox();
          if(curvesOverlap(c1, c3)) {
            finished = false;
            Bezier3 nc1 = new Bezier3(c1);
            nc1.computeBoundingBox();
            curvepairs.add(new CurvePair(c3, nc1)); }}

        if(finished && !finals.contains(curvepair)) {
          finals.add(curvepair); }
      }

      // clipping could be performed, so we're not done.
      else { finished = false; curvepairs.add(clipped); }
    }
    return finished;
  }

  CurvePair runPair(Bezier3 reference, Bezier3 target, double start_t, double end_t)
  {
    double[] bounds = reference.getBoundingBox();

    // get the distances from C1's baseline to the two other lines
    Point p0 = reference.points[0];
    // offset distances from baseline
    double dx = p0.x - bounds[0];
    double dy = p0.y - bounds[1];
    double d1 = sqrt(dx*dx+dy*dy);
    dx = p0.x - bounds[2];
    dy = p0.y - bounds[3];
    double d2 = sqrt(dx*dx+dy*dy);

    // get the distances from C2's point 0 to the three lines (baseline + max distances)
    Point c2p0 = target.points[0];
    double dxtblue = c2p0.x - bounds[0];
    double dytblue = c2p0.y - bounds[1];
    double dtblue = sqrt(dxtblue*dxtblue + dytblue*dytblue);
    double dxtred = c2p0.x - bounds[2];
    double dytred = c2p0.y - bounds[3];
    double dtred = sqrt(dxtred*dxtred + dytred*dytred);

    // which of d1/d2 is negative, and which is positive?
    if(dtblue <= dtred) { d1 = abs(d1); d2 = -abs(d2); }
    else { d1 = -abs(d1); d2 = abs(d2); }

    // find the expression L: ax + by + c = 0 for the baseline
    Point p3 = reference.points[3];
    dx = (p3.x - p0.x);
    dy = (p3.y - p0.y);

    // if vertical, salt dx ever so slightly. However, this is only for
    // demonstration purposes, and may result in incorrect clipping. Instead,
    // both curves should be uniformly rotated.
    if(dx==0) { dx=0.001; }

    // compute the values for a', b' and c' as expained in the primer.
    double a, b, c;
    a = dy / dx;
    b = -1;
    c = -(a * reference.points[0].x - reference.points[0].y);
    // normalize so that a² + b² = 1
    double scale = sqrt(a*a+1);
    a /= scale; b /= scale; c /= scale;

    // set up the coefficients for the Bernstein polynomial that
    // describes the distance from curve 2 to curve 1's baseline.
    double[] coeff = new double[4];
    for(int i=0; i<4; i++) { coeff[i] = a*target.points[i].x + b*target.points[i].y + c; }
    double[] vals = new double[4];
    for(int i=0; i<4; i++) { vals[i] = computeCubicBaseValue(i*(1/3), coeff[0], coeff[1], coeff[2], coeff[3]); }

    // form the convex hull
    double range = 200;

    ConvexHull ch = new ConvexHull();
    ArrayList hps = new ArrayList();
    hps.add(new Point(range *   0, coeff[0]));
    hps.add(new Point(range * 1/3, coeff[1]));
    hps.add(new Point(range * 2/3, coeff[2]));
    hps.add(new Point(range *   1, coeff[3]));
    Point[] hull = ch.jarvisMarch(hps,-10,-200);

    // to ensure we are performing intersection validation on
    // the correct fat line boundary, we make sure that the lines
    // are such that the convex hull point (0.0, ...) is always
    // above d1.
    if(d1<d2) { double t=d1; d1=d2; d2=t; };

    // are the start and endpoints for the distance function outside of the fat line?
    boolean ssafe = coeff[0]<min(d1,d2) || coeff[0] > max(d1,d2);
    boolean sabove = (coeff[0]>max(d1,d2) ? true : false);
    boolean esafe = coeff[3]<min(d1,d2) || coeff[3] > max(d1,d2);
    boolean eabove = (coeff[3]>max(d1,d2) ? true : false);

    // we start with the safest interval: t1 is 0.0
    double t1 = 0.0;
    // now, are we outside the fat line? if so, we can try to find a better t-value
    if(ssafe)
    {
      // start with the least safe value
      t1 = 1.0;
      // pick the right line for which to perform intersection checking (this is very important)
      double ypos = (sabove? d1 : d2);
      double[] line = {0,ypos,range,ypos};
      // find the two hull edges that join up at the safe point (t=0.0)
      double[][] edges = getEdgesOn(hull, 0.0);
      // now, we have two edges to test for intersection values
      for(int test=0; test<edges.length; test++) {
        double[] intersection = intersectsLineLine(line, edges[test]);
        if(intersection==null) continue;	// unlikely, but safe
        double ix = intersection[0];
        double iy = intersection[1];
        double val = ix/range;
        // is this t-value lower (==safer) than what we already have?
        if(val>=0 && val<=1.0 && t1>val) { t1 = val; }}
      if(t1<0) { t1=0; }
    }

    // we do the same thing for t2, but then in the opposite direction
    double t2 = 1.0;
    if(esafe)
    {
      t2 = 0.0; // least safe value
      double ypos = (eabove? d1 : d2);
      double[] line = {0,ypos,range,ypos};
      double[][] edges = getEdgesOn(hull, 1.0);
      for(int test=0; test<edges.length; test++) {
        double[] intersection = intersectsLineLine(line, edges[test]);
        if(intersection==null) continue;	// unlikely, but safe
        double ix = intersection[0];
        double iy = intersection[1];
        double val = ix/range;
        if(val>=0 && val<=1.0 && t2<val) { t2 = val; }}
      if(t2>1) { t2=1; }
    }

    // ===========================
    // CONTINUE FROM HERE TOMORROW
    // ===========================

    // cutoff criterium. Indicates the curve needs splitting first.
//    if(t1<=start_t || t2>=end_t || t2<=t1) { return null; }
    if((t1==0 && t2==1) || t2<=t1) { return null; }

    // we now have our clipping interval t-values: clip and return new pair
    return new CurvePair((Bezier3)target.splitSegment(t1,t2), reference);
  }
}

// ================================

class BoundingBoxIntersectionFinder implements IntersectionFinder
{
  ArrayList<CurvePair> curvepairs;
  ArrayList<CurvePair> finals;

  /**
   * set up bounding box clipping variables
   */
  double[][] findIntersectionsFor(Bezier3 c1, Bezier3 c2)
  {
    curvepairs = new ArrayList<CurvePair>();
    curvepairs.add(new CurvePair(c1,c2));
    finals = new ArrayList<CurvePair>();

    // run
    while(!iterate()) {}

    // get the results
    ArrayList<Coordinate> intersections = new ArrayList<Coordinate>();
    for(CurvePair cp: finals){
      double[] intersection = cp.getIntersection();
      Coordinate c = new Coordinate(0,0, intersection[2],intersection[3]);
      if(!intersections.contains(c)) { intersections.add(c); }}

    // turn the values into a double[][] form
    double[][] values = new double[intersections.size()][2];
    for(int p=0, end=values.length; p<end; p++) {
      values[p][0] = intersections.get(p).getSubT1();
      values[p][1] = intersections.get(p).getSubT2(); }

    return values;
  }

  /**
   * Perform an iteration step
   */
  boolean iterate()
  {

    // crisis measure
    if(curvepairs.size()>100) {
      println("ERROR: math failz! the list of potential intersections has gotten way too big:");
      for(int cps=curvepairs.size()-1; cps>=0; cps--) {
        CurvePair curvepair = curvepairs.remove(cps);
        println(curvepair.toString()); }
      return true;
    }

    else
    {
      boolean finished = true;

      // subdivide all curves with overlapping bounding boxes.
      // if we're left with more than 0 pairs in the to-do list,
      // we're not finished yet
      for(int cps=curvepairs.size()-1; cps>=0; cps--) {
        CurvePair curvepair = curvepairs.remove(cps);
        ArrayList<CurvePair> subpairs = curvepair.generateSubPairs();
        if(subpairs==null) {
          if(!finals.contains(curvepair)) {
            finals.add(curvepair); }}
        else {
          finished = false;
          for(int ncp=subpairs.size()-1; ncp>=0; ncp--) {
            curvepairs.add(subpairs.get(ncp)); }}}

      return finished;
    }
  }
}