package  com.lixuefeng.framework
{
	
	/**
	 * ...
	 * @author li xuefeng
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class SimpleButton extends Sprite
	{
		public static const OFF:int = 1;
		public static const OVER:int = 2;
		public static const DOWN:int = 3;

		private var offBackGroundBD:BitmapData;
		private var overBackGroundBD:BitmapData;
		private var downBackGroundBD:BitmapData;
		
		private var positionOffset:Number;
		private var buttonBackGroundBitmap:Bitmap;
		private var buttonTextBitmapData:BitmapData;
		private var buttonTextBitmap:Bitmap;
		
		public var id:int;
		
		public var state:int;
		
		
		public function SimpleButton(id:int, x:Number = 0, y:Number = 0, offBackGroundBD:BitmapData  = null ,overBackGroundBD:BitmapData = null, downBackGroundBD:BitmapData = null) 
		{
			this.id = id;
			this.x = x;
			this.y = y;
			
			
			this.offBackGroundBD = offBackGroundBD;

			this.overBackGroundBD = overBackGroundBD;
			
			this.downBackGroundBD = downBackGroundBD;
				
			//background

			buttonBackGroundBitmap = new Bitmap(offBackGroundBD);
						
			addChild(buttonBackGroundBitmap);			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			
		}
		
		public function setText(text:String = null, textformat:TextFormat = null, positionOffset:Number = 0)
		{
			//text
			this.positionOffset = positionOffset;
			var tempText:TextField = new TextField();
			tempText.text = text;
			if(textformat != null) {
				tempText.setTextFormat(textformat);
			}
			
			buttonTextBitmapData  = new BitmapData(tempText.textWidth+positionOffset,tempText.textHeight+positionOffset, true, 0x00000000);
			buttonTextBitmapData.draw(tempText);
			buttonTextBitmap = new Bitmap(buttonTextBitmapData);
	
			buttonTextBitmap.x = ((buttonBackGroundBitmap.width - int(tempText.textWidth))/2)-positionOffset;
			buttonTextBitmap.y = ((buttonBackGroundBitmap.height - int(tempText.textHeight))/2)-positionOffset;
		
			addChild(buttonTextBitmap);
		}
		
		
		public function changeBackGround(typeval:int):void {
			if (typeval == OFF) {
				buttonBackGroundBitmap.bitmapData = offBackGroundBD;
			}else if (typeval == OVER){
				buttonBackGroundBitmap.bitmapData = offBackGroundBD;
			} else if (typeval == DOWN) {
				buttonBackGroundBitmap.bitmapData = offBackGroundBD;
			}
		}
		
		
	}

}