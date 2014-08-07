package ;

import motion.Actuate;
import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileSprite;
import openfl.geom.Rectangle;


class Emitter extends Enemy {
	
	public var _clip:TileClip;
	private var _isSecond:Bool;
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int, second:Bool = false) {
		super(tl, group, points, xp, yp);
		
		_isSecond = second;
		
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
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		
		_hitbox.x = x + _clip.width / 2;
		if (!_isSecond)
			_hitbox.y = y + 4;
		else
			_hitbox.y = y + 3;
		
		for (bullet in b)
			if (collision(bullet))
				bullet.destroy();
	}
	
}

class Eye extends Enemy {
	
	public var _clip:TileClip;
	public var _pupil:TileSprite;
	
	public function new(tl:TileLayer, group:EnemyGroup) {
		super(tl, group, 0, 0, 0);
		
		x = 160; y = 43;
		
		_pupil = new TileSprite(_layer, "firstboss_pupil");
		_layer.addChild(_pupil);
		
		_pupil.x = x + 2 + _pupil.width / 2; _pupil.y = y + 7 + _pupil.height / 2;

		_clip = new TileClip(_layer, "firstboss_eye", 3);
		_layer.addChild(_clip);

		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;

		_hitbox.x = x + 8; _hitbox.y = y + 4;
		_hitbox.width = _clip.width; _hitbox.height = _clip.height - 4;
		
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		_hitbox.x = x + 8; _hitbox.y = y + 4;
		
		_pupil.x = x + 2 + _pupil.width / 2; _pupil.y = y + 7 + _pupil.height / 2;
		
		for (bullet in b)
			if (collision(bullet))
				bullet.destroy();
	}
	
}

class FirstBoss extends Enemy {
	
	private var _sprite:TileSprite;
	
	private var _emitter1:Emitter;
	private var _emitter2:Emitter;
	private var _eye:Eye;
	
	public function new(tl:TileLayer, group:EnemyGroup) {
		super(tl, group, 5000, 161, 0);
		
		_sprite = new TileSprite(_layer, "firstboss_base");
		_layer.addChild(_sprite);
		
		x = 161; y = 0;
		
		_hitbox.width = 27; _hitbox.height = 114;
		_hitbox.x = x + 16; _hitbox.y = 0;
		
		_sprite.x = x + _sprite.width / 2; _sprite.y = y + _sprite.height / 2;
		
		_emitter1 = new Emitter(_layer, group, 0, Std.int(x + 1), Std.int(y + 11));
		_emitter2 = new Emitter(_layer, group, 0, Std.int(x + 1), Std.int(y + 110), true);
		_eye = new Eye(_layer, group);
		
		Actuate.timer(1.5).onComplete(Actuate.tween, [this, 1 /* 5 */, { x: 119 } ]);
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_sprite.x = x + _sprite.width / 2; _sprite.y = y + _sprite.height / 2;
		_hitbox.x = x + 16; _hitbox.y = 0;
		
		for (bullet in b)
			if (collision(bullet))
				bullet.destroy();
		
		_emitter1.x = x + 1; _emitter1.y = y + 11;
		_emitter1.update(eTime, b);
		
		_emitter2.x = x + 1; _emitter2.y = y + 114 - _emitter2._clip.height - 11;
		_emitter2.update(eTime, b);
		
		_eye.x = x + 7; _eye.y = 43;
		_eye.update(eTime, b);
	}
	
}