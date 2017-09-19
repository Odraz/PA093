ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Button> buttons = new ArrayList<Button>();

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
}

void mouseClicked(){
  if(mouseY < canvasHeight){
    if(mouseButton == LEFT){
      points.add(new Point(mouseX, mouseY));
    }else if (mouseButton == RIGHT){
      Point clickedPoint = getClickedPoint();
      if(clickedPoint != null){
        points.remove(clickedPoint);
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
  buttons.add(new RefreshButton(0, height - guiHeight, "Refresh"));
  buttons.add(new AddPointsButton(100, height - guiHeight, "Add points"));
}