package ;

import aze.display.TileClip;
import aze.display.TileLayer;
import openfl.geom.Rectangle;

class Bullet extends Entity {

	private var _clip:TileClip;
	private var _bullets:Array<Bullet>;
	private var _destroyed:Bool;
	
	public function new(tl:TileLayer, x:Int, y:Int, bullets:Array<Bullet>, hspeed:Float = 1, vspeed:Float = 0, speed:Float = 0.17) {
		super(tl);
		
		this.x = x; this.y = y;
		_vspeed = vspeed;
		_hspeed = hspeed;
		_speed = speed;
		
		_clip = new TileClip(_layer, "shoot", 10);
		_clip.x = x; _clip.y = y;
		_layer.addChild(_clip);
		
		_bullets = bullets;
		
		_hitbox = new Rectangle(x - _clip.width / 2, y - _clip.height / 2, _clip.width, _clip.height);
		
		_destroyed = false;
	}
	
	public function update(eTime:Int) : Void {
		x += eTime * _hspeed * _speed;
		y += eTime * _vspeed * _speed;
		
		_clip.x = x; _clip.y = y;
		
		if (x < -8 || x > 164 || y < -8 || y > 118) {
			destroy();
		}
		
		_hitbox.x = x;
		_hitbox.y = y;
	}
	
	public function destroy():Void {
		_bullets.remove(this);
		_layer.removeChild(_clip);
		_destroyed = true;
	}
	
}
