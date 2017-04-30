package ;
import createjs.easeljs.Bitmap;
import createjs.easeljs.Container;
import createjs.easeljs.Text;
import createjs.soundjs.Sound;
import createjs.tweenjs.Tween;
import down.Floor;
import down.Player;
import game.Actor;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;

/**
 * ...
 * @author wuyu
 */
class Game extends Container {
	private var floorLayer:Container;
	private var floors:Array<Actor>;
	private var player:Player;
	
	private var layer:Text;
	
	private var createCd:Float = 0;
	private var createCdMax:Float = 2;
	
	public var exists:Bool;
	
	public function new() {
		super();
		
		floorLayer = new Container();
		this.addChild(floorLayer);
		
		floors = [];
		
		var floor = new Floor(G.stageWidth / 2, G.stageHeight - 48, FloorType.Normal);
		floorLayer.addChild(floor.container);
		floors.push(floor);
		
		var arrow = new Bitmap(Manifest.BMP_ARROW);
		this.addChild(arrow);
		
		player = new Player(G.stageWidth / 2, G.stageHeight / 2 - 128);
		player.container.alpha = 0;
		Tween.get(player.container).to( { alpha:1 }, 500);
		this.addChild(player.container);
		
		layer = new Text("00:00:00", "bold 24px Arial", "#FFF");
		layer.x = 4;
		layer.y = G.stageHeight - 24 - 4;
		this.addChild(layer);
		
		G.totalTime = 0;
		exists = true;
		
		G.space.listeners.add(new InteractionListener(
            CbEvent.BEGIN,
            InteractionType.COLLISION,
            Player.CB_TYPE,
            Floor.CB_TYPE_ELASTIC,
            function (cb:InteractionCallback):Void{
				Sound.play("elastic");
			}
        ));		
	}
	
	public function destory():Void {
		for (floor in floors) {
			if(floor != null){
				floor.destroy();
			}
		}
		player.destroy();
		floorLayer = null;
		floors = null;
		player = null;
		layer = null;
	}
	
	public function update(time:Float):Void {
		if(exists){
			G.totalTime += time;
			layer.text = G.stringTime(G.totalTime); //"L" + Math.floor(G.totalTime / 5);
			G.space.step(time);
			for (i in 0...floors.length) {
				var floor = floors[i];
				if (floor != null) {
					floor.update();
					if (floor.body.position.y < -floor.body.bounds.height) {
						floor.destroy();
						floors[i] = null;
					}
				}
			}
			if (player.exists) {
				player.update();
				if (player.body.position.y >= G.stageHeight || player.body.position.y <= 16 + 22) {
					player.die();
				}
			}
			
			createCd += time;
			if (createCd >= createCdMax) {
				createCd -= createCdMax;
				//createCd = 0;
				
				var floor = new Floor(Math.random() * G.stageWidth, G.stageHeight + 48/*8*/);
				floorLayer.addChild(floor.container);
				for (i in 0...floors.length + 1) {
					if (floors[i] == null) {
						floors[i] = floor;
						break;
					}
				}				
			}
		}
	}	
}