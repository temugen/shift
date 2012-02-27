package shiftLevelEditorGUI;

import shiftBoardPackage.*;

public class LevelEditorGuiModel {

	private LevelEditorGuiView view;
	private Board gameBoard;
	private int currentXcoord;
	private int currentYcoord;
	private int currentElement;
	private int currentColor;
	private int numSaves;
	
	
	public LevelEditorGuiModel(LevelEditorGuiView view){
		this.view = view;
		numSaves = 0;
		gameBoard = new Board(7);
	}
	
	
	public int getBoardSize() {
		return gameBoard.getSize();
	}


	public int getCurrentXcoord() {
		return currentXcoord;
	}


	public void setCurrentXcoord(int currentXcoord) {
		this.currentXcoord = currentXcoord;
	}


	public int getCurrentYcoord() {
		return currentYcoord;
	}


	public void setCurrentYcoord(int currentYcoord) {
		this.currentYcoord = currentYcoord;
	}


	public int getSelectedElement() {
		return currentElement;
	}


	public void setSelectedElement(int selectedElement) {
		this.currentElement = selectedElement;
	}


	public int getSelectedColor() {
		return currentColor;
	}


	public void setSelectedColor(int selectedColor) {
		this.currentColor = selectedColor;
	}
	
	
	public void newBoardSize() {
		gameBoard = new Board(view.getSpinVal());
		view.buildPuzzle(view.getSpinVal());
	}
	
	
	public void ChessModelAction(String source){
		String s1 = "Nothing here yet";
		String message = s1;
		String title = "HELP!";
		view.showPopUp(message, title);
	}
	

	public void setCoords(String s, int index) {
		String s1 = s.substring(0, index);
		String s2 = s.substring(index+1);
		int row = Integer.parseInt(s1);
		int col = Integer.parseInt(s2);
		currentXcoord = row;
		currentYcoord = col;
	}
	
	
	public void changeColor() {
		setSelectedColor(view.getSelectedColor());
		System.out.println(view.getSelectedColor());
	}
	
	
	public void drawCurrent() {
		
		if(currentElement == 1)
			gameBoard.setBlockAt(currentXcoord, currentYcoord, currentColor);
		else if(currentElement == 2)
			gameBoard.setGoalAt(currentXcoord, currentYcoord, currentColor);
		else
		{
			clearCell();
			gameBoard.setBlockAt(currentXcoord, currentYcoord, currentColor); 
		}
		
		view.drawElement(currentXcoord, currentYcoord, currentElement, currentColor);
	}
	
	
	public void clearCell() {
		gameBoard.setBlockAt(currentXcoord, currentYcoord, 0);
		gameBoard.setGoalAt(currentXcoord, currentYcoord, 0);
		view.clearElement(currentXcoord, currentYcoord);
	}
	
	
	public void saveCurrent() {
		gameBoard.saveBoard(numSaves);
		numSaves++;
	}
	
}
	
	
	
