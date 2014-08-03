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
		_health = 22;
	}
	
	public override function aishoot():Void {
		if (_health > 0 && !PlayState.getInstance()._gameOver) {
			var xb = x - 12; var yb = y - 3;
			
			shoot(xb, yb);
			Actuate.timer(0.2).onComplete(shoot, [xb, yb]);
			Actuate.timer(0.4).onComplete(shoot, [xb, yb]);
			Actuate.timer(0.6).onComplete(bigShoot, [xb, yb]);
			
			Actuate.timer(0.8).onComplete(aimovement);
		}
	}
	
	public override function shoot(x:Float, y:Float) {
		var bullet = new EnemyBullet(_layer, Std.int(x), Std.int(y));
		PlayState.getInstance()._enemyBullets.push(bullet);
	}
	
	public function bigShoot(x:Float, y:Float) {
		var bullet = new BigBullet(_layer, Std.int(x - 8), Std.int(y));
		PlayState.getInstance()._enemyBullets.push(bullet);
	}
}