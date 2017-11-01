class Point{
  float WIDTH = 15;
  float x, y;
  color clr;
  
  Point(float x, float y){
   this.x = x;
   this.y = y; 
   this.clr = color(255);
  }
  
  void display(){
    noStroke();
    fill(clr);
    ellipse(x, y, WIDTH, WIDTH);
  }
  
  String toString(){
    return "[" + x + ", " + y + "]";
  }
}