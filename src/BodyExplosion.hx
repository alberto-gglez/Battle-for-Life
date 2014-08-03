package ;

import motion.Actuate;
import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileSprite;
import openfl.display.Sprite;

class BodyPiece extends TileSprite {
	
	public var _vspeed:Float;
	public var _hspeed:Float;
	
	public function new(tl:TileLayer, name:String) {
		super(tl, name);
	}
	
}

class BodyExplosion extends Sprite {
	
	private var _layer:TileLayer;
	private var _pieces:Array<BodyPiece>;
	private var _inertia:Float;
	private var _speed:Float;
	
	public function new(tl:TileLayer, x:Int, y:Int, sc:Float = 1) {
		super();
		
		_layer = tl;
		this.x = x; this.y = y;
		_inertia = 0.1;
		_speed = 0.1;
		
		_pieces = new Array<BodyPiece>();
		
		for (i in 0...7) {
			var tile = new BodyPiece(_layer, "piece" + i);
			
			tile.x = x; tile.y = y;
			tile.rotation = Std.random(360);
			tile.mirror = Std.random(3);
			tile._hspeed = 1 - Std.random(3);
			tile._vspeed = 1 - Std.random(3);
			tile.scale = sc;
			
			_pieces.push(tile);
			_layer.addChild(tile);
		}
		
	}
	
	public function update(eTime:Int, es:Array<BodyExplosion>) {
		var cont = 0;
		
		for (p in _pieces) {
			p._hspeed -= _inertia;
			
			p.x += p._hspeed * eTime * _speed;
			p.y += p._vspeed * eTime * _speed;
			
			if (p.x < -50)
				cont++;
		}
		
		if (cont == _pieces.length)
			es.remove(this);
		
	}
	
}