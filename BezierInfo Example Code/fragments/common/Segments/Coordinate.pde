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
