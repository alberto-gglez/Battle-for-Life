package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;

class Entity extends Sprite {
	private var _layer:TileLayer;
	
	private var _vspeed:Int;
	private var _hspeed:Int;
	private var _speed:Float;
	
	private function new(tl:TileLayer) {
		super();
		
		_layer = tl;
	}
	
	// Event management
	public function keyPressed	(event:KeyboardEvent) : Void { }
	public function keyReleased	(event:KeyboardEvent) : Void { }
	
	//public function update(eTime:Int, ?obj:Dynamic) : Void { }
	
}
