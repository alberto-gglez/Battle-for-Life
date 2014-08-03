package ;

import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import aze.display.TileSprite;
import aze.display.TileClip;
import openfl.Assets;
import motion.Actuate;
import openfl.media.Sound;
import openfl.text.TextField;
import openfl.utils.Timer;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import Map;

class PlayState extends GameState {
	
	private static var _instance:PlayState;
	
	private var _gamelayer:TileLayer;
	private var _uilayer:TileLayer;
	
	private var _player:Player;
	private var _bullets:Array<Bullet>;
	private var _maxBullets:Int;
	
	private var _enemies:Array<Enemy>;
	private var _enemyBullets:Array<EnemyBullet>;
	private var _bodyexplosions:Array<BodyExplosion>;
	
	private var _prevTime:Int;
	
	private var _rect:Sprite;
	private var _maxSpecial:Int;
	private var _special:Int;
	private var _maxLifes:Int;
	private var _lifes:Int;
	private var _vlifes:Array<TileSprite>;
	private var _score:Int;
	
	private var _sndshoot:Sound;
	private var _sndplayerhit:Sound;
	private var _sndexplosion:Sound;
	
	private var _keysPressed:Map<Int, Bool>;
	
	public var _drawHitboxes:Bool;
	public var _playerHitbox:Sprite;
	
	private var _gameOver:Bool;
	
