package ;

import openfl.Lib;
import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;

class Entity extends Sprite {
	private var _layer:TileLayer;
	
	private var _vspeed:Float;
	private var _hspeed:Float;
	private var _speed:Float;
	private var _hitbox:Rectangle;
	
	private function new(tl:TileLayer) {
		super();
		
		_layer = tl;
		
		_hitbox = new Rectangle(0, 0, 0, 0);
	}
	
	public function hitbox():Rectangle {
		return _hitbox;
	}
	
	private function collision(e:Entity):Bool {
		return _hitbox.intersects(e.hitbox());
	}
	
	// Event management
	public function keyPressed	(event:KeyboardEvent) : Void { }
	public function keyReleased	(event:KeyboardEvent) : Void { }
	
	//public function update(eTime:Int, ?obj:Dynamic) : Void { }
	
}
