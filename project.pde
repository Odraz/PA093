ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Button> buttons = new ArrayList<Button>();

ArrayList<Point> hullToDisplay = new ArrayList<Point>();

float guiHeight = 50;
float canvasHeight;

void setup() {
  size(640, 360);
  background(50);
  
  canvasHeight = height - guiHeight;
  createGUI();
}

void draw() {
  background(50);
  for (Point point : points) {
    point.display();
  }
  
  for (Button button : buttons) {
    button.display();
  }
  
  displayHull(hullToDisplay);
}

void mouseClicked(){
  if(mouseY < canvasHeight){
    if(mouseButton == LEFT){
      points.add(new Point(mouseX, mouseY));
    }else if (mouseButton == RIGHT){
      Point clickedPoint = getClickedPoint();
      if(clickedPoint != null){
        points.remove(clickedPoint);
        hullToDisplay.remove(clickedPoint);
        return;
      }
    } //<>//
  }else{
    Button clickedButton = getClickedButton();
      if(clickedButton != null){
        clickedButton.onClick();
        return;
      }
  }
}

void mouseDragged(){
  if(mouseY < canvasHeight){
    Point clickedPoint = getClickedPoint();
    if(clickedPoint != null){
        clickedPoint.x = mouseX;
        clickedPoint.y = mouseY;
        return;
      }
  }
}

void keyPressed() {
  if (key == 'r') {
    background(50);
    points.clear();    
  }else if(key == 'p'){
    for(int i = 0; i < 10; i++){
      points.add(new Point(random(20, width - 20), random(20, height - guiHeight - 20)));
    }
  }
}

Point getClickedPoint(){
  for(Point point : points){
      if((mouseX >= point.x - point.WIDTH && mouseX <= point.x + point.WIDTH) &&
       (mouseY >= point.y - point.WIDTH && mouseY <= point.y + point.WIDTH)){
          
      return point;
    }
  }
  
  return null;
}

Button getClickedButton(){
  for(Button button : buttons){
      if((mouseX >=button.x - button.WIDTH && mouseX <= button.x + button.WIDTH) &&
       (mouseY >= button.y - button.WIDTH && mouseY <= button.y + button.WIDTH)){
          
      return button;
    }
  }
  
  return null;
}

void createGUI(){
  buttons.add(new RefreshButton(0, "Refresh"));
  buttons.add(new AddPointsButton(100, "Add points"));
  buttons.add(new GiftWrappingButton(200, "Gift wrapping"));
  buttons.add(new GrahamScanButton(300, "Graham scan"));
}

void displayHull(ArrayList<Point> hull){
  if(hull.isEmpty()){
    return;
  }
  Point previousPoint = hull.get(0);
  
  for(int i = 1; i < hull.size(); i++){
    stroke(255);
    line(previousPoint.x, previousPoint.y, hull.get(i).x, hull.get(i).y);
    previousPoint = hull.get(i);
    
   if(i == hull.size() - 1){
     line(hull.get(0).x, hull.get(0).y, hull.get(i).x, hull.get(i).y);
   }
  }
}

/*
# Three points are a counter-clockwise turn if ccw > 0, clockwise if
# ccw < 0, and collinear if ccw = 0 because ccw is a determinant that
# gives twice the signed  area of the triangle formed by p1, p2 and p3.
*/
float counterClockwise(Point p1, Point p2, Point p3){
    return (p2.x - p1.x)*(p3.y - p1.y) - (p2.y - p1.y)*(p3.x - p1.x);
}