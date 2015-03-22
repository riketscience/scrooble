package scrooble ;
import flash.display.Bitmap;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import openfl.Assets;
import flash.events.MouseEvent;
import openfl.geom.Point;

class Tile extends Sprite {
	
	public var row:Int;
	public var column:Int;
	public var type:Int;
	public var letter:String;
	public var value:Int;
	
	var mouseCache:Point;
	var cache_originiatingSquareX:Int;
	var cache_originiatingSquareY:Int;	
	var isMoving:Bool;
	var game:ScroobleGame;
	var boardState:Board;
	
	public function new (imagePath:String, tile_letter:String, tile_value:Int) {
		
		super ();
		this.letter = tile_letter;
		this.value = tile_value;
		var image = new Bitmap (Assets.getBitmapData (imagePath));
		image.smoothing = true;
		addChild (image);
		
		mouseChildren = false;
		buttonMode = true;
		
		graphics.beginFill (0x000000, 0);
		graphics.drawRect ( -5, -5, 66, 66);
	}

	public function initialize (game:ScroobleGame):Void {
		mouseEnabled = true;
		buttonMode = true;
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownTile);
		this.addEventListener(MouseEvent.MOUSE_UP, mouseUpTile);
		this.game = game;
		this.boardState = game.MainBoard;
		
