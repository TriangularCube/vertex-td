public class Level{
	
	public String name = "New Level";
	
	public boolean[][] terrain;
	
	public Level(){
		// DEBUG for now
		terrain = new boolean[ LEVEL_SIZE_X ][ LEVEL_SIZE_Y ];
	}
	
}