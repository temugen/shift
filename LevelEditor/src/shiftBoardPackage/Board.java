package shiftBoardPackage;

import java.io.BufferedWriter;
import java.io.FileWriter;


/**
 * @author matthew
 */
public class Board {

	private static String header1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	private static String header2 = "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n";
	private static String pOpen = "<plist version=\"1.0\">\n";
	private static String pClose = "</plist>";
	private static String dOpen = "<dict>\n";
	private static String dClose = "</dict>\n";
	private static String kOpen = "<key>";
	private static String kClose = "</key>\n";
	private static String iOpen = "<integer>";
	private static String iClose = "</integer>\n";
	private static String aOpen = "<array>\n";
	private static String aClose = "</array>\n";
	private static String sOpen = "<string>";
	private static String sClose = "</string>\n";
	private static String t1 = "\t";
	private static String t2 = "\t\t";
	private static String t3 = "\t\t\t";
	private static String t4 = "\t\t\t\t";
	private static String[] coloring = {"None", "blue", "red", "orange", "green", "purple", "yellow", "stationary", "rotate", "wild"};
	private static String[] blocktype = {"BlockSprite", "GoalSprite", "StationaryBlock", "RotationBlock", "LockBlock", "KeyBlock", "WildcardBlock"};
	
	private int [][] blocks;
	private int [][] goals;
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


	public void saveBoard(int x) {
		
		try
		{
			FileWriter fstream = new FileWriter("newLevel" + x + ".plist");
			BufferedWriter out = new BufferedWriter(fstream);
			out.write(header1+header2+pOpen+dOpen+t1+kOpen+"board"+kClose);
			out.write(t1+dOpen+t2+kOpen+"columns"+kClose+t2);
			out.write(iOpen+getSize()+iClose+t2+kOpen+"rows"+kClose+t2);
			out.write(iOpen+getSize()+iClose+t2+kOpen+"cells"+kClose+t2+aOpen);
			for(int i=0;i<getSize();i++)
				for(int j=0;j<getSize();j++)
				{
					if(blocks[i][j] >= 7)
						generateList(out,i,j,blocks[i][j],blocks[i][j]-5);
					else
					{
						if(blocks[i][j] > 0)
							generateList(out,i,j,blocks[i][j],0);
						if(goals[i][j] > 0)
							generateList(out,i,j,goals[i][j],1);
					}
					
				}
			out.write(t2+aClose+t1+dClose+dClose+pClose);
			out.close();
		}
		catch (Exception e)
		{
			System.err.println("Error: " + e.getMessage());
		}
		
	}
	
	
	private void generateList(BufferedWriter out, int x, int y, int color, int type) {
		try
		{
			out.write(t3+dOpen);
			out.write(t4+kOpen+"class"+kClose);
			out.write(t4+sOpen+blocktype[type]+sClose);
			out.write(t4+kOpen+"name"+kClose);
			out.write(t4+sOpen+coloring[color]+sClose);
			out.write(t4+kOpen+"row"+kClose);
			out.write(t4+iOpen+x+iClose);
			out.write(t4+kOpen+"column"+kClose);
			out.write(t4+iOpen+y+iClose);
			out.write(t3+dClose);
		}
		catch (Exception e)
		{
			System.err.println("Error: " + e.getMessage());
		}
	}
	
	
	
	

}
