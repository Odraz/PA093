import java.util.Collections;
import java.util.Comparator;
import java.util.Stack;

class Button{
  float WIDTH = 100;
  float x, y;
  String text;
  
  color basicColor = color(65);
  color highlightColor = color(85);
  
  Button(float x, String text){
   this.x = x;
   this.y = height - guiHeight; 
   this.text = text;
  }
  
  void display(){
    strokeWeight(2);
    stroke(50);
    if(mouseOver()){
      fill(highlightColor);
    }else{
      fill(basicColor);
    }
    rect(x, y, WIDTH, guiHeight);
    fill(255);
    text(text, x + WIDTH/5, y + guiHeight/3, WIDTH, guiHeight);
  }
  
  boolean mouseOver()  {
    if (mouseX >= x && mouseX < x + WIDTH && 
        mouseY >= y && mouseY < y + guiHeight) {
      return true;
    } else {
      return false;
    }
  }
  
  void onClick(){
    return;
  }
}

class RefreshButton extends Button{
  RefreshButton(float x){
    super(x, "Refresh");
  }
  
  void onClick(){
    refresh();
  }
}

class AddPointsButton extends Button{
  AddPointsButton(float x){
    super(x, "Add points");
  }
  
  void onClick(){
    for(int i = 0; i < 10; i++){
      points.add(new Point(random(20, width - 20), random(20, height - guiHeight - 20)));
    }
  }
}

class GiftWrappingButton extends Button{
  GiftWrappingButton(float x){
    super(x, "Gift wrapping");
  }
  
  void onClick(){
    hullToDisplay = giftWrapping();
  }
  
  ArrayList<Point> giftWrapping(){
    ArrayList<Point> hull = new ArrayList<Point>();
    if(points.size() == 0){
      return hull;
    }
    
   Point leftmostPoint = new Point(Integer.MAX_VALUE, 0);
   
   for(Point point : points){
     if(point.x < leftmostPoint.x)
       leftmostPoint = point;
   }
    
   Point pointOnHull = leftmostPoint;
   Point endpoint = new Point(0, 0);
   
   int i = 0;
   do{
      hull.add(pointOnHull);
      endpoint = points.get(0);      // initial endpoint for a candidate edge on the hull
      for(int j = 1; j < points.size(); j++){ //<>//
         if ((endpoint == pointOnHull) || ((endpoint.x - hull.get(i).x)*(points.get(j).y - hull.get(i).y) - (points.get(j).x - hull.get(i).x)*(endpoint.y - hull.get(i).y) > 0)){
            endpoint = points.get(j);   // found greater left turn, update endpoint
         }
      }
      i++;
      pointOnHull = endpoint;
   }while(endpoint != hull.get(0));
   
   return hull;
  }
}

class GrahamScanButton extends Button{
  GrahamScanButton(float x){
    super(x, "Graham scan");
  }
  
  void onClick(){
    hullToDisplay = grahamScan();
  }
  
  ArrayList<Point> grahamScan(){
    ArrayList<Point> hull = new ArrayList<Point>();
    ArrayList<Point> tmpPoints = (ArrayList<Point>)points.clone();
    int n = points.size();
    
    if(n < 3){
      return hull;
    }
        
    Point lowestPoint = new Point(Integer.MAX_VALUE, Integer.MAX_VALUE);
    int lowestPointIndex = 0;
    for(int i = 0; i < n; i++){
      if(tmpPoints.get(i).y < lowestPoint.y){
        lowestPoint = tmpPoints.get(i);
        lowestPointIndex = i;        
      }
    }
    
    Point tmpPoint = tmpPoints.get(0);
    points.set(0, lowestPoint);
    points.set(lowestPointIndex, tmpPoint);
    
    Collections.sort(tmpPoints, new PolarComparator(lowestPoint)); 
     
    hull.add(lowestPoint);
    hull.add(tmpPoints.get(1));    
    
    int i = 2;    
    while(i < n){
      if(counterClockwise(hull.get(hull.size() - 2), hull.get(hull.size() - 1), tmpPoints.get(i)) > 0){
        hull.add(tmpPoints.get(i)); 
        i++;
      }else{
        hull.remove(hull.size() - 1);
      }
    }
    
    return hull;
  }
}

class PolygonButton extends Button{
  PolygonButton(float x){
    super(x, "Start polygon");
  }
  
  void onClick(){
    if(isCreatingPolygon){
      text = "Start polygon ccw";
      isCreatingPolygon = false;
      hullToDisplay = new ArrayList<Point>(points);
    }else{
      refresh();
      text = "Draw polygon";
      isCreatingPolygon = true;
    }
  }
}

class TriangulationButton extends Button{
  TriangulationButton(float x){
    super(x, "Triangulation");
  }
  
  void onClick(){
    triangulate(hullToDisplay);
  }
  
  void triangulate(ArrayList<Point> hull){ //<>//
    ArrayList<Point> leftPath = new ArrayList<Point>();
    ArrayList<Point> rightPath = new ArrayList<Point>();
    
    Point previousPoint = hull.get(0);
    
    for(Point point : hull){
      if(point.y > previousPoint.y)
      {
        leftPath.add(point);
      }else{
        rightPath.add(point);
      }
      
      previousPoint = point;
    }
    
    //sort vertices v1, v2, …, vn lexicographically
    ArrayList<Point> sortedHull = new ArrayList<Point>(hull);
    Collections.sort(sortedHull, new LexicographicallComparator());
    
    //put v1 , v2 to stack
    Stack<Point> stack = new Stack<Point>();
    stack.push(sortedHull.get(0));
    stack.push(sortedHull.get(1));
    
    ArrayList<Edge> edges = new ArrayList<Edge>();
    //for i = 3 to n:
    for(int i = 2; i < sortedHull.size(); i++){       //<>//
      Point pointi = sortedHull.get(i);
    //  if vi and the top of the stack lie on the same path (left or right)
    //    add edges vi, vj, …, vi, vk, where vk is the last vertex forming the “correct” line
    //    pop vj, …, vk and push vi
      if(leftPath.contains(stack.peek()) && leftPath.contains(pointi)){
        while(stack.size() >= 2){
          Point pointj = stack.pop();
          Point pointk = stack.pop();
          if(counterClockwise(pointk, pointj, pointi) > 0){
            edges.add(new Edge(pointi, pointk));
          }else{
            stack.push(pointk);
            stack.push(pointj);            
            return;
          }
        }
      }else if(rightPath.contains(stack.peek()) && rightPath.contains(pointi)){
        while(stack.size() >= 2){
          Point pointj = stack.pop();
          Point pointk = stack.pop();
          if(counterClockwise(pointk, pointj, pointi) < 0){
            edges.add(new Edge(pointi, pointk));
          }else{
            stack.push(pointk);
            stack.push(pointj);
            return;
          }
        }
    //  else
    //    add edges from vi to all vertices stored in stack and remove (pop) them from stack
    //    store vtop
    //    push vtop and vi
      }else{
        Point pointTop = stack.peek();
        while(stack.size() > 0){
          
          edges.add(new Edge(pointi, stack.pop()));
        }
        
        stack.push(pointTop);
      }
      
      stack.push(pointi);
    }
    
    edgesToDisplay = new ArrayList(edges);
  }
}