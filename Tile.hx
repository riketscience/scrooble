package scrooble ;


import flash.display.Bitmap;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import openfl.Assets;
import flash.events.MouseEvent;


class Tile extends Sprite {
	
	public var row:Int;
	public var column:Int;
	public var moving:Bool;
	public var removed:Bool;
	public var type:Int;
	public var isInBag:Bool;
	public var isOnRack:Bool;
	public var isOnBoard:Bool;
	public var isPlaced:Bool;
	public var letter:Letter;
	
	
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

	public function initialize ():Void {
		
		moving = false;
		removed = false;
		
		mouseEnabled = true;
		buttonMode = true;
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseOnTile);
		this.addEventListener(MouseEvent.MOUSE_UP, mouseUpTile);
		
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
	
	
	
	function mouseOnTile(event:MouseEvent):Void {
		this.startDrag();
	}
	
	
	function mouseUpTile(event:MouseEvent):Void {
		this.stopDrag();
		snapToTile(this.x, this.y);
	}
	
	private function snapToTile(x, y) {
		
		var targetRow = getClosestBoardRow(y);
		var targetColumn = getClosestBoardColumn(x);
		
		//var targetTile = squares[targetRow][targetColumn];

		
		this.x = this.x+targetRow;
		this.y = this.y+targetColumn;
	}
	
	function getClosestBoardRow(y:Float) {
		
		return 5;
	}
	
	function getClosestBoardColumn(x:Float) {
		return 15;
	}
	
	public function moveTo (duration:Float, targetX:Float, targetY:Float):Void {
		
		moving = true;
		
		Actuate.tween (this, duration, { x: targetX, y: targetY } ).ease (Quad.easeOut).onComplete (this_onMoveToComplete);
		
	}
	
	
	public function remove (animate:Bool = true):Void {
		
		#if (js && !openfl_html5)
		animate = false;
		#end
		
		if (!removed) {
			
			if (animate) {
				
				mouseEnabled = false;
				buttonMode = false;
				
				parent.addChildAt (this, 0);
				Actuate.tween (this, 0.6, { alpha: 0, scaleX: 2, scaleY: 2, x: x - width / 2, y: y - height / 2 } ).onComplete (this_onRemoveComplete);
				
			} else {
				
				this_onRemoveComplete ();
				
			}
			
		}
		
		removed = true;
		
	}

	
	// Event Handlers
	
	private function this_onMoveToComplete ():Void {
		
		moving = false;
		
	}
	
	
	private function this_onRemoveComplete ():Void {
		
		parent.removeChild (this);
		
	}
	
	
}