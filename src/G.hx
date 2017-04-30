package ;
import createjs.easeljs.Stage;
import nape.space.Space;

/**
 * ...
 * @author wuyu
 */
class G {

	public static var stageWidth:Int;
	public static var stageHeight:Int;

	public static var stage:Stage;

	public static var space:Space;

	public static var game:Game;
	public static var totalTime:Float = 0;

	public static function stringTime(seconds:Float):String {
		var h:Int = Math.floor(seconds / 3600);
		seconds -= h * 3600;
		var m:Int = Math.floor(seconds / 60);
		seconds -= m * 60;
		var s:Int = Math.floor(seconds);
		return addZero(h) + ":" + addZero(m) + ":" + addZero(s);
	}

	private static function addZero(i:Int):String {
		if (i < 10) {
			return "0" + i;
		}
		else {
			return Std.string(i);
		}
	}

	public static var menu:Menu;
	public static var reset:Void->Void;
}
