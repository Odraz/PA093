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
}