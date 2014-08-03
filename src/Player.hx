package ;

import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.Lib;

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
	private var _curClip:TileClip;
	private var _movingDown:Bool;
	
	public function new(tl:TileLayer, x:Int, y:Int) {
		super(tl);
		
		this.x = x; this.y = y;
		_speed = 0.15;
		_movingDown = false;
		
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
					_vspeed -= 1;
			}
			case Keyboard.DOWN: {
				if (_vspeed == 0)
					_vspeed += 1;
			}
			case Keyboard.RIGHT: {
				if (_hspeed == 0)
					_hspeed += 1;
			}
			case Keyboard.LEFT: {
				if (_hspeed == 0)
					_hspeed -= 1;
			}
			case Keyboard.A: {
				
			}
		}
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.UP: {
				if (_vspeed == -1)
					_vspeed = 0;
			}
			case Keyboard.DOWN: {
				if (_vspeed == 1)
					_vspeed = 0;
			}
			case Keyboard.RIGHT: {
				if (_hspeed == 1)
					_hspeed = 0;
			}
			case Keyboard.LEFT: {
				if (_hspeed == -1)
					_hspeed = 0;
			}
		}
	}
	
	private function collision(eb:EnemyBullet):Bool {
		if (eb.x - eb.width / 2 > _curClip.x - _curClip.width / 2 && eb.x + eb.width / 2 < _curClip.x + _curClip.width / 2)
			if (eb.y - eb.height / 2 > _curClip.y - _curClip.height / 2 && eb.y + eb.height / 2 < _curClip.y + _curClip.height / 2)
				return true;
		
		return false;
	}
	
	public function update(eTime:Int, eb:Array<EnemyBullet>):Void {
		
		// collisions with enemy bullets
		for (bullet in eb)
			if (collision(bullet))
				trace("te dio!");
			else
				trace(" ");
		
		x += _hspeed * eTime * _speed;
		y += _vspeed * eTime * _speed;

		if (x - _curClip.width / 2 < -12)
			x = _curClip.width / 2 - 12;
		else if (x + _curClip.width / 2 > 100)
			x = 100 - _curClip.width / 2;

		if (y - _curClip.height / 2 < 0)
			y = _curClip.height / 2;
		else if (y + _curClip.height / 2 > 144 - 30 + 6)
			y = 144 - _curClip.height / 2 - 30 + 6;
		
		// select the correct sprite
		if (_vspeed == 1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerdown))];
			_movingDown = true;
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
		if (_movingDown)
			_curClip.y -= 8;

		_curClip.visible = true;
		_movingDown = false;
	}
	
}
