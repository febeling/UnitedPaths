/**
 * Perform intersection checks using both bounding box subdivision and Fat Line clipping
 */

ViewPort main, fatline, params;
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

  points[0] = new Point(85,30);
  points[1] = new Point(180,50);
  points[2] = new Point(30,155);
  points[3] = new Point(130,160);

  points[4] = new Point(175,25);
  points[5] = new Point(55,40);
  points[6] = new Point(140,140);
  points[7] = new Point(85,210);

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
  params = new ViewPort(50+500,50,boxsize,boxsize);
}


int cstep = 0;
void keyPressed(){
  if(keyCode==10){cstep++;redraw();}
  else if(key=='r'){cstep=0;redraw();}}


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

/**
 * Draw all the viewport graphics
 * (axes, labels, numbering, etc)
 */
void drawViewPorts()
{
  main.drawText("curves", -20,-25, 0,0,0,255);
  main.drawLine(0,0,0,main.height,  0,0,0,255);
  main.drawLine(0,0,main.width,0,  0,0,0,255);

  fatline.drawText("fat line clipping - "+cstep, -20,-25, 0,0,0,255);
  fatline.drawLine(0,0,0,main.height,  0,0,0,255);
  fatline.drawLine(0,0,main.width,0,  0,0,0,255);
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

  startFL(new Bezier3(c1),new Bezier3(c2));
  for(int i=0; i<cstep; i++) { iterate(); }

  double t1, t2, x1, y1, x2, y2;
  println("curvepairs: "+curvepairs.size());

  int oxx=-100;
  int oxs=40;

  for(CurvePair cp: curvepairs) {
    cp.draw(oxx+fatline.ox, fatline.oy);
    oxx+=oxs;
    if(cp.swapped) { cp.swap(); }

    // draw both curves
    t1 = cp.curve1.getStartT();
    t2 = cp.curve1.getEndT();

    x1 = c1.getX(t1);
    y1 = c1.getY(t1);
    fatline.drawEllipse(x1, y1, 5, 5,  255,0,0,255);

    x2 = c1.getX(t2);
    y2 = c1.getY(t2);
    fatline.drawEllipse(x2, y2, 5, 5,  0,255,0,255);

    t1 = cp.curve2.getStartT();
    t2 = cp.curve2.getEndT();

    x1 = c2.getX(t1);
    y1 = c2.getY(t1);
    fatline.drawEllipse(x1, y1, 5, 5,  0,0,255,255);

    x2 = c2.getX(t2);
    y2 = c2.getY(t2);
    fatline.drawEllipse(x2, y2, 5, 5,  255,0,255,255);
  }

  if(finals.size()>0)
  {
    for(CurvePair cp: finals) {
      cp.draw(fatline.ox, fatline.oy);
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

ArrayList<CurvePair> curvepairs;
ArrayList<CurvePair> finals;

void startFL(Bezier3 c1, Bezier3 c2)
{
  curvepairs = new ArrayList<CurvePair>();
  CurvePair initial = new CurvePair(c1,c2);
  initial.computeTightBoundingBox();
  curvepairs.add(initial);
  finals = new ArrayList<CurvePair>();
}

boolean iterate()
{
  boolean finished = true;

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
        Bezier3 c3 = (Bezier3) split[i];
        if(curvesOverlap(c1, c3)) {
          finished = false;
          CurvePair newpair = new CurvePair(c3, c1);
          newpair.swapped = !curvepair.swapped;
          newpair.computeTightBoundingBox();
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
      newpair.computeTightBoundingBox();
      curvepairs.add(newpair); }
  }
  return finished;
}

Bezier3 clipFT(Bezier3 flcurve, Bezier3 curve)
{
  stroke(255); fill(255); drawRect(500,0,boxsize+100,boxsize+100);

  double[] bounds = flcurve.getBoundingBox();

  // get the distances from C1's baseline to the two other lines
  Point p0 = flcurve.points[0];
  // offset distances from baseline
  double dx = p0.x - bounds[0];
  double dy = p0.y - bounds[1];
  double d1 = sqrt(dx*dx+dy*dy);
  dx = p0.x - bounds[2];
  dy = p0.y - bounds[3];
  double d2 = sqrt(dx*dx+dy*dy);

  // get the distances from C2's point 0 to the three lines
  Point c2p0 = curve.points[0];
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
  Point p3 = flcurve.points[3];
  dx = (p3.x - p0.x);
  dy = (p3.y - p0.y);

  // if vertical, salt dx ever so slightly. However, this is only for
  // demonstration purposes, and may result in incorrect clipping. Instead,
  // both curves should be uniformly rotated.
  if(dx==0) { dx=0.1; }

  double a, b, c;
  a = dy / dx;
  b = -1;
  c = -(a * flcurve.points[0].x - flcurve.points[0].y);
  // normalize so that a² + b² = 1
  double scale = sqrt(a*a+b*b);
  a /= scale; b /= scale; c /= scale;

  // set up the coefficients for the Bernstein polynomial that
  // describes the distance from curve 2 to curve 1's baseline
  double[] coeff = new double[4];
  for(int i=0; i<4; i++) { coeff[i] = a*curve.points[i].x + b*curve.points[i].y + c; }

  // get the coefficient value range and scale for better visualisation.
  double ymin = 999;
  double ymax = -999;
  for(double co: coeff) {
    ymin = (co<ymin) ?  co : ymin;
    ymax = (co>ymax) ?  co : ymax; }
  double ydiff = ymax-ymin;
  double yscale = 200.0/ydiff;
  for(int co=0;co<4;co++) { coeff[co] *= yscale; }

  // also scale the distances!!
  d1 *= yscale;
  d2 *= yscale;

  double[] vals = new double[4];
  for(int i=0; i<4; i++) { vals[i] = computeCubicBaseValue(i*(1/3), coeff[0], coeff[1], coeff[2], coeff[3]); }

  translate(0,100);

  // draw the fat line + baseline
  params.drawLine(0,d1,200,d1, 100,0,0,255);
  params.drawText(""+round(d1),-20,d1+5);
  params.drawLine(0,0,200,0, 0,100,0,255);
  params.drawText("0",-10,5);
  params.drawLine(0,d2,200,d2, 0,0,100,255);
  params.drawText(""+round(d2),-20,d2+5);

  // draw the distance Bezier function
  double range = 200;
  for(float t = 0; t<1.0; t+=1.0/range) {
    double y = computeCubicBaseValue(t, coeff[0], coeff[1], coeff[2], coeff[3]);
    params.drawPoint(t*range, y, 0,0,0,255); }

  // form the convex hull
  ConvexHull ch = new ConvexHull();
  ArrayList hps = new ArrayList();
  hps.add(new Point(        0, coeff[0]));
  hps.add(new Point(  range/3, coeff[1]));
  hps.add(new Point(2*range/3, coeff[2]));
  hps.add(new Point(    range, coeff[3]));
  Point[] hull = ch.jarvisMarch(hps,-10,-200);

  // draw the convex hull
  noStroke();
  fill(100,100,255,50);
  beginShape();
  for(Point p: hull) {
    drawVertex(params.ox+p.x, params.oy+p.y); }
  endShape(CLOSE);
  fill(0);

  // draw the control lines
  params.drawLine(0*range, coeff[0], (1.0/3.0)*range, coeff[1], 0,0,255,255);
  params.drawLine((2.0/3.0)*range, coeff[2], 1*range, coeff[3], 0,0,255,255);

  // draw the control points
  for(int i=0; i<4; i++) {
    double x = i * (range/3);
    double y = coeff[i];
    params.drawEllipse(x,y,4,4,  0,0,0,255);
    params.drawText(""+round(y/yscale),x+10,y);
  }

  // to ensure we are performing intersection validation the correct
  // fat line boundary, we make sure that the lines are such that
  // the convex hull point (0.0, ...) is always above d1.
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
      if(intersection==null) continue;  // unlikely, but safe
      double ix = intersection[0];
      double iy = intersection[1];
      if(ix>=0 && ix<=range) params.drawEllipse(ix, iy, 3, 3, 0,0,255,255);
      double val = ix/range;
      // is this t-value lower (==safer) than what we already have?
      if(val>=0 && val<=1.0 && t1>val) { t1 = val; }}
    // make sure that t values don't drop below 0.0
    if(t1<0) { t1=0; }
    params.drawLine(range*t1,0,range*t1,100, 0,0,0,150);
    params.drawText("t1: "+round(1000*t1)/1000,10+range*t1,100, 0,0,0,150);
  }

  // we do the same thing for t2, but then in the opposite direction
  double t2 = 1.0;
  if(esafe)
  {
    t2 = 0.0; // least safe value
    double ypos = (eabove? d1 : d2);
    double[] line = {0,ypos,range,ypos};
    double[][] edges = getEdgesOn(hull, range);
    for(int test=0; test<edges.length; test++) {
      double[] intersection = intersectsLineLine(line, edges[test]);
      if(intersection==null) continue;  // unlikely, but safe
      double ix = intersection[0];
      double iy = intersection[1];
      if(ix>=0 && ix<=range) params.drawEllipse(ix, iy, 3, 3, 255,0,0,255);
      double val = ix/range;
      if(val>=0 && val<=1.0 && t2<val) { t2 = val; }}
    // make sure that t values don't go over 1.0
    if(t2>1) { t2=1; }
    params.drawLine(range*t2,0,range*t2,-100, 0,0,0,150);
    params.drawText("t2: "+round(1000*t2)/1000,10+range*t2,-85, 0,0,0,150);
  }

  translate(0,-100);

  if((t1==0 && t2==1) || t2<t1) { return null; }
  if(t1<curve.getStartT() || curve.getEndT()<t2) { return null; }

  // we now have our clipping interval t-values: let's clip!
  Segment clipped = curve.splitSegment(t1,t2);

  return (Bezier3) clipped;
}

/*
void mouseReleased()
{
  cstep=0;
  redraw();
}
*/