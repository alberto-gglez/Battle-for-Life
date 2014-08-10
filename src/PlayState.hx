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
	
	private var _hearts:Array<Heart>;
	
	public var _player:Player;
	public var _bullets:Array<Bullet>;
	public var _maxBullets:Int;
	
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
	private var _gameOverTxt:TextField;
	private var _gameCompletedTxt:TextField;
	
	public var _sndshoot:Sound;
	public var _sndshoot2:Sound;
	public var _sndplayerhit:Sound;
	public var _sndenemyhit:Sound;
	public var _sndexplosion:Sound;
	public var _sndbigbullet:Sound;
	public var _sndEyeAwoken:Sound;
	public var _sndLifeUp:Sound;
	public var _sndHordeKilled:Sound;
	public var _sndLaser:Sound;
	
	private var _keysPressed:Map<Int, Bool>;
	
	public var _gameOver:Bool;
	public var _canReset:Bool;
	public var _gameMode:Int;
	
	private var _bg:Background;
	
	public var _hordeEnemiesKilled:Int;
	
	public var _laser:Laser;
	
	private function new() {
		super();
		
		var tiletxt = Assets.getText("img/atlas.xml");
		var tilesheet:SparrowTilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), tiletxt);
		_gamelayer = new TileLayer(tilesheet);
		_uilayer = new TileLayer(tilesheet);
		
		_sndshoot = Assets.getSound("snd/shoot.wav");
		_sndshoot2 = Assets.getSound("snd/shoot_2.wav");
		_sndplayerhit = Assets.getSound("snd/playerhit.wav");
		_sndenemyhit = Assets.getSound("snd/enemyhit.wav");
		_sndexplosion = Assets.getSound("snd/enemykilled.wav");
		_sndbigbullet = Assets.getSound("snd/bigbullet.wav");
		_sndEyeAwoken = Assets.getSound("snd/eyeawoken.wav");
		_sndLifeUp = Assets.getSound("snd/lifeup.wav");
		_sndHordeKilled = Assets.getSound("snd/hordekilled.wav");
		_sndLaser = Assets.getSound("snd/laser.wav");
		
		_hearts = new Array<Heart>();
		
		_rect = new Sprite();
		_rect.graphics.beginFill(0x133C2E);
		_rect.graphics.drawRect(0, 114, 160, 30);
		
		_maxBullets = 4;
		_maxLifes = 3;
		_maxSpecial = 3;
		_gameMode = 1;
		
		_scoretxt = new TextField();
		_scoretxt.selectable = false; _scoretxt.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		_scoretxt.defaultTextFormat = new TextFormat(font, 20, 0x517E39);
		_scoretxt.x = 62; _scoretxt.y = 112;
		_scoretxt.autoSize = TextFieldAutoSize.NONE;
		_scoretxt.text = "00000000";
		
		_gameOverTxt = new TextField();
		_gameOverTxt.visible = false;
		_gameOverTxt.selectable = false; _gameOverTxt.embedFonts = true;
		_gameOverTxt.defaultTextFormat = new TextFormat(font, 16, 0x133C2E);
		_gameOverTxt.x = 39; _gameOverTxt.y = 40;
		_gameOverTxt.autoSize = TextFieldAutoSize.NONE;
		_gameOverTxt.text = "GAME OVER";
		
		_gameCompletedTxt = new TextField();
		_gameCompletedTxt.visible = false;
		_gameCompletedTxt.selectable = false; _gameCompletedTxt.embedFonts = true;
		_gameCompletedTxt.defaultTextFormat = new TextFormat(font, 16, 0x133C2E);
		_gameCompletedTxt.x = 0; _gameCompletedTxt.y = 4;
		_gameCompletedTxt.autoSize = TextFieldAutoSize.NONE;
		_gameCompletedTxt.width = 160;
		_gameCompletedTxt.text = "     You have completed\n             the first level!\n        Stay alert for the\n            final version ;)\n\n      Thanks for playing!";
		
	}
	
	public function gameCompleted():Void {
		for (h in _hearts)
			Actuate.timer(2).onComplete(h.destroy);
		
		Actuate.timer(2).onComplete(Actuate.apply, [_player, { visible: false}]);
		Actuate.timer(2).onComplete(Actuate.apply, [_gameCompletedTxt, { visible: true }]);
		Actuate.timer(3).onComplete(Actuate.apply, [ this, { _canReset: true } ]);
		_gameOver = true;
	}
	
	public function gameOver():Void {
		for (h in _hearts)
			Actuate.timer(2).onComplete(h.destroy);
		
		Actuate.timer(2).onComplete(Actuate.apply, [_gameOverTxt, { visible: true }]);
		Actuate.timer(2).onComplete(Actuate.apply, [ this, { _canReset: true } ]);
		_gameOver = true;
	}
	
	public function createHeart(xp:Float, yp:Float):Void {
		var h = new Heart(_gamelayer, _hearts, xp, yp);
		_hearts.push(h);
	}
	
	public function damagedEffect(e:Dynamic, p:Int, t:Float):Void {
		if (!_gameOver) {
			if (p == 0) {
				e.visible = true;
			} else {
				if (p % 2 == 0) {
					e.visible = false;
					Actuate.timer(t).onComplete(damagedEffect, [e, p - 1, t]);
				} else {
					e.visible = true;
					Actuate.timer(t).onComplete(damagedEffect, [e, p - 1, t]);
				}
			}
		} else {
			if (e == _player)
				e.visible = false;
			else
				e.visible = true;
		}
	}
	
	public static function getInstance():PlayState {
		if (_instance == null)
			_instance = new PlayState();
		
		return _instance;
	}
	
	// Event management
	public override function enter():Void {
		_bg = new Background(_gamelayer);
		
		_player = new Player(_gamelayer, 15, 50);
		_bullets = new Array<Bullet>();
		
		_laser = null;
		_score = 0;
		_special = 3;
		_hordeEnemiesKilled = 0;
		
		if (_gameMode == 3)
			_lifes = 1;
		else
			_lifes = 3;
		
		_vlifes = new Array<TileSprite>();
		for (i in 0..._lifes) {
			var llife = new TileSprite(_uilayer, "fullheart");
			llife.x = 15 + i * 15; llife.y = 123;
			_vlifes.push(llife);
			_uilayer.addChild(llife);
		}
		
		/*
		for (i in 0..._special) {
			var lspecial = new TileClip(_uilayer, "special", 3);
			lspecial.x = 15 + i * 15; lspecial.y = 136;
			_uilayer.addChild(lspecial);
		}
		*/
		
		_keysPressed = new Map<Int, Bool>();
		
		_enemyBullets = new Array<Bullet>();
		_bodyexplosions = new Array<BodyExplosion>();
		_enemiesKilled = 0;
		
		_gameOverTxt.visible = false;
		_gameCompletedTxt.visible = false;
		
		_canReset = false;
		_gameOver = false;
		
		Actuate.timer(0.2).onComplete(addChild, [_gamelayer.view]);
		Actuate.timer(0.2).onComplete(addChild, [_rect]);
		Actuate.timer(0.2).onComplete(addChild, [_uilayer.view]);
		Actuate.timer(0.2).onComplete(addChild, [_scoretxt]);
		
		addChild(_gameOverTxt);
		Actuate.timer(0.3).onComplete(addChild, [_gameCompletedTxt]);
		
		EnemyManager.getInstance().init(_gamelayer, 1);
		LevelManager.getInstance().init(_gamelayer, ["level1", "level2"]);
		LevelManager.getInstance().startLevel(1);
		
		_prevTime = Lib.getTimer();
	}
	
	public override function exit():Void {
		removeChildren();
		_gamelayer.removeAllChildren();
		_uilayer.removeAllChildren();
		EnemyManager.getInstance().reset();
		LevelManager.getInstance().reset();
	}
	
	public override function frameStarted(event:Event):Void {
		
		var curTime = Lib.getTimer(); var eTime = curTime - _prevTime;
		_prevTime = curTime;
		
		for (bullet in _bullets)
			bullet.update(eTime);
		
		for (ebullet in _enemyBullets)
			ebullet.update(eTime);
		
		_player.update(eTime, _enemyBullets, _hearts, _laser);
			
		EnemyManager.getInstance().update(eTime, _bullets);
			
		for (explosion in _bodyexplosions)
			explosion.update(eTime, _bodyexplosions);
		
		for (h in _hearts)
			h.update(eTime);
		
		_bg.update(eTime);
			
		_gamelayer.render();
		_uilayer.render();
		
		_scoretxt.text = Std.string(_score);
		for (i in 0...(8 - _scoretxt.text.length))
			_scoretxt.text = "0" + _scoretxt.text;
		
	}
	
	public override function keyPressed(event:KeyboardEvent):Void {
		if (_keysPressed.get(event.keyCode) == null && !_gameOver) {
			_keysPressed.set(event.keyCode, true);
			
			_player.keyPressed(event);
		} else if (_canReset) {
			changeState(MainMenuState.getInstance());
		}
	}
	
	public override function keyReleased(event:KeyboardEvent):Void {
		_keysPressed.remove(event.keyCode);
		_player.keyReleased(event);
	}
	
	
	/*
	public override function frameEnded(event:Event):Void { }
	public function pause	() : Void { }
	public function resume	() : Void { }
	
	
	
	*/
	
}
