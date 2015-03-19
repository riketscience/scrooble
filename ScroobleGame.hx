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
	
	private static var NUM_COLUMNS = 7;
	private static var NUM_ROWS = 7;
	private static var NUM_LETTERS = 7;
	public var squarewidth = 49;
	public var squareheight = 52;
	private static var squarespacer = 0;
	
	private static var squareTypeImages = [ "images/SL.png", "images/DL.png", "images/TL.png", "images/DW.png", "images/TW.png" ];
	
	private var Background:Sprite;
	private var IntroSound:Sound;
	private var Logo:Bitmap;
	public var Score:TextField;
	private var Sound3:Sound;
	private var Sound4:Sound;
	private var Sound5:Sound;
	private var SquareContainer:Sprite;
	private var Rack:Sprite;
	public var currentScale:Float;
	public var currentScore:Int;
	private var cacheMouse:Point;
	private var needToCheckMatches:Bool;
	private var selectedTile:Tile;
	private var tiles:Array<Tile>;
	private var racktiles:Array <Tile>;
	public var MainBoard:Board;
	private var oursquares:Array <Array <Int>>;
	private var bag:Bag;
		
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
					  
		
		//boardPositions = new Array<Array<Float
					   
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
		SquareContainer = new Sprite ();
		Rack = new Sprite ();
	}

	
		
	private function construct ():Void {
		
		Logo.smoothing = true;
		addChild (Logo);
		
		var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 60, 0x000000);
		defaultFormat.align = TextFormatAlign.RIGHT;
		
		#if (js && !openfl_html5)
		defaultFormat.align = TextFormatAlign.LEFT;
		#end
		
		var contentWidth = (squarewidth + squarespacer) * NUM_COLUMNS;
		var contentHeight = (squareheight + squarespacer) * NUM_ROWS;
		
		Score.x = contentWidth - 200;
		Score.width = 550;
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
		
		Background.y = 85;
		Background.graphics.beginFill (0xFFFFFF, 0.4);
		Background.graphics.drawRect (0, 0, contentWidth+27, contentHeight+27);

		// RJP Background.graphics.drawRect (0, contentHeight+80, (squarewidth + squarespacer) * 7, (squareheight + squarespacer) );

		#if (!js || openfl_html5)
		Background.filters = [ new BlurFilter (10, 10) ];
		addChild (Background);
		#end
		
		SquareContainer.x = 14;
		SquareContainer.y = Background.y + 14;
		Rack.x = 14;
		Rack.y = Background.y + (NUM_ROWS* squareheight )+ 45;
		addChild (Rack);
		addChild (SquareContainer);
		
		IntroSound = Assets.getSound ("soundTheme");
		Sound3 = Assets.getSound ("sound3");
		Sound4 = Assets.getSound ("sound4");
		Sound5 = Assets.getSound ("sound5");
		
	}

	
	public function newGame ():Void {
		
		currentScore = 8;
		Score.text = "!"+currentScore+"!";
		bag.initialize();
		drawBoardSquares();		         // CANT THESE BE IN INITIALISERS IN THE CLASSES THEMSELVES?!
		addStartingTilesToRack();		
		// IntroSound.play ();
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
			moveATileFromBagToRack (letterPosition);			
		}		
	}

	private function moveATileFromBagToRack (column:Int):Void {
		var tile = bag.takeATile(); 		
		
		tile.initialize(this); // boardState! currently irrelevant random number
		
		tile.column = column;
		// !!!!!!! how about setting tile.isOnRack and tile.isInBag now? create enum?? use this throughout on all tiles? 
		// or start with empty list of tiles belonging to board and rack, all starting in bag and migrating around? Hmmm
		racktiles[column] = tile;
		
		var position = getRackPosition (column);

			tile.x = position.x;
			tile.y = position.y;
			
		// RJP this was adding to racktilecontainer but had problems with droptarget over squares 
		SquareContainer.addChild (tile);	
		
		Score.text = Std.string (bag.availableTiles.length);
		
	}
	

	private function addSquare (row:Int, column:Int, animate:Bool = true):Void {
		
		var type = oursquares[row][column];
				
		var square = new GameSquare (squareTypeImages[type]);
		
		square.initialize ();
		
		square.id = (NUM_COLUMNS * row) + column;
		square.type = type;
		square.row = row;
		square.column = column;
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