package ;

import aze.display.TileLayer;

class Enemy extends Entity {

	private var _points:Int;
	private var _health:Int;
	private var _group:EnemyGroup;
	
	private function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int) {
		super(tl);

		_group = group;
		_points = points;
		x = xp; y = yp;
	}
	
	public function update(eTime:Int, b:Array<Bullet>):Void { }
	public function removeClips():Void {}
	
}