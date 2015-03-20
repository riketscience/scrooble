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
	public var current_tile_value:Int;
	public var current_tile_letter:String;
	public var multipler_value:Int;
		// var CURRENT TILE!!!! need a dictionary, ["A":1,"B":4,"C":1.....]    ( int representation? ) 
		// CALM DOWN THATS ON THE BOARD OBJECT 
		// var MULTIPLIER
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
		current_tile_letter = "";
		current_tile_value = 0;  // "A" or 0?  (alphabet[0] = A)
		multipler_value = 1;
		
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