	private function new() {
		super();
		
		var tiletxt = Assets.getText("img/atlas.xml");
		var tilesheet:SparrowTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), tiletxt);
		_gamelayer = new TileLayer(tilesheet);
		_uilayer = new TileLayer(tilesheet);
		
		_sndshoot = Assets.getSound("snd/shoot.wav");
		_sndplayerhit = Assets.getSound("snd/playerhit.wav");
		_sndexplosion = Assets.getSound("snd/enemykilled.wav");
		
		_rect = new Sprite();
		_rect.graphics.beginFill(0x000000);
		_rect.graphics.drawRect(0, 114, 160, 30);
		
		_player = new Player(_gamelayer, 15, 50);
		_bullets = new Array<Bullet>();
		_maxBullets = 5;
		
		_score = 0;
		_lifes = 3;
		_maxLifes = 3;
		
		_vlifes = new Array<TileSprite>();
		
		_gameOver = false;
		
		for (i in 0..._lifes) {
			var llife = new TileSprite(_uilayer, "fullheart");
			llife.x = 15 + i * 15; llife.y = 123;
			_vlifes.push(llife);
			_uilayer.addChild(llife);
		}
		
		_maxSpecial = 3;
		_special = 3;
		
		for (i in 0..._special) {
			var lspecial = new TileClip(_uilayer, "special", 4);
			lspecial.x = 15 + i * 15; lspecial.y = 136;
			_uilayer.addChild(lspecial);
		}
		
		_keysPressed = new Map<Int, Bool>();
		
		_enemies = new Array<Enemy>();
		_enemyBullets = new Array<EnemyBullet>();
		_bodyexplosions = new Array<BodyExplosion>();
		
		_drawHitboxes = false;
		
		_playerHitbox = new Sprite();
		_playerHitbox.visible = false;
		_playerHitbox.x = _player.hitbox().x;
		_playerHitbox.y = _player.hitbox().y;
		_playerHitbox.graphics.beginFill(0x00FF00);
		_playerHitbox.graphics.drawRect(0, 0, _player.hitbox().width, _player.hitbox().height);
		_playerHitbox.graphics.endFill();
		addChild(_playerHitbox);
	}
	
	public function enemyGotHit(e:Enemy):Void {
		var health = e.damage();
		if (health > 0) {
			damagedEffect(e, 8);
			
			if (health == 7) {
				_enemies.push(new Enemy(_gamelayer, _player));
			
				if (Std.random(50) == 0)
					_enemies.push(new Enemy(_gamelayer, _player));
			}
				
		} else {
			e.kill(_enemies);
			_sndexplosion.play();
			_score += 10;
			_bodyexplosions.push(new BodyExplosion(_gamelayer, Std.int(e.x), Std.int(e.y)));
		}
	}
	
	public function playerGotHit():Void {
		if (_lifes > 0) {
			_lifes--;
			_vlifes[_lifes].tile = "emptyheart";
			
			_sndplayerhit.play();
			damagedEffect(_player, 8);
			
		} else {
			_sndexplosion.play();
			_player.setInvul(true);
			_player.visible = false;
			_bodyexplosions.push(new BodyExplosion(_gamelayer, Std.int(_player.x), Std.int(_player.y)));
			
			gameOver();
		}
	}
	
	public function gameOver():Void {
		var txt = new TextField();
		
		txt.selectable = false; txt.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		txt.defaultTextFormat = new TextFormat(font, 16, 0x000000);
		txt.x = 40; txt.y = 40;
		txt.autoSize = TextFieldAutoSize.NONE;
		txt.htmlText = "GAME OVER";
		Actuate.timer(2).onComplete(addChild, [txt]);
		_gameOver = true;
	}
	
	public function checkGameOver():Bool {
		return _gameOver;
	}
	
	public function damagedEffect(e:Entity, p:Int):Void {
		if (!_gameOver) {
			if (p == 0) {
				e.visible = true;
			} else {
				if (p % 2 == 0) {
					e.visible = false;
					Actuate.timer(0.15).onComplete(damagedEffect, [e, p - 1]);
				} else {
					e.visible = true;
					Actuate.timer(0.15).onComplete(damagedEffect, [e, p - 1]);
				}
			}
		} else
			e.visible = false;
	}
	
	public static function getInstance():PlayState {
		if (_instance == null)
			_instance = new PlayState();
		
		return _instance;
	}
	
	// Event management
	public override function enter():Void {
		Actuate.timer(0.2).onComplete(addChild, [_gamelayer.view]);
		Actuate.timer(0.2).onComplete(addChild, [_rect]);
		Actuate.timer(0.2).onComplete(addChild, [_uilayer.view]);
		Actuate.timer(0.2).onComplete(_enemies.push, [new Enemy(_gamelayer, _player)]);
		//Actuate.timer(0.2).onComplete(addChild, [new FPS(100, 120, 0xFFFFFF)]);
		_prevTime = Lib.getTimer();
	}
	
	public override function exit():Void {
		removeChild(_gamelayer.view);
		removeChild(_uilayer.view);
		removeChild(_rect);
	}
	
	public override function frameStarted(event:Event):Void {
		
		var curTime = Lib.getTimer(); var eTime = curTime - _prevTime;
		_prevTime = Lib.getTimer();
		
		for (bullet in _bullets)
			bullet.update(eTime);
		
		for (ebullet in _enemyBullets)
			ebullet.update(eTime);
		
		_player.update(eTime, _enemyBullets);
			
		for (enemy in _enemies)
			enemy.update(eTime, _bullets);
			
		for (explosion in _bodyexplosions)
			explosion.update(eTime, _bodyexplosions);
		
		_gamelayer.render();
		_uilayer.render();
		
		if (_drawHitboxes) {
			_playerHitbox.x = _player.hitbox().x;
			_playerHitbox.y = _player.hitbox().y;
			_playerHitbox.visible = true;
		} else
			_playerHitbox.visible = false;
		
		//trace("b:" + _bullets.length + " eb:" + _enemyBullets.length + " e:" + _enemies.length);
	}
	
	public override function keyPressed(event:KeyboardEvent):Void {
		if (_keysPressed.get(event.keyCode) == null && !_gameOver) {
			_keysPressed.set(event.keyCode, true);
			
			if (event.keyCode == Keyboard.A && _bullets.length < _maxBullets) {
				var bullet = new Bullet(_gamelayer, Std.int(_player.x + 14), Std.int(_player.y - 3), _bullets);
				_bullets.push(bullet);
				_sndshoot.play();
			}
			
			_player.keyPressed(event);
		}
	}
	
	public function enemyShoot(x:Float, y:Float) {
		var bullet = new EnemyBullet(_gamelayer, Std.int(x), Std.int(y), _enemyBullets);
		_enemyBullets.push(bullet);
		//_sndshoot.play();
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		_keysPressed.remove(event.keyCode);
		_player.keyReleased(event);
	}
	
	public override function frameEnded(event:Event):Void {
		// ...
	}
	
	/*
	public function pause	() : Void { }
	public function resume	() : Void { }
	
	
	
	*/
	
}
