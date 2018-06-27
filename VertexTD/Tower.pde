enum TowerType{
	Green1, Green2, Green3, Red1, Red2, Red3, Purple1, Purple2, Purple3, Blue1, Blue2
}

enum DamageType{
	Red, Green, Blue, Purple
}

enum TargetingType{
	Hard, Weak, Close, Fast
}

// We need this class because I can't use Statics effectively in Proccessing
public class TowerMaker{
	public Tower MakeTower( TowerType type, Tile tile ){
    
		Tower tower;
	
		switch( type ){
			case Green1:
				tower = new Green1Tower( TowerType.Green1, "Green Laser 1" );
				break;
			case Green2:
				tower = new Green2Tower( TowerType.Green2, "Green Laser 2" );
				break;
			case Green3:
				tower = new Green3Tower( TowerType.Green3, "Green Laser 3" );
				break;
			case Red1:
				tower = new Red1Tower( TowerType.Red1, "Red Refractor" );
				break;
			case Red2:
				tower = new Red2Tower( TowerType.Red2, "Little Red Spammer" );
				break;
			case Red3:
				tower = new Red3Tower( TowerType.Red3, "Red Rockets" );
				break;
			case Purple1:
				tower = new Purple1Tower( TowerType.Purple1, "Purple Focus Laser" );
				break;
			case Purple2:
				tower = new Purple2Tower( TowerType.Purple2, "Advanced Purple Focus Laser" );
				break;
			case Purple3:
				tower = new Purple3Tower( TowerType.Purple3, "Massive Purple Laser" );
				break;
			case Blue1:
				tower = new Blue1Tower( TowerType.Blue1, "Blue Chrono Condenser" );
				break;
			case Blue2:
				tower = new Blue2Tower( TowerType.Blue2, "Blue Deep Freeze" );
				break;
			default:
				return null;
		}
		
		tower.tile = tile;
		
		return tower;
		
	}
	
	public Tower MakeTower( TowerType type ){
		return MakeTower( type, null );
	}
}


public abstract class Tower{
	
	public Tile tile;
	public String name;
	
	public TowerType type;
	
	public int level = 1;
	public int range;
	public float damage;
	public int cost;
	public int upgradeCost;
	public int sell;
	public int damageBoost = 0;
	public int rangeBoost = 0;
	
	public float getDamage(){
		return damage * ( 1 + ( damageBoost * 0.25 ) );
	}
	
	public float getRange(){
		return range * ( 1 + ( rangeBoost * 0.25 ) );
	}
	
	public TargetingType targetingType = TargetingType.Hard;
	
	public Tower( TowerType type, String n, int cost, int damage, int upgradeCost, int range ){
		this.type = type;
		name = n;
		
		this.damage = float( damage );
		this.upgradeCost = upgradeCost;
		
		this.cost = cost;
		sell = int( cost * 0.75 );
		
		this.range = range;
	}
	
	public abstract void DrawTower( int x, int y );
	
	protected void DrawWalls( int x, int y ){
		// Top
		line( x + 1, y + 1, x + GAME_TOWER_SIZE - 1, y + 1 );
		
		// Right
		line( x + GAME_TOWER_SIZE - 1, y + 1, x + GAME_TOWER_SIZE - 1, y + GAME_TOWER_SIZE - 1 );
		
		// Bottom
		line( x + 1, y + GAME_TOWER_SIZE - 1, x + GAME_TOWER_SIZE - 1, y + GAME_TOWER_SIZE - 1 );
		
		// Left
		line( x + 1, y + 1, x + 1, y + GAME_TOWER_SIZE - 1 );
	}
	
	public void DrawTowerRange(){

		PVector point = TranslateGridToPixel( tile.x, tile.y );
		DrawTowerRange( point.x, point.y );
		
	}
	
