package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import motion.Actuate;
import motion.easing.Cubic;

class MiniEnemy extends Enemy {
	
	public function new(tl:TileLayer, pl:Player) {
		super(tl, pl);
		
		for (clip in _vclips)
			clip.scale = 0.8;
			
		_hitbox.height *= 0.8;
		_hitbox.width *= 0.8;
		_health = 8;
	}
}