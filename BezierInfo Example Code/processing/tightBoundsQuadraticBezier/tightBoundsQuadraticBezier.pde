// main sketch code: sketches/examples/bbox/minimal/QuadraticBounds.pde

// Dependencies are in the "common" directory
// © 2011 Mike "Pomax" Kamermans of nihongoresources.com

Point[] points;
int boxsize = 300;

// REQUIRED METHOD
void setup()
{
	size(boxsize,boxsize);
	noLoop();
	setupPoints();
	text("",0,0);
}

/**
 * Set up three points, to form a quadratic curve
 */
void setupPoints()
{
	points = new Point[3];
	points[0] = new Point(70,250);
	points[1] = new Point(20,110);
	points[2] = new Point(250,60);
}

// REQUIRED METHOD
void draw()
{
	noFill();
	stroke(0);
	background(255);
	drawCurve();
	drawBoundingBox();
	drawExtras();
}

/**
 * Run through the entire interval [0,1] for 't'.
 */
void drawCurve()
{
	for(float t = 0; t<1.0; t+=1.0/200.0) {
		float mt = (1-t);
		double x = computeQuadraticBaseValue(t, points[0].getX(), points[1].getX(), points[2].getX());
		double y = computeQuadraticBaseValue(t, points[0].getY(), points[1].getY(), points[2].getY());
		drawPoint(x,y); }
}

/**
 * Compute the bounding box based on the straightened curve, for best fit
 */
void drawBoundingBox()
{
	// translate to 0,0
	Point np2 = new Point(points[1].getX() - points[0].getX(), points[1].getY() - points[0].getY());
	Point np3 = new Point(points[2].getX() - points[0].getX(), points[2].getY() - points[0].getY());

	// get angle for rotation
	float angle = (float) getDirection(np3.getX(), np3.getY());
	
	// rotate everything counter-angle so that it's aligned with the x-axis
	Point rnp2 = new Point(np2.getX() * cos(-angle) - np2.getY() * sin(-angle), np2.getX() * sin(-angle) + np2.getY() * cos(-angle));
	Point rnp3 = new Point(np3.getX() * cos(-angle) - np3.getY() * sin(-angle), np3.getX() * sin(-angle) + np3.getY() * cos(-angle));

	// same bounding box approach as before:
	double minx = 9999;
	double maxx = -9999;
	if(0<minx) { minx=0; }
	if(0>maxx) { maxx=0; }
	if(rnp3.getX()<minx) { minx=rnp3.getX(); }
	if(rnp3.getX()>maxx) { maxx=rnp3.getX(); }
	double t = computeQuadraticFirstDerivativeRoot(0, rnp2.getX(), rnp3.getX());
	if(t>=0 && t<=1) {
		stroke(255,0,0);
		int x = (int) computeQuadraticBaseValue(t, 0, rnp2.getX(), rnp3.getX());
		if(x<minx) { minx=x; }
		if(x>maxx) { maxx=x; }}

	float miny = 9999;
	float maxy = -9999;
	if(0<miny) { miny=0; }
	if(0>maxy) { maxy=0; }
	if(0<miny) { miny=0; }
	if(0>maxy) { maxy=0; }
	t = computeQuadraticFirstDerivativeRoot(0, rnp2.getY(), 0);
	if(t>=0 && t<=1) {
		stroke(255,0,255);
		int y = (int) computeQuadraticBaseValue(t, 0, rnp2.getY(), 0);
		if(y<miny) { miny=y; }
		if(y>maxy) { maxy=y; }}

	// bounding box corner coordinates
	Point bb1 = new Point(minx,miny);
	Point bb2 = new Point(minx,maxy);
	Point bb3 = new Point(maxx,maxy);
	Point bb4 = new Point(maxx,miny);
	
	// rotate back!
	Point nbb1 = new Point(bb1.x * cos(angle) - bb1.y * sin(angle), bb1.x * sin(angle) + bb1.y * cos(angle));
	Point nbb2 = new Point(bb2.x * cos(angle) - bb2.y * sin(angle), bb2.x * sin(angle) + bb2.y * cos(angle));
	Point nbb3 = new Point(bb3.x * cos(angle) - bb3.y * sin(angle), bb3.x * sin(angle) + bb3.y * cos(angle));
	Point nbb4 = new Point(bb4.x * cos(angle) - bb4.y * sin(angle), bb4.x * sin(angle) + bb4.y * cos(angle));
	
	// move back!
	nbb1.x += points[0].getX();	nbb1.y += points[0].getY();
	nbb2.x += points[0].getX();	nbb2.y += points[0].getY();
	nbb3.x += points[0].getX();	nbb3.y += points[0].getY();
	nbb4.x += points[0].getX();	nbb4.y += points[0].getY();
	
	double[] bounds = {nbb1.x, nbb1.y, nbb2.x, nbb2.y, nbb3.x, nbb3.y, nbb4.x, nbb4.y};
	
	// draw bounding box
	noFill();
	stroke(0,255,0);
	drawLine(bounds[0], bounds[1], bounds[2], bounds[3]);
	drawLine(bounds[2], bounds[3], bounds[4], bounds[5]);
	drawLine(bounds[4], bounds[5], bounds[6], bounds[7]);
	drawLine(bounds[6], bounds[7], bounds[0], bounds[1]);
}

/**
 * For nice visuals, make the curve's fixed points stand out,
 * and draw the lines connecting the start/end and control point.
 * Also, we label each coordinate with its x/y value, for clarity.
 */
void drawExtras()
{
	showPoints(points);
	stroke(0,75);
	drawLine(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY());
	drawLine(points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY());
}


// source code include: sketches/common/utils/common.pde


;

/**
 * Used all over the place - draws all points as open circles,
 * and lists their coordinates underneath.
 */
void showPoints(Point[] points) {
	stroke(0,0,200);
	for(int p=0; p<points.length; p++) {
		noFill();
		drawEllipse(points[p].getX(), points[p].getY(), 5, 5);
		fill(0,0,255,100);
		int x = round(points[p].getX());
		int y = round(points[p].getY());
		drawText("x"+(p+1)+": "+x+"\ny"+(p+1)+": "+y, x-10, y+15); }}


/**
 * draws an estimated 't' value on the sketch area
 */
