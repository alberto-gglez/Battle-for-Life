package ;

import motion.Actuate;
import aze.display.TileLayer;
import aze.display.TileClip;
import aze.display.TileSprite;

class Laser extends Entity {
	
	private var _clips:Array<TileClip>;
	private var _warning:TileSprite;
	public var _active:Bool;
	
	public function new(tl:TileLayer, yp:Float) {
		super(tl);
		
		y = yp;
				
		_clips = new Array<TileClip>();
		
		for (i in 0...16) {
			var tc = new TileClip(_layer, "laser", 70);
			tc.visible = false;
			tc.y = y + tc.height / 2;
			tc.x = i * tc.width + tc.width / 2;
			_clips.push(tc);
			_layer.addChild(tc);
		}
		
		_warning = new TileSprite(_layer, "warning");
		_warning.x = 140; _warning.y = yp;
		_layer.addChild(_warning);
		
		_active = false;
		
		Actuate.timer(2).onComplete(activate);
		PlayState.getInstance().damagedEffect(_warning, 8, 0.25);
		
		_hitbox.x = 0; _hitbox.y = y;
		_hitbox.width = 160; _hitbox.height = 24;
	}
	
	private function activate():Void {
		_layer.removeChild(_warning);
		
		_active = true;
		PlayState.getInstance()._sndLaser.play();
		
		for (c in _clips)
			c.visible = true;
		
		Actuate.timer(2).onComplete(destroy);
	}
	
	public function destroy():Void {
		for (i in 0..._clips.length) {
			_layer.removeChild(_clips.pop());
		}
		
		PlayState.getInstance()._laser = null;
	}
	
}
