class Triangle{
  
  Point point1;
  Point point2;
  Point point3;
  color clr;
  
  Triangle(Point p1, Point p2, Point p3){
   this.point1 = p1;
   this.point2 = p2;
   this.point3 = p3;
   this.clr = color(random(255), random(255), random(255));
  }
  
  void display(){
    stroke(255);
    fill(clr);
    triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y); //<>//
  }
}