	public void DrawTowerRange( float x, float y ){
		stroke( #FFFFFF, 127 );
		noFill();
		
		ellipseMode( RADIUS );
		ellipse( x + LEVEL_TILE_SIZE/2, y + LEVEL_TILE_SIZE/2, getRange(), getRange() );
	}
	
	public abstract void DrawTowerShoot( ArrayList<Enemy> enemies );
	
	public void DrawLevel( int x, int y ){
		fill( 0, 200 );
		rect( x + 1, y + 1, LEVEL_TILE_SIZE / 3, LEVEL_TILE_SIZE / 3 );
		textSize( 10 );
		textAlign( CENTER, CENTER );
		fill( #FFFFFF );
		text( level, x + 6, y + 6 );
	}
	
	public void Upgrade(){
		level++;
		damage = damage * 1.15;
		range += 10;
		sell += upgradeCost/2;
	}
	
	protected PVector TranslateGridToPixel( int x, int y ){
		return new PVector( x * LEVEL_TILE_SIZE + OFFSET_X, y * LEVEL_TILE_SIZE + OFFSET_Y );
	}
	
	protected float FindDistance( PVector a, PVector b ){
		return sqrt( pow( a.x - b.x, 2 ) + pow( a.y - b.y, 2 ) );
	}
	
	public void DamageBoostModify( int modify ){
		damageBoost += modify;
	}
	
	public void RangeBoostModify( int modify ){
		rangeBoost += modify;
	}
	
}

public class Green1Tower extends Tower{
	
	public Green1Tower( TowerType type, String n ){
		super( type, n, 100, 1000, 50, 100 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_GREEN_COLOR );
		fill( GAME_TOWER_GREEN_COLOR );
		
		// Four Walls
		DrawWalls( x, y );
		
		// Symbol
		line( x, y + GAME_TOWER_SIZE, x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2 );
		ellipseMode( CENTER );
		ellipse( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, 5, 5 );
	}
	
	private Enemy target;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemy ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > getRange() || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( target == null ){
			for( Enemy e : enemy ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
					continue;
				}
				if( target == null ){
					target = e;
					continue;
				}
				switch( targetingType ){
					case Hard:
						if( e.hp > target.hp ){
							target = e;
						}
						break;
					case Weak:
						if( e.hp < target.hp ){
							target = e;
						}
						break;
					case Close:			
						if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
							target = e;
						}
				}
			}
			
			if( target == null ){
				return;
			}
		}

		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_GREEN_COLOR );
		strokeWeight( 1 );
		
		line( location.x, location.y, target.x + random( -1, 1 ), target.y + random( -1, 1 ) );
		target.TakeDamage( DamageType.Green, getDamage() / FRAME_RATE, null );
		
		strokeWeight( 1 );
		
		popMatrix();
	}
	
}

public class Green2Tower extends Tower{
	
	public Green2Tower( TowerType type, String n ){
		super( type, n, 400, 2000, 200, 100 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_GREEN_COLOR );
		fill( GAME_TOWER_GREEN_COLOR );
		
		// Four Walls
		DrawWalls( x, y );
		
		// Symbol
		line( x, y + GAME_TOWER_SIZE, x + 10, y + 17 );
		ellipseMode( CENTER );
		ellipse( x + 10, y + 17, 5, 5 );
		
		line( x + 10, y + 17, x + 24, y + 12 );
		ellipse( x + 24, y + 12, 5, 5 );
	}
	
	Enemy target1 = null;
	Enemy target2 = null;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemy ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		Enemy ret = FindAndShootTarget( location, enemy, target1, getRange(), false );
		if( ret == null ){
			target1 = null;
			return;
		} else {
			target1 = ret;
		}
		ret = FindAndShootTarget( new PVector( target1.x, target1.y ), enemy, target2, getRange()/2, true );
		if( ret == null ){
			target2 = null;
		} else {
			target2 = ret;
		}
	}

	private Enemy FindAndShootTarget( PVector location, ArrayList<Enemy> enemy, Enemy target, float currentRange, boolean avoid ){

		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > currentRange || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( target == null ){
			for( Enemy e : enemy ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) > currentRange ){
					continue;
				}
				if( avoid && e == target1 ){
					continue;
				}
				if( target == null ){
					target = e;
					continue;
				}
				switch( targetingType ){
					case Hard:
						if( e.hp > target.hp ){
							target = e;
						}
						break;
					case Weak:
						if( e.hp < target.hp ){
							target = e;
						}
						break;
					case Close:			
						if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
							target = e;
						}
				}
			}
			
			if( target == null ){
				return null;
			}
		}

		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_GREEN_COLOR );
		strokeWeight( 1 );
		
		line( location.x, location.y, target.x + random( -1, 1 ), target.y + random( -1, 1 ) );
		target.TakeDamage( DamageType.Green, getDamage() / FRAME_RATE, null );
		
		strokeWeight( 1 );
		
		popMatrix();
		
		return target;
	}
}

