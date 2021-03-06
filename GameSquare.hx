package scrooble ;


import flash.display.Bitmap;
import flash.display.Sprite;
import motion.Actuate;
import motion.actuators.GenericActuator;
import motion.easing.Linear;
import motion.easing.Quad;
import openfl.Assets;


class GameSquare extends Sprite {
	
	public var id:Int;
	public var row:Int;
	public var column:Int;
	public var x_centre:Float;
	public var y_centre:Float;
	public var type:Int;
	public var current_tile:Int;
		
	public function new (imagePath:String) {
		
		super ();
		
		var image = new Bitmap (Assets.getBitmapData (imagePath));
		image.smoothing = true;
		addChild (image);
		
		mouseChildren = false;
		buttonMode = false;
		
		graphics.beginFill (0x000000, 0);
		graphics.drawRect (-5, -5, 86, 66);
		
	}
	
	
	public function initialize ():Void {
			
		mouseEnabled = false;
		buttonMode = false;
		
		#if (!js || openfl_html5)
		scaleX = 1;
		scaleY = 1;
		alpha = 1;
		#end
		
	}
		
	public function get_coords()
	{
		return 0;
	}
	// Event Handlers
	
}