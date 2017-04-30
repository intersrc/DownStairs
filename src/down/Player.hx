package down;

import createjs.easeljs.DisplayObject;
import createjs.easeljs.Shape;
import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Touch;
import createjs.soundjs.Sound;
import createjs.tweenjs.Tween;
import game.Actor;
import nape.callbacks.CbType;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Polygon;

/**
 * ...
 * @author wuyu
 */
class Player extends Actor {

	public static inline var COLLISION_GROUP:Int = 4;
	public static var CB_TYPE:CbType = new CbType();
	
	private static inline var IMPULSE:Int = 12;
	private static inline var DRAG:Float = 0.96;
	private static inline var RADIUS:Int = 16;
	private var mousePressed:Bool = false;
	private var facingLeft:Bool;
	private var sprite:Sprite;
	
	public function new(x:Float, y:Float) {
		var w = 16;// 24;//16;
		var h = 44;// 56;//44;
		var frameSize = 48;// 64;
		var rect = new Body(BodyType.DYNAMIC);
		rect.shapes.add(new Polygon(Polygon.box(w, h)));
		rect.position.setxy(x, y);
		rect.allowRotation = false;
		rect.setShapeMaterials(Material.wood());
		rect.space = G.space;
		var right_run:Array<Dynamic> = [0, 3, "right_run"];
		var right_stand:Array<Dynamic> = [0, 0, "right_stand"];
		var right_jump:Array<Dynamic> = [3, 3, "right_jump"];
		var left_run:Array<Dynamic> = [4, 7, "left_run"];
		var left_stand:Array<Dynamic> = [4, 4, "left_stand"];
		var left_jump:Array<Dynamic> = [7, 7, "left_jump"];
		var data = {
			images: [Manifest.BMP_PLAYER],
			frames: {width:frameSize, height:frameSize, count:8},
			animations: {
				right_run:right_run, right_stand:right_stand, right_jump:right_jump,
				left_run:left_run, left_stand:left_stand, left_jump:left_jump
			}
		};
		var spriteSheet = new SpriteSheet(data);
		sprite = new Sprite(spriteSheet, "right_jump");
		sprite.framerate = 60 / 6;
		sprite.setBounds(0, 0, frameSize, frameSize + (frameSize - h));
		super(rect, sprite);
		
		this.linearDragX = DRAG;
		
		this.body.setShapeFilters(new InteractionFilter(COLLISION_GROUP, Floor.COLLISION_GROUP));
		this.body.cbTypes.add(CB_TYPE);
		
		// enable touch interactions if supported on the current device:
		Touch.enable(G.stage);
		// enabled mouse over / out events
		//G.stage.enableMouseOver(10);
		
		G.stage.addEventListener("stagemousedown", onMouseDown);
		G.stage.addEventListener("stagemouseup", onMouseUp);
		
	}
	
	private function onMouseDown(e):Void {
		mousePressed = true;
	}
	
	private function onMouseUp(e):Void {
		mousePressed = false;
	}
	
	override public function destroy():Void {
		super.destroy();
		
		sprite = null;
		
		G.stage.removeEventListener("stagemousedown", onMouseDown);
		G.stage.removeEventListener("stagemouseup", onMouseUp);
		
	}
	
	public function die():Void {		
		if(exists){
			exists = false;
			
			Tween.get(container)
				.to( { alpha:0, visible:false, rotation:this.container.rotation + 360 * 2, scaleX:2, scaleY:2 }, 500)
				.call(G.reset);
			
			Sound.play("die");
		}
	}
	
	override public function update():Void {
		super.update();
		
		if(exists){
			
			if (mousePressed && G.stage.mouseY > 48) {
				/*if (G.stage.mouseX < this.body.position.x) {
					facingLeft = true;
				}
				else if (G.stage.mouseX > this.body.position.x) {
					facingLeft = false;
				}*/
				
				if (G.stage.mouseX < G.stageWidth / 2) {
					facingLeft = true;
				}
				else if (G.stage.mouseX > G.stageWidth / 2) {
					facingLeft = false;
				}
				this.body.applyImpulse(Vec2.weak(facingLeft? -IMPULSE : IMPULSE, 0));
			}
			
			if (Math.abs(this.body.velocity.x) > 2) {
				if (facingLeft) {
					if (sprite.currentAnimation != "left_run") { 
						sprite.gotoAndPlay("left_run");
					}
				}
				else{
					if (sprite.currentAnimation != "right_run") { 
						sprite.gotoAndPlay("right_run");
					}
				}
			}
			else {
				if (facingLeft) {
					if (sprite.currentAnimation != "left_stand") { 
						sprite.gotoAndPlay("left_stand");
					}
				}
				else {
					if (sprite.currentAnimation != "right_stand") { 
						sprite.gotoAndPlay("right_stand");
					}
				}
			}
			
			if (this.body.position.x < RADIUS) {
				this.body.position.x = RADIUS;
			}
			else if (this.body.position.x > G.stageWidth - RADIUS) {
				this.body.position.x = G.stageWidth - RADIUS;
			}			
		}
	}
}