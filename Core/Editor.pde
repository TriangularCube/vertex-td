public class Editor{
  
	PImage background;
	Level currentLevel;
  
	public Editor(){
		background = loadImage( "Background.png" );
		
		// Buttons
		
		// Buildable Terrain Type
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Buildable, "[aA]" );
		
		// Lane Type
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Lane, "[sS]" );
		
		// Entrance Type
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 2, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Entrance, "[dD]" );
		
		// Exit Type
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 3, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Exit, "[fF]" );
		
		// Save
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 5, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Save );
		
		// Load
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 6, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Load );
		
		// Return To Main Menu Button
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 700, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Return );
		
		currentLevel = new Level();
	}
  
	ArrayList<EditorButton> buttons = new ArrayList<EditorButton>();
  
	private void MakeButton( int x, int y, int buttonWidth, int buttonHeight, EditorButtonType type ){
		EditorButton button = new EditorButton( x, y, buttonWidth, buttonHeight, type );
		buttons.add( button );
	}
	
	private void MakeButton( int x, int y, int buttonWidth, int buttonHeight, EditorButtonType type, String shortcut ){
		EditorButton button = new EditorButton( x, y, buttonWidth, buttonHeight, type, shortcut );
		buttons.add( button );
	}
  
	public void DrawEditor(){
    
		background( background );
		
		fill( #FFFFFF, 255 );
		stroke( 0 );
		text( currentLevel.name, LEVEL_AREA_WIDTH/2, 15 );
		
		// Workspace
		fill( #FFFFFF, 127 );
		noStroke();
		rect( LEVEL_AREA_X, LEVEL_AREA_Y, LEVEL_AREA_WIDTH, LEVEL_AREA_HEIGHT );
		
		// fill( #FF00FF, 255 );
		for( int i = 0; i < LEVEL_SIZE_X; i++ ){
			for( int j = 0; j < LEVEL_SIZE_Y; j++ ){
				
				if( isMouseInTile( i, j ) ){
					fill( TILE_COLOR_SELECTED, 255 );
					stroke( 0 );
				} else {
					if( currentLevel.terrain[i][j] == true ){
						fill( TILE_COLOR_ROAD, TILE_COLOR_ROAD_ALPHA );
						noStroke();
					} else {
						fill( TILE_COLOR_BUILDABLE, TILE_COLOR_BUILDABLE_ALPHA );
						stroke( 0 );
					}
				}
								
				rect( i * LEVEL_TILE_SIZE + LEVEL_AREA_X + LEVEL_AREA_TILE_X_OFFSET, j * LEVEL_TILE_SIZE + LEVEL_AREA_Y + LEVEL_AREA_TILE_Y_OFFSET, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
				
			}
		}
		
		// TODO draw start/end
		
		// TODO draw move lines
		
		// Right Sidebar
		fill( #FFFFFF, 128 );
		rect( SIDEBAR_X, SIDEBAR_Y, SIDEBAR_WIDTH, SIDEBAR_HEIGHT );
		
		fill( #FFFFFF );
		String editor = "Level Editor";
		text( editor, SIDEBAR_X + SIDEBAR_WIDTH/2, 40 );
		
		for( EditorButton button : buttons ){
		  button.UpdateMouse();
		  button.DrawButton();
		}
    
	}
  
	private boolean isMouseInTile( int x, int y ){
		int offsetX = LEVEL_AREA_X + LEVEL_AREA_TILE_X_OFFSET;
		int offsetY = LEVEL_AREA_Y + LEVEL_AREA_TILE_Y_OFFSET;
	  
		boolean isInX = false, isInY = false;
	  
		// X check
		if( mouseX >= x * LEVEL_TILE_SIZE + offsetX && mouseX < ( x + 1 ) * LEVEL_TILE_SIZE + offsetX ){
			isInX = true;
		}
	  
		if( mouseY >= y * LEVEL_TILE_SIZE + offsetY && mouseY < ( y + 1 ) * LEVEL_TILE_SIZE + offsetY ){
			isInY = true;
		}
		
		if( isInX && isInY ){
			return true;
		}
		
		return false;
	}
  
	public boolean MousePressed(){
    
		// For buttons
		for( EditorButton button : buttons ){
			
			switch( button.MousePressed() ){
				case None:
					continue;
				case Return:
					return true; // Can't hook up PApplet, so have to do this work around
				case Buildable:
					
					break;
				default:
					// TODO
					break;
			}
		  
		}
		
		// Level
		
		return false;
	}
	
	public void KeyPressed(){
		
		for( EditorButton button : buttons ){
			
			switch( button.isShortcutPressed( key ) ){
				case None:
					continue;
				case Buildable:
					print( "ho" );
					break;
			}
			
		}
		
	}
  
}
