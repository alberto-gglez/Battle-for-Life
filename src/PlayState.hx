package ;

import aze.display.TileLayer;
import aze.display.TileSprite;
import aze.display.TileClip;

class PlayState extends GameState {
	
	private static vat _instance:PlayState;
	
	
	
	private function new() {
		super();
	}
	
	public static function getInstance():PlayState {
		if (_instance == null)
			_instance = new PlayState();
		
		return _instance;
	}
	
}