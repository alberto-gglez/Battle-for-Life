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
	
	private function halfTop():Int {
		return 10 + Std.random(40);
	}
	
	private function halfBottom():Int {
		return 60 + Std.random(40);
	}
	
	private function wholeScreen():Int {
		return 10 + Std.random(90);
	}
	
	private function addNormalEnemy(ypos:Int):Void {
		var e = new Enemy(_layer, this, 100, 180, ypos);
		e.init();
		_enemies.push(e);
	}
	
	private function addMiniEnemy(ypos:Int):Void {
		var e = new MiniEnemy(_layer, this, 150, 180, ypos);
		e.init();
		_enemies.push(e);
	}
	
	public function create(n:Int):Void {
		switch (n) {
			case 0: {
				// 1 normal enemy
				addNormalEnemy(wholeScreen());
			}
			case 1: {
				// 2 normal enemies
				addNormalEnemy(halfBottom());
				Actuate.timer(1).onComplete(addNormalEnemy, [halfTop()]);
			}
			case 2: {
				// 1 minienemy
				addMiniEnemy(wholeScreen());
			}
			case 3: {
				// 1 normal enemy, 1 minienemy
				addMiniEnemy(halfTop());
				Actuate.timer(2).onComplete(addNormalEnemy, [halfBottom()]);
			}
			case 4: {
				// 2 normal enemies, 1 minienemy
				create(1);
				Actuate.timer(3.5).onComplete(create, [2]);
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