public class Green3Tower extends Tower{
	public Green3Tower( TowerType type, String n ){
		super( type, n, 2000, 4000, 1000, 100 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_GREEN_COLOR );
		fill( GAME_TOWER_GREEN_COLOR );
		
		// Four Walls
		DrawWalls( x, y );
		
		// Symbol
		line( x, y + GAME_TOWER_SIZE, x + 10, y + 17 );
		ellipseMode( CENTER );
		ellipse( x + 10, y + 17, 5, 5 );
		
		line( x + 10, y + 17, x + 24, y + 12 );
		ellipse( x + 24, y + 12, 5, 5 );
		
		line( x + 24, y + 12, x + 20, y + 26 );
		ellipse( x + 20, y + 26, 5, 5 );
	}
	
	Enemy target1 = null;
	Enemy target2 = null;
	Enemy target3 = null;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemy ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		Enemy ret = FindAndShootTarget( location, enemy, target1, getRange(), false, false );
		if( ret == null ){
			target1 = null;
			return;
		} else {
			target1 = ret;
		}
		ret = FindAndShootTarget( new PVector( target1.x, target1.y ), enemy, target2, getRange()/2, true, false );
		if( ret == null ){
			target2 = null;
			return;
		} else {
			target2 = ret;
		}
		ret = FindAndShootTarget( new PVector( target2.x, target2.y ), enemy, target3, getRange()/2, true, true );
		if( ret == null ){
			target3 = null;
		} else {
			target3 = ret;
			return;
		}
	}

	private Enemy FindAndShootTarget( PVector location, ArrayList<Enemy> enemy, Enemy target, float currentRange, boolean avoid1, boolean avoid2 ){

		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > currentRange || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( target == null ){
			for( Enemy e : enemy ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) > currentRange ){
					continue;
				}
				if( (avoid1 && e == target1) || (avoid2 && e == target2) ){
					continue;
				}
				if( target == null ){
					target = e;
					continue;
				}
				switch( targetingType ){
					case Hard:
						if( e.hp > target.hp ){
							target = e;
						}
						break;
					case Weak:
						if( e.hp < target.hp ){
							target = e;
						}
						break;
					case Close:			
						if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
							target = e;
						}
				}
			}
			
			if( target == null ){
				return null;
			}
		}

		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_GREEN_COLOR );
		strokeWeight( 1 );
		
		line( location.x, location.y, target.x + random( -1, 1 ), target.y + random( -1, 1 ) );
		target.TakeDamage( DamageType.Green, getDamage() / FRAME_RATE, null );
		
		strokeWeight( 1 );
		
		popMatrix();
		
		return target;
	}
}

public class Red1Tower extends Tower{
	
	public Red1Tower( TowerType type, String n ){
		super( type, n, 200, 800, 100, 120 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_RED_COLOR );
		fill( GAME_TOWER_RED_COLOR );
		
		DrawWalls( x, y );
		
		// Symbol
		ellipseMode( CENTER );
		
		line( x, y + GAME_TOWER_SIZE, x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2 );
		
		line( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, x + 11, y + 12 );
		ellipse( x + 11, y + 12, 2, 2 );
		
		line( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, x + 20, y + 8 );
		ellipse( x + 20, y + 8, 2, 2 );
		
		line( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, x + 6, y + 18 );
		ellipse( x + 6, y + 18, 2, 2 );
		
		line( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, x + 28, y + 22 );
		ellipse( x + 28, y + 22, 2, 2 );
		
		line( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, x + 22, y + 29 );
		ellipse( x + 22, y + 29, 2, 2 );
	}
	
	final int reloadTimer = 10;
	int currentReload = 0;
	
	int transTickdown = 0;
	