void showEstimatedT(double ix, double iy, double[] line, double st, double et)
{
	double perc;
	if(line[0]>line[2]) { perc = (ix - line[2]) / (line[0] - line[2]); }
	else if(line[2]>line[0]) { perc = (ix - line[0]) / (line[2] - line[0]); }
	else {
		if(line[1]>line[3]) { perc = (iy - line[3]) / (line[1] - line[3]); }
		else { perc = (iy - line[1]) / (line[3] - line[1]); }}
	double precision = 1000;
	double estimated_t = (int)(precision*((1-perc)*st + perc*et));
	estimated_t = estimated_t/precision;
	fill(255,0,255);
	text("t = "+estimated_t, (float)ix, (float)(iy+15));
}

/**
 * Get the angular direction indicated by the provided dx/dy ratio,
 * with the value expressed in radians (not degrees!)
 */
double getDirection(double dx, double dy)
{
  return Math.atan2(-dy,-dx) - PI;
}

/**
 * get the angular directions for a curve's end points, giving the angels (start->start control) and (end control->end)
 */
double[] getCurveDirections(double xa, double ya, double xb, double yb, double xc, double yc, double xd, double yd)
{
	double[] directions = new double[2];
	if(notEqual(xa,ya,xb,yb)) { directions[0] = getDirection(xb-xa, yb-ya); }
	else if(notEqual(xa,ya,xc,yc)) { directions[0] = getDirection(xc-xa, yc-ya); }
	else if(notEqual(xa,ya,xd,yd)) { directions[0] = getDirection(xd-xa, yd-ya); }
	else { directions[0] = -1; }

	if(notEqual(xd,yd,xc,yc)) { directions[1] = getDirection(xd-xc, yd-yc); }
	else if(notEqual(xd,yd,xb,yb)) { directions[1] = getDirection(xd-xb, yd-yb); }
	else if(notEqual(xd,yd,xa,ya)) { directions[1] = getDirection(xd-xa, yd-ya); }
	else { directions[1] = -1; }

	return directions;
}


boolean notEqual(double x1, double y1, double x2, double y2) { return x1!=x2 || y1 != y2; }

/**
 * Rotate a set of points so that point 0 is on (0,0) and point [last] is on (...,0)
 */
Point[] rotateToUniform(Point[] points)
{
	int len = points.length;
	Point[] uniform = new Point[len];
	// translate point set to start at 0,0
	double xoffset = points[0].getX();
	double yoffset = points[0].getY();
	uniform[0] = new Point(0,0);
	for(int i=1; i<len; i++) {
		uniform[i] = new Point(points[i].getX() - xoffset, points[i].getY() - yoffset); }
	// rotate all points so that the last point of the curve is on the x-axis
	double angle = -getDirection(uniform[len-1].getX(), uniform[len-1].getY());
	for(int i=1; i<len; i++) {
		Point uorg = uniform[i];
		double x = uorg.getX();
		double y = uorg.getY();
		uniform[i] = new Point(x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle)); }
	// done
	return uniform;
}

/**
 * line intersection detection algorithm
 * see http://www.topcoder.com/tc?module=Static&d1=tutorials&d2=geometry2#line_line_intersection
 */
double[] intersectsLineLine(double[] line1, double[] line2)
{
	// value extraction to named variables is purely for convenience
	double x1 = line1[0];    double y1 = line1[1];
	double x2 = line1[2];    double y2 = line1[3];
	double x3 = line2[0];    double y3 = line2[1];
	double x4 = line2[2];    double y4 = line2[3];

	// the important values
	double nx = (x1*y2 - y1*x2)*(x3-x4) - (x1-x2)*(x3*y4 - y3*x4);
	double ny = (x1*y2 - y1*x2)*(y3-y4) - (y1-y2)*(x3*y4 - y3*x4);
	double denominator = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);

	// If the lines are parallel, there is no real 'intersection',
	// and if they are colinear, the intersection is an entire line,
	// rather than a point. return "null" in both cases.
	if(denominator==0) { return null; }
	// if denominator isn't zero, there is an intersection, and it's a single point.
	double px = nx/denominator;
	double py = ny/denominator;
	double[] ret = {px, py};
	return ret;
}

/**
 * Determine whether an intersection point between two lines is virtual, or actually
 * on both line segments it was computed for
 */
boolean intersectsLineSegmentLineSegment(double ix, double iy, double[] line1, double[] line2)
{
	if(0<=ix && ix<=boxsize && 0<=iy && iy<=boxsize)
	{
		double bounds_1_xmin = min(line1[0], line1[2]);
		double bounds_2_xmin = min(line2[0], line2[2]);
		double bounds_xmin = max(bounds_1_xmin, bounds_2_xmin);

		double bounds_1_xmax = max(line1[0], line1[2]);
		double bounds_2_xmax = max(line2[0], line2[2]);
		double bounds_xmax = min(bounds_1_xmax, bounds_2_xmax);

		double bounds_1_ymin = min(line1[1], line1[3]);
		double bounds_2_ymin = min(line2[1], line2[3]);
		double bounds_ymin = max(bounds_1_ymin, bounds_2_ymin);

		double bounds_1_ymax = max(line1[1], line1[3]);
		double bounds_2_ymax = max(line2[1], line2[3]);
		double bounds_ymax = min(bounds_1_ymax, bounds_2_ymax);

		return (bounds_xmin<=ix && ix<=bounds_xmax && bounds_ymin<=iy && iy<=bounds_ymax);
	}
	return false;
}

/**
 * interpolates a time value for a coordinate on a line, based on the start and end times of the line
 */
double estimateT(double ix, double iy, double[] line, double st, double et)
{
	double perc;
	if(line[0]>line[2]) { perc = (ix - line[2]) / (line[0] - line[2]); }
	else if(line[2]>line[0]) { perc = (ix - line[0]) / (line[2] - line[0]); }
	else {
		if(line[1]>line[3]) { perc = (iy - line[3]) / (line[1] - line[3]); }
		else { perc = (iy - line[1]) / (line[3] - line[1]); }}
	double estimated_t = (1-perc)*st + perc*et;
	return estimated_t;
}

/**
 * interpolates a distance value (expressed over interval [0,1]) for a coordinate on a line, based on the start and end distances of the line
 */
double estimateDistancePercentage(double ix, double iy, double[] line, double sd, double ed)
{
	double perc;
	if(line[0]>line[2]) { perc = (ix - line[2]) / (line[0] - line[2]); }
	else if(line[2]>line[0]) { perc = (ix - line[0]) / (line[2] - line[0]); }
	else {
		if(line[1]>line[3]) { perc = (iy - line[3]) / (line[1] - line[3]); }
		else { perc = (iy - line[1]) / (line[3] - line[1]); }}
	return perc;
}

/**
 * generate a 2D array; each row models an edge {x1,y1,x2,y2}
 */
