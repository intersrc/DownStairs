package ;

import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Stage;
import createjs.Ticker;
import down.Floor;
import down.Player;
import game.Actor;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;
import js.Lib;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

/**
 * ...
 * @author wuyu
 */

class Main {
	
	static function main() {
		Common.autoSize();
		G.stageWidth = Common.stageWidth;
		G.stageHeight = Common.stageHeight;
		
		/**
		* mainStage
		*/
		var stage = new Stage( cast Browser.document.getElementById( "mainCanvas" ) );
		//stage.snapToPixelsEnabled = true;
		G.stage = stage;
		
		//From here
		var gravity = Vec2.weak(0, 600);
        G.space = new Space(gravity);
		
		var mute = new Mute();
		
		G.reset = function() {
			if (G.game != null) {
				G.game.destory();
				G.stage.removeChild(G.game);
				G.game = null;
			}
			G.menu = new Menu(function():Void {
				//menu
				G.menu.destroy();
				G.stage.removeChild(G.menu);
				G.menu = null;
				//game
				G.game = new Game();
				G.stage.addChild(G.game);
				G.stage.addChild(mute);
			} );
			G.space.listeners.clear();
			G.stage.addChild(G.menu);
			G.stage.addChild(mute);
		}
		G.reset();
		
		var time:Float;
		function update(event):Void {
			time = event.delta / 1000;
			if (G.game != null) {
				G.game.update(time);
			}
			G.stage.update(event);
		}
		
		/*
		* createjs
		*/
		Ticker.addEventListener("tick", update);
		//Ticker.timingMode = Ticker.TIMEOUT;
		Ticker.setFPS(60);
	}	
}