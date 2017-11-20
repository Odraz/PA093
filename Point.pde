class Point{
  float WIDTH = 15;
  float x, y;
  color clr;
  
  Point(float x, float y){
   this.x = x;
   this.y = y; 
   this.clr = color(255);
  }
  
  void setPoint(float x, float y){
    this.x = x;
    this.y = y;    
  }
  
  void display(){
    noStroke();
    fill(clr);
    ellipse(x, y, WIDTH, WIDTH);
  }
  
  String toString(){
    return "[" + x + ", " + y + "]";
  }
  
  double distance(Point p2){
    return Math.sqrt(Math.pow(x-p2.x,2)+Math.pow(y-p2.y,2));
  }
  
  double square(){
    return Math.pow(x, 2) + Math.pow(y, 2);
  }
  
  double crossproduct(Point p2, Point p3){
    double u1 = p2.x - x;
    double v1 = p2.y - y;
    double u2 = p3.x - x;
    double v2 = p3.y - y;
    
    return u1 * v2 - v1 * u2;
  }
}