package  com.lixuefeng.games.tower
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class Test extends Sprite
	{
		
		public function Test() 
		{
			var image:Bitmap = new Bitmap(new TestImage(0, 0));
			var imageSprite:Sprite = new Sprite;
			imageSprite.addChild(image);
			addChild(imageSprite);
			var shakeAnimation:ShakeAnimation  = new ShakeAnimation(this);
			shakeAnimation.startShake();
		}
		
	}

}