	Enemy target = null;
	PVector targeted;
	ArrayList<PVector> AuxTargets = new ArrayList<PVector>();
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > getRange() || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( currentReload > 0 ){
			currentReload--;
			
			if( transTickdown > 0 ){
				DrawBeam( location, targeted );
				
				// Aux Targets
				for( PVector aux : AuxTargets ){
					DrawBeam( targeted, aux );
				}
				
				transTickdown--;
			} else {
				targeted = null;
				AuxTargets.clear();
			}
		} else {
		
			if( target == null ){
				for( Enemy e : enemies ){

					if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
						continue;
					}
					if( target == null ){
						target = e;
						continue;
					}
					
					switch( targetingType ){
						case Hard:
							if( e.hp > target.hp ){
								target = e;
							}
							break;
						case Weak:
							if( e.hp < target.hp ){
								target = e;
							}
							break;
						case Close:			
							if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
								target = e;
							}
					}
				
				}
			}
			
			if( target == null ){
				return;
			}

			targeted = new PVector( target.x, target.y );
			
			DrawBeam( location, targeted );
			target.TakeDamage( DamageType.Red, getDamage() / (FRAME_RATE/reloadTimer), null );
			
			// Aux Targets
			for( Enemy auxEnemy : enemies ){
				if( auxEnemy == target ){
					continue;
				}
				if( AuxTargets.size() < 5 && FindDistance( targeted, new PVector( auxEnemy.x, auxEnemy.y ) ) <= getRange() / 2 ){
					PVector aux = new PVector( auxEnemy.x, auxEnemy.y );
					
					DrawBeam( targeted, aux );
					auxEnemy.TakeDamage( DamageType.Red, getDamage() / (FRAME_RATE/reloadTimer), null );
					AuxTargets.add( aux );
				}
			}
			
			currentReload = reloadTimer;
			transTickdown = 8;

			return;
		
		}

	}
	
	private void DrawBeam( PVector location, PVector target ){
		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_RED_COLOR, 180 - (( 8 - transTickdown ) * 40 ) );
		strokeWeight( 3 );
		
		line( location.x, location.y, target.x, target.y );
		
		strokeWeight( 1 );
		
		popMatrix();
	}
	
}

public class Missile2{
	public PVector location;
	
	public Missile2( PVector loc ){
		location = loc;
	}
}

public class Red2Tower extends Tower{
	public Red2Tower( TowerType type, String n ){
		super( type, n, 800, 500, 400, 140 );
		
		fireSpot[0] = new PVector( LEVEL_TILE_SIZE / 4, LEVEL_TILE_SIZE / 4 );
		fireSpot[1] = new PVector( LEVEL_TILE_SIZE / 2, LEVEL_TILE_SIZE / 4 );
		fireSpot[2] = new PVector( LEVEL_TILE_SIZE * 3 / 4, LEVEL_TILE_SIZE / 4 );
		
		fireSpot[3] = new PVector( LEVEL_TILE_SIZE / 4, LEVEL_TILE_SIZE / 2 );
		fireSpot[4] = new PVector( LEVEL_TILE_SIZE / 2, LEVEL_TILE_SIZE / 2 );
		fireSpot[5] = new PVector( LEVEL_TILE_SIZE * 3 / 4, LEVEL_TILE_SIZE / 2 );
		
		fireSpot[6] = new PVector( LEVEL_TILE_SIZE / 4, LEVEL_TILE_SIZE * 3 / 4 );
		fireSpot[7] = new PVector( LEVEL_TILE_SIZE / 2, LEVEL_TILE_SIZE * 3 / 4 );
		fireSpot[8] = new PVector( LEVEL_TILE_SIZE * 3 / 4, LEVEL_TILE_SIZE * 3 / 4 );
		
	}
	
	PVector[] fireSpot = new PVector[9];
	private int currentSpot = 0;
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_RED_COLOR );
		fill( GAME_TOWER_RED_COLOR );
		
		DrawWalls( x, y );
		
		pushMatrix();
		translate( x, y );
		
		ellipseMode( CENTER );
		
		for( int i = 0; i < fireSpot.length; i++ ){
			ellipse( fireSpot[i].x, fireSpot[i].y, 3, 3 );
		}
		
		popMatrix();
	}
	
	HashMap<Missile2, Enemy> missiles = new HashMap<Missile2, Enemy>();
	int reload = 0;
	ArrayList<Enemy> inRange = new ArrayList<Enemy>();
	ArrayList<Missile2> toRemove = new ArrayList<Missile2>();
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		for( HashMap.Entry<Missile2, Enemy> entry : missiles.entrySet() ){
			if( MoveTowards( entry.getKey(), entry.getValue() ) ){
				toRemove.add( entry.getKey() );
			}
		}
		
		for( Missile2 mis : toRemove ){
			missiles.remove( mis );
		}
		
		toRemove.clear();
		
		if( reload > 0 ){
			reload--;
		} else {
			PVector location = TranslateGridToPixel( tile.x, tile.y );
			inRange.clear();
			for( Enemy e : enemies ){
				if( location.dist( new PVector( e.x, e.y ) ) < getRange() ){
					inRange.add( e );
				}
			}
			if( inRange.isEmpty() ){
				return;
			}
			missiles.put( new Missile2( new PVector( tile.x * LEVEL_TILE_SIZE + OFFSET_X + fireSpot[currentSpot].x, tile.y * LEVEL_TILE_SIZE + OFFSET_Y + fireSpot[currentSpot++].y ) ), inRange.get( int( random( inRange.size() - 1 ) ) ) );
			if( currentSpot > 8 ){
				currentSpot -= 9;
			}
			reload = 2;
		}
	}
	
	private boolean MoveTowards( Missile2 missile, Enemy target ){
		if( target.hp <= 0 ){
			return true;
		}
			
		PVector move = new PVector( target.x + LEVEL_TILE_SIZE/2, target.y + LEVEL_TILE_SIZE/2 ).sub( missile.location );
		
		if( move.mag() < 8 ){
			target.TakeDamage( DamageType.Red, getDamage(), null );
			return true;
		}
		
		move.setMag( 8 );
		missile.location.add( move );
		
		noStroke();
		ellipseMode( CENTER );
		fill( GAME_TOWER_RED_COLOR );
		ellipse( missile.location.x, missile.location.y, 4, 4 );
		
		return false;
	}
}

