package ;

import aze.display.TileClip;
import aze.display.TileLayer;

class Heart extends Entity {
	
	private var _clip:TileClip;
	private var _container:Array<Heart>;
	
	public function new(tl:TileLayer, c:Array<Heart>, xp:Float, yp:Float) {
		super(tl);
		
		x = xp; y = yp;
		_container = c;
		
		_speed = 0.08;
		_hspeed = 1 - Std.random(2) * 2;
		_vspeed = 1 - Std.random(2) * 2;
		
		_clip = new TileClip(_layer, "fullheart");
		_layer.addChild(_clip);
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		
		_hitbox.x = x; _hitbox.y = y;
		_hitbox.width = _clip.width; _hitbox.height = _clip.height;
	}
	
	public function update(eTime:Int):Void {
		x += _speed * _hspeed * eTime;
		y += _speed * _vspeed * eTime;
		
		_hitbox.x = x; _hitbox.y = y;
		_clip.x = x + _clip.width / 2; _clip.y = y + _clip.height / 2;
		
		if (x < 0) {
			x = 0;
			_hspeed = 1;
		} else if (x >= 160 - _clip.width) {
			x = 160 - _clip.width;
			_hspeed = -1;
		}
		if (y < 0) {
			y = 0;
			_vspeed = 1;
		} else if (y > 114 - _clip.height) {
			y = 114 - _clip.height;
			_vspeed = -1;
		}
	}
	
	public function destroy():Void {
		_layer.removeChild(_clip);
		_container.remove(this);
	}
	
}
