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
		//game.Score.text = neighbourTiles[0][0] + "," + neighbourTiles[0][1] + "/"
		//				+ neighbourTiles[1][0] + "," + neighbourTiles[1][1] + "/"
		//				+ neighbourTiles[2][0] + "," + neighbourTiles[2][1] + "/"
		//				+ neighbourTiles[3][0] + "," + neighbourTiles[3][1];
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
		var nt = get_neighbourTiles();

		var xU = nt[0][0], yU = nt[0][1];
		var xD = nt[2][0], yD = nt[2][1];
		if (yU >= 0 && game.MainBoard.squares[xU][yU].current_tile_value > 0
		||  yD < game.NUM_ROWS && game.MainBoard.squares[xD][yD].current_tile_value > 0) {
			startVerticalTrackScore();
		}

		var xR = nt[1][0], yR = nt[1][1];
		var xL = nt[3][0], yL = nt[3][1];
		if (xL >= 0 && game.MainBoard.squares[xL][yL].current_tile_value > 0
		||  xR < game.NUM_COLUMNS && game.MainBoard.squares[xR][yR].current_tile_value > 0) {
			startHorizontalTrackScore();
		}
	}
	
	function startVerticalTrackScore(){
		game.Score.text = "vert";
	}
	
	function startHorizontalTrackScore(){
		game.Score.text = "horiz";
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
	
	private function snapToBoard(targetColumn, targetRow) {
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
		//h = game.squareheight;
		//var result = y%h > Math.floor(h/2) ? y+(h - y%h) : y-y%h;
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
		//w = game.squarewidth;
		//var result = x%w > Math.floor(w/2) ? x+(w - x%w) : x-x%w;
		game.Score.text = Std.string (columnResult);

		return columnResult;
	}
	
}