package ;

import aze.display.TileLayer;

class Enemy extends Entity {
	
	private function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int) {
		super(tl);
	}
	
	public function update(eTime:Int, b:Array<Bullet>):Void { }
	
}