public class Missile3Trail{
	public PVector location;
	public int timer;
	
	public Missile3Trail( PVector loc ){
		location = loc;
		timer = 8;
	}
}

public class Missile3{
	public PVector location;
	public Enemy target;
	ArrayList<Missile3Trail> trails = new ArrayList<Missile3Trail>();
	int trailCooldown = 0;
	
	public Missile3( PVector loc, Enemy t ){
		location = loc;
		target = t;
	}
	
	public boolean Draw( ArrayList<Enemy> enemies, int damage ){
		if( target != null ){
			if( target.hp <= 0 ){
				target = null;
				return false;
			}
				
			PVector move = new PVector( target.x + LEVEL_TILE_SIZE/2, target.y + LEVEL_TILE_SIZE/2 ).sub( location );
			
			if( move.mag() < 5 ){
				target.TakeDamage( DamageType.Red, damage, null );
				return true;
			}
			
			move.setMag( 5 );
			location.add( move );
			
			noStroke();
			fill( GAME_TOWER_RED_COLOR );
			
			rectMode( CENTER );
			rect( location.x, location.y, 8, 8 );
			rectMode( CORNER );
			
			if( trailCooldown-- < 1 ){
				trails.add( new Missile3Trail( new PVector( location.x, location.y ) ) );
				trailCooldown = 2;
			}
			
			ellipseMode( CENTER );
			// fill( #FFFFFF );
			
			for( int i = 0; i < trails.size(); ){
				if( trails.get(i).timer-- < 1 ){
					trails.remove( i );
					continue;
				} else {
					Missile3Trail t = trails.get(i);
					ellipse( t.location.x, t.location.y, t.timer, t.timer );
				}
				i++;
			}
			
			return false;
		}
	
		for( Enemy e : enemies ){
			if( target == null ){
				target = e;
				continue;
			}

			if( location.dist( new PVector( e.x, e.y ) ) < location.dist( new PVector( target.x, target.y ) ) ){
				target = e;
			}
		}
		
		if( target == null ){
			return true;
		}
		
		return false;

	}
}

public class Red3Tower extends Tower{
	public Red3Tower( TowerType type, String n ){
		super( type, n, 2500, 25000, 1250, 300 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_RED_COLOR );
		fill( GAME_TOWER_RED_COLOR );
		
		DrawWalls( x, y );
		
		noFill();
		
		pushMatrix();
		translate( x, y );
		
		rectMode( CENTER );
		
		rect( 10, LEVEL_TILE_SIZE/2, 5, 5 );
		rect( LEVEL_TILE_SIZE - 10, LEVEL_TILE_SIZE/2, 5, 5 );
		
		rectMode( CORNER );
		
		popMatrix();
	}
	
	int reload = 0;
	ArrayList<Missile3> missiles = new ArrayList<Missile3>();
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		
		for( int i = 0; i < missiles.size(); ){
			if( missiles.get(i).Draw( enemies, int( getDamage() ) ) ){
				missiles.remove( i );
			} else {
				i++;
			}
		}
		