		#if (!js || openfl_html5)
		scaleX = 1;
		scaleY = 1;
		alpha = 1;
		#end	
	}
	
	function mouseDownTile(event:MouseEvent):Void {
		mouseCache = new Point (this.x, this.y); // (event.stageX, event.stageY);
		isMoving = true;
		cache_originiatingSquareX = getClosestBoardColumn(x);
		cache_originiatingSquareY = getClosestBoardRow(y);
		//var val = game.MainBoard.getSquareValue(getClosestBoardColumn(x), getClosestBoardRow(y));
		//game.Score.text = this.letter + "(" + this.value + ")";
		
		this.parent.setChildIndex(this, parent.numChildren - 1);
		
		this.startDrag();
	}
	
	function get_neighbourTiles() {
		var neighbourTiles = [];
		neighbourTiles.push([column, row - 1]);
		neighbourTiles.push([column + 1, row]);
		neighbourTiles.push([column, row + 1]);
		neighbourTiles.push([column - 1, row]);
		return neighbourTiles;
	}
	
	function mouseUpTile(event:MouseEvent):Void {
		
		if (this.isMoving) {
			this.stopDrag();
			
			var targetColumn = getClosestBoardColumn(x);
			var targetRow = getClosestBoardRow(y);
			var canDrop = canDropHere(targetColumn, targetRow); 
			if (canDrop) {	
				this.column = targetColumn;
				this.row = targetRow;
				snapToBoard(column, row);
				updateBoard(column, row);
				updateThisGoScore(); 
			} else {
				this.x = mouseCache.x;
				this.y = mouseCache.y;			
			}
			
			isMoving = false;
		}
	}
	
	function updateThisGoScore() {
		var thisGoScore = 0;
		game.Score.text = " ";
		var nt = get_neighbourTiles();

		var xU = nt[0][0], yU = nt[0][1];
		var xD = nt[2][0], yD = nt[2][1];
		if (yU >= 0 && game.MainBoard.squares[xU][yU].current_tile_value > 0
		||  yD < game.NUM_ROWS && game.MainBoard.squares[xD][yD].current_tile_value > 0) {
			thisGoScore += getVerticalTrackScore();
		}

		var xR = nt[1][0], yR = nt[1][1];
		var xL = nt[3][0], yL = nt[3][1];
		if (xL >= 0 && game.MainBoard.squares[xL][yL].current_tile_value > 0
		||  xR < game.NUM_COLUMNS && game.MainBoard.squares[xR][yR].current_tile_value > 0) {
			thisGoScore += getHorizontalTrackScore();
		}

	}
	
	function getVerticalTrackScore(){
		var vWordStartPos = this.row;
		var multiplier = 1;
		var vScore = 0;
		var vWord = "";
		var t = this.row - 1;
		while (t >= 0) {
			if (game.MainBoard.squares[this.column][t].current_tile_value != 0) {
				vWordStartPos--;
				t--;
			} else {
				t = -1;
			}
		}
		var vPos = vWordStartPos;
		var wordMultipler = 1;
		while (vPos < game.NUM_ROWS) {
			if (game.MainBoard.squares[this.column][vPos].current_tile_value != 0) {
				vWord += game.MainBoard.squares[this.column][vPos].current_tile_letter;
				vScore += (game.MainBoard.squares[this.column][vPos].current_tile_value * game.MainBoard.squares[this.column][vPos].multipler_value); 
				if (vPos == this.row) wordMultipler *= game.MainBoard.squares[this.column][vPos].wordMultipler_value;
				vPos++;
			} else {
				vPos = game.NUM_ROWS;
			}
		}
		vScore *= wordMultipler;
		game.Score.text += vWord +":"+ vScore + " ";
		return vScore;
	}
	
	function getHorizontalTrackScore(){
		var hWordStartPos = this.column;
		var multiplier = 1;
		var hScore = 0;
		var hWord = "";
		var t = this.column - 1;
		while (t >= 0) {
			if (game.MainBoard.squares[t][this.row].current_tile_value != 0) {
				hWordStartPos--;
				t--;
			} else {
				t = -1;
			}
		}
		var hPos = hWordStartPos;
		var wordMultipler = 1;
		while (hPos < game.NUM_COLUMNS) {
			if (game.MainBoard.squares[hPos][this.row].current_tile_value != 0) {
				hWord += game.MainBoard.squares[hPos][this.row].current_tile_letter;
				hScore += (game.MainBoard.squares[hPos][this.row].current_tile_value * game.MainBoard.squares[hPos][this.row].multipler_value); 
				//if (hPos == this.column) ... sort of thing for below. need to know if i put it down during my turn or not ie if to count multipliers or not
				   wordMultipler *= game.MainBoard.squares[hPos][this.row].wordMultipler_value;
				hPos++;
			} else {
				hPos = game.NUM_COLUMNS;
			}
		}
		hScore *= wordMultipler;
		game.Score.text += hWord +":" + hScore;
		return hScore;
	}
	
	function updateBoard(x, y) {
		game.MainBoard.squares[x][y].current_tile_letter = this.letter;
		game.MainBoard.squares[x][y].current_tile_value = this.value;
		// and reset originator square back to zero
		if (cache_originiatingSquareY<game.NUM_ROWS) { // !!! if = dirty fix for current lack of board v rack tile differentiation 
			game.MainBoard.setSquareValue(cache_originiatingSquareX,cache_originiatingSquareY,0,"");
		}
	}
	
	function stopMoving() {
		// isMoving = false;
	}
	
	private function snapToBoard(targetColumn, targetRow) {
		#if (!js || openfl_html5)
		this.alpha = 0.7;
		Actuate.tween (this, 0.1, { x:targetColumn*game.squarewidth, y:targetRow*game.squareheight, alpha:1 } ).ease(Quad.easeOut).onComplete(stopMoving);
		#end				
	}
	
	function canDropHere(x:Int, y:Int) {
		return game.MainBoard.getSquareValue(x, y) <= 0;
	}
	
	function getClosestBoardRow(y:Float):Int {
		var rowResult = 0;
		var h = game.squareheight;
		var nextTileLocation = h/2;
		while (y > nextTileLocation) {
			nextTileLocation += h;
			rowResult += 1;
		}
		return rowResult;
	}
	
	function getClosestBoardColumn(x:Float):Int {
		var columnResult = 0;
		var w = game.squarewidth;
		var nextTileLocation = w/2;
		while (x > nextTileLocation) {
			nextTileLocation += w;
			columnResult += 1;
		}
		return columnResult;
	}
	
}