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
  
  void draw(){
    if(depth % 2 == 0){
      if(parent != null){
        if(parent.point.y > point.y){
          edgesToDisplay.add(new Edge(point.x, 0, point.x, parent.point.y, color(20 * depth, 0, 0)));
        }else{
          edgesToDisplay.add(new Edge(point.x, parent.point.y, point.x, height, color(20 * depth, 0, 0)));
        }
      }else{
        edgesToDisplay.add(new Edge(point.x, 0, point.x, height, color(20 * depth, 0, 0)));
      }
    }else{
      if(parent != null){
        if(parent.point.x < point.x){
          edgesToDisplay.add(new Edge(0, point.y, parent.point.x, point.y, color(0, 20 * depth, 0)));
        }else{
          edgesToDisplay.add(new Edge(parent.point.x, point.y, width, point.y, color(0, 20 * depth, 0)));
        }
      }else{
        edgesToDisplay.add(new Edge(0, point.y, width, point.y, color(0, 20 * depth, 0)));
      }
    }
   
   if(lesser != null){
     lesser.draw();
   }
   
   if(greater != null){
     greater.draw();
   }
  }
}