		if( reload > 0 ){
			reload--;
		} else {
			PVector location = TranslateGridToPixel( tile.x, tile.y );
			
			Enemy target = null;
			
			for( Enemy e : enemies ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
					continue;
				}
				if( target == null ){
					target = e;
					continue;
				}
				switch( targetingType ){
					case Hard:
						if( e.hp > target.hp ){
							target = e;
						}
						break;
					case Weak:
						if( e.hp < target.hp ){
							target = e;
						}
						break;
					case Close:			
						if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
							target = e;
						}
						break;
				}
			}
			
			if( target == null ){
				return;
			}
			
			missiles.add( new Missile3( new PVector( location.x + LEVEL_TILE_SIZE/2, location.y + LEVEL_TILE_SIZE/2 ), target ) );
			
			reload = 25;
		}
		
	}
}

public class Purple1Tower extends Tower{
	
	public Purple1Tower( TowerType type, String n ){
		super( type, n, 300, 2000, 150, 120 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_PURPLE_COLOR, 200 );
		noFill();
		strokeWeight( 1 );
		
		DrawWalls( x, y );
		
		pushMatrix();
		translate( x + LEVEL_TILE_SIZE/2, y + LEVEL_TILE_SIZE/2 );
		
		rectMode( CENTER );
		rect( 0, 0, 10, 10 );
		
		rectMode( CORNER );
		
		popMatrix();
		
		line( x, y, x + LEVEL_TILE_SIZE, y + LEVEL_TILE_SIZE );
		line( x + LEVEL_TILE_SIZE, y, x, y + LEVEL_TILE_SIZE );
		
	}
	
	private int targetTimer = 0;
	private int shootTimer = 0;
	private int reload = 0;
	private PVector targeted;
	private Enemy target = null;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		if( targetTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 100 );
			strokeWeight( 3 );
			
			line( location.x, location.y, target.x, target.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			targetTimer--;
			
			if( targetTimer == 0 ){
				shootTimer = 5;
				targeted = new PVector( target.x, target.y );
				target.TakeDamage( DamageType.Purple, getDamage(), new Condition( ConditionType.Burning, getDamage() / 10, 20 ) );
			}
			
			return;
		} 
		
		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > getRange() || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( shootTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 200 );
			strokeWeight( 3 );
			
			line( location.x, location.y, targeted.x, targeted.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			if( --shootTimer == 0 ){
				reload = 20;
			}
			
			return;
		}
		
		if( reload > 0 ){
			reload--;
		} else {
		
			if( target == null ){
				for( Enemy e : enemies ){

					if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
						continue;
					}
					if( target == null ){
						target = e;
						continue;
					}
					
					switch( targetingType ){
						case Hard:
							if( e.hp > target.hp ){
								target = e;
							}
							break;
						case Weak:
							if( e.hp < target.hp ){
								target = e;
							}
							break;
						case Close:			
							if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
								target = e;
							}
					}
				
				}
			}
			
			if( target == null ){
				return;
			}
			
			targetTimer = 20;
			
		}
	}
}

public class Purple2Tower extends Tower{
	public Purple2Tower( TowerType type, String n ){
		super( type, n, 900, 3000, 450, 120 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_PURPLE_COLOR, 200 );
		noFill();
		strokeWeight( 1 );
		
		DrawWalls( x, y );
		
		pushMatrix();
		translate( x + LEVEL_TILE_SIZE/2, y + LEVEL_TILE_SIZE/2 );
		
		rectMode( CENTER );
		rect( -6, 0, 10, 10 );
		rect( 6, 0, 10, 10 );
		
		rectMode( CORNER );
		
		popMatrix();
		
		line( x, y, x + LEVEL_TILE_SIZE, y + LEVEL_TILE_SIZE );
		line( x + LEVEL_TILE_SIZE, y, x, y + LEVEL_TILE_SIZE );
		
	}
	
	private int targetTimer = 0;
	private int shootTimer = 0;
	private int reload = 0;
	private PVector targeted;
	private Enemy target = null;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		if( targetTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 100 );
			strokeWeight( 4 );
			
			line( location.x, location.y, target.x, target.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			targetTimer--;
			
			if( targetTimer == 0 ){
				shootTimer = 5;
				targeted = new PVector( target.x, target.y );
				target.TakeDamage( DamageType.Purple, getDamage(), new Condition( ConditionType.Burning, getDamage() / 10, 20 ) );
			}
			
			return;
		} 
		
		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > getRange() || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( shootTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 200 );
			strokeWeight( 4 );
			
