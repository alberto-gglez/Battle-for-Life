package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

enum PlayerStates {
	playerstand;
	playerup;
	playerdown;
	playerleft;
	playerright;
}

class Player extends Entity {
	
	private var _vclips:Array<TileClip>;
	private var _mapstate:Map<String, Int>;
	private var _speed:Float;
	private var _curClip:TileClip;
	
	public function new(tl:TileLayer, x:Int, y:Int) {
		super(tl);
		
		this.x = x; this.y = y;
		_speed = 0.1;
		
		_vclips = new Array<TileClip>();
		_mapstate = new Map<String, Int>();
		
		var i:Int = 0;
		for (value in Type.getEnumConstructs(PlayerStates)) {
			var clip = new TileClip(_layer, value);
			clip.x = x; clip.y = y;
			clip.visible = false;
			_layer.addChild(clip);
			
			_vclips.push(clip);
			_mapstate.set(value, i);
			i++;
		}
		
		_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		_curClip.visible = true;
	}
	
	public override function keyPressed	(event:KeyboardEvent) : Void {
		switch (event.keyCode) {
			case Keyboard.UP: {
				if (_vspeed == 0)
					_vspeed = -1;
			}
			case Keyboard.DOWN: {
				if (_vspeed == 0)
					_vspeed = 1;
			}
			case Keyboard.RIGHT: {
				if (_hspeed == 0)
					_hspeed = 1;
			}
			case Keyboard.LEFT: {
				if (_hspeed == 0)
					_hspeed = -1;
			}
		}
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		
		var pKey = event.keyCode;
		
		/*
		if (pKey == Keyboard.UP) {
			if (Keyboard.
		}
		*/
		
		if (pKey == Keyboard.UP || pKey == Keyboard.DOWN) {
			_vspeed = 0;
		} else if (pKey == Keyboard.LEFT || pKey == Keyboard.RIGHT) {
			_hspeed = 0;
		}
	}
	
	public override function update(eTime:Int):Void {
		x += _hspeed * eTime * _speed;
		y += _vspeed * eTime * _speed;
		
		// select the correct sprite
		if (_vspeed == 1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerdown))];
		} else if (_vspeed == -1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerup))];
		} else if (_hspeed == 1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerright))];
		} else if (_hspeed == -1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerleft))];
		} else
			_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		
		for (i in _vclips)
			i.visible = false;
			
		_curClip.visible = true;
		_curClip.x = x; _curClip.y = y;
		_curClip.visible = true;
	}
	
}
