package  com.lixuefeng.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class BasicScreen extends Sprite {
				
		public var id:int;
		protected var backgroundBitmapData:BitmapData;
		protected var backgroundBitmap:Bitmap;
		public var imageBitmaps:Array = [];
		public var displayTexts:Array = [];
		public var simpleButtons:Array = [];
		
		public var imageBitmapsSeen:Array;
		public var imageBitmapsSeenId:int;
		
		
		public function BasicScreen(id:int = 0) {
			this.id = id;
		}
		
		public function setBackground(width:Number, height:Number, isTransparent:Boolean = true, color:uint = 0xffffffff):void 
		{

			backgroundBitmapData = new BitmapData(width, height, isTransparent, color);
			backgroundBitmap = new Bitmap(backgroundBitmapData);
			addChild(backgroundBitmap);
		}
		
		public function addImageBitmap(id:int, x:int, y:int, image:BitmapData):void 
		{
			var imageBitmap:Bitmap;
			imageBitmap = new Bitmap(image);
			imageBitmap.x = x;
			imageBitmap.y = y;
			addChild(imageBitmap);
			imageBitmaps[id] = imageBitmap;
		}
		

		public function setBackgroundBitmap(backgroundBD:BitmapData):void {
			backgroundBitmapData = backgroundBD;
			backgroundBitmap = new Bitmap(backgroundBD);
			addChild(backgroundBitmap);
		}
		
		
		public function createDisplayText(id:int,text:String, width:Number, x:Number, y:Number, textFormat:TextFormat = null):void {
			var displayText:TextField;
			displayText = new TextField();
			displayText.y = y;
			displayText.x = x;
			displayText.width = width;
			
			if (textFormat == null) {
				var tempTextFormat:TextFormat = new TextFormat();
				displayText.defaultTextFormat = tempTextFormat;
			}
			if (textFormat != null) {
				displayText.defaultTextFormat = textFormat;
			}
			
			displayText.text = text;
			addChild(displayText);
			displayTexts[id] = displayText;
		}
		
		public function createButton(id:int,x:Number,y:Number, offBackGroundBD:BitmapData = null ,overBackGroundBD:BitmapData = null, downBackGroundBD:BitmapData = null):void {
			var button:SimpleButton;
			button = new SimpleButton(id, 0, 0, offBackGroundBD, overBackGroundBD ,downBackGroundBD);
			button.y = y;
			button.x = x;
			addChild(button);
			simpleButtons[id] = button;
			button.addEventListener(MouseEvent.MOUSE_OVER, buttonOverListener, false, 0, true);
			button.addEventListener(MouseEvent.MOUSE_OUT, buttonOffListener, false, 0, true);
			button.addEventListener(MouseEvent.CLICK, buttonClickListener, false, 0, true);
		}
		
		public function removeSprite(sprite:*):void {
			this.removeChild(sprite);
		}
	
		
		public function changeDisplayText(id:int, text:String):void {
			displayTexts[id].text = text;
		}
		

		private function buttonClickListener(e:MouseEvent):void {
			dispatchEvent(new SimpleButtonEvent(SimpleButtonEvent.BUTTON_ID, e.target.id));
			e.target.state = SimpleButton.DOWN;
		}
		
		private function buttonOverListener(e:MouseEvent):void {
			e.target.changeBackGround(SimpleButton.OVER);
			e.target.state = SimpleButton.OVER;
		}
		
		private function buttonOffListener(e:MouseEvent):void {
			e.target.changeBackGround(SimpleButton.OFF);
			e.target.state = SimpleButton.OFF;
		}
		
		public function dispose():void 
		{
			
			var i:int;
			var length:int = imageBitmaps.length;
			for (i = 0; i <  length; i ++ ) {
				if(imageBitmaps[i] != null) {
					imageBitmaps[i].bitmapData.dispose();
				}
			}
			imageBitmaps = [];
			backgroundBitmapData.dispose();
			backgroundBitmap = null;
			
			displayTexts = [];
			simpleButtons = [];
		}
		
		public function disposeText():void 
		{
			displayTexts = [];
		}
		
	}

}