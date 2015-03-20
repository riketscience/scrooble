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
	// may or may NOT need these later
	// public var isInBag:Bool;
	// public var isOnRack:Bool;
	// public var isOnBoard:Bool;
	public var isPlaced:Bool;
	public var letter:String;
	public var value:Int;
	public var mouseCache:Point;
	public var cache_originiatingSquareX:Int;
	public var cache_originiatingSquareY:Int;
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
		game.Score.text = this.letter + "(" + this.value + ")";

		this.startDrag();
	}
	
	function mouseUpTile(event:MouseEvent):Void {
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		//   please only affect the piece you're dragging											  !!
		//   currently tiles load in left to right. so RH tiles pass OVER LH tiles and mouseup works  !!
		//   However, if you try to drop a LH tile onto a RH tile you see it shows UNDER the other    !!
		//   tile and all the logic fails 															  !!
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		if (this.isMoving) {
			this.stopDrag();
			
			var targetColumn = getClosestBoardColumn(x);
			var targetRow = getClosestBoardRow(y);
			var canDrop = canDropHere(targetColumn, targetRow); 
			if (canDrop) {	
				snapToTile(targetColumn, targetRow);
				updateBoard(targetColumn, targetRow);
			} else {
				this.x = mouseCache.x;
				this.y = mouseCache.y;			
			}
			
			isMoving = false;
		}
	}
	
	function updateBoard(x, y) {
		game.MainBoard.squares[x][y].current_tile_letter = this.letter;
		game.MainBoard.squares[x][y].current_tile_value = this.value;
		// and reset originator square back to zero
		game.MainBoard.setSquareValue(cache_originiatingSquareX,cache_originiatingSquareY,0,"");
	}
	
	function stopMoving() {
		// isMoving = false;
	}
	
	private function snapToTile(targetColumn, targetRow) {
		#if (!js || openfl_html5)
		this.alpha = 0.7;
		Actuate.tween (this, 0.1, { x:targetColumn*game.squarewidth, y:targetRow*game.squareheight, alpha:1 } ).ease(Quad.easeOut).onComplete(stopMoving);
		#end				
	}
	
	function canDropHere(x:Int, y:Int) {
		var sqval = game.MainBoard.getSquareValue(x, y);
		game.Score.text += " : " + sqval;
		return sqval > 0 ? false : true;
	}
	
	function getClosestBoardRow(y:Float):Int {
		var rowResult = 0;
		var h = game.squareheight;
		var nextTileLocation = h/2;
		while (y > nextTileLocation) {
			nextTileLocation += h;
			rowResult += 1;
		}
		//return rowResult;
		h = game.squareheight;
		var result = y%h > Math.floor(h/2) ? y+(h - y%h) : y-y%h;
		game.Score.text = game.Score.text + ", " + Std.string (rowResult);

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
		//return rowResult;
		w = game.squarewidth;
		var result = x%w > Math.floor(w/2) ? x+(w - x%w) : x-x%w;
		game.Score.text = Std.string (columnResult);

		return columnResult;
	}
	
}