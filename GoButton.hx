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

class GoButton extends Sprite {
	
	public var xpos:Int;
	public var ypos:Int;
	private var game:ScroobleGame;
	
	private static var goButtonImage = "images/button_GO.png";
	
	public function new () {
		
		super ();

		var image = new Bitmap (Assets.getBitmapData (goButtonImage));
		image.smoothing = true;
		addChild (image);
		this.x = 20;
		this.y = 20;
		mouseChildren = false;
		buttonMode = true;
	}

	public function initialize (sgame:ScroobleGame):Void {
		mouseEnabled = true;
		buttonMode = true;
		this.game = sgame;
		
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownGoButton);
		this.addEventListener(MouseEvent.MOUSE_UP, mouseUpGoButton);
		#if (!js || openfl_html5)
		scaleX = 1;
		scaleY = 1;
		alpha = 1;
		#end	
	}
	
	function mouseDownGoButton(event:MouseEvent):Void {
		game.Score.text = "PRESSED";
	}
	
	
	function mouseUpGoButton(event:MouseEvent):Void {
		// update players score
		this.stopDrag();
	}

	
}