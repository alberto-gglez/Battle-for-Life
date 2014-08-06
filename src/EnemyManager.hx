package ;

import aze.display.TileLayer;
import openfl.display.Sprite;

class EnemyManager extends Sprite {
	
	private static var _instance:EnemyManager;
	private var _layer:TileLayer;
	
	private var _groups:Array<EnemyGroup>;
	private var _unused:Array<EnemyGroup>;
	private var _initialized:Bool;
	
	private function new() {
		super();
		
		_groups = new Array<EnemyGroup>();
		_unused = new Array<EnemyGroup>();
		_initialized = false;
	}
	
	public static function getInstance():EnemyManager {
		if (_instance == null)
			_instance = new EnemyManager();
			
		return _instance;
	}
	
	public function init(tl:TileLayer, groups:Int):Void {
		if (!_initialized) {
			_initialized = true;
			
			_layer = tl;
			
			for (i in 0...groups) {
				var eg = new EnemyGroup(_layer);
				_groups.push(eg);
				_unused.push(eg);
			}
		}
	}
	
	public function reset():Void {
		for (g in _groups)
			g.reset();
		
		_unused = _groups.copy();
	}
	
	public function getGroup():EnemyGroup {
		if (_initialized) {
			if (_unused.length > 0)
				return _unused.pop();
			else {
				var g = new EnemyGroup(_layer);
				_groups.push(g);
				return g;
			}
			
		} else {
			trace("The enemy manager must be initialiced in order to use it.");
			return new EnemyGroup(_layer);
		}
	}
	
	public function update(eTime:Int, bullets:Array<Bullet>):Void {
		for (g in _groups)
			g.update(eTime, bullets);
	}
	
	public function groupDeleted(g:EnemyGroup):Void {
		_unused.push(g);
		LevelManager.getInstance().nextEnemyGroup();
	}
	
}