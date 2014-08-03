package ;

import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.events.Event;
import aze.display.SparrowTilesheet;
import aze.display.TileLayer;
import aze.display.TileSprite;
import aze.display.TileClip;
import openfl.Assets;
import motion.Actuate;
import openfl.media.Sound;
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
	
	private var _prevTime:Int;
	
	private var _rect:Sprite;
	private var _maxSpecial:Int;
	private var _special:Int;
	private var _maxLifes:Int;
	private var _lifes:Int;
	private var _score:Int;
	
	private var _sndshoot:Sound;
	
	private var _keysPressed:Map<Int, Bool>;
	
	private function new() {
		super();
		
		var tiletxt = Assets.getText("img/atlas.xml");
		var tilesheet:SparrowTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), tiletxt);
		_gamelayer = new TileLayer(tilesheet);
		_uilayer = new TileLayer(tilesheet);
		
		_sndshoot = Assets.getSound("snd/shoot.wav");
		
		_rect = new Sprite();
		_rect.graphics.beginFill(0x000000);
		_rect.graphics.drawRect(0, 114, 160, 30);
		
		_player = new Player(_gamelayer, 15, 50);
		_bullets = new Array<Bullet>();
		_maxBullets = 5;
		
		_score = 0;
		_lifes = 3;
		_maxLifes = 3;
		for (i in 0..._lifes) {
			var llife = new TileSprite(_uilayer, "fullheart");
			llife.x = 15 + i * 15; llife.y = 123;
			_uilayer.addChild(llife);
		}
		
		for (i in _lifes..._maxLifes) {
			var llife = new TileSprite(_uilayer, "emptyheart");
			llife.x = 15 + i * 15; llife.y = 123;
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
			enemy.update(eTime);
		
		_gamelayer.render();
		_uilayer.render();
		
		//trace("b:" + _bullets.length + " eb:" + _enemyBullets.length + " e:" + _enemies.length);
	}
	
	public override function keyPressed(event:KeyboardEvent):Void {
		if (_keysPressed.get(event.keyCode) == null) {
			_keysPressed.set(event.keyCode, true);
			
			if (event.keyCode == Keyboard.A && _bullets.length < _maxBullets) {
				var bullet = new Bullet(_gamelayer, Std.int(_player.x + 14), Std.int(_player.y), _bullets);
				_bullets.push(bullet);
				_sndshoot.play();
			}
			
			_player.keyPressed(event);
		}
	}
	
	public function enemyShoot(x:Float, y:Float) {
		var bullet = new EnemyBullet(_gamelayer, Std.int(x), Std.int(y), _enemyBullets);
		_enemyBullets.push(bullet);
		_sndshoot.play();
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		_keysPressed.remove(event.keyCode);
		_player.keyReleased(event);
	}
	
	/*
	public function pause	() : Void { }
	public function resume	() : Void { }
	
	
	public function frameEnded		(event:Event) : Void { }
	*/
	
}
