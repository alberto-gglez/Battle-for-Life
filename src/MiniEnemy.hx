package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import motion.Actuate;
import motion.easing.Cubic;

class MiniEnemy extends Enemy {
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int) {
		super(tl, group, points, xp, yp);
		
		for (clip in _vclips)
			clip.scale = 0.8;
			
		_hitbox.height = 9;
		_health = 22;
	}
	
	public override function update(eTime:Int, b:Array<Bullet>) : Void {
		
		for (bullet in b)
			if (collision(bullet)) {
				gotHit();
				bullet.destroy();
			}
		
		for (i in _vclips)
			i.visible = false;
			
		if (visible)
			_curClip.visible = true;
		
		_curClip.x = x; _curClip.y = y;
		if (_movingDown)
			_curClip.y -= 8;
		
		_hitbox.x = x - 10; _hitbox.y = y - 5;
	}
	
	public override function aimovement():Void {
		if (_health > 0) {
			var ytarget:Float;
			
			if (y < 57)
				ytarget = y + 30 + Std.random(30);
			else
				ytarget = y - 30 - Std.random(30);
				
			if (ytarget - _curClip.height / 2 < 5)
				ytarget = _curClip.height / 2 + 5;
			else if (ytarget + _curClip.height / 2 > 144 - 30)
				ytarget = 144 - _curClip.height / 2 - 30;
			
			Actuate.timer(0.2).onComplete(updateClip, [ytarget]);
			
			Actuate.tween(this, 1, { y: ytarget } ).ease(Cubic.easeInOut).onComplete(aistart);
		}
	}
	
	public override function aishoot():Void {
		if (_health > 0 && !PlayState.getInstance()._gameOver) {
			var xb = x - 10; var yb = y - 3;
			
			bigShoot(xb, yb);
			
			Actuate.timer(0.8).onComplete(aimovement);
		}
	}
	
	public function bigShoot(x:Float, y:Float) {
		var bullet = new BigBullet(_layer, Std.int(x - 8), Std.int(y), PlayState.getInstance()._enemyBullets);
		PlayState.getInstance()._enemyBullets.push(bullet);
	}
}
