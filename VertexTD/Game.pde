public class Game{
	
	PImage background;
	Level currentLevel;
	
	ArrayList<GameButton> buttons = new ArrayList<GameButton>();
	ArrayList<GameButton> specialButtons = new ArrayList<GameButton>();
	
	TowerMaker towerMaker = new TowerMaker();
	
	GameButton selectedButton;
	TowerType selectedTowerToBuild;
	Tower selectedTowerToBuildTemplate;
	Tower selectedBuiltTower;
	
	ArrayList<Enemy> enemies = new ArrayList<Enemy>();
	
	EnemySpawner spawner = new EnemySpawner();
	int spawnDelay = 30;
	int spawnTracker = 0;
	
	Enemy[] currentWave;
	Enemy[] nextWave;
	
	int wave = 0;
	boolean doSpawn = false;
	boolean hasUpdatedInterest = true;
	
	// Player Variables
	int money = 250;
	int interest = 3;
	int lives = 20;
	ArrayList<Tower> towers = new ArrayList<Tower>();
	
	boolean gameLost = false;
	boolean gameWon = false;

	public Game( Level level ){
		currentLevel = level;
		
		background = loadImage( "Background3.png" );
		
		// Make Buttons...
		
		// First Row
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/5 - GAME_TOWER_SIZE/2, 50, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Green1, towerMaker.MakeTower( TowerType.Green1 ), "[qQ]", "[ Q ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 2/5 - GAME_TOWER_SIZE/2, 50, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Red1, towerMaker.MakeTower( TowerType.Red1 ), "[wW]", "[ W ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 3/5 - GAME_TOWER_SIZE/2, 50, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Purple1, towerMaker.MakeTower( TowerType.Purple1 ), "[eE]", "[ E ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 4/5 - GAME_TOWER_SIZE/2, 50, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Blue1, towerMaker.MakeTower( TowerType.Blue1 ), "[rR]", "[ R ]" );
		
		// Second Row
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/5 - GAME_TOWER_SIZE/2, 110, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Green2, towerMaker.MakeTower( TowerType.Green2 ), "[aA]", "[ A ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 2/5 - GAME_TOWER_SIZE/2, 110, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Red2, towerMaker.MakeTower( TowerType.Red2 ), "[sS]", "[ S ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 3/5 - GAME_TOWER_SIZE/2, 110, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Purple2, towerMaker.MakeTower( TowerType.Purple2 ), "[dD]", "[ D ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 4/5 - GAME_TOWER_SIZE/2, 110, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Blue2, towerMaker.MakeTower( TowerType.Blue2), "[fF]", "[ F ]" );
		
		// Third Row
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/5 - GAME_TOWER_SIZE/2, 170, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Green3, towerMaker.MakeTower( TowerType.Green3 ), "[zZ]", "[ Z ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 2/5 - GAME_TOWER_SIZE/2, 170, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Red3, towerMaker.MakeTower( TowerType.Red3 ), "[xX]", "[ X ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 3/5 - GAME_TOWER_SIZE/2, 170, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Purple3, towerMaker.MakeTower( TowerType.Purple3 ), "[cC]", "[ C ]" );
		
		// Theoretical 4th Row
		/* MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/5 - GAME_TOWER_SIZE/2, 230, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Green3, towerMaker.MakeTower( TowerType.Green3 ), "tT", "[ T ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 2/5 - GAME_TOWER_SIZE/2, 230, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Red1, towerMaker.MakeTower( TowerType.Red3 ), "gG", "[ G ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 3/5 - GAME_TOWER_SIZE/2, 230, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Purple1, towerMaker.MakeTower( TowerType.Purple3 ), "[bB]", "[ B ]" );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH * 4/5 - GAME_TOWER_SIZE/2, 230, GAME_TOWER_SIZE, GAME_TOWER_SIZE, GameButtonType.Blue1, towerMaker.MakeTower( TowerType.Blue1 ), "[nN]", "[ N ]" ); */
		
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 530, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.NextWave, "Next Wave", null );
		
		MakeButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 730, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT, GameButtonType.Quit, "Quit this game", null );
		
		
		MakeSpecialButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 400, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Upgrade, "Upgrade", null );
		
		MakeSpecialButton( SIDEBAR_X + 25, 434, 83, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Hard, "Hard", null );
		MakeSpecialButton( SIDEBAR_X + 109, 434, 83, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Weak, "Weak", null );
		MakeSpecialButton( SIDEBAR_X + 193, 434, 83, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Close, "Close", null );
		
		MakeSpecialButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 434, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Fast, "Fastest", null );
		MakeSpecialButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 434, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Random, "Random", null );
		
		MakeSpecialButton( SIDEBAR_X + SIDEBAR_WIDTH/2 - GAME_TEXT_BUTTON_WIDTH/2, 470, GAME_TEXT_BUTTON_WIDTH, GAME_TEXT_BUTTON_HEIGHT/2, GameButtonType.Sell, "Sell", null );
		
		// Enemy en = new BlueSpinner();
		// en.hp = en.maxHP/3;
		// en.StartAt( currentLevel.links.get( 0 ) );
		
		// enemies.add( en );
		
		currentWave = spawner.GenerateEnemyList( wave );
		nextWave = spawner.GenerateEnemyList( wave + 1 );
	}
	
	private void MakeSpecialButton( int x, int y, int buttonWidth, int buttonHeight, GameButtonType type, String text, String shortcut ){
		GameButton button = new GameButton( x, y, buttonWidth, buttonHeight, type, text, shortcut );
		specialButtons.add( button );
	}
	
	private void MakeButton( int x, int y, int buttonWidth, int buttonHeight, GameButtonType type, Tower tower, String shortcut, String shortcutDisplay ){
		GameButton button = new GameButton( x, y, buttonWidth, buttonHeight, type, tower, shortcut, shortcutDisplay );
		buttons.add( button );
	}
	
	private void MakeButton( int x, int y, int buttonWidth, int buttonHeight, GameButtonType type, String text, String shortcut ){
		GameButton button = new GameButton( x, y, buttonWidth, buttonHeight, type, text, shortcut );
		buttons.add( button );
	}
	
	public void DrawGame(){
		
		background( background );
		
		if( gameWon ){
			fill( #FFFFFF );
			textAlign( CENTER, CENTER );
			text( "You have won the game!\nClick to go back to Main Menu", width/2, height/2 );
			return;
		}
		
		if( gameLost ){
			fill( #FFFFFF );
			textAlign( CENTER, CENTER );
			text( "You have sadly lost the game\nClick to go back to Main Menu", width/2, height/2 );
			return;
		}
		
		// Game Name
		fill( #FFFFFF );
		stroke( 0 );
		textSize( 25 );
		text( "Current Level: " + currentLevel.name, 150, 15 );
		
		// Player Stats
		textSize( 15 );
		text( "Bank: $" + money, 450, 15 );
		text( "Interest: " + interest + "%", 570, 15 );
		text( "Lives: " + lives, 670, 15 );
		text( "Wave: " + wave, 770, 15 );
		
		
		// Game Area
		fill( #FFFFFF, 127 );
		noStroke();
		rect( LEVEL_AREA_X, LEVEL_AREA_Y, LEVEL_AREA_WIDTH, LEVEL_AREA_HEIGHT );
		
		currentLevel.DrawLevel( OFFSET_X, OFFSET_Y );
		
		if( selectedTowerToBuild != null ){
			// Draw Tower to be built
			Tile buildingTile = FindTile( mouseX, mouseY );
			
			if( buildingTile != null && buildingTile.terrain == Terrain.Buildable && buildingTile.tower == null ){
				fill( #07091E, 100 );
				noStroke();
				
				rect( buildingTile.x * LEVEL_TILE_SIZE + OFFSET_X, buildingTile.y * LEVEL_TILE_SIZE + OFFSET_Y, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
				
				selectedTowerToBuildTemplate.DrawTower( buildingTile.x * LEVEL_TILE_SIZE + OFFSET_X, buildingTile.y * LEVEL_TILE_SIZE + OFFSET_Y );
				selectedTowerToBuildTemplate.DrawTowerRange( buildingTile.x * LEVEL_TILE_SIZE + OFFSET_X, buildingTile.y * LEVEL_TILE_SIZE + OFFSET_Y );
			}
		}
		
		// Draw enemies
		for( int i = 0; i < enemies.size(); ){
			if( enemies.get( i ).Draw() ){
				if( enemies.get( i ).hasReachedEnd ){
					lives--;
					if( lives < 1 ){
						gameLost = true;
					}
				} else {
					money += enemies.get( i ).reward;
				}
				enemies.remove( i );
				continue;
			}
			
			i++;
		}
		
		if( doSpawn && spawnTracker < currentWave.length && spawnDelay == 0 ){
			if( currentWave[spawnTracker] instanceof YellowSprinter ){
				spawnDelay = 5;
			} else {
				spawnDelay = 10;
			}
			
			for( ArrayList<Tile> link : currentLevel.links ){
				currentWave[spawnTracker].StartAt( link );
				enemies.add( currentWave[spawnTracker] );
				spawnTracker++;
			}
		} else if( spawnDelay > 0 ){
			spawnDelay--;
		}
		
		if( !hasUpdatedInterest && !doSpawn && enemies.isEmpty() ){
			money = int( money * ( 1 + ( float(interest)/100 ) ) );
			hasUpdatedInterest = true;
		}
		
		if( spawnTracker >= currentWave.length ){
			doSpawn = false;
		}
		
		// Selected Tower Range
		if( selectedBuiltTower != null ){
			selectedBuiltTower.DrawTowerRange();
			Tile t = selectedBuiltTower.tile;
			
			stroke( #FFFFFF );
			int x = t.x * LEVEL_TILE_SIZE + OFFSET_X;
			int y = t.y * LEVEL_TILE_SIZE + OFFSET_Y;
			// Top
			line( x, y, x + GAME_TOWER_SIZE - 1, y );
			
			// Right
			line( x + GAME_TOWER_SIZE - 1, y, x + GAME_TOWER_SIZE - 1, y + GAME_TOWER_SIZE - 1 );
			
			// Bottom
			line( x, y + GAME_TOWER_SIZE - 1, x + GAME_TOWER_SIZE - 1, y + GAME_TOWER_SIZE - 1 );
			
			// Left
			line( x, y, x, y + GAME_TOWER_SIZE - 1 );
		}
		
		// Tower Shoot
		for( Tower tower : towers ){
			tower.DrawTowerShoot( enemies );
		}

		

		
		// Right Sidebar
		fill( #2873ED, 72 );
		noStroke();
		rect( SIDEBAR_X, 10, SIDEBAR_WIDTH, 500 );
		
		// Towers
		fill( #28A4ED, 127 );
		rect( SIDEBAR_X + 4, 15, SIDEBAR_WIDTH - 8, 270 );
		
		textAlign( CENTER, CENTER );
		textSize( 20 );
		fill( #FFFFFF, 200 );
		text( "Towers", SIDEBAR_X + ( SIDEBAR_WIDTH / 2 ), 25 );
		
		// Description
		fill( #28A4ED, 192 );
		rect( SIDEBAR_X + 4, 290, SIDEBAR_WIDTH - 8, 220 );
		
		
		// Bottom
		fill( #2873ED, 72 );
		rect( SIDEBAR_X, 520, SIDEBAR_WIDTH, 200 );
		
		boolean isDisplayingTowerBuild = false;
		
		for( GameButton button : buttons ){
			GameButtonType t = button.UpdateMouse();
			switch( t ){
				case None:
				case Quit:
				case NextWave:
					break;
				default:
					DrawBuildTowerDescription( t );
					isDisplayingTowerBuild = true;
			}
			button.DrawButton( money );
		}
		
		if( !isDisplayingTowerBuild && selectedBuiltTower != null ){
			fill( #FFFFFF );
			textAlign( LEFT, TOP );
			
			textSize( 16 );
			text( selectedBuiltTower.name, SIDEBAR_X + 6, 294 );
			
			textSize( 10 );
			String total = "Range: " + selectedBuiltTower.range + "\nDamage: " + int( selectedBuiltTower.damage ) + "\nUpgrade Cost: " + selectedBuiltTower.upgradeCost + "\nSell for: " + selectedBuiltTower.sell + "\n\n";
			
			text( total, SIDEBAR_X + 6, 325, SIDEBAR_WIDTH - 12, 100 );
			
			textAlign( CENTER, CENTER );
			
			GameButtonType targetType = null;
			
			switch( selectedBuiltTower.targetingType ){
				case Hard:
					targetType = GameButtonType.Hard;
					break;
				case Weak:
					targetType = GameButtonType.Weak;
					break;
				case Close:
					targetType = GameButtonType.Close;
					break;
				case Fast:
					targetType = GameButtonType.Fast;
					break;
			}
			
			for( GameButton button : specialButtons ){
				button.Selected( false );
				if( selectedBuiltTower == null ){
					button.isHoveringOver = false;
					continue;
				}
				if( button.type == GameButtonType.Upgrade && ( selectedBuiltTower.level > 9 || selectedBuiltTower.upgradeCost > money ) ){
					button.isHoveringOver = false;
					continue;
				}
				if( selectedBuiltTower.type == TowerType.Blue1 || selectedBuiltTower.type == TowerType.Blue2 ){
					if( button.type == GameButtonType.Hard || button.type == GameButtonType.Weak || button.type == GameButtonType.Close || button.type == GameButtonType.Random ){
						button.isHoveringOver = false;
						continue;
					}
				} else if( selectedBuiltTower.type == TowerType.Red2 ){
					if( button.type == GameButtonType.Hard || button.type == GameButtonType.Weak || button.type == GameButtonType.Close || button.type == GameButtonType.Fast ){
						button.isHoveringOver = false;
						continue;
					} else {
						button.Selected( true );
					}
				} else {
					if( button.type == GameButtonType.Fast || button.type == GameButtonType.Random ){
						button.isHoveringOver = false;
						continue;
					}
				}
				button.Selected( false );
				if( targetType != null && button.type == targetType ){
					button.Selected( true );
				}
				button.UpdateMouse();
				button.DrawButton( money );
			}
			
		}
		
		// Wave Display
		fill( #FFFFFF );
		textSize( 16 );
		textAlign( LEFT, CENTER );
		text( "Current Wave: ", SIDEBAR_X + 20, 600 );
		pushMatrix();
		
		translate( SIDEBAR_X + 150, 585 );
		currentWave[0].DrawStatic( 0, 0 );
		
		text( currentWave[0].maxHP + " HP", 40, 14 );
		
		popMatrix();
		
		text( "Next Wave: ", SIDEBAR_X + 20, 650 );
		pushMatrix();
		
		translate( SIDEBAR_X + 150, 635 );
		nextWave[0].DrawStatic( 0, 0 );
		
		text( nextWave[0].maxHP + " HP", 40, 14 );
		
		popMatrix();
		
	}
	
	private void DrawBuildTowerDescription( GameButtonType t ){
		String type = "";
		String cost = "";
		String dmg = "";
		String other = "";
		String des = "";
		
		switch( t ){
			case Green1:
				type = "Green Laser 1";
				cost = "100";
				dmg = "1000 / Second";
				other = "150% Damage to Green Enemies\n50% Damage to Red Enemies";
				des = "The green laser fires a medium beam at the targeted enemy, dealing nominal damage. It also has impressive range for its cost";
				break;
			case Green2:
				type = "Green Laser 2";
				cost = "400";
				dmg = "2000 / Second, Per Target";
				other = "150% Damage to Green Enemies\n50% Damage to Red Enemies";
				des = "This updated version of the  green laser fires a beam that will bounce to an additional enemy, dealing impressive damage.";
				break;
			case Green3:
				type = "Green Laser 3";
				cost = "2000";
				dmg = "4000 / Second, Per Target";
				other = "150% Damage to Green Enemies\n50% Damage to Red Enemies";
				des = "The latest version of the green laser, fires a beam that will bounce to two additional enemies, dealing massive damage. Expensive but has good damage output.";
				break;
			case Red1:
				type = "Red Refractor";
				cost = "200";
				dmg = "800 / Second, Per Target";
				other = "150% Damage to Red Enemies\n50% Damage to Green Enemies";
				des = "The Red Refractor fires a special beam that will redistribute to up to 5 additional targets, making this an excellent tool for crowds.";
				break;
			case Red2:
				type = "Little Red Spammer";
				cost = "800";
				dmg = "500 Per Target";
				other = "150% Damage to Red Enemies\n50% Damage to Green Enemies";
				des = "This tower has a high output rate at random targets within range. Good for area supression or high damage to a single tough target.";
				break;
			case Red3:
				type = "Red Rocket";
				cost = "2500";
				dmg = "25,000 Per Rocket";
				other = "150% Damage to Red Enemies\n50% Damage to Green Enemies";
				des = "Smart Rockets dealing overwhelming damage. Will retarget to the nearest enemy if target is destroyed on the Way.";
				break;
			case Purple1:
				type = "Purple Focus Laser";
				cost = "300";
				dmg = "800 Per Beam, 80 Burning";
				other = "150% Damage to Purple Enemies\n50% Damage to Blue Enemies";
				des = "Focus lasers has high damage output, and is so intense that it burns the enemy for some time afterwards.";
				break;
			case Purple2:
				type = "Purple Focus Laser 2";
				cost = "900";
				dmg = "3000 Per Beam, 300 Burning";
				other = "150% Damage to Purple Enemies\n50% Damage to Blue Enemies";
				des = "Version 2 of the Focus Laser hits harder, and burns hotter.";
				break;
			case Purple3:
				type = "Purple Focus Laser 3";
				cost = "2800";
				dmg = "20,000 Per Beam, 2000 Burning";
				other = "150% Damage to Purple Enemies\n50% Damage to Blue Enemies";
				des = "State of the art burning technology, packs bigger punch than ever.";
				break;
			case Blue1:
				type = "Blue Chrono Condenser";
				cost = "300";
				dmg = "1000 Per Target";
				other = "Slows Enemies by 40%\n150% Damage to Blue Enemies\n50% Damage to Purple Enemies";
				des = "The Chrono Condenser is more of a support tower, slowing up to 4 enemies down. As such, its damage isn't very impressive. ";
				break;
			case Blue2:
				type = "Deep Freeze";
				cost = "600";
				dmg = "5000 Per Target";
				other = "Stops Enemies\n150% Damage to Blue Enemies\n50% Damage to Purple Enemies";
				des = "Deep Freeze leverages the latest technology to slow up to 2 enemies to a halt. Its slow firing rate limits its usefulness.";
				break;
		}
		
		stroke( #FFFFFF );
		fill( #FFFFFF );
		strokeWeight( 1 );
		textAlign( LEFT, TOP );
		
		textSize( 16 );
		text( type, SIDEBAR_X + 6, 294 );
		
		textSize( 10 );
		String total = "Cost: " + cost + "\nDamage:" + dmg + "\n" + other + "\n\n" + des;
		
		text( total, SIDEBAR_X + 6, 325, SIDEBAR_WIDTH - 12, 200 );
		
		textAlign( CENTER, CENTER );
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
		
		if( gameWon || gameLost ){
			return true;
		}
		
		// Buttons
		for( GameButton button : buttons ){
			
			GameButtonType pressed = button.MousePressed();
			switch( pressed ){
				case None:
					continue;
				case Quit:
					return true; // Have to do this way since it takes too much effort to use inner classes
				case NextWave:
					SpawnNextWave();
					
					return false;
				default:
					SelectButton( pressed, button );
			}
			
		}
		
		for( GameButton button : specialButtons ){
			GameButtonType pressed = button.MousePressed();
			switch( pressed ){
				case Upgrade:
					if( selectedBuiltTower != null && selectedBuiltTower.upgradeCost <= money ){
						selectedBuiltTower.Upgrade();
						money -= selectedBuiltTower.upgradeCost;
					}
					return false;
				case Sell:
					money += selectedBuiltTower.sell;
					selectedBuiltTower.tile.tower = null;
					towers.remove( selectedBuiltTower );
					selectedBuiltTower = null;
					button.isHoveringOver = false;
					return false;
				case Hard:
					selectedBuiltTower.targetingType = TargetingType.Hard;
					return false;
				case Weak:
					selectedBuiltTower.targetingType = TargetingType.Weak;
					return false;
				case Close:
					selectedBuiltTower.targetingType = TargetingType.Close;
					return false;
			}
		}
		
		BuildOrSelectTower();
		
		return false;
		
	}
	
	private void SpawnNextWave(){
		if( doSpawn ){
			return;
		}
	
		// Interest
		if( !hasUpdatedInterest ){
			money = int( money * ( 1 + ( float(interest)/100 ) ) );
		}
		hasUpdatedInterest = false;
		
		// Update waves
		if( ++wave % 5 == 0 ){
			interest += 3;
		}
		
		currentWave = nextWave;
		nextWave = spawner.GenerateEnemyList( wave + 1 );
		
		spawnTracker = 0;
		doSpawn = true;
	}
	
	public void KeyPressed(){
		if( key == ' ' ){
			SpawnNextWave();
			return;
		}
		for( GameButton button : buttons ){
			GameButtonType type = button.isShortcutPressed( key );
			if( type != GameButtonType.None ){
				SelectButton( type, button );
			}
		}
	}
	
	private void BuildOrSelectTower(){
		
		selectedBuiltTower = null;
		
		// Playing Area
		Tile tile = FindTile( mouseX, mouseY );
		
		if( tile == null ){
			return;
		}
		
		// If this tile isn't buildable or we're not building a tower and there's no built tower to select
		if( tile.terrain != Terrain.Buildable ){
			DeselectButtonAndTower();
			return;
		}
		if( selectedTowerToBuild == null && tile.tower == null ){
			DeselectButtonAndTower();
			return;
		} else if( selectedTowerToBuild != null && tile.tower != null ){
			DeselectButtonAndTower();
			return;
		}
		
		// First, if we're building a tower
		if( selectedTowerToBuild != null && tile.tower == null ){ // Extra redundency
			
			Tower newTower = towerMaker.MakeTower( selectedTowerToBuild, tile );
			
			tile.tower = newTower;
			towers.add( newTower );
			money -= newTower.cost;
			
			DeselectButtonAndTower();
			
			return;
			
		}
		
		// If we're selecting a built tower
		if( tile.tower != null && selectedTowerToBuild == null ){
			selectedBuiltTower = tile.tower;
			return;
		}
		
	}
	
	private void DeselectButtonAndTower(){
		// Deselect the tower
		selectedTowerToBuild = null;
		if( selectedButton != null ){
			selectedButton.Selected( false );
		}
		selectedTowerToBuildTemplate = null;
	}
	
	private void SelectButton( GameButtonType type, GameButton button ){
		if( selectedButton != null ){
			selectedButton.Selected( false );
			selectedTowerToBuild = null;
			selectedTowerToBuildTemplate = null;
		}
		
		if( button.tower.cost > money ){
			return;
		}
		
		selectedButton = button;
		
		selectedTowerToBuild = button.tower.type;
		selectedTowerToBuildTemplate = button.tower;
		
		// switch( type ){
			// case Green1:
				// selectedTowerToBuild = TowerType.Green1;
				// break;
			// case Red1:
				// selectedTowerToBuild = TowerType.Red1;
				// break;
			// case Purple1:
				// selectedTowerToBuild = TowerType.Purple1;
				// break;
			// case Blue1:
				// selectedTowerToBuild = TowerType.Blue1;
				// break;
		// }
		
		button.Selected( true );
	}
	
}
