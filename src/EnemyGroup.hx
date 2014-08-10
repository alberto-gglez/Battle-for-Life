package ;

import aze.display.TileLayer;
import openfl.display.Sprite;
import motion.Actuate;

class EnemyGroup extends Sprite {

	private var _enemies:Array<Enemy>;
	private var _layer:TileLayer;
	
	public function new(tl:TileLayer) {
		super();
		
		_layer = tl;
		_enemies = new Array<Enemy>();
	}
	
	public function reset():Void {
		for (e in _enemies)
			e.removeClips();
			
		_enemies = new Array<Enemy>();
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
	
	private function addBasicEnemy(ypos:Float):Void {
		var e = new BasicEnemy(_layer, this, 100, 180, ypos);
		e.init();
		_enemies.push(e);
	}
	
	private function addMiniEnemy(ypos:Float):Void {
		var e = new MiniEnemy(_layer, this, 200, 180, ypos);
		e.init();
		_enemies.push(e);
	}
	
	private function addHorde(ypos:Float):Void {
		var e = new HordeEnemy(_layer, this, 25, 180, ypos);
		_enemies.push(e);
		
		Actuate.timer(0.15).onComplete(extraHorde, [ypos]);
		Actuate.timer(0.3).onComplete(extraHorde, [ypos]);
		Actuate.timer(0.45).onComplete(extraHorde, [ypos]);
	}
	
	private function extraHorde(ypos:Float):Void {
		var e = new HordeEnemy(_layer, this, 25, 180, ypos);
		_enemies.push(e);
	}
	
	public function create(n:Int):Void {
		switch (n) {
			case 0: {
				// 1 normal enemy
				addBasicEnemy(wholeScreen());
			}
			case 1: {
				// 2 normal enemies
				addBasicEnemy(halfBottom());
				Actuate.timer(1).onComplete(addBasicEnemy, [halfTop()]);
			}
			case 2: {
				// 1 minienemy
				addMiniEnemy(wholeScreen());
			}
			case 3: {
				// 1 normal enemy, 1 minienemy
				addMiniEnemy(halfTop());
				Actuate.timer(2).onComplete(addBasicEnemy, [halfBottom()]);
			}
			case 4: {
				// 2 normal enemies, 1 minienemy
				create(1);
				Actuate.timer(3.5).onComplete(create, [2]);
			}
			case 5: {
				// first boss
				var e = new FirstBoss(_layer, this);
				_enemies.push(e);
			}
			case 6: {
				// horde
				addHorde(wholeScreen());
			}
			case 7: {
				// 2 hordes
				addHorde(halfTop());
				Actuate.timer(1).onComplete(addHorde, [halfBottom()]);
			}
			case 8: {
				// 4 hordes
				addHorde(halfTop());
				Actuate.timer(1).onComplete(addHorde, [halfBottom()]);
				Actuate.timer(2).onComplete(addHorde, [halfTop()]);
				Actuate.timer(3).onComplete(addHorde, [halfBottom()]);
			}
			case 9: {
				// 2 hordes and a laser
				create(7);
				PlayState.getInstance()._laser = new Laser(_layer, wholeScreen());
			}
		}
	}
	
	public function remove(e:Enemy):Void {
		_enemies.remove(e);
		
		if (_enemies.length == 0 && !PlayState.getInstance()._gameOver)
			EnemyManager.getInstance().groupDeleted(this);
	}
	
	public function update(eTime:Int, bullets:Array<Bullet>):Void {
		for (enemy in _enemies)
			enemy.update(eTime, bullets);
	}
	
}
