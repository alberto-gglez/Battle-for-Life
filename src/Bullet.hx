package ;

import aze.display.TileClip;
import aze.display.TileLayer;

class Bullet extends Entity {

	private var _clip:TileClip;
	private static var _bullets:Array<Bullet>;
	
	public function new(tl:TileLayer, x:Int, y:Int, bullets:Array<Bullet>) {
		super(tl);
		
		this.x = x; this.y = y;
		_vspeed = 0;
		_hspeed = 1;
		_speed = 0.17;
		
		_clip = new TileClip(_layer, "shoot", 10);
		_clip.x = x; _clip.y = y;
		_layer.addChild(_clip);
		
		_bullets = bullets;
	}
	
	public function update(eTime:Int) : Void {
		x += eTime * _hspeed * _speed;
		_clip.x = x;
		
		if (x > 170) {
			destroy();
		}
	}
	
	public function destroy():Void {
		_bullets.remove(this);
		_layer.removeChild(_clip);
	}
	
}
