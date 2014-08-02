package ;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Assets;
import openfl.Lib;

/**
 * ...
 * @author Alberto García
 */

class Main extends Sprite {
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e:Event) {
		if (!inited) init();
		else {
			//
		}
	}
	
	function init() {
		if (inited) return;
		inited = true;

		//
		addChild(MainMenuState.getInstance());
		addChild(PlayState.getInstance());
		
		GameManager.getInstance().start();
	}

	/* SETUP */

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = openfl.display.StageScaleMode.EXACT_FIT;
		Lib.current.addChild(new Main());
	}
}
