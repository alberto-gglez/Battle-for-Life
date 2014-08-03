package ;

import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author Alberto García
 */
class GameManager {

	private static var _instance:GameManager;
	private var _states:Array<GameState>;
	
	private function new() {
		_states = new Array<GameState>();
	}
	
	public static function getInstance():GameManager {
		if (_instance == null)
			_instance = new GameManager();
		
		return _instance;
	}
	
	public function start():Void {
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, frameStarted);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		
		changeState(MainMenuState.getInstance());
	}
	
	// events management
	public function frameStarted(event:Event):Void {
		if (_states.length > 0)
			_states[_states.length - 1].frameStarted(event);
	}
	
	public function keyPressed(event:KeyboardEvent):Void {
		if (_states.length > 0)
			_states[_states.length - 1].keyPressed(event);
	}
	
	public function keyReleased(event:KeyboardEvent):Void {
		if (_states.length > 0)
			_states[_states.length - 1].keyReleased(event);
	}
	
	// state transition
	public function changeState(state:GameState):Void {
		if (_states.length > 0)
			_states.pop().exit();
		
		_states.push(state);
		state.enter();
	}
	
	public function pushState(state:GameState):Void {
		var actualState = _states[_states.length - 1];
		actualState.pause();
		
		_states.push(state);
		state.enter();
	}
	
	public function popState():Void {
		_states.pop().exit();
	}
	
}
