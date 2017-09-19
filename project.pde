ArrayList<Point> points = new ArrayList<Point>();
ArrayList<Button> buttons = new ArrayList<Button>();

void setup() {
  size(640, 360);
  background(50);
  
  createGUI();
}

float guiHeight = 50;
float canvasHeight = height - guiHeight;

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
  if(mouseButton == LEFT){
    points.add(new Point(mouseX, mouseY));
  }else if (mouseButton == RIGHT){
    Point clickedPoint = getClickedPoint();
    if(clickedPoint != null){
      points.remove(clickedPoint);
      return;
    }
  } //<>//
}

void mouseDragged(){
  Point clickedPoint = getClickedPoint();
  if(clickedPoint != null){
      clickedPoint.x = mouseX;
      clickedPoint.y = mouseY;
      return;
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

void createGUI(){
  buttons.add(new Button(0, height - guiHeight, "Refresh"));
}