double[][] getEdges(Point[] hull)
{
	double[][] edges = new double[hull.length][4];
	int len = hull.length;
	for(int p=0; p<len; p++) {
		double[] edge = {hull[p].x, hull[p].y, hull[(p+1)%len].x, hull[(p+1)%len].y};
		edges[p] = edge; }
	return edges;
}

/**
 * generate a 2D array; each row models an edge {x1,y1,x2,y2}
 * but only edges with coordinates at the specified _x value
 * are returned.
 */
double[][] getEdgesOn(Point[] hull, double _x)
{
	double r = 0.1;
	double[][] edges = new double[2][4];
	int len = hull.length;
	int pos = 0;
	for(int p=0; p<len; p++) {
		if(!near(hull[p].x,_x,r) && !near(hull[(p+1)%len].x,_x,r)) continue;
		// important: ignore vertical edges
  	if(hull[p].x == hull[(p+1)%len].x) continue;
		double[] edge = {hull[p].x, hull[p].y, hull[(p+1)%len].x, hull[(p+1)%len].y};
		edges[pos++] = edge; }
	return edges;
}

/**
 * "is v1 a near enough to v2" check
 */
boolean near(double v1, double v2, double r) {
	return (abs(v1-v2)<=r);
}

/**
 * Arguably the least efficient sorting algorithm available... but very easy to write!
 */
void swapSort(double[] array)
{
	boolean sorted;
	int len = array.length;
	do {	sorted=true;
			for(int i=0; i<len-1; i++) {
				if(array[i+1]<array[i]) {
					// out of order: swap
					double swap = array[i];
					array[i] = array[i+1];
					array[i+1] = swap;
					// this list was not sorted
					sorted=false; }}} while(!sorted);
}

/**
 * check whether two curves' bounding boxes overlap
 */
boolean curvesOverlap(Segment curve1, Segment curve2)
{
  curve1.computeTightBoundingBox();
  curve2.computeTightBoundingBox();

  double[] bounds1 = curve1.getBoundingBox();
  double[] bounds2 = curve2.getBoundingBox();

  double[][] lines1 = new double[4][];
  double[][] lines2 = new double[4][];
  for(int i=0, j=0; i<8 ;i+=2) {
    j = int(i/2);
    double[] l1 = { bounds1[i], bounds1[i+1], bounds1[(i+2)%8], bounds1[(i+3)%8] };
    lines1[j] = l1;
    double[] l2 = { bounds2[i], bounds2[i+1], bounds2[(i+2)%8], bounds2[(i+3)%8] };
    lines2[j] = l2; }

  for(double[] l1: lines1) {
    for(double[] l2: lines2) {
      double[] ixy = intersectsLineLine(l1, l2);
      if(ixy!=null && intersectsLineSegmentLineSegment(ixy[0], ixy[1], l1, l2)) {
        return true; }}}

  // no overlap detected yet, but we might be fully contained
  boolean iscontained = contained(bounds1[0], bounds1[1], bounds2);
  if(!iscontained) { iscontained = contained(bounds2[0], bounds2[1], bounds1); }
  if(!iscontained) { return false; }
  return true;
}

boolean contained(double x, double y, double[] bounds)
{
    double bounds_xmin = min(bounds[0], bounds[4]);
    double bounds_xmax = min(bounds[0], bounds[4]);
    double bounds_ymin = min(bounds[1], bounds[3]);
    double bounds_ymax = min(bounds[1], bounds[3]);

    return (bounds_xmin<=x && x<=bounds_xmax && bounds_ymin<=y && y<=bounds_ymax);
}


// source code include: sketches/common/utils/P5Double.pde


/**
 * Processing does not support doubles. A bit silly, but easy enough to get around
 */

double abs(double x) { if(x<0) { return -x; } return x; }
double min(double a, double b) { if(a<b) { return a; } return b; }
double max(double a, double b) { if(a<b) { return b; } return a; }
double sqrt(double v) { return Math.sqrt(v); }

double sin(double v) { return Math.sin(v); }
double cos(double v) { return Math.cos(v); }
double tan(double v) { return Math.tan(v); }
double asin(double v) { return Math.asin(v); }
double acos(double v) { return Math.acos(v); }
double atan(double v) { return Math.atan(v); }

int round(double x) { return (int) Math.round(x); }
int floor(double x) { return (int) Math.floor(x); }
int ceil(double x) { return (int) Math.ceil(x); }

// -- draw methods --

void drawPoint(double x, double y) { point(round(x),round(y)); }
void drawLine(double x1, double y1, double x2, double y2) {
	line(round(x1),round(y1),round(x2),round(y2)); }
void drawRect(double x, double y, double w, double h) {
	rect(round(x),round(y),round(w),round(h)); }
void drawBezier(double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4) {
	bezier(round(x1),round(y1),round(x2),round(y2),round(x3),round(y3),round(x4),round(y4)); }
void drawEllipse(double x, double y, double w, double h) {
	ellipse(round(x),round(y),round(w),round(h)); }
void drawText(String t, double x, double y) {text(t,round(x),round(y)); }
void drawVertex(double x, double y) { vertex((float)x,(float)y); }


// source code include: sketches/common/Segments/Point.pde


/**
 * Convenience class, used for interactive points
 */
class Point
{
	double x, y;
	double xo=0;
	double yo=0;
	boolean moving=false;
	Point(double x, double y) {
		this.x = x;
		this.y = y; }
	double getX() { return x+xo; }
	double getY() { return y+yo; }
	boolean over(int x, int y) { return abs(this.x-x)<=3 && abs(this.y-y)<=3; }
	String toString() { return x+","+y; }
	boolean equals(Object o) {
		if(this==o) return true;
		if(!(o instanceof Point)) return false;
		Point other = (Point) o;
		return abs(x-other.x)<=0.1 && abs(y-other.y)<=0.1; }
}


// source code include: sketches/common/Segments/Segment.pde


/**
 * A segment is any kind of line section over a definite interval
 */
class Segment
{
	boolean showtext=false;
	void setShowText(boolean b) { showtext=b; }
	boolean showText() { return showtext; }

	boolean showpoints=true;
	void setShowPoints(boolean b) { showpoints=b; }
	boolean showPoints() { return showpoints; }

	boolean showcontrols=true;
	void setShowControlPoints(boolean b) { showcontrols=b; }
	boolean showControlPoints() { return showcontrols; }

	boolean drawcurve=true;
	void setDrawCurve(boolean b) { drawcurve=b; }
	boolean drawCurve() { return drawcurve; }

	boolean drawbbox=false;
	void setShowBoundingBox(boolean b) { drawbbox=b; }
	boolean showBoundingBox() { return drawbbox; }

