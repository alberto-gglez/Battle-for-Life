package ;

import motion.Actuate;
import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileSprite;
import openfl.geom.Rectangle;

enum BossStages {
	InitialStage;
	EndStage;
}

class Emitter extends Enemy {
	
	public var _clip:TileClip;
	private var _isSecond:Bool;
	private var _father:FirstBoss;
	private var _active:Bool;
	
	private var _nAttacks:Int;
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int, second:Bool, f:FirstBoss) {
		super(tl, group, points, xp, yp);
		
		_isSecond = second;
		_father = f;
		
		_active = false;
		
		_clip = new TileClip(_layer, "firstboss_emitter", 2);
		_layer.addChild(_clip);

		if (_isSecond)
			_clip.mirror = 2;
		
		x = xp; y = yp;
		
		_hitbox.width = 12; _hitbox.height = 20;
		_hitbox.x = x + _clip.width / 2;
		if (!_isSecond)
			_hitbox.y = y + 4;
		else
			_hitbox.y = y + 3;
			
		_health = 50;
	}
	
	public function init():Void {
		if (!_active) {
			_active = true;
			_nAttacks = 0;
			
			if (_isSecond)
				Actuate.timer(2.5).onComplete(attack);
			else 
				Actuate.timer(0.5).onComplete(attack);
		}
	}
	
	public function attack():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			
			var onlyOneLeft = false;
			
			if (_isSecond && _father._emitter1._active == false || !_isSecond && _father._emitter2._active == false)
				onlyOneLeft = true;
			
			if (onlyOneLeft) {
				var bullet = new BigBullet(_layer, x - 8, y + 12, PlayState.getInstance()._enemyBullets, PlayState.getInstance()._player.x, PlayState.getInstance()._player.y);
				PlayState.getInstance()._enemyBullets.push(bullet);
				
				
				Actuate.timer(2).onComplete(attack);
			} else {
				if (_nAttacks == 2) { // double attack
					_nAttacks = 0;
					
					if (_isSecond)
						secondAttack();
					else
						Actuate.timer(2).onComplete(secondAttack);
						
				} else {
					_nAttacks++;
					var bullet = new BigBullet(_layer, x - 8, y + 12, PlayState.getInstance()._enemyBullets, PlayState.getInstance()._player.x, y + 12);
					PlayState.getInstance()._enemyBullets.push(bullet);
					
					
					Actuate.timer(4).onComplete(attack);
				}
			}
		}
	}
	
	public function secondAttack():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			var bullet = new BigBullet(_layer, x - 8, y + 12, PlayState.getInstance()._enemyBullets, PlayState.getInstance()._player.x, y + 12);
			PlayState.getInstance()._enemyBullets.push(bullet);
			
			if (_isSecond)
				Actuate.timer(4).onComplete(attack);
			else 
				Actuate.timer(2).onComplete(attack);
		}
	}
	
	public function gotHit():Void {
		if (_active) {
			_health--;
			
			if (_health > 0) {
				PlayState.getInstance().damagedEffect(_clip, 2, 0.1);
				PlayState.getInstance()._sndenemyhit.play();
			} else {
				_layer.removeChild(_clip);
				_active = false;
				PlayState.getInstance()._sndexplosion.play();
			}
		}
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		
		_hitbox.x = x + _clip.width / 2;
		if (!_isSecond)
			_hitbox.y = y + 4;
		else
			_hitbox.y = y + 3;
		
		for (bullet in b)
			if (_active && collision(bullet)) {
				gotHit();
				bullet.destroy();
			}
	}
	
}

class Eye extends Enemy {
	
	public var _clip:TileClip;
	public var _pupil:TileSprite;
	public var _active:Bool;
	
	private var _father:FirstBoss;
	
	public function new(tl:TileLayer, group:EnemyGroup, f:FirstBoss) {
		super(tl, group, 0, 0, 0);
		
		x = 160; y = 43;
		
		_father = f;
		
		_active = false;
		
		_health = 100;
		
		_pupil = new TileSprite(_layer, "firstboss_pupil");
		_layer.addChild(_pupil);
		
		_pupil.x = x + 2 + _pupil.width / 2; _pupil.y = y + 7 + _pupil.height / 2;

		_clip = new TileClip(_layer, "firstboss_eye", 1);
		_layer.addChild(_clip);
		
		_clip.animated = false;
		_clip.loop = false;

		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;

		_hitbox.x = x + 8; _hitbox.y = y + 4;
		_hitbox.width = _clip.width; _hitbox.height = _clip.height - 4;
		
	}
	
	public function active():Void {
		if (!_active) {
			_active = true;
			Actuate.timer(2).onComplete(attack);
		}
	}
	
	public function attack():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			
			var player = PlayState.getInstance()._player;
			var angulo = Math.atan2(player.y - _pupil.y, player.x + 10 - _pupil.x);
			var hspeed = Math.cos(angulo);
			var vspeed = Math.sin(angulo);
			
			for (i in 0...10) {
				Actuate.timer(i * 0.1).onComplete(shoot, [hspeed, vspeed]);
			}
			
