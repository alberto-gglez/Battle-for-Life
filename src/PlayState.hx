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
	
	public var _player:Player;
	private var _bullets:Array<Bullet>;
	private var _maxBullets:Int;
	
	public var _enemies:Array<Enemy>;
	public var _enemyBullets:Array<Bullet>;
	public var _enemiesKilled:Int;
	
	public var _bodyexplosions:Array<BodyExplosion>;
	
	private var _prevTime:Int;
	
	private var _rect:Sprite;
	private var _maxSpecial:Int;
	private var _special:Int;
	private var _maxLifes:Int;
	public var _lifes:Int;
	public var _vlifes:Array<TileSprite>;
	public var _score:Int;
	private var _scoretxt:TextField;
	
	private var _sndshoot:Sound;
	public var _sndplayerhit:Sound;
	public var _sndenemyhit:Sound;
	public var _sndexplosion:Sound;
	public var _sndbigbullet:Sound;
	
	private var _keysPressed:Map<Int, Bool>;
	
	public var _drawHitboxes:Bool;
	public var _playerHitbox:Sprite;
	
	public var _gameOver:Bool;
	
	private function new() {
		super();
		
		var tiletxt = Assets.getText("img/atlas.xml");
		var tilesheet:SparrowTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), tiletxt);
		_gamelayer = new TileLayer(tilesheet);
		_uilayer = new TileLayer(tilesheet);
		
		_sndshoot = Assets.getSound("snd/shoot.wav");
		_sndplayerhit = Assets.getSound("snd/playerhit.wav");
		_sndenemyhit = Assets.getSound("snd/enemyhit.wav");
		_sndexplosion = Assets.getSound("snd/enemykilled.wav");
		_sndbigbullet = Assets.getSound("snd/bigbullet.wav");
		
		_rect = new Sprite();
		_rect.graphics.beginFill(0x000000);
		_rect.graphics.drawRect(0, 114, 160, 30);
		
		_player = new Player(_gamelayer, 15, 50);
		_bullets = new Array<Bullet>();
		_maxBullets = 5;
		
		_score = 0;
		_lifes = 3;
		_maxLifes = 3;
		_scoretxt = new TextField();
		_scoretxt.selectable = false; _scoretxt.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		_scoretxt.defaultTextFormat = new TextFormat(font, 20, 0x808080);
		_scoretxt.x = 62; _scoretxt.y = 112;
		_scoretxt.autoSize = TextFieldAutoSize.NONE;
		_scoretxt.text = "00000000";
		
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
			var lspecial = new TileClip(_uilayer, "special", 3);
			lspecial.x = 15 + i * 15; lspecial.y = 136;
			_uilayer.addChild(lspecial);
		}
		
		_keysPressed = new Map<Int, Bool>();
		
		_enemies = new Array<Enemy>();
		_enemyBullets = new Array<Bullet>();
		_bodyexplosions = new Array<BodyExplosion>();
		_enemiesKilled = 0;
		
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
	
	public function gameOver():Void {
		var txt = new TextField();
		
		txt.selectable = false; txt.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		txt.defaultTextFormat = new TextFormat(font, 16, 0x000000);
		txt.x = 40; txt.y = 40;
		txt.autoSize = TextFieldAutoSize.NONE;
		txt.text = "GAME OVER";
		Actuate.timer(2).onComplete(addChild, [txt]);
		_gameOver = true;
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
		Actuate.timer(0.2).onComplete(_enemies.push, [new Enemy(_gamelayer)]);
		//Actuate.timer(0.2).onComplete(addChild, [new FPS(100, 120, 0xFFFFFF)]);
		Actuate.timer(0.2).onComplete(addChild, [_scoretxt]);
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
			
		_scoretxt.text = Std.string(_score);
		for (i in 0...(8 - _scoretxt.text.length))
			_scoretxt.text = "0" + _scoretxt.text;
		
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