	Point[] points = new Point[0];
	Point getFirstPoint() { return points[0]; }
	Point getLastPoint() { return points[points.length-1]; }
	
	double start_t = 0.0;
	double end_t = 1.0;
	void setTValues(double st, double et) { start_t=st; end_t=et;}
	double getStartT() { return start_t;}
	double getEndT() { return end_t;}

	double start_d = 0.0;
	double end_d = 0.0;
	void setDistanceValues(double sd, double ed) { start_d=sd; end_d=ed;}
	double getStartDistance() { return start_d;}
	double getEndDistance() { return end_d;}
	
	double[] bounds = new double[8];
	double[] getBoundingBox() { return bounds; }
	void computeBoundingBox() {}
	void computeTightBoundingBox() {}

  double getLength() { return 0; }

	int ox=0;
	int oy=0;
	
	Segment() {}
	Segment(Segment other) {
		setPoints(other.points);
		showtext=other.showtext;
		showpoints=other.showpoints;
		showcontrols=other.showcontrols;
		drawcurve=other.drawcurve;
		setTValues(other.start_t, other.end_t);
		setDistanceValues(other.start_d, other.end_d);
		if(other.bounds!=null) arrayCopy(other.bounds,0,bounds,0,8);
		ox=other.ox;
		oy=other.oy;
	}
	
	void setPoints(Point[] opoints)
	{
		int len = opoints.length;
		points = new Point[len];
		for(int i=0; i<len; i++) {
		  points[i] = new Point(opoints[i].x, opoints[i].y); }
	}
	
	void draw(int ox, int oy) {
		this.ox=ox;
		this.oy=oy;
		draw(); }

	// draw this segment
	void draw() {
		stroke(r,g,b);
		fill(r,g,b);
		if(drawcurve) drawSegment();
		stroke(0,0,255);
		int last = points.length-1;
		for(int p=0; p<points.length; p++){
			noFill();
			double x = points[p].getX();
			double y = points[p].getY();
			if(showpoints) {
				if(p==0 || p==last || (points.length>2 && p!=0 && p!=last && showcontrols)) {
					drawEllipse(ox+x, oy+y, 4, 4); 
				}
			}
			fill(0);
			if(showtext) drawText("x: "+x+"\ny: "+y, ox+x, oy+y+15); }
		if(drawbbox && bounds!=null) {
			noFill();
			stroke(255,0,0,150);
			strokeWeight(1);
			beginShape();
			drawVertex(bounds[0]+ox, bounds[1]+oy);
			drawVertex(bounds[2]+ox, bounds[3]+oy);
			drawVertex(bounds[4]+ox, bounds[5]+oy);
			drawVertex(bounds[6]+ox, bounds[7]+oy);
			endShape(CLOSE); }
	}

	void drawSegment() { }
	
	Line[] flattened = null;
	Line[] flatten(int steps) { if(flattened!=null) { return flattened; } return new Line[0]; }
	Line[] flattenWithDistanceThreshold(double threshold) { return flatten(0); }

	// offset default: don't offset
	Segment[] offset(double distance) { Segment[] ret = {this}; return ret; }

	// simple offset default: don't offset
	Segment simpleOffset(double distance) { return this; }
	
	int r, g, b;
	void setColor(int r, int g, int b) { this.r=r; this.g=g; this.b=b; }
	
	String toString() {
		String r = "";
		for(int p=0; p<points.length; p++) {
			r += points[p].getX()+","+points[p].getY()+" "; }
		return r; }

	Segment[] splitSegment(double t) { return null; }
	Segment splitSegment(double t1, double t2) { return null; }

	boolean equals(Object o)
	{
		if(this==o) return true;
		if(!(o instanceof Segment)) return false;
		Segment other = (Segment) o;
		if(other.points.length != points.length) return false;
		int len = points.length;
		// if the coordinates are the same, the segments are the same
		boolean same=true;
		for(int p=0; p<len; p++) {
			if(!points[p].equals(other.points[p])) {
				same = false;
				break; }}
		if(same) return true;
		// the segments are also the same if the coordinates match in reverse
		int last = len-1;
		same=true;
		for(int p=0; p<len; p++) {
			if(!points[p].equals(other.points[last-p])) {
				same = false;
				break; }}
		return same;

	}
}


// source code include: sketches/common/Segments/LineSegment.pde


/**
 * Straight line segment from point P1 to P2
 */
class Line extends Segment
{
	double length=0;
	double getLength() { return length; }

	void computeBoundingBox() {
		double minx = min(points[0].x, points[1].x);
		double miny = min(points[0].y, points[1].y);
		double maxx = max(points[0].x, points[1].x);
		double maxy = max(points[0].y, points[1].y);
		// direction: {+x, +y, -x, -y}
		double[] bbox = {minx,miny, maxx,miny, maxx,maxy, minx,maxy};
		bounds = bbox;
	}

	void computeTightBoundingBox() {
		double[] bbox = {points[0].x, points[0].y, points[1].x, points[1].y, points[1].x, points[1].y, points[0].x, points[0].y};
		bounds = bbox;
	}

	Line() { super(); }

	Line(double x1, double y1, double x2, double y2) {
		points = new Point[2];
		points[0] = new Point(x1,y1);
		points[1] = new Point(x2,y2); 
		length = (double) sqrt((float)((x2-x1)*(x2-x1)) + (float)((y2-y1)*(y2-y1))); }

	Line(Line other) { super(other); }

	void drawSegment() {
		drawLine(ox+points[0].getX(), oy+points[0].getY(), ox+points[1].getX(), oy+points[1].getY()); }
		
	// can't flatten a line, return self
	Line[] flatten(int steps) { Line[] ret = {this}; return ret; }
	
	/**
	 * check how many pixels of the curve are not covered by this line
	 */
	int getOffPixels(double[] xcoords, double[] ycoords, int end)
	{
		int off = 0;
		for(int c=0; c<end; c++) {
			double x = xcoords[c];
			double y = ycoords[c];
			double supposed_y = getYforX(x);
			if(abs((float)(supposed_y-y))>=2) { off++; }}
		return off;
	}
	
	/**
	 * If we plug an 'x' value into this line's f(x), which 'y' value comes rolling out?
	 */
	double getYforX(double x)
	{
		double dy = points[1].getY() - points[0].getY();
		double dx = points[1].getX() - points[0].getX();
		return (dy/dx) * (x - points[0].getX()) + points[0].getY();
	}