			line( location.x, location.y, targeted.x, targeted.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			if( --shootTimer == 0 ){
				reload = 20;
			}
			
			return;
		}
		
		if( reload > 0 ){
			reload--;
		} else {
		
			if( target == null ){
				for( Enemy e : enemies ){

					if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
						continue;
					}
					if( target == null ){
						target = e;
						continue;
					}
					
					switch( targetingType ){
						case Hard:
							if( e.hp > target.hp ){
								target = e;
							}
							break;
						case Weak:
							if( e.hp < target.hp ){
								target = e;
							}
							break;
						case Close:			
							if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
								target = e;
							}
					}
				
				}
			}
			
			if( target == null ){
				return;
			}
			
			targetTimer = 20;
			
		}
	}
}

public class Purple3Tower extends Tower{
	public Purple3Tower( TowerType type, String n ){
		super( type, n, 2800, 20000, 450, 130 );
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_PURPLE_COLOR, 200 );
		noFill();
		strokeWeight( 1 );
		
		DrawWalls( x, y );
		
		pushMatrix();
		translate( x + LEVEL_TILE_SIZE/2, y + LEVEL_TILE_SIZE/2 );
		
		rectMode( CENTER );
		rect( -6, -5, 10, 10 );
		rect( 6, -5, 10, 10 );
		
		rect( -6, 5, 10, 10 );
		rect( 6, 5, 10, 10 );
		
		rectMode( CORNER );
		
		popMatrix();
		
		line( x, y, x + LEVEL_TILE_SIZE, y + LEVEL_TILE_SIZE );
		line( x + LEVEL_TILE_SIZE, y, x, y + LEVEL_TILE_SIZE );
		
	}
	
	private int targetTimer = 0;
	private int shootTimer = 0;
	private int reload = 0;
	private PVector targeted;
	private Enemy target = null;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemies ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );
		
		if( targetTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 100 );
			strokeWeight( 5 );
			
			line( location.x, location.y, target.x, target.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			targetTimer--;
			
			if( targetTimer == 0 ){
				shootTimer = 5;
				targeted = new PVector( target.x, target.y );
				target.TakeDamage( DamageType.Purple, getDamage(), new Condition( ConditionType.Burning, getDamage() / 10, 20 ) );
			}
			
			return;
		} 
		
		if( target != null ){
			if( FindDistance( location, new PVector( target.x, target.y ) ) > getRange() || target.hp <= 0 ){
				target = null;
			}
		}
		
		if( shootTimer > 0 ){
			pushMatrix();
	
			translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
			
			stroke( GAME_TOWER_PURPLE_COLOR, 200 );
			strokeWeight( 5 );
			
			line( location.x, location.y, targeted.x, targeted.y );
			
			strokeWeight( 1 );
			
			popMatrix();
			
			if( --shootTimer == 0 ){
				reload = 20;
			}
			
			return;
		}
		
		if( reload > 0 ){
			reload--;
		} else {
		
			if( target == null ){
				for( Enemy e : enemies ){

					if( FindDistance( location, new PVector( e.x, e.y ) ) > getRange() ){
						continue;
					}
					if( target == null ){
						target = e;
						continue;
					}
					
					switch( targetingType ){
						case Hard:
							if( e.hp > target.hp ){
								target = e;
							}
							break;
						case Weak:
							if( e.hp < target.hp ){
								target = e;
							}
							break;
						case Close:			
							if( FindDistance( location, new PVector( e.x, e.y ) ) < FindDistance( location, new PVector( target.x, target.y ) ) ){
								target = e;
							}
					}
				
				}
			}
			
			if( target == null ){
				return;
			}
			
			targetTimer = 20;
			
		}
	}
}

public class Blue1Tower extends Tower{
	
	public Blue1Tower( TowerType type, String n ){
		super( type, n, 300, 1000, 150, 100 );
		
		targetingType = TargetingType.Fast; // Just a formality
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_BLUE_COLOR );
		fill( GAME_TOWER_BLUE_COLOR );
		
		DrawWalls( x, y );
		
