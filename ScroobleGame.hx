package scrooble ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.Lib;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;

class ScroobleGame extends Sprite {
	
	public  var NUM_COLUMNS = 7;
	public  var NUM_ROWS = 7;
	private static var NUM_LETTERS = 7;
	private static var squarespacer = 0;	
	private static var squareTypeImages = [ "images/SL.png", "images/DL.png", "images/TL.png", "images/DW.png", "images/TW.png" ];
	
	private var Background:Sprite;
	private var IntroSound:Sound;
	private var Logo:Bitmap;
	private var Sound3:Sound;
	private var Sound4:Sound;
	private var Sound5:Sound;
	private var SquareContainer:Sprite;
	private var Rack:Sprite;
	private var goButton:GoButton;
	private var cacheMouse:Point;
	private var needToCheckMatches:Bool;
	private var selectedTile:Tile;
	private var tiles:Array<Tile>;
	private var racktiles:Array <Tile>;
	private var oursquares:Array <Array <Int>>;
	private var bag:Bag;

	public var MainBoard:Board;
	public var players:Array<Player>;
	public var player1:Player;
	public var player2:Player;
	public var squarewidth = 49;
	public var squareheight = 52;
	public var Score:TextField;
	public var MessageArea:TextField;
	public var currentScale:Float;
	public var currentScore:Int;

	public function new () {
		
		super ();
		
		initialize ();
		construct ();	
		newGame ();		
	}
	
	private function initialize ():Void {
		
		currentScale = 1;
		currentScore = 0;
		
		//board = new Board ();
		racktiles = new Array <Tile> ();
		MainBoard = new Board ();
		bag = new Bag ();
		player1 = new Player();
		player2 = new Player();
		// 				Single:0 DL:1 TL:2 DW:3 TW:4
		oursquares = [[4,0,0,1,0,0,0,4,0,0,0,1,0,0,4],
					  [0,3,0,0,0,2,0,0,0,2,0,0,0,3,0],
					  [0,0,3,0,0,0,1,0,1,0,0,0,3,0,0],
					  [1,0,0,3,0,0,0,1,0,0,0,3,0,0,1],
					  [0,0,0,0,1,0,0,0,0,0,1,0,0,0,0],
					  [0,2,0,0,0,2,0,0,0,2,0,0,0,2,0],
					  [0,0,1,0,0,0,1,0,1,0,0,0,1,0,0],
					  [4,0,0,1,0,0,0,3,0,0,0,1,0,0,4],
					  [0,0,1,0,0,0,1,0,1,0,0,0,1,0,0],
					  [0,2,0,0,0,2,0,0,0,2,0,0,0,2,0],
					  [0,0,0,0,1,0,0,0,0,0,1,0,0,0,0],
					  [1,0,0,3,0,0,0,1,0,0,0,3,0,0,1],
					  [0,3,0,0,0,2,0,0,0,2,0,0,0,3,0],
					  [0,0,3,0,0,0,1,0,1,0,0,0,3,0,0],
					  [4,0,0,1,0,0,0,4,0,0,0,1,0,0,4]];
					  					   
		for (row in 0...NUM_ROWS) {
			
			MainBoard.squares[row] = new Array <GameSquare> ();
			
			for (column in 0...NUM_COLUMNS) {
				
				MainBoard.squares[row][column] = null;
				
			}
		}

		for (column in 0...NUM_LETTERS) {
			
			racktiles[column] = null;
			
		}
		
		Background = new Sprite ();
		Logo = new Bitmap (Assets.getBitmapData ("images/logo.png"));
		Score = new TextField ();
		MessageArea = new TextField ();
		SquareContainer = new Sprite ();
		Rack = new Sprite ();
		goButton = new GoButton();

	}

	
		
	private function construct ():Void {
		
		var contentWidth = (squarewidth + squarespacer) * NUM_COLUMNS;
		var contentHeight = (squareheight + squarespacer) * NUM_ROWS;

		Logo.smoothing = true;
		addChild (Logo);
		
		// Score (Textfield) setup
		var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 40, 0x000000);
		defaultFormat.align = TextFormatAlign.LEFT;		
		#if (js && !openfl_html5)
		defaultFormat.align = TextFormatAlign.LEFT;
		#end				
		Score.multiline = true;
		Score.wordWrap = true;
		Score.x = 10;
		Score.width = 450;
		Score.y = 620;
		Score.selectable = false;
		Score.defaultTextFormat = defaultFormat;		
		#if (!js || openfl_html5)
		// Score.filters = [ new BlurFilter (1.5, 1.5), new DropShadowFilter (1, 45, 0, 0.2, 5, 5) ];
		#else
		Score.y = 0;
		Score.x += 90;
		#end		
		//Score.embedFonts = true;
		Score.textColor = 0xFFEE88;
		addChild (Score);
		
		var mdefaultFormat = new TextFormat (font.fontName, 25, 0x000000);
		mdefaultFormat.align = TextFormatAlign.LEFT;		
		#if (js && !openfl_html5)
		mdefaultFormat.align = TextFormatAlign.LEFT;
		#end				
		MessageArea.multiline = true;
		MessageArea.wordWrap = true;
		MessageArea.x = 10;
		MessageArea.width = 450;
		MessageArea.y = 590;
		MessageArea.textColor = 0xFFEE88;
		MessageArea.selectable = false;
		MessageArea.defaultTextFormat = mdefaultFormat;		
		addChild (MessageArea);
		
