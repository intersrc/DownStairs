package ;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;
import createjs.soundjs.Sound;

/**
 * ...
 * @author wuyu
 */
class Mute extends Container {

	public function new() {
		super();

		if (Sound.initializeDefaultPlugins()) {

			var normal:Array<Dynamic> = [0, 1, "normal"];
			var data = {
				images: [Manifest.BMP_MUTE],
				frames: {width:32, height:32, count:2},
				animations: {
					normal:normal
				}
			};
			var spriteSheet = new SpriteSheet(data);
			var sprite = new Sprite(spriteSheet, "normal");
			sprite.alpha = 0.49;
			sprite.x = G.stageWidth - 32 - 8;
			sprite.y = 8;

			sprite.gotoAndStop(Sound.getMute()?1:0);
			addChild(sprite);

			var bg = new Bitmap(Manifest.BMP_MUTE_BG);
			bg.x = sprite.x;
			bg.y = sprite.y;
			bg.alpha = 0.01;
			addChild(bg);

			bg.addEventListener("click", function():Void {
				Sound.setMute(!Sound.getMute());
				sprite.gotoAndStop(Sound.getMute()?1:0);
			} );
		}
	}
}
