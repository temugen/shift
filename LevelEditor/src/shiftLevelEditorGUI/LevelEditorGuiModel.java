package shiftLevelEditorGUI;

import shiftBoardPackage.*;

public class LevelEditorGuiModel {

	private LevelEditorGuiView view;
	private Board gameBoard;
	private int boardSize;
	private int currentXcoord;
	private int currentYcoord;
	private int selectedElement;
	private int selectedColor;
	
	
	public LevelEditorGuiModel(LevelEditorGuiView view){
		this.view = view;
		boardSize = 7;
		currentXcoord = 0;
		currentYcoord = 0;
		selectedElement = 0;
		selectedColor = 0;
	}
	
	
	public int getBoardSize() {
		return boardSize;
	}


	public void setBoardSize(int boardSize) {
		this.boardSize = boardSize;
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
		return selectedElement;
	}


	public void setSelectedElement(int selectedElement) {
		this.selectedElement = selectedElement;
	}


	public int getSelectedColor() {
		return selectedColor;
	}


	public void setSelectedColor(int selectedColor) {
		this.selectedColor = selectedColor;
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
		
	}
	
	
	public void clearCell() {
		gameBoard.setBlockAt(currentXcoord, currentYcoord, 0);
		gameBoard.setGoalAt(currentXcoord, currentYcoord, 0);
		gameBoard.setSpecialAt(currentXcoord, currentYcoord, 0);
		
	}
	
	
	public void saveCurrent() {
		gameBoard.saveBoard();
	}
	
}
	
	
	
