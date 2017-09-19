class Button{
  float WIDTH = 100;
  float x, y;
  String text;
  
  color basicColor = color(65);
  color highlightColor = color(85);
  
  Button(float x, float y, String text){
   this.x = x;
   this.y = y; 
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
    text(text, x + WIDTH/4, y + guiHeight/3, WIDTH, guiHeight);
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
  RefreshButton(float x, float y, String text){
    super(x, y, text);
  }
  
  void onClick(){
    background(50);
    points.clear();  
  }
}

class AddPointsButton extends Button{
  AddPointsButton(float x, float y, String text){
    super(x, y, text);
  }
  
  void onClick(){
    for(int i = 0; i < 10; i++){
      points.add(new Point(random(20, width - 20), random(20, height - guiHeight - 20)));
    }
  }
}