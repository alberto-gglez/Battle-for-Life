package ;

import aze.display.TileLayer;
import openfl.display.Sprite;
import motion.Actuate;

class EnemyGroup extends Sprite {

	private var _enemies:Array<Enemy>;
	private var _layer:TileLayer;
	
	public function new(tl:TileLayer) {
		super();
		
		_enemies = new Array<Enemy>();
		_layer = tl;
		
	}
	
	public function create(n:Int):Void {
		if (_enemies.length == 0) {
			switch (n) {
				case 0: {
					var e = new Enemy(_layer, this, 100, 180, 10 + Std.random(40));
					e.init();
					_enemies.push(e);
					
					e = new Enemy(_layer, this, 100, 180, 60 + Std.random(40));
					_enemies.push(e);
					Actuate.timer(1).onComplete(e.init);
				}
			}
		}
	}
	
	public function remove(e:Enemy):Void {
		_enemies.remove(e);
		
		if (_enemies.length == 0)
			EnemyManager.getInstance().groupDeleted(this);
	}
	
	public function update(eTime:Int, bullets:Array<Bullet>):Void {
		for (enemy in _enemies)
			enemy.update(eTime, bullets);
	}
	
}
