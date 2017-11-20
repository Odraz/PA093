class Edge{
  float WIDTH = 5;
  Point point1;
  Point point2;
  color clr;
  
  Edge(Point p, Point q){
   this.point1 = p;
   this.point2 = q; 
   this.clr = color(255);
  }
  
  Edge(float x1, float y1, float x2, float y2, color clr){
    point1 = new Point(x1, y1);
    point2 = new Point(x2, y2);
    this.clr = clr;
  }
  
  void display(){
    stroke(clr);
    line(point1.x, point1.y, point2.x, point2.y);
  }
  
  @Override
  public boolean equals(Object obj){
    if (obj == null) {
        return false;
    }
    if (!Edge.class.isAssignableFrom(obj.getClass())) {
        return false;
    }
    final Edge other = (Edge) obj;
    
    return (point1 == other.point1 && point2 == other.point2) || (point1 == other.point2 && point2 == other.point1);
  }
  
  double delaunayDistance(Point p){
    Circle c = new Circle(point1, point2, p);
    return ((direction(c.centre) > 0 && direction(p) > 0) || (direction(c.centre) < 0 && direction(p) < 0)) ? c.radius : -c.radius;
  }
  
  Point findDelaunayPoint(ArrayList<Point> hull){
    double smallestDelaunayDistance = Integer.MAX_VALUE;
    Point p = null;
    
    for(Point point : hull){
      if((point == point1 || point == point2) || (direction(point) <= 0)){
        continue;
      }
      if(delaunayDistance(point) < smallestDelaunayDistance){
        smallestDelaunayDistance = delaunayDistance(point);
        p = point;
      }
    }
    
    return p;
  }
  
  /*
  if value > 0, p2 is on the left side of the line.
  if value = 0, p2 is on the same line.
  if value < 0, p2 is on the right side of the line.
  */
  double direction(Point p){
    return (point2.x - point1.x) * (p.y - point1.y) - (p.x - point1.x) * (point2.y - point1.y);
  }
  
  double distance(Point p) {
    double normalLength = Math.sqrt((point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y));
    return Math.abs((p.x - point1.x) * (point2.y - point1.y) - (p.y - point1.y) * (point2.x - point1.x)) / normalLength;
  }
}