package ;

import aze.display.SparrowTilesheet;
import aze.display.TileSprite;
import flash.display.Graphics;
import openfl.display.Bitmap;
import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.Assets;
import openfl.Lib;
import openfl.text.TextField;
import motion.Actuate;
import aze.display.TileLayer;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

class MainMenuState extends GameState {
	
	private static var _instance:MainMenuState;
	
	private var _info:TextField;
	private var _layer:TileLayer;
	
	private function new() {
		super();
		
		var atlastxt = Assets.getText("img/atlas.xml");
		var tilesheet = new SparrowTilesheet(Assets.getBitmapData("img/atlas.png"), atlastxt);
		_layer = new TileLayer(tilesheet);
		
		var logo = new TileSprite(_layer, "title");
		logo.x = Lib.current.stage.stageWidth / 2;
		logo.y = 50;
		_layer.addChild(logo);
		
		_info = new TextField();
		_info.selectable = false; _info.embedFonts = true;
		var font:String = Assets.getFont("fnt/gbb.ttf").fontName;
		_info.defaultTextFormat = new TextFormat(font, 16, 0x000000);
		_info.x = 32; _info.y = 94;
		_info.autoSize = TextFieldAutoSize.NONE;
		_info.htmlText = "Press any key";
		ftextmenu0();
		
	}
	
	private function ftextmenu0() {
		Actuate.tween(_info, 1, { alpha: 1 }).onComplete(ftextmenu1);
	}
	
	private function ftextmenu1() {
		Actuate.tween(_info, 0.5, { alpha: 0 }).onComplete(ftextmenu0);
	}
	
	public static function getInstance():MainMenuState {
		if (_instance == null)
			_instance = new MainMenuState();
			
		return _instance;
	}
	
	// Event management
	public override function enter	() : Void {
		addChild(_layer.view);
		addChild(_info);
	}
	
	public override function exit() : Void {
		removeChild(_layer.view);
		removeChild(_info);
	}
	
	public override function frameStarted(event:Event) : Void {
		_layer.render();
	}
	
	public override function keyPressed	(event:KeyboardEvent) : Void {
		Actuate.tween(Lib.current.stage, 0.5, { color: 0xFFFFFF });
		changeState(PlayState.getInstance());
	}
	
	/*
	public function pause	() : Void { }
	public function resume	() : Void { }
	public function keyReleased	(event:KeyboardEvent) : Void { }
	
	public function frameEnded		(event:Event) : Void { }
	*/
}