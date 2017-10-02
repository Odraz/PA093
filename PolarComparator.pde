import java.util.Comparator;

class PolarComparator implements Comparator<Point> {

  Point r;
  
  public PolarComparator(Point reference){
    this.r = reference;
  }
  
  @Override
  public int compare(Point p, Point q){
      int compPolar = (int)counterClockwise(p, r, q);
      int compDist = (int)dist(p.x, p.y, r.x, r.y) - (int)dist(q.x, q.y, r.x, r.y); 
      return compPolar == 0 ? compDist : compPolar;
  }
}