package ;

import openfl.geom.Rectangle;
import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.events.KeyboardEvent;
import motion.Actuate;
import motion.easing.Cubic;

enum EnemyStates {
	playerleft;
	playerup;
	playerdown;
}

class BasicEnemy extends Enemy {
	
	private var _vclips:Array<TileClip>;
	private var _mapstate:Map<String, Int>;
	private var _curClip:TileClip;
	private var _movingUp:Bool;
	private var _movingDown:Bool;
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Float, yp:Float) {
		super(tl, group, points, xp, yp);
		
		_health = 12;
		
		_speed = 0.15;
		_movingUp = false;
		_movingDown = false;
		
		_vclips = new Array<TileClip>();
		_mapstate = new Map<String, Int>();
		
		
		var i:Int = 0;
		for (value in Type.getEnumConstructs(EnemyStates)) {
			var clip = new TileClip(_layer, value, 12);
			clip.mirror = 1;
			clip.x = x; clip.y = y;
			clip.visible = false;
			_layer.addChild(clip);
			
			_vclips.push(clip);
			_mapstate.set(value, i);
			i++;
		}
		
		_curClip = _vclips[_mapstate.get(Std.string(playerleft))];
		
		_curClip.visible = true;
		_hitbox = new Rectangle(x - 10, y - 7, 19, 11);
	}
	
	public function init():Void {
		Actuate.tween(this, 0.8, { x: x - 48 + Std.random(12) } ).delay(1.5).ease(Cubic.easeOut).onComplete(aistart);
	}
	
	public function gotHit():Void {
		_health--;
		
		if (_health > 0) {
			PlayState.getInstance().damagedEffect(this, 2, 0.1);
			PlayState.getInstance()._sndenemyhit.play();
		} else {
			kill();
			PlayState.getInstance()._enemiesKilled++;
			PlayState.getInstance()._sndexplosion.play();
			PlayState.getInstance()._score += _points * PlayState.getInstance()._gameMode;
			PlayState.getInstance()._bodyexplosions.push(new BodyExplosion(_layer, Std.int(x), Std.int(y), _curClip.scale));
		}
	}
	
	// Event management
	public override function update(eTime:Int, b:Array<Bullet>) : Void {
		
		for (bullet in b)
			if (collision(bullet)) {
				gotHit();
				bullet.destroy();
			}
		
		for (i in _vclips)
			i.visible = false;
			
		if (visible)
			_curClip.visible = true;
		
		_curClip.x = x; _curClip.y = y;
		if (_movingDown)
			_curClip.y -= 8;
		
		_hitbox.x = x - 10; _hitbox.y = y - 7;
	}
	
	public function aistart():Void {
		updateClip(y);
		Actuate.timer(0.5).onComplete(aishoot);
	}
	
	private function updateClip(ytarget:Float):Void {
		if (y < ytarget) {
			_movingDown = true;
			_movingUp = false;
			_curClip = _vclips[_mapstate.get(Std.string(playerdown))];
		} else if (y > ytarget) {
			_movingDown = false;
			_movingUp = true;
			_curClip = _vclips[_mapstate.get(Std.string(playerup))];
		} else {
			_movingDown = false;
			_movingUp = false;
			_curClip = _vclips[_mapstate.get(Std.string(playerleft))];
		}
	}
	
	public override function removeClips():Void {
		for (clip in _vclips)
			_layer.removeChild(clip);
	}
	
	public function kill():Void {
		removeClips();
		
		_group.remove(this);
	}
	
	public function shoot(x:Float, y:Float) {
		var bullet = new Bullet(_layer, Std.int(x), Std.int(y), PlayState.getInstance()._enemyBullets, -1);
		PlayState.getInstance()._enemyBullets.push(bullet);
	}
	
	public function aimovement():Void {
		if (_health > 0) {
			var ytarget = PlayState.getInstance()._player.y - 2;
			Actuate.timer(0.2).onComplete(updateClip, [ytarget]);
			
			Actuate.tween(this, 1, { y: ytarget } ).ease(Cubic.easeInOut).onComplete(aistart);
		}
	}
	
	public function aishoot():Void {
		if (_health > 0 && !PlayState.getInstance()._gameOver) {
			var xb = x - 12; var yb = y - 3;
			
			shoot(xb, yb);
			Actuate.timer(0.2).onComplete(shoot, [xb, yb]);
			Actuate.timer(0.4).onComplete(shoot, [xb, yb]);
			
			Actuate.timer(0.6).onComplete(aimovement);
		}
	}
	
}
