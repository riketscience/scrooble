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
	private static var squarewidth = 49;
	private static var squareheight = 52;
	private static var squarespacer = 0;
	
	private static var squareImages = [ "images/SL.png", "images/DL.png", "images/TL.png", "images/DW.png", "images/TW.png" ];
	private static var tileImages = [ "images/A.png", "images/B.png", "images/C.png", "images/D.png", "images/E.png", "images/F.png", "images/G.png" ];
	
	private var Background:Sprite;
	private var IntroSound:Sound;
	private var Logo:Bitmap;
	private var Score:TextField;
	private var Sound3:Sound;
	private var Sound4:Sound;
	private var Sound5:Sound;
	private var BoardTileContainer:Sprite;
	private var SquareContainer:Sprite;
	private var RackTileContainer:Sprite;
	public var currentScale:Float;
	public var currentScore:Int;
	private var cacheMouse:Point;
	private var needToCheckMatches:Bool;
	private var selectedTile:Tile;
	private var tiles:Array<Tile>;
	private var boardtiles:Array <Array <Tile>>;
	private var racktiles:Array <Tile>;
	private var MainBoard:Board;
	private var oursquares:Array <Array <Int>>;
	private var bag:Bag;
	
	public var squares:Array <Array <GameSquare>>;
	
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
		boardtiles = new Array <Array <Tile>> ();
		racktiles = new Array <Tile> ();
		squares = new Array <Array <GameSquare>> ();
		MainBoard = new Board ();
		bag = new Bag ();
		
		oursquares = new Array<Array<Int>> (); 
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
			
			squares[row] = new Array <GameSquare> ();
			boardtiles[row] = new Array <Tile> ();
			
			for (column in 0...NUM_COLUMNS) {
				
				squares[row][column] = null;
				boardtiles[row][column] = null;
				
			}
		}

		for (column in 0...NUM_LETTERS) {
			
			racktiles[column] = null;
			
		}

		
		Background = new Sprite ();
		Logo = new Bitmap (Assets.getBitmapData ("images/logo.png"));
		Score = new TextField ();
		BoardTileContainer = new Sprite ();
		SquareContainer = new Sprite ();
		RackTileContainer = new Sprite ();
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
		Score.width = 200;
		Score.y = 12;
		Score.selectable = false;
		Score.defaultTextFormat = defaultFormat;
		
		#if (!js || openfl_html5)
		Score.filters = [ new BlurFilter (1.5, 1.5), new DropShadowFilter (1, 45, 0, 0.2, 5, 5) ];
		#else
		Score.y = 0;
		Score.x += 90;
		#end
		
		Score.embedFonts = true;
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
		BoardTileContainer.x = 14;
		BoardTileContainer.y = Background.y + 14;
		RackTileContainer.x = 14;
		RackTileContainer.y = Background.y + (NUM_ROWS* squareheight )+ 45;
		//BoardTileContainer.addEventListener (MouseEvent.MOUSE_DOWN, BoardTileContainer_onMouseDown);
		//RackTileContainer.addEventListener (MouseEvent.MOUSE_DOWN, RackTileContainer_onMouseDown);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		addChild (BoardTileContainer);
		addChild (RackTileContainer);
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
		addStartingTilesToRack();		
		// IntroSound.play ();
	}
	
	function addStartingTilesToRack() {
			for (row in 0...NUM_ROWS) {
			
			for (column in 0...NUM_COLUMNS) {
				addSquare (row, column, false);
			}
		}
	
		for (column in 0...NUM_LETTERS) {
			addStartingTileToRack (column);			
		}		
	}

	private function addStartingTileToRack (column:Int):Void {
		var row = 1;
		var tile = null;
		var chosenTile = Math.round (Math.random () * (bag.availableTiles.length)); // 100 tiles in the game
		// ToDo: ultimately maintain list of available tiles
				
		if (tile == null) {
			tile = bag.tiles[chosenTile]; //  new Tile (tileImages[type]);		
		}
		
		tile.initialize ();
		
		//tile.type = chosenTile;
		tile.column = column;

		
		racktiles[column] = tile;
		
		var position = getRackPosition (column);

			tile.x = position.x;
			tile.y = position.y;
			
		// RJP this was adding to racktilecontainer but had problems with droptarget over squares 
		SquareContainer.addChild (tile);	
		
		Score.text = "hello"; // Std.string (bag.availableTiles.length);
		updateBoard ();
		
	}
	

	private function addSquare (row:Int, column:Int, animate:Bool = true):Void {
		
		var type = getBoardSquareType(row, column); // Math.round (Math.random () * (squareImages.length - 1));
				
		var square = new GameSquare (squareImages[type]);
		
		square.initialize ();
		
		square.id = (NUM_COLUMNS * row) + column;
		square.type = type;
		square.row = row;
		square.column = column;
		squares[row][column] = square;
		
		var position = getPosition (row, column);
	/*	
		if (1==2) { // (animate) {
			
			var firstPosition = getPosition (-1, column);
			
			#if (!js || openfl_html5)
			tile.alpha = 0;
			#end
			tile.x = firstPosition.x;
			tile.y = firstPosition.y;
			
			tile.moveTo (0.15 * (row + 1), position.x, position.y);
			#if (!js || openfl_html5)
			Actuate.tween (tile, 0.3, { alpha: 1 } ).delay (0.15 * (row - 2)).ease (Quad.easeOut);
			#end
			
		} else {
	*/		
			square.x = position.x;
			square.y = position.y;
			square.x_centre = position.x;
			square.y_centre = position.y;

			
		// }
		
		SquareContainer.addChild (square);
		// needToCheckMatches = true;
		
	}
	
	
	private function getBoardSquareType (row:Int, col:Int):Int {
		
			var type = Math.round (Math.random () * (squareImages.length - 1));
			type = oursquares[row][col];
		return type;
	}
	
	private function updateBoard ():Void {
		
		for (column in 0...NUM_COLUMNS) {
			
			var spaces = 0;
			
			for (row in 0...NUM_ROWS) {
				
				var index = (NUM_ROWS - 1) - row;
				var tile = boardtiles[index][column];
				
				if (tile == null) {
					
					spaces++;
					
				} else {
					
					if (spaces > 0) {
						
						var position = getPosition (index + spaces, column);
						tile.moveTo (0.15 * spaces, position.x,position.y);
						
						tile.row = index + spaces;
						boardtiles[index + spaces][column] = tile;
						boardtiles[index][column] = null;
						
						needToCheckMatches = true;
						
					}
					
				}
				
			}
			
			for (i in 0...spaces) {
				
				var row = (spaces - 1) - i;
				addSquare (row, column);
				
			}
			
		}
		
	}
	
	private function getPosition (row:Int, column:Int):Point {
		
		return new Point (column * (squarewidth + squarespacer), row * (squareheight + squarespacer));
		
	}
	
	private function getRackPosition (column:Int):Point {
		// RJP y value needs to be relative
		return new Point (column * (squarewidth + squarespacer), 1 * (squareheight + squarespacer));
		
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

	// Event Handlers
	private function stage_onMouseUp (event:MouseEvent):Void {
		
		if (cacheMouse != null && selectedTile != null && !selectedTile.moving) {
			
			var differenceX = event.stageX - cacheMouse.x;
			var differenceY = event.stageY - cacheMouse.y;
			
			if (Math.abs (differenceX) > 10 || Math.abs (differenceY) > 10) {
				
				var swapToRow = selectedTile.row;
				var swapToColumn = selectedTile.column;
				
				if (Math.abs (differenceX) > Math.abs (differenceY)) {
					
					if (differenceX < 0) {
						
						swapToColumn --;
						
					} else {
						
						swapToColumn ++;
						
					}
					
				} else {
					
					if (differenceY < 0) {
						
						swapToRow --;
						
					} else {
						
						swapToRow ++;
						
					}
					
				}
				
				// swapTile (selectedTile, swapToRow, swapToColumn);
				
			}
			
		}
		
		selectedTile = null;
		cacheMouse = null;
		
	}
	
	private function BoardTileContainer_onMouseDown (event:MouseEvent):Void {
		
		if (Std.is (event.target, Tile)) {
			// RJP Interesting Line Below !!!!!!!!!!!!!! tile selection...
			selectedTile = cast event.target;
			cacheMouse = new Point (event.stageX, event.stageY);
			
		} else {
			
			cacheMouse = null;
			selectedTile = null;
			
		}
		
	}
	
	private function RackTileContainer_onMouseDown (event:MouseEvent):Void {
		
		if (Std.is (event.target, Tile)) {
			// RJP Interesting Line Below !!!!!!!!!!!!!! tile selection...
			selectedTile = cast event.target;
			cacheMouse = new Point (event.stageX, event.stageY);
			
		} else {
			
			cacheMouse = null;
			selectedTile = null;
			
		}
		
	}
	
}