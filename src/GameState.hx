
package ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class GameState extends Sprite {

	private function new() {
		super();
	}
	
	// Event management
	public function enter	() : Void { }
	public function exit	() : Void { }
	public function pause	() : Void { }
	public function resume	() : Void { }
	
	public function keyPressed	(event:KeyboardEvent) : Void { }
	public function keyReleased	(event:KeyboardEvent) : Void { }
	
	public function frameStarted	(event:Event) : Void { }
	public function frameEnded		(event:Event) : Void { }
	
	// State transition
	public function changeState(state:GameState):Void {
		GameManager.getInstance().changeState(state);
	}
	
	public function pushState(state:GameState):Void {
		GameManager.getInstance().pushState(state);
	}
	
	public function popState():Void {
		GameManager.getInstance().popState();
	}
	
}
