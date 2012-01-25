/**
 * A curve pair tracks two specific curves
 */
class CurvePair
{
  boolean swapped = false;
  Bezier2 curve1;
  Bezier2 curve2;

  /**
   * constructor
   */
  CurvePair(Bezier2 c1, Bezier2 c2)
  {
    curve1 = (c1 instanceof Bezier3) ? new Bezier3() : new Bezier2();
    curve1.setPoints(c1.points);
    curve1.computeBoundingBox();
    curve1.setShowBoundingBox(true);
    curve1.setShowPoints(false);
    curve1.setTValues(c1.getStartT(), c1.getEndT());

    curve2 = (c2 instanceof Bezier3) ? new Bezier3() : new Bezier2();
    curve2.setPoints(c2.points);
    curve2.computeBoundingBox();
    curve2.setShowBoundingBox(true);
    curve2.setShowPoints(false);
    curve2.setTValues(c2.getStartT(), c2.getEndT());
  }

  /**
   * draw the curves
   */
  void draw() { this.draw(0,0); }

  /**
   * draw the curves offset by ox/oy
   */
  void draw(int ox, int oy) {
    curve1.draw(ox,oy);
    curve2.draw(ox,oy); }

  /**
   * clip curve 2 to curve 2
   */
  Segment clip()
  {
    return curve1.clip(curve2);
  }

  void computeTightBoundingBox()
  {
    curve1.computeTightBoundingBox();
    curve2.computeTightBoundingBox();
  }

  /**
   * returns those pairs that overlap after subdividing both curves. If
   * neither curve can be further subdivided (ie, they already represent
   * an intersection), this method returns null
   */
  ArrayList generateSubPairs()
  {
    ArrayList overlappingpairs = new ArrayList();
    Segment[] subs1;
    Segment[] subs2;

    subs1 = tiny(curve1) ?  null : curve1.splitSegment(0.49);
    subs2 = tiny(curve2) ?  null : curve2.splitSegment(0.51);

    if(subs1==null && subs2==null) { return null; }

    else if(subs1==null) {
      CurvePair p1 = new CurvePair(curve1, (Bezier2) subs2[0]);
      CurvePair p2 = new CurvePair(curve1, (Bezier2) subs2[1]);
      if(p1.hasOverlap()) { overlappingpairs.add(p1); }
      if(p2.hasOverlap()) { overlappingpairs.add(p2); }}

    else if(subs2==null) {
      CurvePair p1 = new CurvePair((Bezier2) subs1[0], (Bezier2) curve2);
      CurvePair p2 = new CurvePair((Bezier2) subs1[1], (Bezier2) curve2);
      if(p1.hasOverlap()) { overlappingpairs.add(p1); }
      if(p2.hasOverlap()) { overlappingpairs.add(p2); }}

    else {
      CurvePair p1 = new CurvePair((Bezier2) subs1[0], (Bezier2) subs2[0]);
      CurvePair p2 = new CurvePair((Bezier2) subs1[1], (Bezier2) subs2[0]);
      CurvePair p3 = new CurvePair((Bezier2) subs1[0], (Bezier2) subs2[1]);
      CurvePair p4 = new CurvePair((Bezier2) subs1[1], (Bezier2) subs2[1]);
      if(p1.hasOverlap()) { overlappingpairs.add(p1); }
      if(p2.hasOverlap()) { overlappingpairs.add(p2); }
      if(p3.hasOverlap()) { overlappingpairs.add(p3); }
      if(p4.hasOverlap()) { overlappingpairs.add(p4); }}

    return overlappingpairs;
  }

  /**
   * checks whether or not the two curves in this pair have an overlap,
   * based on their bounding boxes
   */
  boolean hasOverlap()
  {
    return curvesOverlap(curve1, curve2);
  }

  boolean isTiny()
  {
    return tiny(curve1) && tiny(curve2);
  }

  // a tiny curve has all its coordinates within a pixel of each other.
  boolean tiny(Bezier2 curve)
  {
    Point[] p = curve.points;
    // start to end
    boolean tiny = abs(p[0].x - p[p.length-1].x)<=2 && abs(p[0].y - p[p.length-1].y)<=2;
    if(!tiny) return false;
    // coordinate lines
    for(int i=0; i<p.length-1;i++) {
      if(abs(p[i].x - p[i+1].x)>1.5 || abs(p[i].y - p[i+1].y)>1.5) {
        return false; }}
    return true;
  }

  void swap()
  {
    Bezier2 tmp = curve1;
    curve1 = curve2;
    curve2 = tmp;
  }

  double[] getIntersection()
  {
    double[] intersection = new double[4];
    Point[] p1 = curve1.points;
    Point[] p2 = curve2.points;
    int s = 0;
    int e = p1.length-1;
    double[] line1 = {p1[s].x, p1[s].y, p1[e].x, p1[e].y, };
    double[] line2 = {p2[s].x, p2[s].y, p2[e].x, p2[e].y, };
    double[] llint = intersectsLineLine(line1, line2);
    intersection[0] = llint[0];
    intersection[1] = llint[1];
    double t1 = curve1.getStartT() + (curve1.getEndT()-curve1.getStartT()) * (p1[e].x - p1[s].x)/llint[0];
    double t2 = curve2.getStartT() + (curve2.getEndT()-curve2.getStartT()) * (p2[e].x - p2[s].x)/llint[0];
    intersection[2] = t1;
    intersection[3] = t2;
    return intersection;
  }

  boolean equals(Object o)
  {
    if(this==o) return true;
    if(!(o instanceof CurvePair)) return false;
    CurvePair other = (CurvePair) o;
    return (curve1.equals(other.curve1) && curve2.equals(other.curve2)) ||
          (curve1.equals(other.curve2) && curve2.equals(other.curve1));
  }

  String toString()
  {
    return "{"+curve1.toString() + ","+curve2.toString()+"}";
  }
}
