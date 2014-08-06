package ;

import openfl.ui.Keyboard;
import aze.display.SparrowTilesheet;
import aze.display.TileSprite;
import flash.display.Graphics;
import openfl.display.Bitmap;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.Assets;
import openfl.Lib;
import openfl.media.Sound;
import openfl.text.TextField;
import motion.Actuate;
import aze.display.TileLayer;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

class MainMenuState extends GameState {
	
	private static var _instance:MainMenuState;
	
	private var _pressStartTxt:TextField;
	private var _normalTxt:TextField;
	private var _hardTxt:TextField;
	private var _insaneTxt:TextField;
	private var _descriptionTxt:TextField;
	private var _selected:Int;
	
	private var _layer:TileLayer;
	
	private var _startSnd:Sound;
	private var _selectSnd:Sound;
	
	private var _alreadyPressed:Bool;
	private var _menuShown:Bool;
	
	private function new() {
		super();
		
		var atlastxt = Assets.getText("img/atlas.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), atlastxt);
		_layer = new TileLayer(tilesheet);
		
		var logo = new TileSprite(_layer, "title");
		logo.x = Lib.current.stage.stageWidth / 2;
		logo.y = 50;
		_layer.addChild(logo);
		
		_startSnd = Assets.getSound("snd/gamestart.wav");
		_selectSnd = Assets.getSound("snd/select.wav");
		
		_pressStartTxt = new TextField();
		_pressStartTxt.selectable = false; _pressStartTxt.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		_pressStartTxt.defaultTextFormat = new TextFormat(font, 16, 0x133C2E);
		_pressStartTxt.x = 39; _pressStartTxt.y = 94;
		_pressStartTxt.autoSize = TextFieldAutoSize.NONE;
		_pressStartTxt.text = "Press enter";
		
		_normalTxt = new TextField();
		_normalTxt.selectable = false; _normalTxt.embedFonts = true;
		_normalTxt.defaultTextFormat = new TextFormat(font, 16, 0x517E39);
		_normalTxt.x = 54; _normalTxt.y = 30;
		_normalTxt.autoSize = TextFieldAutoSize.NONE;
		_normalTxt.text = "Normal";
		
		_hardTxt = new TextField();
		_hardTxt.selectable = false; _hardTxt.embedFonts = true;
		_hardTxt.defaultTextFormat = new TextFormat(font, 16, 0x133C2E);
		_hardTxt.x = 54; _hardTxt.y = 44;
		_hardTxt.autoSize = TextFieldAutoSize.NONE;
		_hardTxt.text = "Hard";
		
		_insaneTxt = new TextField();
		_insaneTxt.selectable = false; _insaneTxt.embedFonts = true;
		_insaneTxt.defaultTextFormat = new TextFormat(font, 16, 0x133C2E);
		_insaneTxt.x = 54; _insaneTxt.y = 58;
		_insaneTxt.autoSize = TextFieldAutoSize.NONE;
		_insaneTxt.text = "Insane";
		
		_descriptionTxt = new TextField();
		_descriptionTxt.selectable = false; _descriptionTxt.embedFonts = true;
		_descriptionTxt.width = 200;
		_descriptionTxt.defaultTextFormat = new TextFormat(font, 12, 0x133C2E);
		_descriptionTxt.x = 10; _descriptionTxt.y = 86;
		_descriptionTxt.autoSize = TextFieldAutoSize.NONE;
		_descriptionTxt.text = "3 lifes\nInvincible when gets hit\n1x points";
		
		ftextmenu0();
	}
	
	private function updateMenu():Void {
		switch (_selected) {
			case 1: {
				_normalTxt.textColor = 0x517E39; _hardTxt.textColor = 0x133C2E; _insaneTxt.textColor = 0x133C2E;
				_descriptionTxt.text = "3 lifes\nInvincible when gets hit\n1x points";
			}
			case 2: {
				_normalTxt.textColor = 0x133C2E; _hardTxt.textColor = 0x517E39; _insaneTxt.textColor = 0x133C2E;
				_descriptionTxt.text = "3 lifes\nNot invincible when gets hit\n2x points";
			}
			case 3: {
				_normalTxt.textColor = 0x133C2E; _hardTxt.textColor = 0x133C2E; _insaneTxt.textColor = 0x517E39;
				_descriptionTxt.text = "1 life\nNot invincible when gets hit\n3x points\nGood luck";
			}
		}
	}
	
	private function ftextmenu0() {
		Actuate.timer(0.8).onComplete(ftextmenu1);
		_pressStartTxt.visible = false;
	}
	
	private function ftextmenu1() {
		Actuate.timer(0.8).onComplete(ftextmenu0);
		_pressStartTxt.visible = true;
	}
	
	public static function getInstance():MainMenuState {
		if (_instance == null)
			_instance = new MainMenuState();
			
		return _instance;
	}
	
	// Event management
	public override function enter():Void {
		Lib.current.stage.color = 0xD6E894;
		
		_alreadyPressed = false;
		_menuShown = false;
		_selected = 1;
		updateMenu();
		
		addChild(_layer.view);
		addChild(_pressStartTxt);
	}
	
	public override function exit():Void {
		removeChildren();
	}
	
	public override function frameStarted(event:Event):Void {
		_layer.render();
	}
	
	public override function keyPressed(event:KeyboardEvent):Void {
		if (!_menuShown) {
			if (event.keyCode == Keyboard.ENTER) {
				_menuShown = true;
				//_startSnd.play();
				_selectSnd.play();
				
				removeChild(_pressStartTxt);
				removeChild(_layer.view);
				
				addChild(_normalTxt);
				addChild(_hardTxt);
				addChild(_insaneTxt);
				addChild(_descriptionTxt);
			}
		} else if (!_alreadyPressed) {
			
			switch (event.keyCode) {
				case Keyboard.UP: {
					_selected--;
					if (_selected < 1)
						_selected = 3;
					updateMenu();
					_selectSnd.play();
				}
				case Keyboard.DOWN: {
					_selected++;
					if (_selected > 3)
						_selected = 1;
					updateMenu();
					_selectSnd.play();
				}
				case Keyboard.ENTER: {
					_alreadyPressed = true;
					PlayState.getInstance()._gameMode = _selected;
					_startSnd.play();
					Actuate.timer(1.5).onComplete(changeState, [PlayState.getInstance()]);
				}
			}
			
		}
	}
	
	/*
	public function pause	() : Void { }
	public function resume	() : Void { }
	public function keyReleased	(event:KeyboardEvent) : Void { }
	
	public function frameEnded		(event:Event) : Void { }
	*/
}
