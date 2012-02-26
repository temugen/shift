package shiftLevelEditorGUI;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.util.ArrayList;
import java.util.List;

import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JSpinner;
import javax.swing.JSplitPane;
import javax.swing.SpinnerNumberModel;


public class LevelEditorGuiView {
	
	
	
	
	
	
	private LevelEditorGuiModel model;
	private LevelEditorController controller;
	private JPanel buttonPanel;
	private JPanel boardPanel;
	private ButtonGroup group;
	private JSpinner jSpin;
	private JComboBox colorList;
	private JSplitPane splitPane;
	private JFrame window;
	private List<Color> colorIndex;
	private List<ImageIcon> iconIndex;
	@SuppressWarnings("unused")
	private int numTabs;
	private List<JButton> currentButtons;

	
	public LevelEditorGuiView(){
		currentButtons = new ArrayList<JButton>();
		initializeIcons();
		initializeColors();
		numTabs = 0;
		model = new LevelEditorGuiModel(this);
		controller = new LevelEditorController(model);
        window = new JFrame("Shift Level Editor");
        window.setSize(750, 600);
        initializePanes(window);
        initializeRadio(buttonPanel);
        initializeComboBox(buttonPanel);
        initializeSpin(buttonPanel);
        initializeButtons(buttonPanel);
        buildPuzzle(7);
        setUpMenu(window);
        window.setVisible(true);
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
 
	
	private void initializePanes(JFrame window) {
		buttonPanel = new JPanel(new GridLayout(10,0));
		boardPanel = new JPanel(new GridLayout(7,7));
		splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT, buttonPanel, boardPanel);
		splitPane.setOneTouchExpandable(false);
		splitPane.setDividerLocation(150);
		splitPane.setPreferredSize(new Dimension(750,600));
		window.getContentPane().add(splitPane);
	}


	private void initializeRadio(JPanel myPanel){
		
		group = new ButtonGroup();
		addingRadioButtons("Block", myPanel);
		addingRadioButtons("Goal", myPanel);
		addingRadioButtons("Special", myPanel);
	}
	
	private void addingRadioButtons(String s, JPanel myPanel) {
		
		JRadioButton button = new JRadioButton(s);
		if(s.equals("Block"))
			button.setSelected(true);
		button.setActionCommand(s);
		group.add(button);
		button.addActionListener(controller);
		myPanel.add(button);
	}
	
	
	private void initializeComboBox(JPanel myPanel) {
		
		String[] colorStrings = {"None", "Blue", "Red", "Orange", "Green", "Purple", "Yellow", "Stationary", "Rotate"};
		colorList = new JComboBox(colorStrings);
		colorList.setSelectedIndex(0);
		colorList.addActionListener(controller);
		myPanel.add(colorList);
	}
	
	
    private void initializeButtons(JPanel myPanel) {
    	
    	addingSolveButtons("Draw Element", myPanel);
    	addingSolveButtons("Clear Cell", myPanel);
    	addingSolveButtons("Save Level", myPanel);
    	addingSolveButtons("New Level Size", myPanel);
    }

 
    
	private void addingSolveButtons(String s, JPanel myPanel) {
		JButton button = new JButton(s);
		button.setActionCommand(s);
		button.addActionListener(controller);
		myPanel.add(button);
	}
	
	private void initializeSpin(JPanel myPanel) {
		SpinnerNumberModel spin = new SpinnerNumberModel(7,2,7,1);
		jSpin = new JSpinner(spin);
		JLabel x = new JLabel("Set Level Size");
		myPanel.add(x);
		x.setLabelFor(jSpin);
		myPanel.add(jSpin);
	}

	
	private void initializeIcons() {
		iconIndex = new ArrayList<ImageIcon>();
		String dir = System.getProperty("user.dir");
		dir = dir + "/resources/block_";
		iconIndex.add(new ImageIcon(dir+"blank.png"));
		iconIndex.add(new ImageIcon(dir+"blue2.png"));
		iconIndex.add(new ImageIcon(dir+"red2.png"));
		iconIndex.add(new ImageIcon(dir+"orange2.png"));
		iconIndex.add(new ImageIcon(dir+"green2.png"));
		iconIndex.add(new ImageIcon(dir+"purple2.png"));
		iconIndex.add(new ImageIcon(dir+"yellow2.png"));
		iconIndex.add(new ImageIcon(dir+"stationary2.png"));
		iconIndex.add(new ImageIcon(dir+"rotate2.png"));
	}
	
	private void initializeColors() {
		colorIndex = new ArrayList<Color>();
		colorIndex.add(Color.BLACK);
		colorIndex.add(Color.BLUE);
		colorIndex.add(Color.RED);
		colorIndex.add(Color.ORANGE);
		colorIndex.add(Color.GREEN);
		colorIndex.add(Color.PINK);
		colorIndex.add(Color.YELLOW);
	}
	
	
	
	public int getSpinVal() {
		return (Integer) jSpin.getValue();
	}
	
	public int getSelectedColor() {
		return colorList.getSelectedIndex();
	}
	
	
	public void buildPuzzle(int x) {
		currentButtons = new ArrayList<JButton>(x);
		boardPanel.removeAll();
		boardPanel.setLayout(new GridLayout(x,x));
		String dir = System.getProperty("user.dir");
		dir = dir + "/resources/block_blank.png";
		ImageIcon blue = new ImageIcon(dir);
		for(int i=0;i<x;i++)
			for(int j=0;j<x;j++)
			{
				JButton b = new JButton(blue);
				b.setActionCommand(i+","+j);
				b.addActionListener(controller);
				b.setBackground(Color.BLACK);
				boardPanel.add(b);
				currentButtons.add(b);
			}
		currentButtons.get(0).setBackground(Color.GRAY);
        window.setVisible(true);
	}
	
	public void drawElement(int x, int y, int element, int color) {
		return;
	}
	
	
	

	
	
	public void clearElement(int x, int y) {
		int z = model.getBoardSize()*x + y;
		currentButtons.get(z).setBackground(Color.BLACK);
		currentButtons.get(z).setIcon(iconIndex.get(0));
	}
	
	
			
    private void setUpMenu(JFrame window) {
        JMenuBar menubar = new JMenuBar();
        JMenu file = new JMenu("File");
        JMenuItem open = new JMenuItem("Help");
        open.addActionListener(controller);
        file.add(open);
        menubar.add(file);
        window.setJMenuBar(menubar);
    }

	
    public void showPopUp(String message, String title) {
        JOptionPane.showMessageDialog(null,
                    message,
                    title, JOptionPane.INFORMATION_MESSAGE);
    }

}

