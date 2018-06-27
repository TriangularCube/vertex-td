private enum GameState{
  MainMenu, Game, Editor
}

private GameState state;
private PImage Background;

private Editor editor;
private Game game;

void setup(){
  
  size( 1280, 800 );
  frameRate( FRAME_RATE );
  
  state = GameState.MainMenu;
  
  Background = loadImage( "Background2.png" );
  
  PrepMenu();
  
}

void draw(){
  
  switch( state ){
    case MainMenu:
      drawMainMenu();
      break;
    case Game:
      game.DrawGame();
      break;
    case Editor:
      editor.DrawEditor();
      break;
  }
  
}

// Main Menu ------------------------------------------------------------
void PrepMenu(){
  // Menu will use Center aligned text
  textAlign( CENTER, CENTER );
  
  MakeButton( 540, 380, 200, 40,  "Start a Game", MenuButtonCode.StartGame );
  MakeButton( 540, 460, 200, 40, "Level Editor", MenuButtonCode.Editor );
  MakeButton( 540, 540, 200, 40, "Exit", MenuButtonCode.Exit );
}

void drawMainMenu(){
  
  background( Background );
  
  fill( #FFFFFF );
  stroke( 0 );
  textSize( 50 );
  
  text( "Welcome to Vertex TD", width / 2, 80  );
  
  for( MenuRectButton button : menuButtons ){
    button.UpdateMouse();
    button.DrawButton();
  }
  
}

// Bah no delegates for Java, and too lazy to look up inner classes
// Will just do this the dumb way
ArrayList<MenuRectButton> menuButtons = new ArrayList<MenuRectButton>();

void MakeButton( int x, int y, int buttonWidth, int buttonHeight, String display, MenuButtonCode code ){
  MenuRectButton button = new MenuRectButton( x, y, buttonWidth, buttonHeight, display, code );
  
  menuButtons.add( button );
}

// End Main Menu --------------------------------------------------------

public void ReturnToMain(){
  editor = null;
  state = GameState.MainMenu;
}

void mousePressed(){
  switch( state ){
    case MainMenu:
      for( MenuRectButton button : menuButtons ){
        switch( button.MousePressed() ){
          case None:
            continue;
          case StartGame:
            selectInput( "Select a level to play", "StartGame", new File( sketchPath() + "/Levels/ " ) );
			
			// DEBUG
			// game = new Game( new Level( loadJSONObject( new File( sketchPath() + "/Levels/Test" ) ) ) );
			// state = GameState.Game;
			
            break;
          case Editor:
            editor = new Editor();
            state = GameState.Editor;
            break;
          case Exit:
            exit();
            break;
        } // Switch
      } // For
      break;
    case Editor:
      if( editor.MousePressed() ){ // Can't hook up from the other side, so have to do this as a workaround
        editor = null;
        state = GameState.MainMenu;
      }
      break;
    case Game:
      if( game.MousePressed() ){
		game = null;
		state = GameState.MainMenu;
	  }
      break;
  }
}

void StartGame( File selected ){
	if( selected == null ){
		return;
	}
	
	game = new Game( new Level( loadJSONObject( selected ) ) );
	state = GameState.Game;
}

void mouseDragged(){
	
	switch( state ){
		case Editor:
			editor.MouseDragged();
			break;
	}
	
}

void mouseReleased(){
	
	switch( state ){
		case Editor:
			editor.MouseReleased();
			break;
	}
	
}

void keyPressed(){
	switch( state ){
		case Editor:
			editor.KeyPressed();
			break;
		case Game:
			game.KeyPressed();
			break;
	}
}
