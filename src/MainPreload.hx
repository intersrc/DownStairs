package ;

import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Stage;
import createjs.easeljs.Text;
import createjs.Ticker;
import createjs.preloadjs.LoadQueue;
import createjs.soundjs.Sound;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Node;
import js.Lib;

/**
 * ...
 * @author wuyu
 */

class MainPreload {	
	static function main() {
		Common.autoSize();
		var stageWidth = Common.stageWidth;
		var stageHeight = Common.stageHeight;
		
		var canvas:CanvasElement = cast Browser.document.getElementById( "mainCanvas" );
		var stage = new Stage( canvas );
		
		//Preload & Destroy
		var targetJs:String = if (canvas.dataset == null) {
			canvas.getAttribute("data-target");
		}
		else {
			canvas.dataset.target;
		}
		
		var preload = new LoadQueue();
		
		var manifest = [
			{ id: "BMP_PLAYER", src: Manifest.BMP_PLAYER },
			{ id: "BMP_FLOOR_NORMAL", src: Manifest.BMP_FLOOR_NORMAL },
			{ id: "BMP_FLOOR_ELASTIC", src: Manifest.BMP_FLOOR_ELASTIC },
			{ id: "BMP_FLOOR_CONVEYER", src: Manifest.BMP_FLOOR_CONVEYER },
			{ id: "BMP_ARROW", src: Manifest.BMP_ARROW },
			{ id: "BMP_LEFT", src: Manifest.BMP_LEFT },
			{ id: "BMP_RIGHT", src: Manifest.BMP_RIGHT },
			{ id: "BMP_MUTE", src: Manifest.BMP_MUTE },
			{ id: "BMP_MUTE_BG", src: Manifest.BMP_MUTE_BG },
			{ id: targetJs, src: targetJs }
		];
		
		if (Sound.initializeDefaultPlugins()) {
			manifest.push( { id: "elastic", src: Manifest.SND_ELASTIC } );
			manifest.push( { id: "die", src: Manifest.SND_DIE } );
		}
		
		var messageField:Text = new Text("Loading", "bold 24px Arial", "#FFFFFF");
		messageField.maxWidth = 1000;
		messageField.textAlign = "center";
		messageField.x = stageWidth / 2;
		messageField.y = stageHeight / 2 - 48;
		stage.addChild(messageField);
		stage.update();
		
		var blocks:Array<Container> = [];
		for (i in 0...20) {
			var bmp:Bitmap = new Bitmap("./assets/block_0.png");
			bmp.x = -8;
			bmp.y = -8;
			var block:Container = new Container();
			block.addChild(bmp);
			block.x = stageWidth / 2 - 10 * 16 + i * 16 + 8;
			block.y = (stageHeight - 16) / 2 + 8 + 16;
			block.visible = false;
			blocks[i] = block;
			stage.addChild(block);
		}
		var time:Float;
		function update(event):Void {
			time = event.delta / 1000;
			
			for (i in 0...20) {
				if (blocks[i].visible && (blocks[i + 1] == null || !blocks[i + 1].visible)) {
					blocks[i].rotation += 360 * time;
				}
				else {
					blocks[i].rotation = 0;
				}
			}
			
			stage.update(event);
		}
		Ticker.addEventListener("tick", update);
		Ticker.timingMode = Ticker.TIMEOUT;
		Ticker.setFPS(60);
		
		function updateLoading() {
			var percentStr:String = Std.string(Math.floor(preload.progress * 1000) / 10);
			if (percentStr.indexOf(".") == -1) {
				percentStr += ".0";
			}
			messageField.text = "Loading " + percentStr + "%";
			
			var n:Int = Math.ceil(preload.progress * 20);
			for (i in 0...n) {
				blocks[i].visible = true;
			}
			
			stage.update();
		}
		
		var scripts:Array<Node> = [];
		function doneLoading(event) {
			stage.removeAllChildren();
			for (script in scripts) {
				Browser.document.body.appendChild(script);
			}
		}
		
		function handleFileLoaded(event) {
            var item = event.item;
            var id = item.id;
            var result = event.result;
			
			if (item.type == LoadQueue.JAVASCRIPT) {
				scripts.push(result);
			}
		}
		
        preload.installPlugin(Sound);
		preload.addEventListener("complete", doneLoading);
        preload.addEventListener("progress", updateLoading);
		preload.addEventListener("fileload", handleFileLoaded);
	    preload.loadManifest(manifest);		
	}	
}