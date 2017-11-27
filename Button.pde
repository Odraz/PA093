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
  } //<>//
}

class GrahamScanButton extends Button{
  GrahamScanButton(float x){
    super(x, "Graham scan");
  }
  
  void onClick(){
    hullToDisplay = grahamScan();
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
    if(hullToDisplay.isEmpty()){
      return;
    }
    
    edgesToDisplay = new ArrayList<Edge>(triangulate(hullToDisplay));
    //points = new ArrayList<Point>(hullToDisplay);
    hullToDisplay.clear();
  }
}

class KDTreeButton extends Button{
  KDTreeButton(float x){
    super(x, "k-D Tree");
  }
  
  void onClick(){
    if(points.isEmpty()){
      return;
    }
    
    KDNode root = createKDTree(points, 0);
    root.draw(new Rect(0, 0, width, canvasHeight));
  }
}

class DelaunayButton extends Button{
  DelaunayButton(float x){
    super(x, "Delaunay");
  }
  
  void onClick(){
    if(points.isEmpty()){
      println("Points are empty");
      return;
    }
    
    edgesToDisplay = new ArrayList<Edge>(delaunayTriangulation(points));
  }
}

class VoronoiButton extends Button{
  VoronoiButton(float x){
    super(x, "Voronoi");
  }
  
  void onClick(){
    edgesToDisplay = voronoi(trianglesToDisplay);
  }
}