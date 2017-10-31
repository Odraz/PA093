import java.util.Comparator;

class VerticalComparator implements Comparator<Point> {

  @Override
  public int compare(Point p, Point q){
      return p.y > q.y ? -1 : 1;
  }
}