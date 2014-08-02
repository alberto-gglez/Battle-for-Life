package ;

import openfl.Lib;
import openfl.events.Event;
import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import aze.display.TileSprite;
import aze.display.TileClip;
import openfl.Assets;
import motion.Actuate;
import openfl.utils.Timer;
import openfl.events.KeyboardEvent;

class PlayState extends GameState {
	
	private static var _instance:PlayState;
	
	private var _layer:TileLayer;
	private var _enemiesKilled:Int;
	private var _player:Player;
	private var _enemies:Array<Enemy>;
	private var _prevTime:Int;
	
	
	private function new() {
		super();
		
		var tiletxt = Assets.getText("img/atlas.xml");
		var tilesheet:SparrowTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), tiletxt);
		_layer = new TileLayer(tilesheet);
		
		_player = new Player(_layer, 15, 50);
	}
	
	public static function getInstance():PlayState {
		if (_instance == null)
			_instance = new PlayState();
		
		return _instance;
	}
	
	// Event management
	public override function enter():Void {
		Actuate.timer(0.5).onComplete(addChild, [_layer.view]);
		_prevTime = Lib.getTimer();
	}
	
	public override function exit():Void {
		removeChild(_layer.view);
	}
	
	public override function frameStarted(event:Event):Void {
		var curTime = Lib.getTimer(); var eTime = curTime - _prevTime;
		_player.update(eTime);
		
		_prevTime = Lib.getTimer();
		_layer.render();
	}
	
	public override function keyPressed(event:KeyboardEvent):Void {
		_player.keyPressed(event);
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		_player.keyReleased(event);
	}
	
	/*
	public function pause	() : Void { }
	public function resume	() : Void { }
	
	
	public function frameEnded		(event:Event) : Void { }
	*/
	
}