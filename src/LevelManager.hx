package ;

import openfl.Assets;
import aze.display.TileLayer;
import openfl.display.Sprite;

class LevelManager extends Sprite {
	
	private static var _instace:LevelManager;
	
	private var _levels:Array<String>;
	private var _initialized:Bool;
	private var _layer:TileLayer;
	
	private var _active:Bool;
	private var _currentLevel:Int;
	private var _currentEG:Int;
	
	private function new() {
		super();
		
		_levels = new Array<String>();
		_initialized = false;
		
		_active = false;
	}
	
	public static function getInstance():LevelManager {
		if (_instace == null)
			_instace = new LevelManager();
		
		return _instace;
	}
	
	public function init(tl:TileLayer, levelsNames:Array<String>):Void {
		if (!_initialized) {
			_initialized = true;
			
			_layer = tl;
			
			for (n in levelsNames)
				_levels.push(Assets.getText("lvl/" + n + ".txt"));
		}
	}
	
	public function startLevel(n:Int, eg:Int = 0):Void {
		if (!_active && n >= 0 && n < _levels.length) {
			//trace("new level [" + n + "]");
			_active = true;
			_currentLevel = n;
			_currentEG = eg;
			nextEnemyGroup();
		}
	}
	
	public function nextEnemyGroup():Void {
		if (_active) {
			if (_currentEG < _levels[_currentLevel].length) {
				//trace("new enemy group [id:" + Std.parseInt(_levels[_currentLevel].charAt(_currentEG)) + "]");
				EnemyManager.getInstance().getGroup().create(Std.parseInt(_levels[_currentLevel].charAt(_currentEG)));
				_currentEG++;
			} else {
				// level end
				//trace("level completed");
				
				_active = false;
				_currentLevel++;
				
				if (_currentLevel < _levels.length) {
					// start next level
					startLevel(_currentLevel);
				} else {
					// game end
					//trace("game completed");
				}
			}
		}
	}
	
}
