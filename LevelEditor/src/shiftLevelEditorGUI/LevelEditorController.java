package shiftLevelEditorGUI;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class LevelEditorController implements ActionListener {
	
	private LevelEditorGuiModel model;
	
	public LevelEditorController(LevelEditorGuiModel model){
		this.model = model;
	}
	
	
	@Override
	public void actionPerformed(ActionEvent ae) {
		String com = ae.getActionCommand();
		System.out.println(com);
		if(com.equals("New Level Size"))
			model.newBoardSize();
		else if(com.indexOf(',') > 0)
			model.setCoords(com, com.indexOf(','));
		else if(com.equals("comboBoxChanged"))
			model.changeColor();
		else if(com.equals("Block"))
			model.setSelectedElement(1);
		else if(com.equals("Goal"))
			model.setSelectedElement(2);
		else if(com.equals("Special"))
			model.setSelectedElement(3);
		else if(com.equals("Draw Element"))
			model.drawCurrent();
		else if(com.equals("Clear Cell"))
			model.clearCell();
		else if(com.equals("Save Level"))
			model.saveCurrent();
	}


	
	
}
