package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import motion.easing.Cubic;

enum EnemyStates {
	playerstand;
	playerup;
	playerdown;
}

class Enemy extends Entity {
	
	private var _vclips:Array<TileClip>;
	private var _mapstate:Map<String, Int>;
	private var _curClip:TileClip;
	private var _movingDown:Bool;
	private var _player:Player;
	
	private var _health:Int;
	
	public function new(tl:TileLayer, pl:Player) {
		super(tl);
		
		_player = pl;
		
		x = 180;
		y = 20 + Std.random(80);
		
		_health = 5;
		
		_speed = 0.15;
		_movingDown = false;
		
		_vclips = new Array<TileClip>();
		_mapstate = new Map<String, Int>();
		
		var i:Int = 0;
		for (value in Type.getEnumConstructs(EnemyStates)) {
			var clip = new TileClip(_layer, value);
			clip.mirror = 1;
			clip.x = x; clip.y = y;
			clip.visible = false;
			_layer.addChild(clip);
			
			_vclips.push(clip);
			_mapstate.set(value, i);
			i++;
		}
		
		_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		_curClip.visible = true;
		
		Actuate.tween(this, 0.8, { x: x - 48 + Std.random(12) } ).delay(2).ease(Cubic.easeOut).onComplete(aistart);
	}
	
	// Event management
	public function update(eTime:Int) : Void {
		
		for (i in _vclips)
			i.visible = false;
			
		_curClip.visible = true;
		_curClip.x = x; _curClip.y = y;
		if (_movingDown)
			_curClip.y -= 8;

		_curClip.visible = true;
	}
	
	public function aistart():Void {
		updateClip(Std.string(playerstand));
		Actuate.timer(0.5).onComplete(shoot);
	}
	
	public function aimovement():Void {
		
		var ytarget = _player.y;
		if (y < ytarget) {
			Actuate.timer(0.2).onComplete(updateClip, [Std.string(playerdown)]);
		} else if (y > ytarget) {
			Actuate.timer(0.2).onComplete(updateClip, [Std.string(playerup)]);
		}
		
		Actuate.tween(this, 1, { y: ytarget } ).ease(Cubic.easeInOut).onComplete(aistart);
	}
	
	private function updateClip(clipName:String):Void {
		_curClip = _vclips[_mapstate.get(clipName)];
		
		if (clipName == "playerdown")
			_movingDown = true;
		else
			_movingDown = false;
	}
	
	public function shoot():Void {
		var xb = x - 12; var yb = y;
		
		PlayState.getInstance().enemyShoot(xb, yb);
		Actuate.timer(0.2).onComplete(PlayState.getInstance().enemyShoot, [xb, yb]);
		Actuate.timer(0.4).onComplete(PlayState.getInstance().enemyShoot, [xb, yb]);
		
		Actuate.timer(0.6).onComplete(aimovement);
	}
	
}
