package ;

import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Text;
import createjs.tweenjs.Ease;
import createjs.tweenjs.Tween;

/**
 * ...
 * @author wuyu
 */
class Menu extends Container {	
	public static var first:Bool = true;
	
	public function new(endCallback:Void->Void) {
		super();
		
		var background = new Shape();
		background.graphics.beginFill("#000");
		background.graphics.drawRect(0, 0, G.stageWidth, G.stageHeight);
		background.graphics.endFill();
		background.alpha = 0.5;
		background.cache(0, 0, G.stageWidth, G.stageHeight);
		addChild(background);
		
		if (first) {
			first = false;
			//点击开始
			//左右
			var text = new Text("点击开始", "48px 黑体", "#FFFFFF");
			text.textAlign = "center";
			text.lineHeight = 64;
			text.x = (G.stageWidth) / 2;
			text.y = (G.stageHeight - text.getBounds().height) / 2;
			addChild(text);
			
			var gap_big:Int = Std.int(((G.stageWidth / 2) - 96) / 2);
			var gap_mid:Int = Std.int(gap_big / 2);
			var shape:Shape = new Shape();
			var size_rect = (G.stageWidth - gap_mid * 4) / 2;
			var size_shape = gap_mid + size_rect + gap_mid;
			shape.graphics.beginFill("rgba(255, 255, 255, 0.25)");
			shape.graphics.drawRoundRect(gap_mid, gap_mid, size_rect, size_rect, gap_mid);
			shape.graphics.drawRoundRect(G.stageWidth / 2 + gap_mid, gap_mid, size_rect, size_rect, gap_mid);
			shape.graphics.endFill();
			shape.y = G.stageHeight - size_shape;
			shape.cache(0, 0, G.stageWidth, size_shape);
			addChild(shape);
			var left = new Bitmap(Manifest.BMP_LEFT);
			left.x = gap_big;
			left.y = shape.y + gap_big;
			left.alpha = 0.5;
			addChild(left);
			var right = new Bitmap(Manifest.BMP_RIGHT);
			right.x = G.stageWidth / 2 + gap_big;
			right.y = shape.y + gap_big;
			right.alpha = 0.5;
			addChild(right);
			
			background.addEventListener("click", function(event) {
				endCallback();
			});
		}
		else {
			//分数
			//分享
			var text = new Text("你坚持了\n" + G.stringTime(G.totalTime), "48px 黑体", "#FFFFFF");
			text.textAlign = "center";
			text.lineHeight = 64;
			text.x = (G.stageWidth) / 2;
			text.y = (G.stageHeight - text.getBounds().height) / 2;
			text.addEventListener("click", function(event) {
				endCallback();
			});
			addChild(text);
			
			background.addEventListener("click", function(event) {
				endCallback();
			});
			
			this.y = -G.stageHeight;
			Tween.get(this)
				 .to( { y:0 }, 1000, Ease.bounceOut );
		}
	}
	
	public function destroy():Void {
		
	}
}