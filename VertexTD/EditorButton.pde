enum EditorButtonType{
  None, Buildable, Lane, Entrance, Exit, Link, ClearLink, Save, Load, Return
}
  
public class EditorButton{
  
  int x, y; // X, Y will be middle of Button
  int buttonWidth, buttonHeight;
  EditorButtonType type;
  String shortcut;
  
  boolean isHoveringOver = false;
  boolean isSelected = false;
  
	public EditorButton( int x, int y, int buttonWidth, int buttonHeight, EditorButtonType type, String shortcut ){

		this.x = x;
		this.y = y;
		this.buttonWidth = buttonWidth;
		this.buttonHeight = buttonHeight;

		this.type = type;
		this.shortcut = shortcut;

	}
  
    public EditorButton( int x, int y, int buttonWidth, int buttonHeight, EditorButtonType type ){
    
		this.x = x;
		this.y = y;
		this.buttonWidth = buttonWidth;
		this.buttonHeight = buttonHeight;
		
		this.type = type;
		shortcut = "|";
		
	}
  
  public void UpdateMouse(){
    if( mouseX >= x && mouseX < x + buttonWidth && mouseY >= y && mouseY <= y + buttonHeight ){
      isHoveringOver = true;
    } else {
      isHoveringOver = false;
    }
  }
  
	public EditorButtonType MousePressed(){
		if( isHoveringOver ){
		  return type;
		}
		return EditorButtonType.None;
	}
	
	public void Selected( boolean isSelected ){
		this.isSelected = isSelected;
	}
  
	public EditorButtonType isShortcutPressed( char pressed ){
		if( match( pressed + "", shortcut ) != null ){
			return type;
		}
		return EditorButtonType.None;
	}
  
  // Sigh, okay I was hoping to do this generically, but I can't really use Sprites and it's too much effort to build a library of lines
  // So let's just do this the dumb way, again
  
  public void DrawButton(){
	  
	stroke( 0 );
    
    // Selecting Color
    if( isHoveringOver ){
      fill( #5BFABE, 200 );
    } else if( isSelected ){
		fill( TILE_COLOR_SELECTED, 200 );
    } else {
      fill( #5B7EFA, 200 );
    }
    
    rect( x, y, buttonWidth, buttonHeight );
    
    // Text Color
    if( isHoveringOver ){
		fill( 0, 200 );
    } else {
		fill( #FFFFFF, 200 );
	}
	
	// Common to all text
	textAlign( CENTER, CENTER );
	textSize( 20 );
	
	switch( type ){
		case Return:
			text( "Return to Main Menu", x + buttonWidth/2, y - 2 + buttonHeight/2 ); // Extra Y offset, looks weird without it
			break;
		case Buildable:
			text( "[A]", x + 10 + textWidth( "[A]" )/2, y - 2 + buttonHeight/2 ); // Shortcut Key
			text( "Buildable", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case Lane:
			text( "[S]", x + 10 + textWidth( "[S]" )/2, y - 2 + buttonHeight/2 );
			text( "Lane", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case Entrance:
			text( "[D]", x + 10 + textWidth( "[D]" )/2, y - 2 + buttonHeight/2 ); 
			text( "Entrance", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case Exit:
			text( "[F]", x + 10 + textWidth( "[F]" )/2, y - 2 + buttonHeight/2 ); 
			text( "Exit", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case Link:
			text( "[X]", x + 10 + textWidth( "[X]" )/2, y - 2 + buttonHeight/2 ); 
			text( "Link Mode", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case ClearLink:	
			text( "[C]", x + 10 + textWidth( "[C]" )/2, y - 2 + buttonHeight/2 ); 
			text( "Clear Links", x + buttonWidth/2 + 20, y -2 + buttonHeight/2 );
			break;
		case Save:
			text( "Save", x + buttonWidth/2, y + buttonHeight/2 );
			break;
		case Load:
			text( "Load", x + buttonWidth/2, y + buttonHeight/2 );
			break;
	}

  }
  
}
