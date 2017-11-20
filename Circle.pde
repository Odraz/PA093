class Circle{
  Point centre;
  double radius;
  
  Circle(Point centre, double radius){
   this.centre = centre;
   this.radius = radius; 
  }
  
  Circle(Point p1, Point p2, Point p3){
   double cp = p1.crossproduct(p2, p3);
   
   if (cp != 0){
     double p1Sq = p1.square();
     double p2Sq = p2.square();
     double p3Sq = p3.square();     
     double num = p1Sq *(p2.y - p3.y) + p2Sq *(p3.y - p1.y) +p3Sq *(p1.y - p2.y);     
     double cx = num / (2.0 * cp);
     num = p1Sq *(p3.x - p2.x) + p2Sq*(p1.x - p3.x) +p3Sq*(p2.x - p1.x);
     double cy = num / (2.0f * cp);
     
     centre = new Point((float)cx, (float)cy);
     radius = centre.distance(p1);
   }else{
     throw new IllegalArgumentException("Crossproduct is 0");
   }
  }
  
  String toString(){
    return "[" + centre + ", " + radius + "]";
  }
  
  boolean inside(Point p){
    return centre.distance(p) < Math.pow(radius,2); 
  }
}