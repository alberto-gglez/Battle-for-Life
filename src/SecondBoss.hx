package ;

import motion.Actuate;
import motion.easing.Cubic;
import motion.easing.Quad;
import motion.easing.Linear;
import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileSprite;

class SecondBoss extends Enemy {
	
	private var _sprite:TileSprite;
	private var _core:TileSprite;
	private var _angle:Float;
	private var _clipPj1:TileClip;
	private var _clipPj2:TileClip;

	private var _active:Bool;

	public function new(tl:TileLayer, group:EnemyGroup) {
		super(tl, group, 10000, 161, 0);

		_sprite = new TileSprite(_layer, "secondboss_base");
		_layer.addChild(_sprite);

		_core = new TileSprite(_layer, "secondboss_core");
		_layer.addChild(_core);
		_core.visible = false;
		_core.x = 108; _core.y = 57;

		_sprite.x = x + _sprite.width / 2;
		y = 57 - _sprite.height / 2;
		_sprite.y = y + _sprite.height / 2;

		_health = 50;

		_angle = 0;

		_hitbox.x = x + 12; _hitbox.y = y;
		_hitbox.width = _sprite.width; _hitbox.height = _sprite.height - 4;

		_active = false;

		_clipPj1 = new TileClip(_layer, "playersf");
		_clipPj1.visible = false;
		_clipPj1.fps = 4;
		_clipPj1.animated = false;
		_layer.addChild(_clipPj1);

		_clipPj2 = new TileClip(_layer, "playerfinal");
		_clipPj2.visible = false;
		_clipPj2.loop = false;
		_clipPj2.fps = 1;
		_clipPj2.animated = false;
		_layer.addChild(_clipPj2);

		init();
	}

	public function init():Void {
		PlayState.getInstance()._fightingFinalBoss = true;
		Actuate.tween(this, 6, { x: 160 - _sprite.width - 10 });
		Actuate.timer(3).onComplete(Actuate.apply, [this, { _active: true } ]);
		//Actuate.timer(6).onComplete(laser);
		Actuate.timer(3).onComplete(movement1);
	}

	public function movement1():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			Actuate.tween(this, 10, { y: 5 }).ease(Cubic.easeInOut);
			Actuate.timer(10).onComplete(movement2);
		}
	}

	public function movement2():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			Actuate.tween(this, 10, { y: 114 - _sprite.height - 5 }).ease(Cubic.easeInOut);
			Actuate.timer(10).onComplete(movement1);
		}
	}

	private function wholeScreen():Int {
		return 10 + Std.random(90);
	}

	public function laser():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			PlayState.getInstance()._laser = new Laser(_layer, wholeScreen());

			Actuate.timer(10).onComplete(laser);
		} else
			PlayState.getInstance()._laser = null;
	}

	public function gotHit():Void {
		_health--;

		if (_health > 0) {

			PlayState.getInstance()._sndenemyhit.play();
			PlayState.getInstance().damagedEffect(_sprite, 2, 0.1);

		} else {
			if (_active)
				kill();
		}
	}

	public function kill():Void {
		PlayState.getInstance()._musicChannel.stop();
		
		PlayState.getInstance()._laser = null;
		_active = false;
		PlayState.getInstance()._enemiesKilled++;
		PlayState.getInstance()._score += _points * PlayState.getInstance()._gameMode;
		PlayState.getInstance().damagedEffect(_sprite, 20, 0.1);
		
		Actuate.timer(0.3).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1.2).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1.3).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1.4).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1.5).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(1.6).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(2).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(2.05).onComplete(PlayState.getInstance()._sndexplosion.play);
		Actuate.timer(2.1).onComplete(PlayState.getInstance()._sndexplosion.play);
		
		Actuate.timer(2.15).onComplete(gameEnd);
	}

	public function gameEnd():Void {
		var player = PlayState.getInstance()._player;
		PlayState.getInstance().deleteBackground();
		_layer.removeChild(_sprite);
		_core.visible = true;
		player._invul = true;
		player._gameEnd = true;
		Actuate.timer(2).onComplete(endAnim1);
	}

	public function endAnim1():Void {
		var player = PlayState.getInstance()._player;
		Actuate.tween(player, 3, { y: _core.y + 3 }).ease(Quad.easeInOut);
		Actuate.tween(player, 6, { x: _core.x - 3 }).ease(Quad.easeInOut).delay(3);
		Actuate.timer(9.5).onComplete(setFinalClip);
		Actuate.timer(13).onComplete(setFinalPose);
		Actuate.timer(16).onComplete(_group.remove, [this]);
	}

	public function setFinalClip():Void {
		var pl = PlayState.getInstance()._player;
		_clipPj1.visible = true;
		_clipPj1.x = pl._curClip.x; _clipPj1.y = pl._curClip.y;
		_clipPj1.currentFrame = 0;
		_clipPj1.animated = true;
	}

	public function setFinalPose():Void {
		var pl = PlayState.getInstance()._player;
		_clipPj1.visible = false;
		_clipPj2.visible = true;
		_clipPj2.x = pl._curClip.x; _clipPj2.y = pl._curClip.y;
		_clipPj2.currentFrame = 0;
		_clipPj2.animated = true;
	}

	public override function update(eTime:Int, b:Array<Bullet>):Void {

		for (bullet in b)
			if (collision(bullet)) {
				gotHit();
				bullet.destroy();
			}

		_sprite.x = x + _sprite.width / 2;
		_sprite.y = y + _sprite.height / 2;

		_hitbox.x = x + 22; _hitbox.y = y + 4;

		if (_active) {
			_sprite.rotation += 0.1 * eTime / 1000;

			if (_sprite.rotation > 6.2831853)
				_sprite.rotation -= 6.2831853;
		}
	}

}
