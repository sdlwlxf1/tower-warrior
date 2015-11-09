package  com.lixuefeng.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author lixuefeng
	 */
	public class StatusScreenElement extends Sprite
	{
		private var content:TextField;
		private var imageBitmap:Bitmap;
		private var bufferWidth:Number;
		
		
		public function StatusScreenElement(x:Number, y:Number,contentText:String = null, contentTextFormat:TextFormat = null, imageBD:BitmapData = null) {
			this.x = x;
			this.y = y;
			
			if (contentText != null && contentTextFormat != null) {
				content = new TextField();
				content.autoSize;
				content.defaultTextFormat = contentTextFormat;
				content.text = contentText;
				addChild(content);			
			}
			
			if (imageBD != null) {
				imageBitmap = new Bitmap(imageBD);
				addChild(imageBitmap);
			}
		}
		
		public function setContentText(str:String):void {
			content.text = str;
		}
		
		public function setImageBD(imageBD:BitmapData):void {
			imageBitmap.bitmapData = imageBD;
		}
	}
	
}