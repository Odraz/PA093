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
  
  void display(){
    stroke(clr);
    line(point1.x, point1.y, point2.x, point2.y);
  }
}