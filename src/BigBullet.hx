package ;

import openfl.geom.Rectangle;
import aze.display.TileLayer;
import aze.display.TileClip;
import motion.Actuate;
import motion.easing.Quad;

class BigBullet extends Bullet {
	
	public function new(tl:TileLayer, x:Int, y:Int, bullets:Array<Bullet>) {
		super(tl, x, y, bullets, -1);
		
		_layer.removeChild(_clip);
		_clip = new TileClip(_layer, "bigbullet", 8);
		_clip.x = x; _clip.y = y;
		_layer.addChild(_clip);
		
		_hitbox = new Rectangle(x - _clip.width / 2, y - _clip.height / 2, _clip.width, _clip.height);
		
		var xdest = PlayState.getInstance()._player.x;
		Actuate.tween(this, 1.5, { x: xdest } ).ease(Quad.easeInOut).onComplete(destroy);
		
		PlayState.getInstance()._sndbigbullet.play();
	}
	
	public override function update(eTime:Int) : Void {
		_clip.x = x;
		_hitbox.x = x;
	}
	
	public override function destroy():Void {
		if (!_destroyed) {
			_bullets.remove(this);
			_layer.removeChild(_clip);
			createBullets();
			Actuate.timer(0.1).onComplete(createBullets);
			Actuate.timer(0.2).onComplete(createBullets);
			_destroyed = true;
		}
	}
	
	public function createBullets():Void {
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, -1, -1, 0.1));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, 0, -1, 0.15));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, 1, -1, 0.1));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, 1, 0, 0.15));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, 1, 1, 0.1));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, 0, 1, 0.15));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, -1, 1, 0.1));
		_bullets.push(new Bullet(_layer, Std.int(x), Std.int(y), _bullets, -1, 0, 0.15));
	}
	
}
