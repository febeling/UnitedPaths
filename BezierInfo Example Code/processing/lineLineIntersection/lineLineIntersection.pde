// main sketch code: sketches/examples/intersection/line-line/Intersection.pde

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
 * Set up four points, to form two lines
 */
void setupPoints()
{
	points = new Point[4];
	points[0] = new Point(50,50);
	points[1] = new Point(150,110);
	points[2] = new Point(50,250);
	points[3] = new Point(170,170);
}

// REQUIRED METHOD
void draw()
{
	noFill();
	stroke(0);
	background(255);
	drawExtras();
	drawLines();
	showPoints(points);
}

/**
 * Draw the two line segment <1,2> and <3,4>
 */
void drawLines()
{
	stroke(0);
	drawLine(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY());
	drawLine(points[2].getX(), points[2].getY(), points[3].getX(), points[3].getY());
}

/**
 * Draw the lines that our line segments are intervals on,
 * plus the intersection (if there is one)
 */
void drawExtras()
{
	stroke(0,50);
	// possible?
	double den = (points[1].getX()-points[0].getX());
	if(den!=0) {
		double a = (points[1].getY()-points[0].getY()) / den;
		double b = points[0].getY() - (a * points[0].getX());
		drawLine(0,b, boxsize, a*boxsize +b); }
	else { drawLine(points[0].getX(),0,points[0].getX(),boxsize); }

	den = (points[3].getX()-points[2].getX());
	if(den!=0) {
		double c = (points[3].getY()-points[2].getY()) / den;
		double d = points[2].getY() - (c * points[2].getX());
		drawLine(0,d, boxsize, c*boxsize +d); }
	else { drawLine(points[2].getX(),0,points[2].getX(),boxsize); }

	double[] line1 = {points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY()};
	double[] line2 = {points[2].getX(), points[2].getY(), points[3].getX(), points[3].getY()};
	// NOTE: intersectsLineLine() is found in common/common.pde
	double[] intersection = intersectsLineLine(line1, line2);
	
	if(intersection!=null) {
		drawIntersection(intersection[0], intersection[1], line1, line2); }
}

/**
 * Draw the intersection between the line( segment)s. If it's between
 * lines only, draw point red. If it's between our line segments, draw point
 * green. If the intersection falls outside the screen, nothing is drawn.
 */
void drawIntersection(double ix, double iy, double[] line1, double[] line2)
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

		if(bounds_xmin<=ix && ix<=bounds_xmax && bounds_ymin<=iy && iy<=bounds_ymax) {
			fill(0,255,0); stroke(0,255,0); }
		else { fill(255,0,0); stroke(255,0,0); }
		drawEllipse(ix,iy,6,6);
	}
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