		Background.y = 85;
		Background.graphics.beginFill (0xFFFFFF, 0.4);
		Background.graphics.drawRect (0, 0, contentWidth+27, contentHeight+27);

		// Background.graphics.drawRect (0, contentHeight+80, (squarewidth + squarespacer) * 7, (squareheight + squarespacer) );

		#if (!js || openfl_html5)
		Background.filters = [ new BlurFilter (10, 10) ];
		addChild (Background);
		#end
		
		SquareContainer.x = 14;
		SquareContainer.y = Background.y + 14;
		addChild (SquareContainer);
		
		goButton.x = 80;
		goButton.y = 620;
		
		IntroSound = Assets.getSound ("soundTheme");
		Sound3 = Assets.getSound ("sound3");
		Sound4 = Assets.getSound ("sound4");
		Sound5 = Assets.getSound ("sound5");
		
	}

	
	public function newGame ():Void {
		
		currentScore = 8;
		Score.text = "!"+currentScore+"!";
		bag.initialize();
		player1.initialize(1,"Rikets", true);
		player2.initialize(2,"Hannah", false);
		MessageArea.text = "Player "+player1.id+ " ("+player1.name+")";
		
		drawBoardSquares();		         // CANT THESE BE IN INITIALISERS IN THE CLASSES THEMSELVES?!
		givePlayersTiles(NUM_LETTERS);
		addStartingTilesToRack();		
		// IntroSound.play ();
	}

	function givePlayersTiles(numLetters:Int) {
		
	}
			
	function drawBoardSquares() {   
		for (row in 0...NUM_ROWS) {	
			for (column in 0...NUM_COLUMNS) {
				addSquare (row, column, false);
			}
		}
	}
	
	function addStartingTilesToRack() {  
		for (letterPosition in 0...NUM_LETTERS) {
			var tile = bag.takeATile(); 			
			tile.initialize(this);	
			tile.column = letterPosition;
			// !!!!!!! how about setting tile.isOnRack and tile.isInBag now? create enum?? use this throughout on all tiles? 
			// or start with empty list of tiles belonging to board and rack, all starting in bag and migrating around? Hmmm
			racktiles[letterPosition] = tile;
			
			var position = getRackPosition (letterPosition);

				tile.x = position.x;
				tile.y = position.y;
				
			// RJP this was adding to racktilecontainer but had problems with droptarget over squares 
			SquareContainer.addChild (tile);			
			Score.text = Std.string (bag.availableTiles.length);
		}		
	}	

	private function addSquare (row:Int, column:Int, animate:Bool = true):Void {
		
		var squareType = oursquares[row][column];
				
		var square = new GameSquare (squareTypeImages[squareType]);
		
		square.initialize ();
		
		square.id = (NUM_COLUMNS * row) + column;
		// SL:0 DL:1 TL:2 DW:3 TW:4
		square.type = squareType;
		square.row = row;
		square.column = column;
		switch squareType {
			case 0: square.multipler_value = 1;
			case 1: square.multipler_value = 2;
			case 2: square.multipler_value = 3;
			case 3: square.multipler_value = 1;
			case 4: square.multipler_value = 1;
			default: square.multipler_value = 1;
		}
		switch squareType {
			case 0: square.wordMultipler_value = 1;
			case 1: square.wordMultipler_value = 1;
			case 2: square.wordMultipler_value = 1;
			case 3: square.wordMultipler_value = 2;
			case 4: square.wordMultipler_value = 3;
			default: square.wordMultipler_value = 1;
		}
		MainBoard.squares[row][column] = square;
		
		var position = getPosition (row, column);

		square.x = position.x;
		square.y = position.y;
		square.x_centre = position.x;
		square.y_centre = position.y;
		
		SquareContainer.addChild (square);
		// needToCheckMatches = true;
	}
	
	private function getPosition (row:Int, column:Int):Point {
		
		return new Point (column * (squarewidth + squarespacer), row * (squareheight + squarespacer));	
	}
	
	private function getRackPosition (column:Int):Point {
		// !!!!!!! y value needs to be right on the Rack, which itself needs a decent relative position / size like the board
		return new Point (column * (squarewidth + squarespacer), 8 * (squareheight + squarespacer));
	}
	
	public function resize (newWidth:Int, newHeight:Int):Void {
		
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;
		
		currentScale = 1;
		scaleX = 1;
		scaleY = 1;
		
		#if (js || !openfl_html5)
		
		var currentWidth = 75 * NUM_COLUMNS;
		var currentHeight = 75 * NUM_ROWS + 85;
		
		#else
		
		var currentWidth = width;
		var currentHeight = height;
		
		#end
		
		if (currentWidth > maxWidth || currentHeight > maxHeight) {
			
			var maxScaleX = maxWidth / currentWidth;
			var maxScaleY = maxHeight / currentHeight;
			
			if (maxScaleX < maxScaleY) {
				
				currentScale = maxScaleX;
				
			} else {
				
				currentScale = maxScaleY;
				
			}
			
			scaleX = currentScale;
			scaleY = currentScale;
			
		}
		
		x = newWidth / 2 - (currentWidth * currentScale) / 2;		
	}
	
}