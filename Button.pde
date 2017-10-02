import java.util.Collections;
import java.util.Comparator;

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
  RefreshButton(float x, String text){
    super(x, text);
  }
  
  void onClick(){
    background(50);
    points.clear();  
    hullToDisplay.clear();
  }
}

class AddPointsButton extends Button{
  AddPointsButton(float x, String text){
    super(x, text);
  }
  
  void onClick(){
    for(int i = 0; i < 10; i++){
      points.add(new Point(random(20, width - 20), random(20, height - guiHeight - 20)));
    }
  }
}

class GiftWrappingButton extends Button{
  GiftWrappingButton(float x, String text){
    super(x, text);
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
  GrahamScanButton(float x, String text){
    super(x, text);
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