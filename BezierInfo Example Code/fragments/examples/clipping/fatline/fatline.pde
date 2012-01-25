/**
 * Perform intersection checks using both bounding box subdivision and Fat Line clipping
 */

ViewPort main, fatline;
Point[] points;
Bezier3 c1;
Bezier3 c2;
int boxsize = 200;

// REQUIRED METHOD
void setup()
{
	size(50 + 2*(boxsize+50),50+boxsize+50);
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
}

int cstep = 0;

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

void keyPressed()
{
  if(keyCode==10) {
    cstep++;
    redraw(); }
}

/**
 * Draw all the viewport graphics
 * (axes, labels, numbering, etc)
 */
void drawViewPorts()
{
	main.drawText("curves", -20,-25, 0,0,0,255);
	main.drawLine(0,0,0,main.height,	0,0,0,255);
	main.drawLine(0,0,main.width,0,	0,0,0,255);

	fatline.drawText("fat line clipping - "+cstep, -20,-25, 0,0,0,255);
	fatline.drawLine(0,0,0,main.height,	0,0,0,255);
	fatline.drawLine(0,0,main.width,0,	0,0,0,255);
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

  if(cstep==0) { startFL(new Bezier3(c1),new Bezier3(c2)); }

  if(curvepairs.size()>0 && cstep>0)
  {
    iterate();
    for(CurvePair cp: curvepairs) {
      cp.draw(fatline.ox, fatline.oy); }
  }
  else
  {
    println("done ("+finals.size()+" intersections)");

    ArrayList intersections = new ArrayList();
    for(CurvePair cp: finals)
    {
      if(cp.swapped) { cp.swap(); }
      double[] intersection = cp.getIntersection();
      Point p = new Point(intersection[0], intersection[1]);
      if(!intersections.contains(p)) {
        intersections.add(p);
        double t1 = round(1000*intersection[2])/1000.0;
        double t2 = round(1000*intersection[3])/1000.0;
        String tinfo = "t1: "+t1+"\nt2: "+t2;
        fatline.drawText(tinfo, p.x+10, p.y, 0,0,0,100);
        fatline.drawEllipse(p.x, p.y, 4, 4,  200,0,0,255);

        main.drawLine(c1.getX(t1), 0, c1.getX(t1), c1.getY(t1),  255,0,0,100);
        main.drawLine(0,c1.getY(t1), c1.getX(t1), c1.getY(t1), 255,0,0,100);

        main.drawLine(c2.getX(t2), 0, c2.getX(t2), c2.getY(t2),  0,0,255,100);
        main.drawLine(0,c2.getY(t2), c2.getX(t2), c2.getY(t2), 0,0,255,100);
      }
    }

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

ArrayList<CurvePair> curvepairs;
ArrayList<CurvePair> finals;

void startFL(Bezier3 c1, Bezier3 c2)
{
  curvepairs = new ArrayList<CurvePair>();
  curvepairs.add(new CurvePair(c1,c2));
  finals = new ArrayList<CurvePair>();
}

boolean iterate()
{
  boolean finished = true;
  println("tracking "+curvepairs.size()+" pairs");

  for(int cps=curvepairs.size()-1; cps>=0; cps--)
  {
    CurvePair curvepair = curvepairs.remove(cps);
    if(curvepair.isTiny()) {
      finals.add(curvepair);
      continue; }

    Bezier3 c1 = (Bezier3) curvepair.curve1;
    Bezier3 c2 = (Bezier3) curvepair.curve2;
    Bezier3 clipped = clipFT(c1, c2);

    // if no clipping could be performed, try to chop up the curves.
    // if this yields no viable curve pairs, we're done.
    if(clipped==null)
    {
      double t = (c2.getStartT() + c2.getEndT())/2.0;
      Segment[] split = c2.splitSegment(t);

      for(int i=0; i<2; i++) {
        Bezier3 c3 = (Bezier3)split[i];
        c3.computeBoundingBox();
        if(curvesOverlap(c1, c3)) {
          finished = false;
          Bezier3 nc1 = new Bezier3(c1);
          nc1.computeBoundingBox();
          // this order is VERY important. If we use nc1/c3, it will simply keep
          // subdividing the target curve further and further without ever clipping.
          // we also need to keep track of whether we swapped the curves for a
          // curve pair, because when we retrieve the t values, we need to know
          // which original curve they belonged to.
          CurvePair newpair = new CurvePair(c3, nc1);
          newpair.swapped = !curvepair.swapped;
          curvepairs.add(newpair); }}

      if(finished && !finals.contains(curvepair)) {
        finals.add(curvepair); }
    }

    // clipping could be performed, so we're not done.
    else {
      finished = false;
      // here, again, the order is important.
      CurvePair newpair = new CurvePair(clipped, c1);
      newpair.swapped = !curvepair.swapped;
      curvepairs.add(newpair); }
  }
  return finished;
}

CurvePair clipFT(Bezier3 reference, Bezier3 target)
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
  // both curves should be uniformly rotated to solve issues with vertical lines.
  if(dx==0) { dx=0.001; }

  // compute the values for a', b' and c' as expained in the primer.
  double a, b, c;
  a = dy / dx;
  b = -1;
  c = -(a * reference.points[0].x - reference.points[0].y);
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

  // cut-off criterium. If this is true, we need to split the curve.
  if((t1==0 && t2==1) || t2<=t1) { return null; }

  // we now have our clipping interval t-values: clip.
  return (Bezier3) target.splitSegment(t1,t2);
}

void mouseReleased()
{
  cstep=0;
  redraw();
}