		noFill();
		ellipseMode( CENTER );
		ellipse( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, GAME_TOWER_SIZE * 3/5, GAME_TOWER_SIZE * 3/5 );
	}
	
	ArrayList<Enemy> ranks = new ArrayList<Enemy>();
	int transTickdown = 0;
	int reload = 0;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemy ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );

		if( reload > 0 ){
			reload--;
			if( transTickdown > 0 ){
				for( int i = 0; i < ranks.size() && i < 4; i++ ){
					DrawBeam( location, new PVector( ranks.get(i).x, ranks.get(i).y ) );
				}
				transTickdown--;
				
				if( transTickdown == 0 ){
					ranks.clear();
				}
			}

		} else if( reload < 1 ){
			for( Enemy e : enemy ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) < getRange() ){
					InsertIntoRanks( e );
				}
			}
			
			if( !ranks.isEmpty() ){
				for( int i = 0; i < ranks.size() && i < 4; i++ ){
					DrawBeam( location, new PVector( ranks.get(i).x, ranks.get(i).y ) );
					ranks.get(i).TakeDamage( DamageType.Blue, getDamage(), new Condition( ConditionType.Slow, 60, 30 ) );
				}
				
				reload = 40;
				transTickdown = 10;
			}

		}
		

	}
	
	private void DrawBeam( PVector location, PVector target ){
		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_BLUE_COLOR, 180 - (( 8 - transTickdown ) * 40 ) );
		strokeWeight( 3 );
		
		line( location.x, location.y, target.x, target.y );
		
		strokeWeight( 1 );
		
		popMatrix();
	}
	
	private void InsertIntoRanks( Enemy e ){
		for( int i = 0; i < ranks.size(); i++ ){
			if( ranks.get(i).effectiveMoveSpeed < e.effectiveMoveSpeed ){
				ranks.add( i, e );
				return;
			}
		}
		ranks.add( e );
	}

}

public class Blue2Tower extends Tower{
	public Blue2Tower( TowerType type, String n ){
		super( type, n, 600, 2000, 250, 140 );
		
		targetingType = TargetingType.Fast; // Just a formality
	}
	
	public void DrawTower( int x, int y ){
		stroke( GAME_TOWER_BLUE_COLOR );
		fill( GAME_TOWER_BLUE_COLOR );
		
		DrawWalls( x, y );
		
		noFill();
		ellipseMode( CENTER );
		ellipse( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, GAME_TOWER_SIZE * 3/5, GAME_TOWER_SIZE * 3/5 );
		ellipse( x + GAME_TOWER_SIZE/2, y + GAME_TOWER_SIZE/2, GAME_TOWER_SIZE / 5, GAME_TOWER_SIZE / 5 );
	}
	
	ArrayList<Enemy> ranks = new ArrayList<Enemy>();
	int transTickdown = 0;
	int reload = 0;
	
	public void DrawTowerShoot( ArrayList<Enemy> enemy ){
		PVector location = TranslateGridToPixel( tile.x, tile.y );

		if( reload > 0 ){
			reload--;
			if( transTickdown > 0 ){
				for( int i = 0; i < ranks.size() && i < 2; i++ ){
					DrawBeam( location, new PVector( ranks.get(i).x, ranks.get(i).y ) );
				}
				transTickdown--;
				
				if( transTickdown == 0 ){
					ranks.clear();
				}
			}

		} else if( reload < 1 ){
			ranks.clear();
			for( Enemy e : enemy ){
				if( FindDistance( location, new PVector( e.x, e.y ) ) < getRange() ){
					InsertIntoRanks( e );
				}
			}
			
			if( !ranks.isEmpty() ){
				for( int i = 0; i < ranks.size() && i < 2; i++ ){
					DrawBeam( location, new PVector( ranks.get(i).x, ranks.get(i).y ) );
					ranks.get(i).TakeDamage( DamageType.Blue, getDamage(), new Condition( ConditionType.Slow, 60, 0 ) );
				}
				
				reload = 40;
				transTickdown = 10;
			}

		}
		

	}
	
	private void DrawBeam( PVector location, PVector target ){
		pushMatrix();
		
		translate( HALF_TILE_SIZE, HALF_TILE_SIZE );
		
		stroke( GAME_TOWER_BLUE_COLOR, 180 - (( 8 - transTickdown ) * 40 ) );
		strokeWeight( 3 );
		
		line( location.x, location.y, target.x, target.y );
		
		strokeWeight( 1 );
		
		popMatrix();
	}
	
	private void InsertIntoRanks( Enemy e ){
		for( int i = 0; i < ranks.size(); i++ ){
			if( ranks.get(i).effectiveMoveSpeed < e.effectiveMoveSpeed ){
				ranks.add( i, e );
				return;
			}
		}
		ranks.add( e );
	}
}