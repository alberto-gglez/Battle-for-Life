package ;

import motion.Actuate;
import aze.display.TileLayer;
import aze.display.TileClip;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import openfl.Lib;
import openfl.display.Sprite;

enum PlayerStates {
	playerstand;
	playerup;
	playerdown;
	playerleft;
}

class Player extends Entity {
	
	private var _vclips:Array<TileClip>;
	private var _mapstate:Map<String, Int>;
	private var _curClip:TileClip;
	private var _movingDown:Bool;
	public var _invul:Bool;
	
	private var _pright:Int;
	private var _pleft:Int;
	private var _pup:Int;
	private var _pdown:Int;
	
	public function new(tl:TileLayer, x:Int, y:Int) {
		super(tl);
		
		this.x = x; this.y = y;
		_speed = 0.15;
		_movingDown = false;
		_invul = false;
		
		_vclips = new Array<TileClip>();
		_mapstate = new Map<String, Int>();
		
		var i:Int = 0;
		for (value in Type.getEnumConstructs(PlayerStates)) {
			var clip = new TileClip(_layer, value, 12);
			clip.x = x; clip.y = y;
			clip.visible = false;
			_layer.addChild(clip);
			
			_vclips.push(clip);
			_mapstate.set(value, i);
			i++;
		}
		
		_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		_curClip.visible = true;
		
		_hitbox = new Rectangle(x - 4, y - 8, 19, 10);
	}
	
	public override function keyPressed	(event:KeyboardEvent) : Void {
		switch (event.keyCode) {
			case Keyboard.UP: {
				_pup = 1;
			}
			case Keyboard.DOWN: {
				_pdown = 1;
			}
			case Keyboard.RIGHT: {
				_pright = 1;
			}
			case Keyboard.LEFT: {
				_pleft = 1;
			}
			case Keyboard.A: {
				var ps = PlayState.getInstance();
				if (ps._bullets.length < ps._maxBullets) {
					var bullet = new Bullet(_layer, Std.int(x + 14), Std.int(y - 3), ps._bullets);
					ps._bullets.push(bullet);
					ps._sndshoot.play();
				}
			}
		}
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.UP: {
				_pup = 0;
			}
			case Keyboard.DOWN: {
				_pdown = 0;
			}
			case Keyboard.RIGHT: {
				_pright = 0;
			}
			case Keyboard.LEFT: {
				_pleft = 0;
			}
		}
	}
	
	public function gotHit():Void {

		PlayState.getInstance()._lifes--;
		PlayState.getInstance()._vlifes[PlayState.getInstance()._lifes].tile = "emptyheart";
		
		if (PlayState.getInstance()._lifes > 0) {
			if (!_invul) {
				PlayState.getInstance()._sndplayerhit.play();
				
				if (PlayState.getInstance()._gameMode == 1) { // easy
					PlayState.getInstance().damagedEffect(this, 10, 0.1);
					_invul = true;
					Actuate.timer(1).onComplete(Actuate.apply, [this, { _invul: false }]);
				} else // hard or insane
					PlayState.getInstance().damagedEffect(this, 2, 0.1);
			}
			
		} else {
			visible = false;
			PlayState.getInstance()._sndexplosion.play();
			PlayState.getInstance()._bodyexplosions.push(new BodyExplosion(_layer, Std.int(x), Std.int(y)));
			
			PlayState.getInstance().gameOver();
		}
	}
	
	public function update(eTime:Int, eb:Array<Bullet>, hs:Array<Heart>, l:Laser):Void {
		
		if (l != null)
			if (l._active && !_invul && PlayState.getInstance()._lifes > 0 && collision(l))
				gotHit();
		
		// collisions with enemy bullets
		for (bullet in eb)
			if (collision(bullet) && PlayState.getInstance()._lifes > 0) {
				if (!_invul)
					gotHit();
				
				bullet.destroy();
			}
		
		for (heart in hs)
			if (collision(heart) && !PlayState.getInstance()._gameOver) {
				if (PlayState.getInstance()._lifes < 3 && PlayState.getInstance()._gameMode != 3) {
					PlayState.getInstance()._vlifes[PlayState.getInstance()._lifes].tile = "fullheart";
					PlayState.getInstance()._lifes++;
				} else {
					PlayState.getInstance()._score += 500 * PlayState.getInstance()._gameMode;
				}
				PlayState.getInstance()._sndLifeUp.play();
				heart.destroy();
			}
		
		_hspeed = _pright - _pleft;
		_vspeed = _pdown - _pup;
					
		x += _hspeed * eTime * _speed;
		y += _vspeed * eTime * _speed;

		if (x - _curClip.width / 2 < 0)
			x = _curClip.width / 2;
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
			_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		} else if (_hspeed == -1) {
			_curClip = _vclips[_mapstate.get(Std.string(playerleft))];
		} else
			_curClip = _vclips[_mapstate.get(Std.string(playerstand))];
		
		for (i in _vclips)
			i.visible = false;
			
		if (visible)
			_curClip.visible = true;
			
		_curClip.x = x; _curClip.y = y;
		if (_movingDown)
			_curClip.y -= 8;

		_movingDown = false;
		
		_hitbox.x = x - 4; _hitbox.y = y - 9;
	}
	
}
