class Triangle{
  
  Point point1;
  Point point2;
  Point point3;
  color clr;
  
  Triangle(){
  }
  
  Triangle(Point p1, Point p2, Point p3){
   this.point1 = p1;
   this.point2 = p2;
   this.point3 = p3;
   this.clr = color(random(40,60));
  }
  
  Triangle(Point p1, Point p2, Point p3, color clr){
   this.point1 = p1;
   this.point2 = p2;
   this.point3 = p3;
   this.clr = clr;
  }
  
  void display(){
    stroke(255);
    fill(clr);
    triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
  }
  
  boolean containsEdge(Edge edge){
    return (edge.equals(new Edge(point1, point2))) ||
           (edge.equals(new Edge(point2, point3))) ||
           (edge.equals(new Edge(point3, point1)));
  }
  
  Point getVoronoiPoint(){
    return (new Circle(point1, point2, point3)).centre;
  }
  
  @Override
  public boolean equals(Object obj){
    if (obj == null) {
        return false;
    }
    if (!Triangle.class.isAssignableFrom(obj.getClass())) {
        return false;
    }
    final Triangle other = (Triangle) obj;
    
    return (point3 == other.point1 && point2 == other.point2 && point1 == other.point3) || (point1 == other.point3 && point2 == other.point2 && point3 == other.point1);
  }
  
  boolean containsPoint(Point p) {
    Point p0 = point1;
    Point p1 = point2;
    Point p2 = point3;
    
    float A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y);
    float sign = A < 0 ? -1 : 1;
    float s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign;
    float t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign;
    
    return s > 0 && t > 0 && (s + t) < 2 * A * sign;
}
}