	/**
	 * Offset this line by {distance} pixels. Note that these do not need to be full pixels
	 */
	Segment[] offset(double distance) {
		double angle = getDirection(points[1].getX()-points[0].getX(), points[1].getY() - points[0].getY());
		double dx = distance * Math.cos(angle + PI/2.0);
		double dy = distance * Math.sin(angle + PI/2.0);
		Segment[] ret = { new Line(points[0].getX() + dx, points[0].getY() + dy, points[1].getX() + dx, points[1].getY() + dy) };
		return ret;
	}
	
	/**
	 * simply wraps offset
	 */
	Segment simpleOffset(double distance) {
		Segment[] soffset = offset(distance);
		return soffset[0]; }
}


// source code include: sketches/common/Segments/Coordinate.pde


class Coordinate extends Point
{
  double subt1=0;
  double subt2=0;

  Coordinate(double x, double y) { super(x,y); }

  Coordinate(double x, double y, double subt1, double subt2) {
    this(x,y);
    this.subt1 = subt1;
    this.subt2 = subt2; }

  double getSubT1() { return subt1; }
  double getSubT2() { return subt2; }
  void draw() { drawEllipse(x,y,3,3); }

  boolean equals(Object o) {
   if(this==o) return true;
   if(o instanceof Coordinate) {
     Coordinate other = (Coordinate) o;
     return other.x==x && other.y==y && other.subt1==subt1 && other.subt2==subt2; }
   return false; }

  String toString() { return "{"+x+","+y+","+subt1+","+subt2+"}"; }
}


// source code include: sketches/common/Segments/PointSegment.pde


/**
 * Convenience class for returning a list of points as
 * a virtual segment
 */
class PointSegment extends Segment
{
	public PointSegment(Point[] points) { 
		this.points = points;  }
}


// source code include: sketches/common/Segments/Bezier2.pde


/**
 * Quadratic Bezier curve segment from point P1 (x1/y1) to P3 (x3/y3) over control point P2 (x2/y2)
 */
class Bezier2 extends Segment
{
	Bezier2() { super(); }
	
	Bezier2(double x1, double y1, double cx, double cy, double x2, double y2) {
		points = new Point[3];
		points[0] = new Point(x1,y1);
		points[1] = new Point(cx,cy); 
		points[2] = new Point(x2,y2); }

	Bezier2(Bezier2 other) { super(other); }

	void drawSegment() {
		for(float t = 0; t<1.0; t+=1.0/200.0) {
			double x = getX(t);
			double y = getY(t);
			drawPoint(ox+x,oy+y); }}

	double getX(double t) { return computeQuadraticBaseValue(t, points[0].getX(), points[1].getX(), points[2].getX()); }
	double getY(double t) { return computeQuadraticBaseValue(t, points[0].getY(), points[1].getY(), points[2].getY()); }

	void computeBoundingBox() { bounds = computeQuadraticBoundingBox(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY()); }
	void computeTightBoundingBox() { bounds = computeQuadraticTightBoundingBox(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY()); }

	Segment[] splitSegment(double t) { return splitQuadraticCurve(t, points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY()); }

	/**
	 * use fat line clippping to clip "other" on "this".
	 */
	Segment clip(Bezier2 other) { return this; }

	/**
	 * Flatten this curve as a series of connected lines, each line
	 * connecting two coordinates on the curve for 't' values that
	 * are separated by fixed intervals.
	 */
	Line[] flatten(int steps)
	{
		// shortcut
		if(flattened!=null) { return flattened; }
		// not previously flattened - compute
		double step = 1.0 / (double)steps;
		Line[] lines = new Line[steps];
		int l = 0;
		double sx = getX(0);
		double sy = getY(0);
		for(double t = step; t<1.0; t+=step) {
			double nx = getX(t);
			double ny = getY(t);
			Line segment = new Line(sx,sy,nx,ny);
			segment.setTValues(t-step, t);
			lines[l++] = segment;
			sx=nx;
			sy=ny; }
		// don't forget to add the last segment
		Line segment = new Line(sx,sy,getX(1),getY(1));
		segment.setTValues(1.0-step, 1.0);
		lines[l++] = segment;
		return lines;
	}

	/**
	 * Flatten this curve as a series of connected lines, each line
	 * made to fit the curve as best as possible based on how big
	 * the tolerance in error is between the line segment, and the
	 * section of curve that segment approximates.
	 *
	 * For this function, the "threshold" value indicates the number
	 * of pixels that are permissibly non-overlapping between the two.
	 */
	Line[] flattenWithDistanceThreshold(double threshold)
	{
		// shortcut
		if(flattened!=null) { return flattened; }
		// not previously flattened - compute
		ArrayList/*<Line>*/ lines = new ArrayList();
		double x1 = getX(0);
		double y1 = getY(0);
		double x2 = x1;
		double y2 = y1;
		Line last_segment = new Line(x1,y1,x2,y2);
		// we use an array of at most 'steps' positions to record which coordinates have been seen
		// during a walk, so that we can determine the error between the curve and the line approximation
		int fsteps = 200;
		double[] xcoords = new double[fsteps];
		double[] ycoords = new double[fsteps];
		int coord_pos = 0;
		xcoords[coord_pos] = x1;
		ycoords[coord_pos] = y1;
		coord_pos++;
		// start running through the curve
		double step = 1.0/(double)fsteps;
		double old_t = 0.0;
		double old_d = 0.0;
		// start building line segments
		for(double t=step; t<1.0; t+=step)
		{
			x2 = getX(t);
			y2 = getY(t);
			xcoords[coord_pos] = x2;
			ycoords[coord_pos] = y2;
			coord_pos++;
			
			Line test = new Line(x1,y1,x2,y2);
			int off_pixels = test.getOffPixels(xcoords, ycoords, coord_pos);
			// too big an error? commit last line as segment
			if(off_pixels>threshold) {
				double d = old_d + last_segment.getLength();
				// record segment
				last_segment.setTValues(old_t, t);
				last_segment.setDistanceValues(old_d, d);
				lines.add(last_segment);
				// cycle all administrative values
				old_t = t;
				old_d = d;
				x1 = last_segment.points[1].getX();
				y1 = last_segment.points[1].getY();
				last_segment = new Line(x1,y1,x2,y2);
				xcoords = new double[fsteps];
				ycoords = new double[fsteps];
				coord_pos = 0;
				xcoords[coord_pos] = x1;
				ycoords[coord_pos] = y1;
				coord_pos++;
			 }
			// error's small enough, try to extend the line
			else { last_segment = test; }
		}
		// make sure we also get the last segment!
		last_segment = new Line(x1,y1,getX(1), getY(1));
		last_segment.setTValues(old_t, 1.0);
		lines.add(last_segment);
		
		Line[] larray = new Line[lines.size()];
		for(int l=0; l<lines.size(); l++) { larray[l] = (Line) lines.get(l); }
		return larray;
	}

