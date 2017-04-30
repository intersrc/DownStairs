package down;

import createjs.easeljs.Bitmap;
import createjs.easeljs.DisplayObject;
import createjs.easeljs.Shape;
import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;
import game.Actor;
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;

/**
 * ...
 * @author wuyu
 */

enum FloorType {
	Random;
	Normal;
	Elastic;
	Conveyer;
}

class Floor extends Actor {
	public static inline var COLLISION_GROUP:Int = 2;
	public static var CB_TYPE:CbType = new CbType();
	public static var CB_TYPE_ELASTIC:CbType = new CbType();
	
	public function new(x:Float, y:Float, type:FloorType = null) {
		var tBody:Body = new Body(BodyType.KINEMATIC);
		var tDO:DisplayObject = null;
		
		var w:Float = 128;
		var h:Float = 16;
		var r:Float = 32;
		
		if (type == null || Type.enumEq(type, FloorType.Random)) {
			var rand = Math.random();
			if (rand < 0.2) {
				type = FloorType.Elastic;
			}
			else if (rand < 0.35) {
				type = FloorType.Conveyer;
			}
			else {
				type = FloorType.Normal;
			}
		}
		
		switch (type) {
			case FloorType.Conveyer:
				tBody.shapes.add(new Polygon(Polygon.box(w, h)));//new Circle(r);
				var material = Material.steel();
				material.dynamicFriction = 1.4;// 1;
				material.staticFriction = 1.4;
				tBody.setShapeMaterials(material);
				tBody.surfaceVel.x = Std.random(2) == 0 ? -300 : 300;
				
				tBody.cbTypes.add(CB_TYPE);
				
				var normal:Array<Dynamic> = [0, 1, "normal"];
				var data = {
					images: [Manifest.BMP_FLOOR_CONVEYER],
					frames: {width:w, height:h, count:2},
					animations: {
						normal:normal
					}
				};
				var spriteSheet = new SpriteSheet(data);
				var sprite:Sprite = cast(tDO = new Sprite(spriteSheet, "normal"));
				sprite.framerate = 60 / 6;
				tDO.setBounds(0, 0, w, h);
				
			case FloorType.Elastic:
				tBody.shapes.add(new Polygon(Polygon.box(w, h)));//new Circle(r);
				var material = Material.rubber();
				material.elasticity = 2;
				tBody.setShapeMaterials(material);
				
				tBody.cbTypes.add(CB_TYPE_ELASTIC);
				
				tDO = new Bitmap(Manifest.BMP_FLOOR_ELASTIC);
				tDO.setBounds(0, 0, w, h);
			
			case FloorType.Normal:
				tBody.shapes.add(new Polygon(Polygon.box(w, h)));
				tBody.setShapeMaterials(Material.steel());
				
				tBody.cbTypes.add(CB_TYPE);
				
				tDO = new Bitmap(Manifest.BMP_FLOOR_NORMAL);
				tDO.setBounds(0, 0, w, h);
				
				var rand:Float = 0;
				for (i in 0...5) {
					rand += Math.random();
				}
				rand = rand / 5;
				
				tBody.angularVel = Math.PI * 0.25 * (rand - 0.5);
			
			case FloorType.Random:
		}
		
		tBody.position.setxy(x, y);
		tBody.space = G.space;
		
		super(tBody, tDO);
		
		this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, Player.COLLISION_GROUP));
		
		this.body.velocity.y = -60;
	}
}