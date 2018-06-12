public class MenuRectButton extends Button{
  
  int x, y; // X, Y will be middle of Button
  int buttonWidth, buttonHeight;
  String displayText;
  boolean isHoveringOver = false;
  MenuButtonCode code;
  
  public MenuRectButton( int x, int y, int buttonWidth, int buttonHeight, String display, MenuButtonCode code ){
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    
    displayText = display;
    this.code = code;
  }
  
  public void UpdateMouse(){
    if( mouseX >= x && mouseX < x + buttonWidth && mouseY >= y && mouseY <= y + buttonHeight ){
      isHoveringOver = true;
    } else {
      isHoveringOver = false;
    }
  }
  
  public MenuButtonCode MousePressed(){
    if( isHoveringOver ){
      return code;
    }
    return MenuButtonCode.None;
  }
  
  public void DrawButton(){
    
	stroke( 0 );
	
    // Selecting Color
    if( isHoveringOver ){
      fill( #5BFABE, 192 );
    } else {
      fill( #5B7EFA, 192 );
    }
    
    rect( x, y, buttonWidth, buttonHeight );
    
    // Selecting Colro
    if( isHoveringOver ){
      fill( 0, 255 );
    } else {
      fill( #FFFFFF, 255 );
    }

    textAlign( CENTER, CENTER );
    textSize( 20 );
    
    text( displayText, x + buttonWidth/2, y - 2 + buttonHeight/2 ); // Extra Y offset, looks weird without it
    
  }
  
}