	/**
	 * Segment this curve into a series of safe-for-scaling curves
	 */
	Segment[] makeSafe()
	{
		Segment[] safe;
		ArrayList segments = new ArrayList();
		Point[] uniform = rotateToUniform(points);
		double x_root = computeQuadraticFirstDerivativeRoot(uniform[0].getX(), uniform[1].getX(), uniform[2].getX());
		double y_root = computeQuadraticFirstDerivativeRoot(uniform[0].getY(), uniform[1].getY(), uniform[2].getY());
		if(x_root>0 && x_root<1 && y_root>0 && y_root<1) {
			if(x_root>y_root) { double swp = y_root; y_root = x_root; x_root = swp; }

			segments.add(getQuadraticSegment(0.0, x_root, points[0].getX(), points[0].getY(),
																			points[1].getX(), points[1].getY(),
																			points[2].getX(), points[2].getY()));

			if(x_root!=y_root) {
				segments.add(getQuadraticSegment(x_root, y_root, points[0].getX(), points[0].getY(),
																					points[1].getX(), points[1].getY(),
																					points[2].getX(), points[2].getY())); }

			segments.add(getQuadraticSegment(y_root, 1.0,	 points[0].getX(), points[0].getY(),
																			points[1].getX(), points[1].getY(),
																			points[2].getX(), points[2].getY()));

			Segment[] ret = new Segment[segments.size()];
			for(int s=0; s<ret.length; s++) { ret[s] = (Segment) segments.get(s); }
			safe = ret; }
		else if(x_root>0 && x_root<1 ) {
			Segment[] split = splitQuadraticCurve(x_root, points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY());
			Segment[] ret = {split[0], split[1]};
			safe = ret; }
		else if(y_root>0 && y_root<1 ) {
			Segment[] split = splitQuadraticCurve(y_root, points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY());
			Segment[] ret = {split[0], split[1]};
			safe = ret; }
		else { Segment[] ret = {this}; safe = ret; }
		return safe;
	}

	/**
	 * Offset this quadratic bezier curve by {distance} pixels. Note that these do not need to be full pixels
	 */
	Segment[] offset(double distance)
	{
		Segment[] safe = makeSafe();
		Segment[] ret = new Segment[safe.length];
		for(int s=0; s<ret.length; s++) {
			ret[s] = safe[s].simpleOffset(distance);
			ret[s].setTValues(safe[s].getStartT(), safe[s].getEndT()); }
		// before we return, make sure to line up the segment coordinates
		for(int s=1; s<ret.length; s++) {
			ret[s].getFirstPoint().x = ret[s-1].getLastPoint().x;
			ret[s].getFirstPoint().y = ret[s-1].getLastPoint().y; }
		return ret;
	}
	
	/**
	 * Offset this quadratic bezier curve, which is presumed to be safe for scaling,
	 * by {distance} pixels. Note that these do not need to be full pixels
	 */
	Segment simpleOffset(double distance)
	{
		double xa = points[0].getX();
		double ya = points[0].getY();
		double xb = points[1].getX();
		double yb = points[1].getY();
		double xc = points[2].getX();
		double yc = points[2].getY();

		// offsetting the end points is always simple
		double[] angles = getCurveDirections(xa, ya, xb, yb, xb, yb, xc, yc);
		double nxa = xa + distance*Math.cos(angles[0] + PI/2.0);
		double nya = ya + distance*Math.sin(angles[0] + PI/2.0);
		double nxc = xc + distance*Math.cos(angles[1] + PI/2.0);
		double nyc = yc + distance*Math.sin(angles[1] + PI/2.0);

		// offsetting the control point requires a few line intersection checks.
		// For quadratic bezier curves, we don't need to figure out where the
		// curve scaling origin is to get the correct offset point
		double[] line1 = {nxa, nya, nxa + (xb-xa), nya + (yb-ya)};
		double[] line2 = {nxc, nyc, nxc + (xc-xb), nyc + (yc-yb)};
		double[] intersection = intersectsLineLine(line1, line2);
		if(intersection==null) {
//			println("ERROR: NO INTERSECTION ON "+nxa+","+nya+","+(nxa + (xb-xa))+","+(nya + (yb-ya))+" WITH "+nxc+","+nyc+","+(nxc + (xc-xb))+","+(nyc + (yc-yb)));
			return this; }
		double nxb = intersection[0];
		double nyb = intersection[1];

		// and return offset curve
		return new Bezier2(nxa, nya, nxb, nyb, nxc, nyc);
	}
}



/**
 * line/curve intersection detection algorithm, returns coordinate and estimated time value on the curve
 */
double[] intersectsLineCurve(double[] oline, Bezier2 curve)
{
	Segment[] flattened = curve.flatten(32);
	for(int l=0; l<flattened.length; l++) {
		Line target = (Line) flattened[l];
		double[] tline = {target.points[0].getX(), target.points[0].getY(), target.points[1].getX(), target.points[1].getY()};
		double[] intersection = intersectsLineLine(oline, tline);
		if(intersection!=null) {
			double ix = intersection[0];
			double iy = intersection[1];
			if(intersectsLineSegmentLineSegment(ix, iy, oline, tline)) {
				double[] values = {	ix, iy,
											estimateT(ix, iy, tline, target.getStartT(), target.getEndT())};
				return values; }}}
	return null;
}


/**
 * line/curve intersection detection algorithm, returns coordinate, estimated time value on the curve, and estimated distance on the curve
 */
double[] intersectsLineCurveWithDistance(double[] oline, Bezier2 curve, double sd, double ed)
{
	Segment[] flattened = curve.flattenWithDistanceThreshold(1);
	for(int l=0; l<flattened.length; l++) {
		Line target = (Line) flattened[l];
		double[] tline = {target.points[0].getX(), target.points[0].getY(), target.points[1].getX(), target.points[1].getY()};
		double[] intersection = intersectsLineLine(oline, tline);
		if(intersection!=null) {
			double ix = intersection[0];
			double iy = intersection[1];
			if(intersectsLineSegmentLineSegment(ix, iy, oline, tline)) {
				double[] values = {	ix, iy,
											estimateT(ix, iy, tline, target.getStartT(), target.getEndT()),
											estimateDistancePercentage(ix, iy, tline, target.getStartDistance(), target.getEndDistance())};
				return values; }}}
	return null;
}


// source code include: sketches/common/Curves/Bezier2Functions.pde


