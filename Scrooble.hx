package scrooble ;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.system.Capabilities;
import flash.Lib;
import openfl.Assets;


class Scrooble extends Sprite {
	
	
	private var Background:Bitmap;
	private var Footer:Bitmap;
	private var Rack:Bitmap;
	private var Game:ScroobleGame; 
	
	public function new () {
		
		super ();
		
		initialize ();
		construct ();
		
		resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	private function initialize ():Void {
		
		Background = new Bitmap (Assets.getBitmapData ("images/background_tile.png"));
		Footer = new Bitmap (Assets.getBitmapData ("images/center_bottom.png"));
		Rack = new Bitmap (Assets.getBitmapData ("images/rack.png"));
		Game = new ScroobleGame ();
		
	}

	
	private function construct ():Void {
		
		Rack.smoothing = true;
		
		addChild (Background);
		addChild (Rack);
		// addChild (Footer);
		addChild (Game);
		
	}

	
	private function resize (newWidth:Int, newHeight:Int):Void {
		
		Background.width = newWidth;
		Background.height = newHeight;
		
		Game.resize (newWidth, newHeight);
		
		Rack.scaleX = 1.3*Game.currentScale;
		Rack.scaleY = 1.3*Game.currentScale;
		Rack.x = newWidth / 2 + 22 - Rack.width / 2 - 86;
		Rack.y = newHeight - 80- Rack.height;
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}
