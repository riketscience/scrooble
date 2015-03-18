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
	
	
	private static var NUM_COLUMNS = 8;
	private static var NUM_ROWS = 8;
	private static var NUM_LETTERS = 7;
	private static var squarewidth = 49;
	private static var squareheight = 52;
	private static var squarespacer = 0;
	
	private static var squareImages = [ "images/S.png", "images/DL.png", "images/TL.png", "images/DW.png", "images/TW.png" ];
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
	private var squares:Array <Array <GameSquare>>;
	private var usedSquares:Array <Tile>;
	private var MainBoard:Board;
	private var oursquares:Array <Array <Int>>;
	
	
	
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
		usedSquares = new Array <Tile> ();
		MainBoard = new Board ();
		
		oursquares = new Array<Array<Int>> (); 
		// S:0 DL:1 TL:2 DW:3 TW:4
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
		RackTileContainer = new Sprite ();
		SquareContainer = new Sprite ();
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
		RackTileContainer.y = Background.y + 440;
		BoardTileContainer.addEventListener (MouseEvent.MOUSE_DOWN, BoardTileContainer_onMouseDown);
		RackTileContainer.addEventListener (MouseEvent.MOUSE_DOWN, RackTileContainer_onMouseDown);
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
		
		currentScore = 0;
		Score.text = "0";
		
		for (row in 0...NUM_ROWS) {
			
			for (column in 0...NUM_COLUMNS) {
				//removeSquare (row, column, false);
				removeTile (row, column, false);
				
			}
			
		}
		
		for (row in 0...NUM_ROWS) {
			
			for (column in 0...NUM_COLUMNS) {
				addSquare (row, column, false);
			}
		}
	
		for (column in 0...NUM_LETTERS) {
			addRackTile (column);			
		}			
		
		// IntroSound.play ();
		
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
		
	private function addRackTile (column:Int):Void {
		var row = 1;
		var tile = null;
		var type = Math.round (Math.random () * (tileImages.length - 1));
				
		if (tile == null) {
			
			tile = new Tile (tileImages[type]);
			
		}
		
		tile.initialize ();
		
		tile.type = type;
		tile.column = column;
		
		racktiles[column] = tile;
		
		var position = getRackPosition (column);
		

			tile.x = position.x;
			tile.y = position.y;
			
		
		//RackTileContainer.addChild (tile);	
		
		
	}
	
	
	private function addSquare (row:Int, column:Int, animate:Bool = true):Void {
		
		var square = null;
		var type = getSquareType(row, column); // Math.round (Math.random () * (squareImages.length - 1));
				
		if (square == null) {
			
			square = new GameSquare (squareImages[type]);
			
		}
		
		square.initialize ();
		
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
			
		// }
		
		SquareContainer.addChild (square);
		// needToCheckMatches = true;
		
	}
	
	
	private function getSquareType (row:Int, col:Int):Int {
		
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
	
	
	private function findNewWords (byRow:Bool, accumulateScore:Bool = true):Array <Tile> {
		
		var matchedTiles = new Array <Tile> ();
		
		var max:Int;
		var secondMax:Int;
		
		if (byRow) {
			
			max = NUM_ROWS;
			secondMax = NUM_COLUMNS;
			
		} else {
			
			max = NUM_COLUMNS;
			secondMax = NUM_ROWS;
			
		}
		
		for (index in 0...max) {
			
			var matches = 0;
			var foundTiles = new Array <Tile> ();
			var previousType = -1;
			
			for (secondIndex in 0...secondMax) {
				
				var tile:Tile;
				
				if (byRow) {
					
					tile = boardtiles[index][secondIndex];
					
				} else {
					
					tile = boardtiles[secondIndex][index];
					
				}
				
				if (tile != null && !tile.moving) {
					
					if (previousType == -1) {
						
						previousType = tile.type;
						foundTiles.push (tile);
						continue;
						
					} else if (tile.type == previousType) {
						
						foundTiles.push (tile);
						matches++;
						
					}
					
				}
				
				if (tile == null || tile.moving || tile.type != previousType || secondIndex == secondMax - 1) {
					
					if (matches >= 2 && previousType != -1) {
						
						if (accumulateScore) {
							
							if (matches > 3) {
								
								Sound5.play ();
								
							} else if (matches > 2) {
								
								Sound4.play ();
								
							} else {
								
								Sound3.play ();
								
							}
							
							currentScore += Std.int (Math.pow (matches, 2) * 50);
							
						}
						
						matchedTiles = matchedTiles.concat (foundTiles);
						
					}
					
					matches = 0;
					foundTiles = new Array <Tile> ();
					
					if (tile == null || tile.moving) {
						
						needToCheckMatches = true;
						previousType = -1;
						
					} else {
						
						previousType = tile.type;
						foundTiles.push (tile);
						
					}
					
				}
				
			}
			
		}
		
		return matchedTiles;
		
	}
	
	
	private function getPosition (row:Int, column:Int):Point {
		
		return new Point (column * (squarewidth + squarespacer), row * (squareheight + squarespacer));
		
	}
	
	private function getRackPosition (column:Int):Point {
		// RJP y value needs to be relative
		return new Point (column * (squarewidth + squarespacer), 1 * (squareheight + squarespacer));
		
	}
	
	
	public function removeTile (row:Int, column:Int, animate:Bool = true):Void {
		
		var tile = boardtiles[row][column];
		
		if (tile != null) {
			
			tile.remove (animate);
			usedSquares.push (tile);
			
		}
		
		boardtiles[row][column] = null;
		
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
	
	
	private function swapTile (tile:Tile, targetRow:Int, targetColumn:Int):Void {
		
		if (targetColumn >= 0 && targetColumn < NUM_COLUMNS && targetRow >= 0 && targetRow < NUM_ROWS) {
			
			var targetTile = boardtiles[targetRow][targetColumn];
			
			if (targetTile != null && !targetTile.moving) {
				
				boardtiles[targetRow][targetColumn] = tile;
				boardtiles[tile.row][tile.column] = targetTile;
				
				if (findNewWords (true, false).length > 0 || findNewWords (false, false).length > 0) {
					
					targetTile.row = tile.row;
					targetTile.column = tile.column;
					tile.row = targetRow;
					tile.column = targetColumn;
					var targetTilePosition = getPosition (targetTile.row, targetTile.column);
					var tilePosition = getPosition (tile.row, tile.column);
					
					targetTile.moveTo (0.3, targetTilePosition.x, targetTilePosition.y);
					tile.moveTo (0.3, tilePosition.x, tilePosition.y);
					
					needToCheckMatches = true;
					
				} else {
					
					boardtiles[targetRow][targetColumn] = targetTile;
					boardtiles[tile.row][tile.column] = tile;
					
				}
				
			}
			
		}
		
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
				
				swapTile (selectedTile, swapToRow, swapToColumn);
				
			}
			
		}
		
		selectedTile = null;
		cacheMouse = null;
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		if (needToCheckMatches) {
			
			var matchedTiles = new Array <Tile> ();
			
			matchedTiles = matchedTiles.concat (findNewWords (true));
			matchedTiles = matchedTiles.concat (findNewWords (false));
			
			for (tile in matchedTiles) {
				
				removeTile (tile.row, tile.column);
				
			}
			
			if (matchedTiles.length > 0) {
				
				Score.text = Std.string (currentScore);
				updateBoard ();
				
			}
			
		}
		
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