enum ConditionType{
	Slow, Burning
}

public class Condition{
	
	public ConditionType type;
	public float remainingTime;
	public int effect; // Be really careful here. Will be DMG if condition is a damaging condition, and percentage if slow effect.
	
	public Condition( ConditionType type, float time, int effect ){
		this.type = type;
		remainingTime = time;
		this.effect = effect;
	}
	
}

enum MoveDirection{
	North, South, East, West
}

public abstract class Enemy{
	
	public int hp, maxHP = 700;
	public int moveSpeed = 90;
	
	public ArrayList<Tile> link;
	public int currentLink = 0;
	public float x, y;
	
	protected MoveDirection direction = MoveDirection.South;
	
	ArrayList<Condition> conditions = new ArrayList<Condition>();
	
	protected float effectiveMoveSpeed;
	protected int burningDamage;
	
	public boolean hasReachedEnd = false;
	public int reward = 5;
	
	public boolean Draw(){
		
		effectiveMoveSpeed = moveSpeed;
		
		// Go through conditions and check stuff
		for( int i = 0; i < conditions.size(); ){
			Condition cond = conditions.get( i );
			
			switch( cond.type ){
				case Slow:
					if( moveSpeed * cond.effect / 100 < effectiveMoveSpeed ){
						effectiveMoveSpeed = moveSpeed * cond.effect / 100;
					}
					break;
				case Burning:
					if( burningDamage < cond.effect ){
						burningDamage = cond.effect;
					}
					break;
			}
			
			cond.remainingTime--;
			if( cond.remainingTime <= 0 ){
				conditions.remove( i );
				continue;
			}
			
			i++;
		}
		
		hp -= burningDamage;
		
		if( hp <= 0 ){
			return true;
		}
		
		// Move sprite
		if( currentLink == link.size() - 1 ){
			// If we've reached the end of the link
			hasReachedEnd = true;
			return true;
		}
		
		
		float distX = ( link.get( currentLink + 1 ).x * LEVEL_TILE_SIZE + OFFSET_X ) - x;
		float distY = ( link.get( currentLink + 1 ).y * LEVEL_TILE_SIZE + OFFSET_Y ) - y;
		
		float moveFrameRate = effectiveMoveSpeed / FRAME_RATE;
		
		boolean xPass = false, yPass = false;
		
		if( abs(distX) <= moveFrameRate ){
			x = link.get( currentLink + 1 ).x * LEVEL_TILE_SIZE + OFFSET_X;
			xPass = true;
		} else {
			if( distX < 0 ){
				x -= moveFrameRate;
				direction = MoveDirection.West;
			} else {
				x += moveFrameRate;
				direction = MoveDirection.East;
			}
		}
		
		if( abs(distY) <= moveFrameRate ){
			y = link.get( currentLink + 1 ).y * LEVEL_TILE_SIZE + OFFSET_Y;
			yPass = true;
		} else {
			if( distY < 0 ){
				y -= moveFrameRate;
				direction = MoveDirection.North;
			} else {
				y += moveFrameRate;
				direction = MoveDirection.South;
			}
		}
		
		if( xPass && yPass ){
			currentLink++;
		}
		
		// Draw HP bar
		fill( #C92225, 170 );
		noStroke();
		
		rect( x + LEVEL_TILE_SIZE / 4, y, LEVEL_TILE_SIZE / 2, 5 );
		
		fill( #1FBA46 );
		rect( x + LEVEL_TILE_SIZE / 4, y, map( hp, 0, maxHP, 0, LEVEL_TILE_SIZE / 2 ), 5 );
		
		return false;
		
	}
	
	public abstract void DrawStatic( float x, float y );
	
	public void StartAt( ArrayList<Tile> link ){
		this.link = link;
		
		x = OFFSET_X + ( link.get( 0 ).x * LEVEL_TILE_SIZE );
		y = OFFSET_Y + ( link.get( 0 ).y * LEVEL_TILE_SIZE );
	}
	
	public void TakeDamage( DamageType type, float damage, Condition cond ){
		hp -= damage;
		
		if( cond != null ){
			conditions.add( cond );
		}
	}
	
}

// No Static method problem
public class EnemySpawner{
	
	public Enemy[] GenerateEnemyList( int wave ){
		
		Enemy[] enemies = new Enemy[20];
		
		/* for( int i = 0; i < enemies.length; i++ ){
			enemies[i] = new YellowSprinter();
			enemies[i].maxHP = int( enemies[i].maxHP * pow( GAME_WAVE_HEALTH_MULTIPLIER, wave ) );
			enemies[i].hp = enemies[i].maxHP;
		}
		return enemies; */
		
		if( wave != 0 && wave % 5 == 0 ){
			for( int i = 0; i < enemies.length; i++ ){
				enemies[i] = new HardGray();
			}
		} else {
			
			int rand = int( random( 5 ) );
			
			switch( rand ){
				case 0:
					for( int i = 0; i < enemies.length; i++ ){
						enemies[i] = new RedShredder();
					}
					break;
				case 1:
					for( int i = 0; i < enemies.length; i++ ){
						enemies[i] = new BlueSpinner();
					}
					break;
				case 2:
					for( int i = 0; i < enemies.length; i++ ){
						enemies[i] = new GreenFlyer();
					}
					break;
				case 3:
					for( int i = 0; i < enemies.length; i++ ){
						enemies[i] = new PurpleBox();
					}
					break;
				case 4:
					for( int i = 0; i < enemies.length; i++ ){
						enemies[i] = new YellowSprinter();
					}
					break;
			}
			
		}
		
		for( int i = 0; i < enemies.length; i++ ){
			enemies[i].maxHP = int( enemies[i].maxHP * pow( GAME_WAVE_HEALTH_MULTIPLIER, wave ) );
			enemies[i].hp = enemies[i].maxHP;
			enemies[i].reward += wave;
		}
		
		return enemies;
		
	}
	
}

public class RedShredder extends Enemy{
	
	float rotation = 0;
	float scale = 1;
	
	public RedShredder(){
		// super( link );
		
		maxHP += 50;
		moveSpeed -= 10;
	}
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
		
		DrawStatic( x, y );
		
		return false;
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x, y );
		
		// Draw sprite
		
		// Draw circle part
		noFill();
		stroke( #F20202 );
		
		ellipseMode( CENTER );
		ellipse( LEVEL_TILE_SIZE/2, LEVEL_TILE_SIZE/2, 6, 6 );
		
		pushMatrix();
		int halfTile = LEVEL_TILE_SIZE/2;
		
		translate( halfTile, halfTile );
		scale( constrain( randomGaussian() + 0.7, 0.8, 1.5 ) );
		
		rotation += random( 0, 40 );
		if( rotation > 360 ){
			rotation -= 360;
		}
		rotate( radians( rotation ) );
		
		// Draw spikes
		line( -3, 0, -10, 0);
		line( 3, 0, 10, 0 );
		line( 0, -3, 0, -10 );
		line( 0, 3, 0, 10 );
		
		rotate( PI / 4 );
		
		line( -3, 0, -6, 0);
		line( 3, 0, 6, 0 );
		line( 0, -3, 0, -6 );
		line( 0, 3, 0, 6 );
		
		popMatrix();
		popMatrix();
	}
	
	public void TakeDamage( DamageType type, int damage, Condition cond ){
		switch( type ){
			case Red:
				damage *= 1.5;
				break;
			case Green:
				damage /= 2;
				break;
		}
		hp -= damage;
		
		if( cond != null ){
			conditions.add( cond );
		}
	}
	
}

public class BlueSpinner extends Enemy{
	
	
	int rotation = 0;
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
	
