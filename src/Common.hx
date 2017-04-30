package ;
import js.Browser;
import js.html.CanvasElement;
import js.html.DivElement;

/**
 * ...
 * @author wuyu
 */
class Common
{

	public static inline var stageWidth:Int = 320;
	public static inline var stageHeight:Int = 568;

	public static function autoSize():Void
	{
		//auto size
		var canvas:CanvasElement = cast Browser.document.getElementById( "mainCanvas" );

		canvas.style.width = (canvas.width = stageWidth) + "px";
		canvas.style.height = (canvas.height = stageHeight) + "px";
		var div:DivElement = cast Browser.document.getElementById( "mainDiv" );
		div.style.position = "absolute";
		div.style.left = "50%";
		div.style.top = "50%";
		div.style.width = canvas.style.width;
		div.style.height = canvas.style.height;
		div.style.marginLeft = -stageWidth / 2 + "px";
		div.style.marginTop = -stageHeight / 2 + "px";
	}
}
