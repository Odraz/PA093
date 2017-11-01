class KDNode{
  int depth; 
  KDNode parent;
  KDNode lesser;
  KDNode greater;
  
  Point point;
  
  KDNode(Point point, int depth){
   this.point = point;
   this.depth = depth;
  }
  
  String print(){
    return "((" + point.x + ", " + point.y + ") L: " +  (lesser != null ? lesser.print() : "-") + " | P: " + (greater != null ? greater.print() : "-");
  }
  
  void draw(Rect sector){
    if(parent != null){    
     //edgesToDisplay.add(new Edge(parent.point, point));
   }   
   
   color red = color(255, 0, 0);
   color green = color(0, 255, 0);
   
   if(depth % 2 == 0){ //even (vertical) //<>//
       edgesToDisplay.add(new Edge(point.x, sector.y1, point.x, sector.y2, red));
       
       if(lesser != null){
         lesser.draw(new Rect(sector.x1, sector.y1, point.x, sector.y2));
       }
       
       if(greater != null){
         greater.draw(new Rect(point.x, sector.y1, sector.x2, sector.y2));
       }
   }else{ //odd (horizontal)
       edgesToDisplay.add(new Edge(sector.x1, point.y, sector.x2, point.y, green));
       
       if(lesser != null){
         lesser.draw(new Rect(sector.x1, sector.y1, sector.x2, point.y));
       }
       
       if(greater != null){
         greater.draw(new Rect(sector.x1, point.y, sector.x2, sector.y2));
       }
   }
   
   
   
   
  }
}