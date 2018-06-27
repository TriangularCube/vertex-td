public class Editor{
  
	PImage background;
	Level currentLevel;
	
	EditorButton selectedButton = null;
	EditorButtonType selectedType = EditorButtonType.None;
	
	boolean hasStartedEditing = false;
	ArrayList<Tile> currentEditingLink;
	
	boolean hasSaved = false;
  
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
		
		// Link Mode
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 4, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Link, "[xX]" );
		
		// Clear Link
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 5, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.ClearLink, "[cC]" );
		
		// Save
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 6, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Save );
		
		// Load
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 7, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Load );
		
		// Return To Main Menu Button
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - EDITOR_BUTTON_WIDTH/2, 70 + EDITOR_BUTTON_OFFSET * 8, EDITOR_BUTTON_WIDTH, EDITOR_BUTTON_HEIGHT, EditorButtonType.Return );
		
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
		
		// Game Name
		fill( #FFFFFF, 255 );
		stroke( 0 );
		textSize( 25 );
		text( currentLevel.name, LEVEL_AREA_WIDTH/2, 15 );
		
		// Workspace
		fill( #FFFFFF, 127 );
		noStroke();
		rect( LEVEL_AREA_X, LEVEL_AREA_Y, LEVEL_AREA_WIDTH, LEVEL_AREA_HEIGHT );
		
		currentLevel.DrawLevel( OFFSET_X, OFFSET_Y );
		
		// Moused Over Tile
		fill( TILE_COLOR_SELECTED, 200 );
		stroke( 0 );
		
		Tile t = FindTile( mouseX, mouseY );
		
		if( t != null ){
			rect( t.x * LEVEL_TILE_SIZE + OFFSET_X, t.y * LEVEL_TILE_SIZE + OFFSET_Y, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
		}
		
		// TODO draw start/end
		
		// Draw already connected links
		for( ArrayList<Tile> link : currentLevel.links ){
			for( int i = 0; i < link.size(); i++ ){
				t = link.get(i);
				fill( #326CF2, 240 );
				noStroke();
				ellipse( t.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, t.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y, 10, 10 );
				
				if( i != 0 ){
					Tile last = link.get( i - 1 );
					
					stroke( #326CF2, 240 );
					line( last.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, last.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y,
							t.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, t.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y );
				}
			}
		}

		
		
		// Draw current editing link
		if( currentEditingLink != null ){
			for( int i = 0; i < currentEditingLink.size(); i++ ){
				t = currentEditingLink.get( i );
				
				fill( #F24932, 240 );
				noStroke();
				ellipse( t.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, t.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y, 10, 10 );
				
				if( i != 0 ){
					Tile last = currentEditingLink.get( i - 1 );
					
					stroke( #F24932, 240 );
					line( last.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, last.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y,
							t.x * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_X, t.y * LEVEL_TILE_SIZE + LEVEL_TILE_SIZE/2 + OFFSET_Y );
				}
			}
			
			if( selectedType == EditorButtonType.Link ){
				// Draw to Mouse
				t = FindTile( mouseX + OFFSET_X, mouseY + OFFSET_Y );
				if( t != null ){
					fill( #F24932, 240 );
					noStroke();
					ellipse( mouseX, mouseY, 10, 10 );
					
					stroke( #F24932, 240 );
					line( mouseX, mouseY,
						currentEditingLink.get( currentEditingLink.size() - 1 ).x * LEVEL_TILE_SIZE + OFFSET_X + LEVEL_TILE_SIZE/2,
						currentEditingLink.get( currentEditingLink.size() - 1 ).y * LEVEL_TILE_SIZE + OFFSET_Y + LEVEL_TILE_SIZE/2 );
				}
			}
		}

		
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
	
	private Tile FindTile( int x, int y ){	

		if( x < OFFSET_X || x >= OFFSET_X + LEVEL_TILE_SIZE * LEVEL_SIZE_X ){
			return null;
		}
		
		if( y< OFFSET_Y || y >= OFFSET_Y + LEVEL_TILE_SIZE * LEVEL_SIZE_Y ){
			return null;
		}
		
		return currentLevel.terrain[ floor( (x - OFFSET_X) / LEVEL_TILE_SIZE ) ][ floor( (y - OFFSET_Y) / LEVEL_TILE_SIZE ) ];
		
	}
  
	public boolean MousePressed(){
    
		// For buttons
		for( EditorButton button : buttons ){
			
			EditorButtonType pressed = button.MousePressed();
			switch( pressed ){
				case None:
					continue;
				case Return:
					return true; // Can't hook up PApplet, so have to do this work around
				case ClearLink:
					currentLevel.links.clear();
					return false;
				case Save:
					selectOutput( "Select save destination", "Save", new File( sketchPath() + "/Levels/ " ), this );
					return false;
				case Load:
					selectInput( "Select a level to load", "Load", new File( sketchPath() + "/Levels/ " ), this );
					return false;
				default:
					SelectedButton( pressed, button );
					return false;
			}
		  
		}
		
		// Level
		Tile t = FindTile( mouseX, mouseY );
		
		if( t == null || selectedType == EditorButtonType.None ){
			return false;
		}
		
		EditTile( t );
		
		hasStartedEditing = true;
		
		return false;
	}
	
	private void SelectedButton( EditorButtonType type, EditorButton button ){
		if( selectedButton != null ){
			selectedButton.Selected( false );
		}
		
		selectedButton = button;
		selectedType = type;
		button.Selected( true );
	}
	
	public void MouseDragged(){
		if( !hasStartedEditing ){
			return;
		}
		
		Tile t = FindTile( mouseX, mouseY );
		
		if( t == null || selectedType == EditorButtonType.None ){
			return;
		}
		
		EditTile( t );
	}
	
	public void MouseReleased(){
		hasStartedEditing = false;
	}
	
	private void EditTile( Tile t ){
		
		switch( selectedType ){
			case Buildable:
				// Turn of any Entrances or Exits
				t.isEntrance = false;
				t.isExit = false;
				
				t.terrain = Terrain.Buildable;
				break;
			case Lane:
				// Turn of any Entrances or Exits
				t.isEntrance = false;
				t.isExit = false;
			
				t.terrain = Terrain.Lane;
				break;
			case Entrance:
				
				// Check if it's a Lane
				if( t.terrain == Terrain.Buildable ){
					return;
				}
				
				// Check if is on edge of map
				if( t.x > 0 && t.x < LEVEL_SIZE_X - 1  && t.y > 0 && t.y < LEVEL_SIZE_Y - 1 ){
					return;
				}
				
				// Check we're not in a corner
				if( ( t.x == 0 || t.x == LEVEL_SIZE_X - 1 ) && ( t.y == 0 || t.y == LEVEL_SIZE_Y - 1 ) ){
					return;
				}
				
				// Check if tile is already an Exit
				if( t.isExit ){
					return;
				}
				
				// print( t.x + ", " + t.y + " is now an entrance." );
				t.isEntrance = true;
				
				break;
			case Exit:
				// Check if it's a Lane
				if( t.terrain == Terrain.Buildable ){
					return;
				}
				
				// Check if is on edge of map
				if( t.x > 0 && t.x < LEVEL_SIZE_X - 1 && t.y > 0 && t.y < LEVEL_SIZE_Y - 1 ){
					return;
				}
				
				// Check we're not in a corner
				if( ( t.x == 0 || t.x == LEVEL_SIZE_X - 1 ) && ( t.y == 0 || t.y == LEVEL_SIZE_Y - 1 ) ){
					return;
				}
				
				// Check if the tile is already an entrance
				if( t.isEntrance ){
					return;
				}
				
				//print( t.x + ", " + t.y + " is now an exit" );
				t.isExit = true;

				break;
			case Link:
				
				if( currentEditingLink == null && !t.isEntrance ){
					return;
				}
				
				if( t.terrain != Terrain.Lane ){
					return;
				}
				
				if( t.isEntrance ){
					ArrayList<Tile> link = null;// Get the link from Level
					for( ArrayList<Tile> l : currentLevel.links ){
						if( l.get( 0 ) == t ){
							link = l;
						}
					}

					if( link == null ){
						link = new ArrayList<Tile>();// If there is no link for this entrance, make a new  one
						link.add( t ); // Add the first element
						currentEditingLink = link;
					} else {
						link.subList( link.indexOf( t ) + 1, link.size() ).clear(); // Clear the link and start again
						currentEditingLink = link;
					}
				} else if( currentEditingLink == null ){

					for( int i = 0; i < currentLevel.links.size(); i++ ){
						if( currentLevel.links.get(i).contains( t ) ){
							currentEditingLink = currentLevel.links.get(i); // We are now editing this link
							currentEditingLink.subList( currentEditingLink.indexOf( t ), currentEditingLink.size() ).clear(); // Clear the link after the selected space
							return;
						}
					}
	
				} else {
					
					// We are currently editing a link
					if( t == currentEditingLink.get( currentEditingLink.size() - 1 ) ){
						return;
					}
					
					if( currentEditingLink.size() > 1 && t == currentEditingLink.get( currentEditingLink.size() - 2 ) ){
						return; // Ignore if we clicked on the previous node
					}
					
					Tile toCheck = currentEditingLink.get( currentEditingLink.size() - 1 );
					
					if( ( t.y == toCheck.y && ( t.x == toCheck.x + 1 || t.x == toCheck.x - 1 ) ) || ( t.x == toCheck.x && ( t.y == toCheck.y + 1 || t.y == toCheck.y - 1 ) ) ){
						// If we're orthogonally adjacent
						currentEditingLink.add( t );
						
						if( t.isExit ){
							currentLevel.links.add( currentEditingLink );
							currentEditingLink = null;
						}
					}
					
				}
				
				
				return;
		}
		
		//currentLevel.RecheckEntranceExit();
		
	}
	
	public void KeyPressed(){
		
		for( EditorButton button : buttons ){
			
			switch( button.isShortcutPressed( key ) ){
				case None:
					continue;
				case Buildable:
					SelectedButton( EditorButtonType.Buildable, button );
					break;
				case Lane:
					SelectedButton( EditorButtonType.Lane, button );
					break;
				case Entrance:
					SelectedButton( EditorButtonType.Entrance, button );
					break;
				case Exit:
					SelectedButton( EditorButtonType.Exit, button );
					break;
				case Link:
					SelectedButton( EditorButtonType.Link, button );
					break;
				case ClearLink:
					currentLevel.links.clear();
					break;
			}
			
		}
		
	}
  
	void Save( File selection ){
		if( selection == null ){
			return;
		}
		
		currentLevel.name = selection.getName();
		
		//print( selection.getAbsolutePath() );
		saveJSONObject( currentLevel.GetJSON(), selection.getAbsolutePath() );
	}
	
	public void Load( File selection ){
		if( selection == null ){
			return;
		}
		
		currentLevel = new Level( loadJSONObject( selection ) );
		
	}
}
