package ;

import aze.display.TileClip;
import aze.display.TileLayer;
import openfl.geom.Rectangle;

// Copia de Bullet debido a un problema al recorrer el vector.
class EnemyBullet extends Entity {

	private var _clip:TileClip;
	private static var _bullets:Array<EnemyBullet>;
	
	public function new(tl:TileLayer, x:Int, y:Int, bullets:Array<EnemyBullet>) {
		super(tl);
		
		this.x = x; this.y = y;
		_vspeed = 0;
		_hspeed = -1;
		_speed = 0.17;
		
		_clip = new TileClip(_layer, "shoot", 10);
		_clip.x = x; _clip.y = y;
		_layer.addChild(_clip);
		
		_bullets = bullets;
		
		_hitbox = new Rectangle(x - _clip.width / 2, y - _clip.height / 2, _clip.width, _clip.height);
	}
	
	public function update(eTime:Int) : Void {
		x += eTime * _hspeed * _speed;
		_clip.x = x;
		
		if (x < 0) {
			destroy();
		}
		
		_hitbox.x = x;
	}
	
	public function destroy():Void {
		_bullets.remove(this);
		_layer.removeChild(_clip);
	}
	
}