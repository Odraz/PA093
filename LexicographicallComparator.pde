import java.util.Comparator;

class LexicographicallComparator implements Comparator<Point> {

  @Override
  public int compare(Point p, Point q){
      return p.y >= q.y ? -1 : 1;
  }
}