package ;

import aze.display.TileClip;
import aze.display.TileLayer;
import aze.display.TileSprite;
import openfl.geom.Rectangle;

/*
class Spore extends Entity {
	
	private var _clip:TileClip;
	
	public function new(tl:TileLayer) {
		super(tl);
		
		_clip = new TileClip(_layer, "boss1spore", 4);
	}
	
}
*/

class FirstBoss extends Enemy {
	
	private var _sprite:TileSprite;
	
	public function new(tl:TileLayer, group:EnemyGroup, points:Int, xp:Int, yp:Int) {
		super(tl, group, points, xp, yp);
		
		_sprite = new TileSprite(_layer, "firstboss_base");
		_layer.addChild(_sprite);
		
		_hitbox.x = 133; _hitbox.y = 0;
		_hitbox.width = 27; _hitbox.height = 114;
	}
	
	public override function update(eTime:Int, b:Array<Bullet>):Void {
		_hitbox.x = _sprite.x; _hitbox.y = _sprite.y;
	}
	
}