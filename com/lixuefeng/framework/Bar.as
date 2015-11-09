package com.lixuefeng.framework 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class Bar extends Sprite{
			
		public var beMaskImage:Bitmap;
		private var lastBeMaskImage:BitmapData;
		public var outSide:Bitmap;
		private var changeBitmap:Bitmap;
		public var changeSprite:Sprite;
		
		public var vLength:Number = 0;
		public var aLength:Number = 0;
		public var nextLength:Number;
		
		private var coltransForm:ColorTransform = new ColorTransform(1, 1, 1, 1, -2.5, -1, -1, 0);
		private var rect:Rectangle;
		
		public function Bar(beMaskImageB:BitmapData, outSideB:BitmapData, changeB:BitmapData) {
			this.beMaskImage = new Bitmap(beMaskImageB);
			lastBeMaskImage = beMaskImageB.clone();
			this.outSide = new Bitmap(outSideB);
			this.changeBitmap = new Bitmap(changeB);
			changeBitmap.x = -.5 * changeBitmap.width;
			changeBitmap.y = -1 * changeBitmap.height;
			changeSprite = new Sprite;
			changeSprite.addChild(changeBitmap);
			
			changeSprite.x = .5 * changeBitmap.width;
			changeSprite.y = outSide.height;
			this.addChild(changeSprite);
			beMaskImage.x = 0;
			beMaskImage.y = 0;
			this.addChild(beMaskImage);
			beMaskImage.mask = changeBitmap;
			outSide.x = 0;
			outSide.y = 0;
			this.addChild(outSide);

		}
		
		public function updata():void {

			nextLength = changeSprite.height;
			vLength += aLength;
			nextLength += vLength;
			
		}
		
		public function stopUpdata(_vLength:Number = 0, _aLength:Number = 0) {
			vLength = _vLength;
			aLength = _aLength;
		}
		
		public function render():void {
			rect = new Rectangle(beMaskImage.x, beMaskImage.y, beMaskImage.width, beMaskImage.height);
			beMaskImage.bitmapData.colorTransform(rect, coltransForm); 
			changeSprite.height = nextLength;
		}
		
		public function resetRender(_nextLength:Number = 0):void {
			nextLength = _nextLength;
			beMaskImage.bitmapData = lastBeMaskImage.clone();
			changeSprite.height = nextLength;
		}
		
		public function checkTheEnd(distanceHeight:int = 0 ):Boolean {
			if (changeSprite.height >= outSide.height + distanceHeight) {
				return true;
			} else {
				return false;
			}
		}
		
		public function heightPercent(distanceHeight:int = 0 ):Number 
		{
			return changeSprite.height / (outSide.height + distanceHeight) * 100;
		}

	}
	
}
