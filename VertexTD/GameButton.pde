enum GameButtonType{
	None, Quit, NextWave, Upgrade, Sell, Hard, Weak, Close, Fast, Random, Green1, Green2, Green3, Red1, Red2, Red3, Purple1, Purple2, Purple3, Blue1, Blue2
}

public class GameButton{
	
	int x, y;
	int buttonWidth, buttonHeight;
	String text, shortcut, shortcutDisplay;
	
	public boolean isHoveringOver = false;
	boolean isSelected = false;
	
	GameButtonType type;
	public Tower tower;
	
	public GameButton( int x, int y, int buttonWidth, int buttonHeight, GameButtonType type, Tower tower, String shortcut, String shortcutDisplay ){
		
		this.x = x;
		this.y = y;
		this.buttonWidth = buttonWidth;
		this.buttonHeight = buttonHeight;
		
		this.tower = tower;
		this.type = type;
		
		this.shortcut = shortcut;
		this.shortcutDisplay = shortcutDisplay;
		
	}
	
	public GameButton( int x, int y, int buttonWidth, int buttonHeight, GameButtonType type, String text, String shortcut ){

		this.x = x;
		this.y = y;
		this.buttonWidth = buttonWidth;
		this.buttonHeight = buttonHeight;

		this.type = type;
		
		this.text = text;
		this.shortcut = shortcut;

	}
	
	public GameButtonType UpdateMouse(){
		if( mouseX >= x && mouseX < x + buttonWidth && mouseY >= y && mouseY <= y + buttonHeight ){
			isHoveringOver = true;
			return type;
		}
		
		isHoveringOver = false;
		return GameButtonType.None;
	}
	
	public GameButtonType MousePressed(){
		if( isHoveringOver ){
			return type;
		}
		return GameButtonType.None;
	}
	
	public void Selected( boolean isSelected ){
		this.isSelected = isSelected;
	}
	
	public GameButtonType isShortcutPressed( char pressed ){
		if( shortcut != null && match( pressed + "", shortcut ) != null ){
			return type;
		}
		return GameButtonType.None;
	}
	
	public void DrawButton( int money ){
		
		stroke( 0 );
		
		if( text != null && !text.isEmpty() ){
			
			if( isSelected || isHoveringOver ){
				fill( #5BFABE, 200 );
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
			
			text( text, x + buttonWidth/2, y - 2 + buttonHeight/2 ); // Extra Y offset, looks weird without it
			
		} else if( tower != null ){
			
			// Selecting Color
			if( isSelected || isHoveringOver ){
				fill( #E8E820, 72 );
			} else {
				fill( #000000, 72 );
			}
		
			rect( x, y, buttonWidth, buttonHeight );
			
			tower.DrawTower( x, y );
			
			if( money < tower.cost ){
				fill( 0, 127 );
				noStroke();
				rect( x, y, buttonWidth, buttonHeight );
			}
			
			// Shortcut Text
			stroke( #FFFFFF );
			fill( #FFFFFF );
			textSize( 9 );
			
			text( shortcutDisplay, x + buttonWidth/2, y + buttonHeight + 10 );
			
		}
		
	}
}