		DrawStatic( x, y );
		
		return false;
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x + LEVEL_TILE_SIZE/2, y + LEVEL_TILE_SIZE/2 );
		rotation += 10;
		if( rotation > 360 ){
			rotation -= 360;
		}
		rotate( radians( rotation ) );
		
		noFill();
		stroke( #528FF2 );
		
		// Circle
		ellipseMode( CENTER );
		ellipse( 0, 0, 6, 6 );
		
		// Leaf
		for( int i = 0; i < 4; i++ ){
			bezier( 2.5, 1, 8, 6, 8, -6, 2.5, -1 );
			rotate( PI / 2 );
		}
		
		popMatrix();
	}
	
	public void TakeDamage( DamageType type, int damage, Condition cond ){
		switch( type ){
			case Blue:
				damage *= 1.5;
				break;
			case Purple:
				damage /= 2;
				break;
		}
		hp -= damage;
		
		if( cond != null ){
			conditions.add( cond );
		}
	}
	
	
}

public class GreenFlyer extends Enemy{
	
	public GreenFlyer(){
		// super( link );
		
		maxHP = 500;
		moveSpeed += 10;
	}
	
	float pattern = 0.0;
	float inc = TWO_PI / 20;
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
		
		DrawStatic( x, y );
		
		return false;
		
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x + HALF_TILE_SIZE, y + HALF_TILE_SIZE );
		
		switch( direction ){
			case North:
				rotate( PI * 3 / 2 );
				break;
			case South:
				rotate( PI / 2);
				break;
			case West:
				rotate( PI );
				break;
			case East:
				// Do Nothing
				break;
		}
		
		// Pattern Rotation
		scale( 1, 1 + sin( pattern )/6 );
		pattern += inc;
		
		if( pattern > TWO_PI ){
			pattern -= TWO_PI;
		}
		
		stroke( #44F442 );
		noFill();
		
		// Draw
		line( -10, 0, 10, 0 );
		triangle( -10, -5, -10, 5, -6, 0 );
		rect( -5, -8, 10, 16 );
		triangle( 5, -8, 5, 8, 10, 0 );
		
		popMatrix();
	}

	public void TakeDamage( DamageType type, int damage, Condition cond ){
		switch( type ){
			case Green:
				damage *= 1.5;
				break;
			case Red:
				damage /= 2;
				break;
		}
		hp -= damage;
		
		if( cond != null ){
			conditions.add( cond );
		}
	}
	
}