/**
 * Quadratic functions
 */

/**
 * compute the value for the quadratic bezier function at time=t
 */
double computeQuadraticBaseValue(double t, double a, double b, double c) {
	double mt = 1-t;
	return mt*mt*a + 2*mt*t*b + t*t*c; }
	
/**
 * compute the value for the first derivative of the quadratic bezier function at time=t
 */
double computeQuadraticFirstDerivativeRoot(double a, double b, double c) {
	double t=-1;
	double denominator = a -2*b + c;
	if(denominator!=0) { t = (a-b) / denominator; }
	return t; }



/**
 * Compute the bounding box based on the straightened curve, for best fit
 */
double[] computeQuadraticBoundingBox(double xa, double ya, double xb, double yb, double xc, double yc)
{
	double minx = 9999;
	double maxx = -9999;
	if(xa<minx) { minx=xa; }
	if(xa>maxx) { maxx=xa; }
	if(xc<minx) { minx=xc; }
	if(xc>maxx) { maxx=xc; }
	double t = computeQuadraticFirstDerivativeRoot(xa, xb, xc);
	if(t>=0 && t<=1) {
		double x = computeQuadraticBaseValue(t, xa, xb, xc);
		double y = computeQuadraticBaseValue(t, ya, yb, yc);
		if(x<minx) { minx=x; }
		if(x>maxx) { maxx=x; }}

	double miny = 9999;
	double maxy = -9999;
	if(ya<miny) { miny=ya; }
	if(ya>maxy) { maxy=ya; }
	if(yc<miny) { miny=yc; }
	if(yc>maxy) { maxy=yc; }
	t = computeQuadraticFirstDerivativeRoot(ya, yb, yc);
	if(t>=0 && t<=1) {
		double x = computeQuadraticBaseValue(t, xa, xb, xc);
		double y = computeQuadraticBaseValue(t, ya, yb, yc);
		if(y<miny) { miny=y; }
		if(y>maxy) { maxy=y; }}

	// bounding box corner coordinates
	double[] bbox = {minx,miny, minx,maxy, maxx,maxy, maxx,miny};
	return bbox;
}


/**
 * Compute the bounding box based on the straightened curve, for best fit
 */
double[] computeQuadraticTightBoundingBox(double xa, double ya, double xb, double yb, double xc, double yc)

{	// translate to 0,0
	Point np2 = new Point(xb - xa, yb - ya);
	Point np3 = new Point(xc - xa, yc - ya);

	// get angle for rotation
	float angle = (float) getDirection(np3.getX(), np3.getY());
	
	// rotate everything counter-angle so that it's aligned with the x-axis
	Point rnp2 = new Point(np2.getX() * cos(-angle) - np2.getY() * sin(-angle), np2.getX() * sin(-angle) + np2.getY() * cos(-angle));
	Point rnp3 = new Point(np3.getX() * cos(-angle) - np3.getY() * sin(-angle), np3.getX() * sin(-angle) + np3.getY() * cos(-angle));

	// same bounding box approach as before:
	double minx = 9999;
	double maxx = -9999;
	if(0<minx) { minx=0; }
	if(0>maxx) { maxx=0; }
	if(rnp3.getX()<minx) { minx=rnp3.getX(); }
	if(rnp3.getX()>maxx) { maxx=rnp3.getX(); }
	double t = computeQuadraticFirstDerivativeRoot(0, rnp2.getX(), rnp3.getX());
	if(t>=0 && t<=1) {
		int x = (int) computeQuadraticBaseValue(t, 0, rnp2.getX(), rnp3.getX());
		if(x<minx) { minx=x; }
		if(x>maxx) { maxx=x; }}

	float miny = 9999;
	float maxy = -9999;
	if(0<miny) { miny=0; }
	if(0>maxy) { maxy=0; }
	if(0<miny) { miny=0; }
	if(0>maxy) { maxy=0; }
	t = computeQuadraticFirstDerivativeRoot(0, rnp2.getY(), 0);
	if(t>=0 && t<=1) {
		int y = (int) computeQuadraticBaseValue(t, 0, rnp2.getY(), 0);
		if(y<miny) { miny=y; }
		if(y>maxy) { maxy=y; }}

	// bounding box corner coordinates
	Point bb1 = new Point(minx,miny);
	Point bb2 = new Point(minx,maxy);
	Point bb3 = new Point(maxx,maxy);
	Point bb4 = new Point(maxx,miny);
	
	// rotate back!
	Point nbb1 = new Point(bb1.x * cos(angle) - bb1.y * sin(angle), bb1.x * sin(angle) + bb1.y * cos(angle));
	Point nbb2 = new Point(bb2.x * cos(angle) - bb2.y * sin(angle), bb2.x * sin(angle) + bb2.y * cos(angle));
	Point nbb3 = new Point(bb3.x * cos(angle) - bb3.y * sin(angle), bb3.x * sin(angle) + bb3.y * cos(angle));
	Point nbb4 = new Point(bb4.x * cos(angle) - bb4.y * sin(angle), bb4.x * sin(angle) + bb4.y * cos(angle));
	
	// move back!
	nbb1.x += xa;	nbb1.y += ya;
	nbb2.x += xa;	nbb2.y += ya;
	nbb3.x += xa;	nbb3.y += ya;
	nbb4.x += xa;	nbb4.y += ya;
	
	double[] bbox = {nbb1.x, nbb1.y, nbb2.x, nbb2.y, nbb3.x, nbb3.y, nbb4.x, nbb4.y};
	return bbox;
}



/**
 * split a quadratic curve into two curves at time=t
 */
Segment[] splitQuadraticCurve(double t, double xa, double ya, double xb, double yb, double xc, double yc) {
	Segment[] curves = new Segment[3];
	// interpolate from 3 to 2 points
	Point p4 = new Point((1-t)*xa + t*xb, (1-t)*ya + t*yb);
	Point p5 = new Point((1-t)*xb + t*xc, (1-t)*yb + t*yc);
	// interpolate from 2 points to 1 point
	Point p6 = new Point((1-t)*p4.getX() + t*p5.getX(), (1-t)*p4.getY() + t*p5.getY());
	// we now have all the values we need to build the subcurves
	curves[0] = new Bezier2(xa,ya, p4.getX(), p4.getY(), p6.getX(), p6.getY());
	curves[0].setTValues(0,t);
	curves[1] = new Bezier2(p6.getX(), p6.getY(), p5.getX(), p5.getY(), xc, yc);
	curves[1].setTValues(t,1);
	// return full intermediate value set, in case they are needed for something else
	Point[] points = {p4, p5, p6};
	curves[2] = new PointSegment(points);
	return curves; }

