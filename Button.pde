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
    noStroke();
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
    if (mouseX >= x && mouseX <= x + WIDTH && 
        mouseY >= y && mouseY <= y + guiHeight) {
      return true;
    } else {
      return false;
    }
  }
}