public class PurpleBox extends Enemy{
	
	public PurpleBox(){
		// super( link );
		
		maxHP += 100;
		moveSpeed -= 20;
	}
	
	float scale = 0.0;
	float inc = TWO_PI / 20;
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
		
		DrawStatic( x, y );
		
		return false;
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x + HALF_TILE_SIZE, y + HALF_TILE_SIZE );
		
		scale( 1 + sin( scale )/6 );
		scale += inc;
		
		if( scale > TWO_PI ){
			scale -= TWO_PI;
		}
		
		stroke( #9900e0 );
		noFill();
		
		quad( 0, -6, 6, 0, 0, 6, -6, 0 );
		
		popMatrix();
	}
	
	public void TakeDamage( DamageType type, int damage, Condition cond ){
		switch( type ){
			case Purple:
				damage *= 1.5;
				break;
			case Blue:
				damage /= 2;
				break;
		}
		hp -= damage;
		
		if( cond != null ){
			conditions.add( cond );
		}
	}
	
}

public class YellowSprinter extends Enemy{
	
	public YellowSprinter(){
		// super( link );
		
		maxHP -= 200;
		moveSpeed += 40;
	}
	
	float scale = 0.0;
	float inc = TWO_PI / 20;
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
		
		DrawStatic( x, y );
		
		return false;
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x + HALF_TILE_SIZE, y + HALF_TILE_SIZE );
		
		switch( direction ){
			case North:
				rotate( PI * 3 / 2 );
				break;
			case South:
				rotate( PI / 2);
				break;
			case West:
				rotate( PI );
				break;
			case East:
				// Do Nothing
				break;
		}
		
		scale( 1 + sin( scale )/4, 1 );
		scale += inc;
		
		if( scale > TWO_PI ){
			scale -= TWO_PI;
		}
		
		stroke( #efe80e );
		noFill();
		
		line( -7, 0, 7, 0 );
		
		line( -9, 10, -7, 0 );
		line( -9, -10, -7, 0 );
		line( -4, 10, -2, 0 );
		line( -4, -10, -2, 0 );
		line( 0, -10, 2, 0 );
		line( 0, 10, 2, 0 );
		line( 5, -10, 7, 0 );
		line( 5, 10, 7, 0 );
		
		popMatrix();
	}
}

public class HardGray extends Enemy{
	
	public HardGray(){
		// super( link );
		
		maxHP += 400;
		moveSpeed -= 30;
	}
	
	float scale = 0.0;
	float inc = TWO_PI / 20;
	
	public boolean Draw(){
		if( super.Draw() ){
			return true;
		}
		
		DrawStatic( x, y );
		
		return false;
	}
	
	public void DrawStatic( float x, float y ){
		pushMatrix();
		
		translate( x + HALF_TILE_SIZE, y + HALF_TILE_SIZE );
		
		scale( 1 + sin( scale + PI )/6, 1 + sin( scale )/6 );
		scale += inc;
		
		if( scale > TWO_PI ){
			scale -= TWO_PI;
		}
		
		stroke( #FFFFFF );
		noFill();
		
		quad( 0, -6, 6, 0, 0, 6, -6, 0 );
		
		popMatrix();
	}
	
}