			Actuate.timer(1.5).onComplete(secondShoot);
			
			Actuate.timer(2.5).onComplete(attack);
		}
	}
	
	public function shoot(hspeed:Float, vspeed:Float):Void {
		if (_active) {
			PlayState.getInstance()._sndshoot2.play();
			var b = new Bullet(_layer, _pupil.x - 5, _pupil.y, PlayState.getInstance()._enemyBullets, hspeed, vspeed, 0.2);
			PlayState.getInstance()._enemyBullets.push(b);
		}
	}
	
	public function secondShoot():Void {
		if (_active && !PlayState.getInstance()._gameOver) {
			var b = new BigBullet(_layer, _pupil.x - 5, _pupil.y, PlayState.getInstance()._enemyBullets, PlayState.getInstance()._player.x, PlayState.getInstance()._player.y);
			PlayState.getInstance()._enemyBullets.push(b);
		}
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		_hitbox.x = x + 8; _hitbox.y = y + 4;
		
		_pupil.x = x + 2 + _pupil.width / 2; _pupil.y = y + 7 + _pupil.height / 2;
		
		for (bullet in b)
			if (collision(bullet)) {
				bullet.destroy();
				gotHit();
			}
		
		if (_active) {
			_pupil.y = y + _pupil.height / 2 + PlayState.getInstance()._player.y * 11 / 102;
		}
	}
	
	public function gotHit():Void {
		if (_active) {
			_health--;
		
			if (_health > 0) {
				PlayState.getInstance()._sndenemyhit.play();
				PlayState.getInstance().damagedEffect(_pupil, 2, 0.1);
			} else {
				_active = false;
				PlayState.getInstance()._sndexplosion.play();
				_layer.removeChild(_clip);
				_layer.removeChild(_pupil);
			}
		}
	}
	
	public function wakeUp():Void {
		Actuate.timer(1).onComplete(PlayState.getInstance()._sndEyeAwoken.play);
		_clip.animated = true;
		Actuate.timer(4).onComplete(Actuate.apply, [_clip, { animated: false } ]);
		Actuate.timer(4).onComplete(active);
	}
	
}

class FirstBoss extends Enemy {
	
	private var _sprite:TileSprite;
	
	public var _emitter1:Emitter;
	public var _emitter2:Emitter;
	private var _eye:Eye;
	private var _isDead:Bool;
	
	public var _stage:BossStages;
	
	public function new(tl:TileLayer, group:EnemyGroup) {
		super(tl, group, 5000, 161, 0);
		
		_sprite = new TileSprite(_layer, "firstboss_base");
		_layer.addChild(_sprite);
		
		_stage = InitialStage;
		_isDead = false;
		
		x = 161; y = 0;
		
		_hitbox.width = 27; _hitbox.height = 114;
		_hitbox.x = x + 16; _hitbox.y = 0;
		
		_sprite.x = x + _sprite.width / 2; _sprite.y = y + _sprite.height / 2;
		
		_emitter1 = new Emitter(_layer, group, 0, Std.int(x + 1), Std.int(y + 11), false, this);
		_emitter2 = new Emitter(_layer, group, 0, Std.int(x + 1), Std.int(y + 110), true, this);
		_eye = new Eye(_layer, group, this);
		
		init();
	}
	
	public function init():Void {
		Actuate.timer(1.5).onComplete(Actuate.tween, [this, 2, { x: 119 } ]);
		Actuate.timer(3.5).onComplete(_emitter1.init);
		Actuate.timer(3.5).onComplete(_emitter2.init);
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_sprite.x = x + _sprite.width / 2; _sprite.y = y + _sprite.height / 2;
		_hitbox.x = x + 18; _hitbox.y = 0;
		
		for (bullet in b)
			if (collision(bullet))
				bullet.destroy();
				
		if (_stage == InitialStage) {
			_emitter1.x = x + 1; _emitter1.y = y + 8;
			_emitter1.update(eTime, b);
			
			_emitter2.x = x + 1; _emitter2.y = y + 114 - _emitter2._clip.height - 8;
			_emitter2.update(eTime, b);
			
			if (_emitter1._health <= 0 && _emitter2._health <= 0) {
				_stage = EndStage;
				Actuate.timer(1).onComplete(_eye.wakeUp);
			}
		}
		
		_eye.x = x + 7; _eye.y = 43;
		_eye.update(eTime, b);
		
		if (!_isDead && _eye._health == 0) {
			_isDead = true;
			kill();
		}
	}
	
	public override function removeClips():Void {
		_layer.removeChild(_sprite);
		_layer.removeChild(_emitter1._clip);
		_layer.removeChild(_emitter2._clip);
		_layer.removeChild(_eye._clip);
		_layer.removeChild(_eye._pupil);
	}
	
	public function kill():Void {
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
		
		Actuate.timer(2.15).onComplete(removeClips);
		Actuate.timer(2.15).onComplete(_group.remove, [this]);
		Actuate.timer(2.15).onComplete(PlayState.getInstance().createHeart, [x, 40]);
		Actuate.timer(2.15).onComplete(PlayState.getInstance().createHeart, [x, 60]);
	}
	
}
