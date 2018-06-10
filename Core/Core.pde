private enum GameState{
  MainMenu, Level, Editor
}

private GameState state;
PImage Background;

void setup(){
  
  size( 1280, 800 );
  frameRate( 30 );
  
  state = GameState.MainMenu;
  
  Background = loadImage( "Background.png" );
  
  PrepMenu();
  
}

void draw(){
  
  switch( state ){
    case MainMenu:
      drawMainMenu();
      break;
    case Level:
      // TODO
      break;
    case Editor:
      // TODO
      break;
  }
  
}



// Main Menu ------------------------------------------------------------
void PrepMenu(){
  // Menu will use Center aligned text
  textAlign( CENTER, CENTER );
}

void drawMainMenu(){
  
  background( Background );
  
  
  
  text( "Start a Game", width / 2, height / 2 );
  
}

private Dictionary<  >

void MakeButton(){
  
}

priva
// End Main Menu --------------------------------------------------------
