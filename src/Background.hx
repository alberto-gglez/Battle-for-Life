package ;

import openfl.display.Sprite;
import aze.display.TileLayer;
import aze.display.TileSprite;

class Background extends Sprite {
	
	private var _layer:TileLayer;
	private var _pieces:Array<TileSprite>;
	private var _spd:Float;
	
	public function new(tl:TileLayer) {
		super();
		
		_layer = tl;
		_pieces = new Array<TileSprite>();
		
		var p = new TileSprite(_layer, "bg");
		p.x = 0; p.y = p.height / 2;
		_layer.addChild(p);
		_pieces.push(p);
		
		p = new TileSprite(_layer, "bg");
		p.x = 91; p.y = p.height / 2;
		_layer.addChild(p);
		_pieces.push(p);
		
		_spd = 0.2;
	}
	
	public function update(eTime:Int):Void {
		for (p in _pieces) {
			p.x -= eTime * _spd;
			
			if (p.x - p.width / 2 < -p.width)
				p.x = 160 + p.width / 2;
		}
	}
	
}