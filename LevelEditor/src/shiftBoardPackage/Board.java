package shiftBoardPackage;


/**
 * @author matthew
 */
public class Board {

	private int [][] blocks;
	private int [][] goals;
	private int [][] special;
	private int size;
	
	/**
 	* @param integer n
 	* A constructor taking an integer argument to create a board of NxN dimensions.
 	*/
	public Board(int n)
	{
		size = n;
		blocks = new int[n][n];
		goals = new int[n][n];
		special = new int[n][n];
	}

	
	public int getSize()
	{
		return this.size;
	}
	
	
	public int getBlockAt(int x, int y) {
		return blocks[x][y];
	}


	public void setBlockAt(int x, int y, int z) {
		this.blocks[x][y] = z;
	}


	public int getGoalAt(int x, int y) {
		return goals[x][y];
	}


	public void setGoalAt(int x, int y, int z) {
		this.goals[x][y] = z;
	}


	public int getSpecial(int x, int y) {
		return special[x][y];
	}


	public void setSpecialAt(int x, int y, int z) {
		this.special[x][y] = z;
	}


	public void saveBoard() {
		
		
	}
	
	

}
