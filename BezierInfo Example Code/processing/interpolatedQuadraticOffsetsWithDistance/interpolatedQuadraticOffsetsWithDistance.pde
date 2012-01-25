// main sketch code: sketches/examples/illustrative/quadOffset3.pde

// Dependencies are in the "common" directory
// © 2011 Mike "Pomax" Kamermans of nihongoresources.com

Point[] points;
int boxsize = 300;
int steps = 30;

// REQUIRED METHOD
void setup()
{
	size(boxsize,boxsize);
	noLoop();
	setupSegments();
	text("",0,0);
}

/**
 * Set up three points, to form a quadratic curve
 */
void setupSegments()
{
	points = new Point[3];
	points[0] = new Point(20,25);
	points[1] = new Point(85,265);
	points[2] = new Point(265,240);
}


// REQUIRED METHOD
void draw()
{
	noFill();
	stroke(0);
	background(255);
	drawCurves();
	drawExtras();
}

/**
 * Run through the entire interval [0,1] for 't'.
 */
void drawCurves()
{
	Bezier2 linesegment = new Bezier2(points[0].getX(), points[0].getY(), points[1].getX(), points[1].getY(), points[2].getX(), points[2].getY());
	linesegment.draw();
	drawOffsets(linesegment);
}

void drawOffsets(Segment segment) {
	Segment[] segments = segment.offset(0);
	Segment[] n_offset = segment.offset(-20);
	Segment[] f_offset = segment.offset(-(20+steps));

	// get total distance, based on segments! (otherwise rounding might mess things up thoroughly)
	double curvelength = computeQuadraticCurveLength(1.0, 12,
                                                    points[0].getX(), points[0].getY(),
                                                    points[1].getX(), points[1].getY(),
                                                    points[2].getX(), points[2].getY());

	// interpolation, distance base
	for(int f=0; f<n_offset.length; f++) {

		if(f%2==0) { n_offset[f].setColor(200,200,255); } else { n_offset[f].setColor(255,200,200); }
		n_offset[f].setShowPoints(false);
		n_offset[f].draw(); 
		
		if(f%2==0) { f_offset[f].setColor(255,200,200); } else { f_offset[f].setColor(200,200,255); }
		f_offset[f].setShowPoints(false);
		f_offset[f].draw();

    double dsf_start = computeQuadraticCurveLength(n_offset[f].getStartT(), 12,
                                                    points[0].getX(), points[0].getY(),
                                                    points[1].getX(), points[1].getY(),
                                                    points[2].getX(), points[2].getY());
    double dsf_end = computeQuadraticCurveLength(n_offset[f].getEndT(), 12,
                                                    points[0].getX(), points[0].getY(),
                                                    points[1].getX(), points[1].getY(),
                                                    points[2].getX(), points[2].getY());

		// interpolation, distance based
		double start_distance = dsf_start/curvelength;
		double end_distance = dsf_end/curvelength;
		Bezier2 interpolated = interpolateQuadraticForDistance(segments[f], n_offset[f], f_offset[f],  start_distance, end_distance);
		if(interpolated!=null) {
			interpolated.setShowPoints(false);
			interpolated.setColor(0,150,0);
			interpolated.draw(); }
	}
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
	drawLine(points[2].getX(), points[2].getY(), points[1].getX(), points[1].getY());
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


// source code include: sketches/common/SketchControls/StepInteraction.pde


// intertaction handling for sketches with a "steps" regulator

void keyPressed()
{
	if(key=='+' || key == 107) { steps++; redraw(); }
	else if(key=='-' || key == 109) { if(steps>1) steps--; redraw(); }
}


// source code include: sketches/common/utils/LGQuadrature.pde


// Legendre-Gauss abscissae (xi values, defined at i=n as the roots of the nth order Legendre polynomial Pn(x))
double[][] Tvalues = {{},{},
  {-0.5773502691896257310588680411456152796745,0.5773502691896257310588680411456152796745},
  {0.0000000000000000000000000000000000000000,-0.7745966692414834042779148148838430643082,0.7745966692414834042779148148838430643082},
  {-0.3399810435848562573113440521410666406155,0.3399810435848562573113440521410666406155,-0.8611363115940525725378051902225706726313,0.8611363115940525725378051902225706726313},
  {0.0000000000000000000000000000000000000000,-0.5384693101056831077144693153968546539545,0.5384693101056831077144693153968546539545,-0.9061798459386639637003213465504813939333,0.9061798459386639637003213465504813939333},
  {0.6612093864662644815410885712481103837490,-0.6612093864662644815410885712481103837490,-0.2386191860831969047129774708082550205290,0.2386191860831969047129774708082550205290,-0.9324695142031520500580654697841964662075,0.9324695142031520500580654697841964662075},
  {0.0000000000000000000000000000000000000000,0.4058451513773971841558818596240598708391,-0.4058451513773971841558818596240598708391,-0.7415311855993944600839995473506860435009,0.7415311855993944600839995473506860435009,-0.9491079123427584862682238053821492940187,0.9491079123427584862682238053821492940187},
  {-0.1834346424956498078362443493460887111723,0.1834346424956498078362443493460887111723,-0.5255324099163289908176466269651427865028,0.5255324099163289908176466269651427865028,-0.7966664774136267279658341067261062562466,0.7966664774136267279658341067261062562466,-0.9602898564975362871720676594122778624296,0.9602898564975362871720676594122778624296},
  {0.0000000000000000000000000000000000000000,-0.8360311073266357695388251158874481916428,0.8360311073266357695388251158874481916428,-0.9681602395076260858530758923734538257122,0.9681602395076260858530758923734538257122,-0.3242534234038089158147499801998492330313,0.3242534234038089158147499801998492330313,-0.6133714327005903577116896485676988959312,0.6133714327005903577116896485676988959312},
  {-0.1488743389816312157059030596428783610463,0.1488743389816312157059030596428783610463,-0.4333953941292472133994806426926515996456,0.4333953941292472133994806426926515996456,-0.6794095682990244355892173189204186201096,0.6794095682990244355892173189204186201096,-0.8650633666889845363456856830453034490347,0.8650633666889845363456856830453034490347,-0.9739065285171717434309357486199587583542,0.9739065285171717434309357486199587583542},
  {0.0000000000000000000000000000000000000000,-0.2695431559523449593918087430211016908288,0.2695431559523449593918087430211016908288,-0.5190961292068118071441062966187018901110,0.5190961292068118071441062966187018901110,-0.7301520055740493564400139803183265030384,0.7301520055740493564400139803183265030384,-0.8870625997680953167545681026240345090628,0.8870625997680953167545681026240345090628,-0.9782286581460569729884468870295677334070,0.9782286581460569729884468870295677334070},
  {-0.1252334085114689132822718420356977730989,0.1252334085114689132822718420356977730989,-0.3678314989981801841345543380157323554158,0.3678314989981801841345543380157323554158,-0.5873179542866174829285341729701030999422,0.5873179542866174829285341729701030999422,-0.7699026741943046925342741815256886184216,0.7699026741943046925342741815256886184216,-0.9041172563704749087776235683122649788857,0.9041172563704749087776235683122649788857,-0.9815606342467192435563561048184055835009,0.9815606342467192435563561048184055835009},
  {0.0000000000000000000000000000000000000000,-0.2304583159551348015003924274424207396805,0.2304583159551348015003924274424207396805,-0.4484927510364468683512484403763664886355,0.4484927510364468683512484403763664886355,-0.6423493394403402279024817289609927684069,0.6423493394403402279024817289609927684069,-0.8015780907333098781464286730624735355377,0.8015780907333098781464286730624735355377,-0.9175983992229779229177211163914762437344,0.9175983992229779229177211163914762437344,-0.9841830547185881350458203087328001856804,0.9841830547185881350458203087328001856804},
  {-0.1080549487073436676354276642086915671825,0.1080549487073436676354276642086915671825,-0.3191123689278897446186533670697826892138,0.3191123689278897446186533670697826892138,-0.5152486363581540995681962158414535224438,0.5152486363581540995681962158414535224438,-0.6872929048116854788830210054584313184023,0.6872929048116854788830210054584313184023,-0.8272013150697650196718768711434677243233,0.8272013150697650196718768711434677243233,-0.9284348836635735180422557277779560536146,0.9284348836635735180422557277779560536146,-0.9862838086968123141318187663273420184851,0.9862838086968123141318187663273420184851},
  {0.0000000000000000000000000000000000000000,-0.2011940939974345143870237961891689337790,0.2011940939974345143870237961891689337790,-0.3941513470775633853904196257644798606634,0.3941513470775633853904196257644798606634,-0.5709721726085388304738899023504927754402,0.5709721726085388304738899023504927754402,-0.7244177313601700696210627938853576779366,0.7244177313601700696210627938853576779366,-0.8482065834104272061821916395274456590414,0.8482065834104272061821916395274456590414,-0.9372733924007059513883177714888006448746,0.9372733924007059513883177714888006448746,-0.9879925180204853774057482951320707798004,0.9879925180204853774057482951320707798004},
  {-0.0950125098376374405129141109682677779347,0.0950125098376374405129141109682677779347,-0.2816035507792589154263396267197094857693,0.2816035507792589154263396267197094857693,-0.4580167776572273696800152720243204385042,0.4580167776572273696800152720243204385042,-0.6178762444026437705701937375124543905258,0.6178762444026437705701937375124543905258,-0.7554044083550029986540153004170861095190,0.7554044083550029986540153004170861095190,-0.8656312023878317551961458775622304528952,0.8656312023878317551961458775622304528952,-0.9445750230732326002680565579794347286224,0.9445750230732326002680565579794347286224,-0.9894009349916499385102497399202547967434,0.9894009349916499385102497399202547967434},
  {0.0000000000000000000000000000000000000000,-0.1784841814958478545261044700964703224599,0.1784841814958478545261044700964703224599,-0.3512317634538763000406902392569463700056,0.3512317634538763000406902392569463700056,-0.5126905370864769384553483178024180233479,0.5126905370864769384553483178024180233479,-0.6576711592166907260903485621383879333735,0.6576711592166907260903485621383879333735,-0.7815140038968013680431567991035990417004,0.7815140038968013680431567991035990417004,-0.8802391537269859123071569229068700224161,0.8802391537269859123071569229068700224161,-0.9506755217687677950166857954172883182764,0.9506755217687677950166857954172883182764,-0.9905754753144173641032921295845881104469,0.9905754753144173641032921295845881104469},
  {-0.0847750130417353059408824833553808275610,0.0847750130417353059408824833553808275610,-0.2518862256915054831374334298743633553386,0.2518862256915054831374334298743633553386,-0.4117511614628426297457508553634397685528,0.4117511614628426297457508553634397685528,-0.5597708310739475390249708652845583856106,0.5597708310739475390249708652845583856106,-0.6916870430603532238222896921797655522823,0.6916870430603532238222896921797655522823,-0.8037049589725231424353069087374024093151,0.8037049589725231424353069087374024093151,-0.8926024664975557021406871172075625509024,0.8926024664975557021406871172075625509024,-0.9558239495713977129653926567698363214731,0.9558239495713977129653926567698363214731,-0.9915651684209308980300079383596312254667,0.9915651684209308980300079383596312254667},
  {0.0000000000000000000000000000000000000000,-0.1603586456402253668240831530056311748922,0.1603586456402253668240831530056311748922,-0.3165640999636298302810644145210972055793,0.3165640999636298302810644145210972055793,-0.4645707413759609383241411251219687983394,0.4645707413759609383241411251219687983394,-0.6005453046616809897884081692609470337629,0.6005453046616809897884081692609470337629,-0.7209661773352293856476080691209062933922,0.7209661773352293856476080691209062933922,-0.8227146565371428188484514976153150200844,0.8227146565371428188484514976153150200844,-0.9031559036148179009373393455462064594030,0.9031559036148179009373393455462064594030,-0.9602081521348300174878431789693422615528,0.9602081521348300174878431789693422615528,-0.9924068438435843519940249279898125678301,0.9924068438435843519940249279898125678301},
  {-0.0765265211334973383117130651953630149364,0.0765265211334973383117130651953630149364,-0.2277858511416450681963397073559463024139,0.2277858511416450681963397073559463024139,-0.3737060887154195487624974703066982328892,0.3737060887154195487624974703066982328892,-0.5108670019508271264996324134699534624815,0.5108670019508271264996324134699534624815,-0.6360536807265150249790508496516849845648,0.6360536807265150249790508496516849845648,-0.7463319064601507957235071444301865994930,0.7463319064601507957235071444301865994930,-0.8391169718222187823286617458506952971220,0.8391169718222187823286617458506952971220,-0.9122344282513259461353527512983419001102,0.9122344282513259461353527512983419001102,-0.9639719272779138092843709273438435047865,0.9639719272779138092843709273438435047865,-0.9931285991850948846604296704754233360291,0.9931285991850948846604296704754233360291},
  {0.0000000000000000000000000000000000000000,-0.1455618541608950933241573011400760151446,0.1455618541608950933241573011400760151446,-0.2880213168024011172185794293909566476941,0.2880213168024011172185794293909566476941,-0.4243421202074387776903563462838064879179,0.4243421202074387776903563462838064879179,-0.5516188358872198271853903861483559012413,0.5516188358872198271853903861483559012413,-0.6671388041974123384036943207320291548967,0.6671388041974123384036943207320291548967,-0.7684399634756778896260698275000322610140,0.7684399634756778896260698275000322610140,-0.8533633645833172964856316866644192487001,0.8533633645833172964856316866644192487001,-0.9200993341504007938524978271743748337030,0.9200993341504007938524978271743748337030,-0.9672268385663063128276917268522083759308,0.9672268385663063128276917268522083759308,-0.9937521706203894522602126926358323544264,0.9937521706203894522602126926358323544264},
  {-0.0697392733197222253194169638845778536052,0.0697392733197222253194169638845778536052,-0.2078604266882212725509049278116435743868,0.2078604266882212725509049278116435743868,-0.3419358208920842412403828802780481055379,0.3419358208920842412403828802780481055379,-0.4693558379867570073962212973128771409392,0.4693558379867570073962212973128771409392,-0.5876404035069116016387624767958186566830,0.5876404035069116016387624767958186566830,-0.6944872631866827461522007070016115903854,0.6944872631866827461522007070016115903854,-0.7878168059792081123759999172762036323547,0.7878168059792081123759999172762036323547,-0.8658125777203001804949167308222968131304,0.8658125777203001804949167308222968131304,-0.9269567721871739829353487039043102413416,0.9269567721871739829353487039043102413416,-0.9700604978354286922481719557254109531641,0.9700604978354286922481719557254109531641,-0.9942945854823992402060639506089501082897,0.9942945854823992402060639506089501082897},
  {0.0000000000000000000000000000000000000000,-0.1332568242984661088801345840693102218211,0.1332568242984661088801345840693102218211,-0.2641356809703449548543119362875586375594,0.2641356809703449548543119362875586375594,-0.3903010380302908144400930723350029438734,0.3903010380302908144400930723350029438734,-0.5095014778460075222099590064317453652620,0.5095014778460075222099590064317453652620,-0.6196098757636461229481028567533940076828,0.6196098757636461229481028567533940076828,-0.7186613631319501704908248029823880642653,0.7186613631319501704908248029823880642653,-0.8048884016188398993207897547108586877584,0.8048884016188398993207897547108586877584,-0.8767523582704416229560706597112584859133,0.8767523582704416229560706597112584859133,-0.9329710868260161493736859483760781586170,0.9329710868260161493736859483760781586170,-0.9725424712181152120393790028174407780170,0.9725424712181152120393790028174407780170,-0.9947693349975521570627279288601130247116,0.9947693349975521570627279288601130247116},
  {-0.0640568928626056299791002857091370970011,0.0640568928626056299791002857091370970011,-0.1911188674736163106704367464772076345980,0.1911188674736163106704367464772076345980,-0.3150426796961633968408023065421730279922,0.3150426796961633968408023065421730279922,-0.4337935076260451272567308933503227308393,0.4337935076260451272567308933503227308393,-0.5454214713888395626995020393223967403173,0.5454214713888395626995020393223967403173,-0.6480936519369755455244330732966773211956,0.6480936519369755455244330732966773211956,-0.7401241915785543579175964623573236167431,0.7401241915785543579175964623573236167431,-0.8200019859739029470802051946520805358887,0.8200019859739029470802051946520805358887,-0.8864155270044010714869386902137193828821,0.8864155270044010714869386902137193828821,-0.9382745520027327978951348086411599069834,0.9382745520027327978951348086411599069834,-0.9747285559713094738043537290650419890881,0.9747285559713094738043537290650419890881,-0.9951872199970213106468008845695294439793,0.9951872199970213106468008845695294439793}};

// Legendre-Gauss weights (wi values, defined by a function linked to in the Bezier primer article)
double[][] Cvalues = {{},{},
  {1.0000000000000000000000000000000000000000,1.0000000000000000000000000000000000000000},
  {0.8888888888888888395456433499930426478386,0.5555555555555555802271783250034786760807,0.5555555555555555802271783250034786760807},
  {0.6521451548625460947761212082696147263050,0.6521451548625460947761212082696147263050,0.3478548451374538497127275604725582525134,0.3478548451374538497127275604725582525134},
  {0.5688888888888888883954564334999304264784,0.4786286704993664709029133064177585765719,0.4786286704993664709029133064177585765719,0.2369268850561890848993584768322762101889,0.2369268850561890848993584768322762101889},
  {0.3607615730481386062677984227775596082211,0.3607615730481386062677984227775596082211,0.4679139345726910370615314604947343468666,0.4679139345726910370615314604947343468666,0.1713244923791703566706701167277060449123,0.1713244923791703566706701167277060449123},
  {0.4179591836734694032529091600736137479544,0.3818300505051189230876218516641529276967,0.3818300505051189230876218516641529276967,0.2797053914892766446342875497066415846348,0.2797053914892766446342875497066415846348,0.1294849661688697028960604029634851031005,0.1294849661688697028960604029634851031005},
  {0.3626837833783619902128236844873754307628,0.3626837833783619902128236844873754307628,0.3137066458778872690693617641954915598035,0.3137066458778872690693617641954915598035,0.2223810344533744820516574236535234376788,0.2223810344533744820516574236535234376788,0.1012285362903762586661571276636095717549,0.1012285362903762586661571276636095717549},
  {0.3302393550012597822629345500899944454432,0.1806481606948573959137149813614087179303,0.1806481606948573959137149813614087179303,0.0812743883615744122650426106702070683241,0.0812743883615744122650426106702070683241,0.3123470770400028628799304897256661206484,0.3123470770400028628799304897256661206484,0.2606106964029354378098446431977208703756,0.2606106964029354378098446431977208703756},
  {0.2955242247147528700246255084493895992637,0.2955242247147528700246255084493895992637,0.2692667193099963496294435572053771466017,0.2692667193099963496294435572053771466017,0.2190863625159820415877476307286997325718,0.2190863625159820415877476307286997325718,0.1494513491505805868886369580650352872908,0.1494513491505805868886369580650352872908,0.0666713443086881379917585377370414789766,0.0666713443086881379917585377370414789766},
  {0.2729250867779006162194832540990319103003,0.2628045445102466515230332788632949814200,0.2628045445102466515230332788632949814200,0.2331937645919904822378043718344997614622,0.2331937645919904822378043718344997614622,0.1862902109277342621584949711177614517510,0.1862902109277342621584949711177614517510,0.1255803694649046120535018644659430719912,0.1255803694649046120535018644659430719912,0.0556685671161736631007421749472996452823,0.0556685671161736631007421749472996452823},
  {0.2491470458134027732288728884668671526015,0.2491470458134027732288728884668671526015,0.2334925365383548057085505433860816992819,0.2334925365383548057085505433860816992819,0.2031674267230659247651658461109036579728,0.2031674267230659247651658461109036579728,0.1600783285433462210800570346691529266536,0.1600783285433462210800570346691529266536,0.1069393259953184266430881166343169752508,0.1069393259953184266430881166343169752508,0.0471753363865118277575838590109924552962,0.0471753363865118277575838590109924552962},
  {0.2325515532308738975153517003491288051009,0.2262831802628972321933531475224299356341,0.2262831802628972321933531475224299356341,0.2078160475368885096170146198346628807485,0.2078160475368885096170146198346628807485,0.1781459807619457380578609217991470359266,0.1781459807619457380578609217991470359266,0.1388735102197872495199959530509659089148,0.1388735102197872495199959530509659089148,0.0921214998377284516317686779984796885401,0.0921214998377284516317686779984796885401,0.0404840047653158771612247335269785253331,0.0404840047653158771612247335269785253331},
  {0.2152638534631577948985636794532183557749,0.2152638534631577948985636794532183557749,0.2051984637212956041896205761076998896897,0.2051984637212956041896205761076998896897,0.1855383974779378219999159682629397138953,0.1855383974779378219999159682629397138953,0.1572031671581935463599677404999965801835,0.1572031671581935463599677404999965801835,0.1215185706879031851679329179205524269491,0.1215185706879031851679329179205524269491,0.0801580871597602079292599341897584963590,0.0801580871597602079292599341897584963590,0.0351194603317518602714208952875196700916,0.0351194603317518602714208952875196700916},
  {0.2025782419255612865072180284187197685242,0.1984314853271115786093048427574103698134,0.1984314853271115786093048427574103698134,0.1861610000155622113293674146916600875556,0.1861610000155622113293674146916600875556,0.1662692058169939202105780395868350751698,0.1662692058169939202105780395868350751698,0.1395706779261543240000520427201990969479,0.1395706779261543240000520427201990969479,0.1071592204671719394948325998484506271780,0.1071592204671719394948325998484506271780,0.0703660474881081243747615872052847407758,0.0703660474881081243747615872052847407758,0.0307532419961172691358353148416426847689,0.0307532419961172691358353148416426847689},
  {0.1894506104550685021692402187909465283155,0.1894506104550685021692402187909465283155,0.1826034150449235837765371570640127174556,0.1826034150449235837765371570640127174556,0.1691565193950025358660127494658809155226,0.1691565193950025358660127494658809155226,0.1495959888165767359691216142891789786518,0.1495959888165767359691216142891789786518,0.1246289712555338768940060845125117339194,0.1246289712555338768940060845125117339194,0.0951585116824927856882254673109855502844,0.0951585116824927856882254673109855502844,0.0622535239386478936318702892549481475726,0.0622535239386478936318702892549481475726,0.0271524594117540964133272751723779947497,0.0271524594117540964133272751723779947497},
  {0.1794464703562065333031227964966092258692,0.1765627053669926449508409405098063871264,0.1765627053669926449508409405098063871264,0.1680041021564500358653759803928551264107,0.1680041021564500358653759803928551264107,0.1540457610768102836296122859494062140584,0.1540457610768102836296122859494062140584,0.1351363684685254751283167706787935458124,0.1351363684685254751283167706787935458124,0.1118838471934039680011352402289048768580,0.1118838471934039680011352402289048768580,0.0850361483171791776580761279547004960477,0.0850361483171791776580761279547004960477,0.0554595293739872027827253475606994470581,0.0554595293739872027827253475606994470581,0.0241483028685479314545681006620725383982,0.0241483028685479314545681006620725383982},
  {0.1691423829631436004383715498988749459386,0.1691423829631436004383715498988749459386,0.1642764837458327298325144738555536605418,0.1642764837458327298325144738555536605418,0.1546846751262652419622867228099494241178,0.1546846751262652419622867228099494241178,0.1406429146706506538855308008351130411029,0.1406429146706506538855308008351130411029,0.1225552067114784593471199514169711619616,0.1225552067114784593471199514169711619616,0.1009420441062871681703327908508072141558,0.1009420441062871681703327908508072141558,0.0764257302548890515847546112127020023763,0.0764257302548890515847546112127020023763,0.0497145488949697969549568199454370187595,0.0497145488949697969549568199454370187595,0.0216160135264833117019200869890482863411,0.0216160135264833117019200869890482863411},
  {0.1610544498487836984068621859478298574686,0.1589688433939543399375793342187535017729,0.1589688433939543399375793342187535017729,0.1527660420658596696075193221986410208046,0.1527660420658596696075193221986410208046,0.1426067021736066031678547005867585539818,0.1426067021736066031678547005867585539818,0.1287539625393362141547726196222356520593,0.1287539625393362141547726196222356520593,0.1115666455473339896409257221421285066754,0.1115666455473339896409257221421285066754,0.0914900216224499990280705219447554554790,0.0914900216224499990280705219447554554790,0.0690445427376412262931992813719261903316,0.0690445427376412262931992813719261903316,0.0448142267656995996194524423117400147021,0.0448142267656995996194524423117400147021,0.0194617882297264781221723950466184760444,0.0194617882297264781221723950466184760444},
  {0.1527533871307258372951309866039082407951,0.1527533871307258372951309866039082407951,0.1491729864726037413369397199858212843537,0.1491729864726037413369397199858212843537,0.1420961093183820411756101975697674788535,0.1420961093183820411756101975697674788535,0.1316886384491766370796739238357986323535,0.1316886384491766370796739238357986323535,0.1181945319615184120110029653005767613649,0.1181945319615184120110029653005767613649,0.1019301198172404415709380032240005675703,0.1019301198172404415709380032240005675703,0.0832767415767047547436874310733401216567,0.0832767415767047547436874310733401216567,0.0626720483341090678353069165495980996639,0.0626720483341090678353069165495980996639,0.0406014298003869386621822457072994438931,0.0406014298003869386621822457072994438931,0.0176140071391521178811867542890468030237,0.0176140071391521178811867542890468030237},
  {0.1460811336496904144777175815761438570917,0.1445244039899700461138110085812513716519,0.1445244039899700461138110085812513716519,0.1398873947910731496691028041823301464319,0.1398873947910731496691028041823301464319,0.1322689386333374683690777828815043903887,0.1322689386333374683690777828815043903887,0.1218314160537285334440227302366110961884,0.1218314160537285334440227302366110961884,0.1087972991671483785625085261017375160009,0.1087972991671483785625085261017375160009,0.0934444234560338621298214434318651910871,0.0934444234560338621298214434318651910871,0.0761001136283793039316591944043466355652,0.0761001136283793039316591944043466355652,0.0571344254268572049326735395879950374365,0.0571344254268572049326735395879950374365,0.0369537897708524937234741969405149575323,0.0369537897708524937234741969405149575323,0.0160172282577743345377552230957007850520,0.0160172282577743345377552230957007850520},
  {0.1392518728556319806966001806358690373600,0.1392518728556319806966001806358690373600,0.1365414983460151721050834794368711300194,0.1365414983460151721050834794368711300194,0.1311735047870623838139891859100316651165,0.1311735047870623838139891859100316651165,0.1232523768105124178928733158500108402222,0.1232523768105124178928733158500108402222,0.1129322960805392156435900119504367467016,0.1129322960805392156435900119504367467016,0.1004141444428809648581335522976587526500,0.1004141444428809648581335522976587526500,0.0859416062170677286236042391465161927044,0.0859416062170677286236042391465161927044,0.0697964684245204886048341563764552120119,0.0697964684245204886048341563764552120119,0.0522933351526832859712534684604179346934,0.0522933351526832859712534684604179346934,0.0337749015848141515006020085820637177676,0.0337749015848141515006020085820637177676,0.0146279952982721998810955454928262042813,0.0146279952982721998810955454928262042813},
  {0.1336545721861061852830943053049850277603,0.1324620394046966131984532921705977059901,0.1324620394046966131984532921705977059901,0.1289057221880821613169132433540653437376,0.1289057221880821613169132433540653437376,0.1230490843067295336776822978208656422794,0.1230490843067295336776822978208656422794,0.1149966402224113642960290349037677515298,0.1149966402224113642960290349037677515298,0.1048920914645414120824895576333801727742,0.1048920914645414120824895576333801727742,0.0929157660600351542612429511791560798883,0.0929157660600351542612429511791560798883,0.0792814117767189491248203125906002242118,0.0792814117767189491248203125906002242118,0.0642324214085258499151720457120973151177,0.0642324214085258499151720457120973151177,0.0480376717310846690356385124687221832573,0.0480376717310846690356385124687221832573,0.0309880058569794447631551292943186126649,0.0309880058569794447631551292943186126649,0.0134118594871417712993677540112003043760,0.0134118594871417712993677540112003043760},
  {0.1279381953467521593204025975865079089999,0.1279381953467521593204025975865079089999,0.1258374563468283025002847352880053222179,0.1258374563468283025002847352880053222179,0.1216704729278033914052770114722079597414,0.1216704729278033914052770114722079597414,0.1155056680537255991980671865348995197564,0.1155056680537255991980671865348995197564,0.1074442701159656343712356374453520402312,0.1074442701159656343712356374453520402312,0.0976186521041138843823858906034729443491,0.0976186521041138843823858906034729443491,0.0861901615319532743431096832864568568766,0.0861901615319532743431096832864568568766,0.0733464814110802998392557583429152145982,0.0733464814110802998392557583429152145982,0.0592985849154367833380163688161701429635,0.0592985849154367833380163688161701429635,0.0442774388174198077483545432642131345347,0.0442774388174198077483545432642131345347,0.0285313886289336633705904233693217975087,0.0285313886289336633705904233693217975087,0.0123412297999872001830201639904771582223,0.0123412297999872001830201639904771582223}};

/**
 * Gauss quadrature for quadratic Bezier curves
 */
double computeQuadraticCurveLength(double z, int n, double x1, double y1, double x2, double y2, double x3, double y3)
{
  double z2 = z/2.0;
  double sum = 0;
  for(int i=0; i<n; i++) {
    double corrected_t = z2 * Tvalues[n][i] + z2;
    sum += Cvalues[n][i] * quadraticF(corrected_t,x1,y1,x2,y2,x3,y3); }
  return z2 * sum;
}

double quadraticF(double t, double x1, double y1, double x2, double y2, double x3, double y3)
{
  double xbase = base2(t,x1,x2,x3);
  double ybase = base2(t,y1,y2,y3);
  double combined = xbase*xbase + ybase*ybase;
  return sqrt(combined);
}

double base2(double t, double p1, double p2, double p3)
{
  return t*(2*p1 - 4*p2 + 2*p3) - 2*p1 + 2*p2;
}


/**
 * Gauss quadrature for cubic Bezier curves
 */
double computeCubicCurveLength(double z, int n, double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4)
{
  double z2 = z/2.0;
  double sum = 0;
  for(int i=0; i<n; i++) {
    double corrected_t = z2 * Tvalues[n][i] + z2;
    sum += Cvalues[n][i] * cubicF(corrected_t,x1,y1,x2,y2,x3,y3,x4,y4); }
  return z2 * sum;
}

double cubicF(double t, double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4)
{
  double xbase = base3(t,x1,x2,x3,x4);
  double ybase = base3(t,y1,y2,y3,y4);
  double combined = xbase*xbase + ybase*ybase;
  return sqrt(combined);
}

double base3(double t, double p1, double p2, double p3, double p4)
{
  double t1 = -3*p1 + 9*p2 - 9*p3 + 3*p4;
  double t2 = t*t1 + 6*p1 - 12*p2 + 6*p3;
  return t*t2 - 3*p1 + 3*p2;
}


// source code include: sketches/common/utils/EmptyConvexHull.pde


// necessary to fulfill dependencies in Bezier3Functions.pde
class ConvexHull{void add(Object a){}Point[]jarvisMarch(ArrayList a,int b,int c){return null;}}
