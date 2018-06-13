enum Terrain{
	Buildable, Lane
}

public class Tile{
	public int x, y;
	public Terrain terrain;
	public boolean isEntrance, isExit;
}

public enum InvalidReason{
	NoEntrance, NoExit, NotEnoughLinks // TODO
}

public class Level{
	
	public String name = "New Level";
	
	public Tile[][] terrain;
	
	//public ArrayList<Tile> entrances = new ArrayList<Tile>();
	//public ArrayList<Tile> exits = new ArrayList<Tile>();
	
	public HashMap<Tile, ArrayList<Tile>> links = new HashMap<Tile, ArrayList<Tile>>();
	
	public Level(){
		// DEBUG for now
		terrain = new Tile[ LEVEL_SIZE_X ][ LEVEL_SIZE_Y ];
		
		for( int i = 0; i < terrain.length; i++ ){
			for( int j = 0; j < terrain[i].length; j++ ){
				Tile t = new Tile();
				t.x = i;
				t.y = j;
				t.terrain = Terrain.Buildable;
				
				terrain[i][j] = t;
			}
		}
		
	}
	
	// Loading from JSON
	public Level( JSONObject json ){
		
		name = json.getString( "name" );
		
		terrain = new Tile[ LEVEL_SIZE_X ][ LEVEL_SIZE_Y ];
		
		JSONArray terrainJSON = json.getJSONArray( "terrain" );
		
		for( int i = 0; i < terrainJSON.size(); i++ ){
			
			Tile t = new Tile();
			
			JSONObject tile = terrainJSON.getJSONObject( i );
			
			t.x = tile.getInt( "x" );
			t.y = tile.getInt( "y" );
				
			switch( tile.getString( "terrain" ) ){
				case "Buildable":
					t.terrain = Terrain.Buildable;
					break;
				case "Lane":
					t.terrain = Terrain.Lane;
					break;
				default:
					t.terrain = Terrain.Buildable;
			}
			
			terrain[ t.x ][ t.y ] = t;
			
		}
		
		// Links, Yay!
		JSONArray linksArray = json.getJSONArray( "links" );
		
		for( int i = 0; i < linksArray.size(); i++ ){
			
			// Get the individual link list
			JSONArray singleLink = linksArray.getJSONArray( i );
			ArrayList<Tile> linkArrayList = new ArrayList<Tile>();
			
			for( int j = 0; j < singleLink.size(); j++ ){
				
				JSONObject linkTile = singleLink.getJSONObject( j );
				
				Tile t = terrain[ linkTile.getInt( "x" ) ][ linkTile.getInt( "y" ) ];
				
				if( j == 0 ){
					t.isEntrance = true;
				} else if( j == singleLink.size() - 1 ){
					t.isExit = true;
				}
				
				linkArrayList.add( j, t );
				
			}
			
			links.put( linkArrayList.get( 0 ), linkArrayList );
			
		}
		
	}
	
	public void DrawLevel( int offsetX, int offsetY ){
		
		for( int i = 0; i < LEVEL_SIZE_X; i++ ){
			for( int j = 0; j < LEVEL_SIZE_Y; j++ ){
				
				if( terrain[i][j].isEntrance ){
					fill( #65F232, 200 );
					noStroke();
				} else if ( terrain[i][j].isExit ){
					fill( #F23232, 200 );
					noStroke();
				} else if( terrain[i][j].terrain == Terrain.Lane ){
					fill( TILE_COLOR_ROAD, TILE_COLOR_ROAD_ALPHA );
					noStroke();
				} else {
					fill( TILE_COLOR_BUILDABLE, TILE_COLOR_BUILDABLE_ALPHA );
					stroke( 0 );
				}

				rect( i * LEVEL_TILE_SIZE + offsetX, j * LEVEL_TILE_SIZE + offsetY, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
				
			}
		}
		
		// Entrance / Exit
		// for( Tile t : entrances ){
			// fill( #65F232, 200 );
			// noStroke();
			
			// rect( t.x * LEVEL_TILE_SIZE + offsetX, t.y * LEVEL_TILE_SIZE + offsetY, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
		// }
		
		// for( Tile t : exits ){
			// fill( #F23232, 200 );
			// noStroke();
			
			// rect( t.x * LEVEL_TILE_SIZE + offsetX, t.y * LEVEL_TILE_SIZE + offsetY, LEVEL_TILE_SIZE, LEVEL_TILE_SIZE );
		// }
		
	}
	
	// public void RecheckEntranceExit(){
		// entrances.clear();
		// exits.clear();
		
		// for( int i = 0; i < LEVEL_SIZE_X; i++ ){
			// for( int j = 0; j < LEVEL_SIZE_Y; j++ ){
				// if( terrain[i][j].isEntrance ){
					// entrances.add( terrain[i][j] );
				// }
				// if( terrain[i][j].isExit ){
					// exits.add( terrain[i][j] );
				// }
			// }
		// }
	// }
	
	public ArrayList<InvalidReason> Validate(){
		// TODO
		return null;
	}
	
	
	
	public JSONObject GetJSON(){
		
		JSONObject lvlObject = new JSONObject();
		
		lvlObject.setString( "name", name );
		
		JSONArray terrainJSON = new JSONArray();
		
		for( int i = 0; i < terrain.length; i++ ){
			for( int j = 0; j < terrain[i].length; j++ ){
				
				JSONObject tileJSON = new JSONObject();
				
				tileJSON.setInt( "x", i );
				tileJSON.setInt( "y", j );
				
				String terrainString;
				
				switch( terrain[i][j].terrain ){
					case Buildable:
						terrainString = "Buildable";
						break;
					case Lane:
						terrainString = "Lane";
						break;
					default:
						terrainString = "Buildable"; // DEBUG
				}
				
				tileJSON.setString( "terrain", terrainString ); // This doesn't work
				
				terrainJSON.setJSONObject( terrain.length * j + i, tileJSON );
				
			}
		}
		
		lvlObject.setJSONArray( "terrain", terrainJSON );
		
		JSONArray allLinksArray = new JSONArray();
		ArrayList<ArrayList<Tile>> linksInArray = new ArrayList<ArrayList<Tile>>( links.values() ); // Can't iterate over HashMap with any sort of clarity. Have to change it to ArrayList
		
		for( int i = 0; i < linksInArray.size(); i++ ){
			
			ArrayList<Tile> link = linksInArray.get(i);
			JSONArray linkArray = new JSONArray();
			
			for( int j = 0; j < link.size(); j++ ){
				
				Tile tile = link.get( j );
				JSONObject tileObject = new JSONObject();
				
				tileObject.setInt( "x", tile.x );
				tileObject.setInt( "y", tile.y );
				
				linkArray.setJSONObject( j, tileObject );
				
			}
			
			allLinksArray.setJSONArray( i, linkArray );
			
		}
		
		lvlObject.setJSONArray( "links", allLinksArray );
		
		return lvlObject;
		
	}
	
}
