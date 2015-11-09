package  com.lixuefeng.framework
{
	// Import necessary classes from the flash libraries
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class StatusScreen extends BasicScreen
	{
		//create text format objects for our various colors of text ( white)
		
		private var statusScreenElements:Object;
		
		//Constructor calls init() only
		public function StatusScreen() 
		{
			init();
		}
		
		
		private function init():void {
			
			statusScreenElements = {};
		}
		
		
		public function createElement(key:String, obj:StatusScreenElement):void {
			statusScreenElements[key] = obj;
			addChild(obj);			
		}
		
		//update() is called by Main after receiving a custom event from the Game class
		//1. two values are passed in:
		//2. key - represents the text name of the scoreBoard object to update ex: "score"
		//3. Value - representes the new value for the Object
		public function update(key:String, text:String = null, image:BitmapData = null):void {
			//trace("key=" + key);
			//trace("value=" + value);
			var tempElement:StatusScreenElement = statusScreenElements[key];
			if(text != null) {
				tempElement.setContentText(text);
			}
			if (image != null) {
				tempElement.setImageBD(image);
			}
			
		}
		
	}
	
}