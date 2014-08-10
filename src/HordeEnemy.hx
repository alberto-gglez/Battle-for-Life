package ;

import aze.display.TileLayer;
import aze.display.TileSprite;

class HordeEnemy extends Enemy {
	
	private var _sprite:TileSprite;
	private var _angle:Float;
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Float, yp:Float) {
		super(tl, group, points, xp, yp);
		
		_sprite = new TileSprite(_layer, "horde");
		_sprite.rotation = 180;
		_sprite.x = x + _sprite.width / 2; _sprite.y = y + _sprite.height / 2;
		_layer.addChild(_sprite);
		
		_health = 3;
		_speed = 0.15;
		_hspeed = -0.5;
		_vspeed = 0;// -1;
		_sprite.rotation = 180 * 0.0174;
		
		_hitbox.x = x + 6; _hitbox.y = y + 3;
		_hitbox.width = _sprite.width; _hitbox.height = _sprite.height;
		
		_angle = 90;
	}
	
	public function gotHit():Void {
		_health--;
		
		var ps = PlayState.getInstance();
		
		if (_health > 0) {
			ps._sndenemyhit.play();
			ps.damagedEffect(_sprite, 2, 0.1);
		} else {
			ps._enemiesKilled++;
			ps._hordeEnemiesKilled++;
			
			if (ps._hordeEnemiesKilled % 16 == 0)
				ps.createHeart(x, y);
			
			kill();
			ps._score += _points * PlayState.getInstance()._gameMode;
			ps._sndHordeKilled.play();
		}
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		
		for (bullet in b)
			if (collision(bullet)) {
				bullet.destroy();
				gotHit();
			}
		
		// todo: check this collision in Player.hx
		if (collision(PlayState.getInstance()._player))
			if (!PlayState.getInstance()._player._invul && PlayState.getInstance()._lifes > 0) {
				kill();
				PlayState.getInstance()._player.gotHit();
			}
		
		_angle += eTime / 1.5;
		
		if (_angle > 360)
			_angle = 0;
		
		_vspeed = Math.sin(_angle * 0.0174);
		
		x += _hspeed * _speed * eTime;
		y += _vspeed * _speed * eTime;
		
		_sprite.x = x + _sprite.width / 2;
		_sprite.y = y + _sprite.width / 2;
		
		_hitbox.x = x + 6; _hitbox.y = y + 3;
		
		if (x < -_sprite.width) {
			kill();
		}
	}
	
	public function kill():Void {
		_layer.removeChild(_sprite);
		_group.remove(this);
	}
	
}
