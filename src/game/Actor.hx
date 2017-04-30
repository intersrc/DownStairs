package game ;
import createjs.easeljs.Container;
import createjs.easeljs.DisplayObject;
import nape.phys.Body;

/**
 * ...
 * @author wuyu
 */
class Actor {
	public var body:Body;
	public var container:Container;
	public var exists:Bool;
	public var linearDragX:Float = 1;
	public var linearDragY:Float = 1;

	public function new(body:Body, display:DisplayObject) {
		this.body = body;
		this.container = new Container();

		var tempX:Float = this.body.position.x;
		var tempY:Float = this.body.position.y;
		var tempRotation:Float = this.body.rotation;
		this.body.position.x = this.body.position.y = 0;
		this.body.rotation = 0;

		var centerX:Float = this.body.bounds.x + this.body.bounds.width / 2;
		var centerY:Float = this.body.bounds.y + this.body.bounds.height / 2;
		display.x = centerX - display.getBounds().width / 2;
		display.y = centerY - display.getBounds().height / 2;
		container.addChild(display);

		this.body.position.x = tempX;
		this.body.position.y = tempY;
		this.body.rotation = tempRotation;

		exists = true;

		update();
	}

	public function update():Void {
		if (exists) {
			container.x = body.position.x;
			container.y = body.position.y;

			if (body.allowRotation) {
				container.rotation = body.rotation * 180 / Math.PI;
			}

			if (linearDragX < 1) {
				body.velocity.x *= linearDragX;
			}
			if (linearDragY < 1) {
				body.velocity.y *= linearDragY;
			}
		}
	}

	public function destroy():Void {
		exists = false;
		if (body != null) {
			G.space.bodies.remove(body);
			body = null;
		}
		if (container != null) {
			if (container.parent != null) {
				container.parent.removeChild(this.container);
			}
			container = null;
		}
	}
}
