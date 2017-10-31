import java.util.Comparator;

class HorizontalComparator implements Comparator<Point> {

  @Override
  public int compare(Point p, Point q){
      return p.x > q.x ? 1 : -1;
  }
}