/**
 * split a quadratic curve into three segments [0,t1,t2,1], returning the segment between t1 and t2
 */
Segment getQuadraticSegment(double t1, double t2, double xa, double ya, double xb, double yb, double xc, double yc)
{
	if(t1==0.0) {
		Segment[] shortcut = splitQuadraticCurve(t2, xa, ya, xb, yb, xc, yc);
		shortcut[0].setTValues(t1,t2);
		return shortcut[0]; }
	else if(t2==1.0) {
		Segment[] shortcut = splitQuadraticCurve(t1, xa, ya, xb, yb, xc, yc);
		shortcut[1].setTValues(t1,t2);
		return shortcut[1]; }
	else {
		Segment[] first_segmentation = splitQuadraticCurve(t1, xa, ya, xb, yb, xc, yc);
		double t3 = (t2-t1) * 1/(1-t1);
		Point[] fs = first_segmentation[1].points;
		Segment[] second_segmentation = splitQuadraticCurve(t3, fs[0].getX(), fs[0].getY(), fs[1].getX(), fs[1].getY(), fs[2].getX(), fs[2].getY());
		second_segmentation[0].setTValues(t1,t2);
		return second_segmentation[0]; }
}

/**
 * create an interpolated segment based on the segments "min" and "max.
 * interpolication ratios are based on the time values at the start and end of the segment.
 */
Bezier2 interpolateQuadraticForT(Segment original, Segment min, Segment max, double segment_start_t, double segment_end_t)
{
	// start point
	double tA = segment_start_t;
	// control point
	double dx = min.points[1].getX() - max.points[1].getX();
	double dy = min.points[1].getY() - max.points[1].getY();

	double[] line1 = {min.points[1].getX() - dx, min.points[1].getY() - dy, 
					min.points[1].getX() + dx, min.points[1].getY() + dy, };
	double[] intersection = intersectsLineCurve(line1, (Bezier2) original);
	// FIXME: The following is a hack, to get around double precision not being precise enough.
	//	We already know that there is an intersection when we enter this function, but machine
	//	preceision might cause the algorithm to miss the coordinate for it. So, we simply try
	//	with arbitrarily different line values until that intersection is found. Is this clean?
	//	no. Does it work? practically, yes. Can it potentially lead to an infinite block? ... yes
	//	A better solution is to encode the scaling point directly into a curve segment, if it
	//	gets computed, so that intersection checks can be omitted if it's set, removing the need
	//	for this particular hack.
	for(int f = 1; intersection==null; f++) {
		double salt = random(10000);
		double[] testline = {min.points[1].getX() - salt*dx, min.points[1].getY() - salt*dy, 
						min.points[1].getX() + salt*dx, min.points[1].getY() + salt*dy, };
		intersection = intersectsLineCurve(testline, (Bezier2) original); 
		// safeguard
		if(f>100) return null; }
	double tB = segment_start_t + (segment_end_t - segment_start_t) * intersection[2];
	// end point
	double tC = segment_end_t;

	// form interpolation
	double nxa = (1-tA) * min.points[0].getX() + tA * max.points[0].getX();
	double nxb = (1-tB) * min.points[1].getX() + tB * max.points[1].getX();
	double nxc = (1-tC) * min.points[2].getX() + tC * max.points[2].getX();
	double nya = (1-tA) * min.points[0].getY() + tA * max.points[0].getY();
	double nyb = (1-tB) * min.points[1].getY() + tB * max.points[1].getY();
	double nyc = (1-tC) * min.points[2].getY() + tC * max.points[2].getY();
	Bezier2 interpolated = new Bezier2(nxa, nya, nxb, nyb, nxc, nyc);
	return interpolated;
}

/**
 * create an interpolated segment based on the segments "min" and "max.
 * interpolication ratios are based on dinstance-on-curve at the start and end of the segment.
 */
Bezier2 interpolateQuadraticForDistance(Segment original, Segment min, Segment max, double segment_start_d, double segment_end_d)
{
	// start point
	double tA = segment_start_d;
	// control point
	double dx = min.points[1].getX() - max.points[1].getX();
	double dy = min.points[1].getY() - max.points[1].getY();
	double[] line1 = {min.points[1].getX() - 100*dx, min.points[1].getY() - 100*dy, 
					min.points[1].getX() + 100*dx, min.points[1].getY() + 100*dy, };
	double[] intersection = intersectsLineCurveWithDistance(line1, (Bezier2) original, segment_start_d, segment_end_d);
	// problem?
	if(intersection==null) { return null; }
	double tB = segment_start_d + (segment_end_d - segment_start_d) * intersection[3];
	// end point
	double tC = segment_end_d;

	// form interpolation
	double nxa = (1-tA) * min.points[0].getX() + tA * max.points[0].getX();
	double nxb = (1-tB) * min.points[1].getX() + tB * max.points[1].getX();
	double nxc = (1-tC) * min.points[2].getX() + tC * max.points[2].getX();
	double nya = (1-tA) * min.points[0].getY() + tA * max.points[0].getY();
	double nyb = (1-tB) * min.points[1].getY() + tB * max.points[1].getY();
	double nyc = (1-tC) * min.points[2].getY() + tC * max.points[2].getY();
	Bezier2 interpolated = new Bezier2(nxa, nya, nxb, nyb, nxc, nyc);
	return interpolated;
}


// source code include: sketches/common/SketchControls/Interaction.pde


// interaction handling without viewports

Point moving = null;
int mx, my;

void mouseMoved() {
	for(int p=0; p<points.length; p++) {
		if(points[p].over(mouseX,mouseY)) {
			cursor(HAND);
			return; }}
	cursor(ARROW); }

void mousePressed() {
	for(int p=0; p<points.length; p++) {
		if(points[p].over(mouseX,mouseY)) {
			moving=points[p];
			mx=mouseX;
			my=mouseY;
			break; }}}

void mouseDragged() {
	if(moving!=null) {
		moving.xo = mouseX-mx;
		moving.yo = mouseY-my; }
	redraw(); }

void mouseReleased() {
	if(moving!=null) {
		moving.x = moving.x+moving.xo;
		moving.y = moving.y+moving.yo;
		moving.xo = 0;
		moving.yo = 0;
		moving=null; }
	cursor(ARROW); }


// source code include: sketches/common/utils/EmptyConvexHull.pde


// necessary to fulfill dependencies in Bezier3Functions.pde
class ConvexHull{void add(Object a){}Point[]jarvisMarch(ArrayList a,int b,int c){return null;}}
