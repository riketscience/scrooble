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
	public var letter:Letter;
	public var mouseCache:Point;
	var game:ScroobleGame;
	var boardState:Board;
	
	public function new (imagePath:String) {
		
		super ();
		
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
	
	public function getCharacter() {
		return letter.character;
	}
	
	public function getValue() {
		return letter.value;
	}
	
	function mouseDownTile(event:MouseEvent):Void {
		mouseCache = new Point (event.stageX, event.stageY);
		this.startDrag();
	}
	
	function mouseUpTile(event:MouseEvent):Void {
		this.stopDrag();
		snapToTile(this.x, this.y);
	}
	
	private function snapToTile(x, y) {

		var targetColumn = getClosestBoardColumn(x);
		var targetRow = getClosestBoardRow(y);
		
		var canDrop = true; // canDropHere(targetColumn, targetRow); // ToDo: implement logic
		if (canDrop) {
			
			
			// var targetTile = squares[targetRow][targetColumn];
			//this.x = targetColumn;
			//this.y = targetRow;
			
			#if (!js || openfl_html5)
			this.alpha = 0.7;
			Actuate.tween (this, 0.1, { x:targetColumn, y:targetRow, alpha:1 } ).ease(Quad.easeOut);
			#end				
			
		} else {
			this.x = mouseCache.x;
			this.y = mouseCache.y;
		}
	}
	
	function canDropHere(x:Int, y:Int) {
		return true;
	}
	
	function getClosestBoardRow(y:Float) {
		var rowResult = 0;
		var h = game.squareheight;
		var nextTileLocation = h/2;
		while (y > nextTileLocation) {
			nextTileLocation += h;
			rowResult += 1;
		}
		//return rowResult;
		h = game.squareheight;
		var result = y%h > (h/2) ? y+(h - y%h) : y-y%h;
		game.Score.text = game.Score.text + ", " + Std.string (rowResult);

		return result;
	}
	
	function getClosestBoardColumn(x:Float) {
		var columnResult = 0;
		var w = game.squarewidth;
		var nextTileLocation = w/2;
		while (x > nextTileLocation) {
			nextTileLocation += w;
			columnResult += 1;
		}
		//return rowResult;
		w = game.squarewidth;
		var result = x%w > ((w-1)/2) ? x+(w - x%w) : x-x%w;
		game.Score.text = Std.string (columnResult);

		return result;
	}
	
}