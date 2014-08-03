package ;

import openfl.geom.Rectangle;
import aze.display.TileLayer;
import aze.display.TileClip;
import motion.Actuate;
import motion.easing.Quad;

class BigBullet extends EnemyBullet {
	
	public function new(tl:TileLayer, x:Int, y:Int) {
		super(tl, x, y);
		
		_layer.removeChild(_clip);
		_clip = new TileClip(_layer, "bigbullet", 10);
		_clip.x = x; _clip.y = y;
		_layer.addChild(_clip);
		
		_hitbox = new Rectangle(x - _clip.width / 2, y - _clip.height / 2, _clip.width, _clip.height);
		
		var xdest = PlayState.getInstance()._player.x;
		Actuate.tween(this, 1.5, { x: xdest } ).ease(Quad.easeInOut).onComplete(destroy);
	}
	
	public override function update(eTime:Int) : Void {
		//x += eTime * _hspeed * _speed;
		_clip.x = x;
		/*
		if (x < 0) {
			destroy();
		}
		*/
		_hitbox.x = x;
	}
	
	public override function destroy():Void {
		PlayState.getInstance()._enemyBullets.remove(this);
		_layer.removeChild(_clip);
	}
	
}