package com.lixuefeng.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * 
	 * @author li xuefeng
	 */
	public class AnimationList extends Bitmap {
		
		protected var _animationDelay:int=3;
		private var _animationCount:int=0;
		protected var _animationLoop:Boolean=false;
		protected var _tileList:Array;
		protected var _currentTile:int;
		private var _loopCounter:int = 0; // counts the number of animation loops if useCounter is set to true;
		
	
		public function AnimationList(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {

			super(bitmapData, pixelSnapping, smoothing);
					
		}
		
		public function init(tileList:Array, currentTile:int) 
		{
			_tileList = tileList;
			_currentTile = currentTile;
			
			this.bitmapData = _tileList[_currentTile];
		}
		
		public function set tileList(tileList:Array):void 
		{
			_tileList = tileList;
			
		}
		
		public function set animationDelay(animationDelay:int):void 
		{
			_animationDelay = animationDelay;
		}
		
		public function set animationLoop(animationLoop:Boolean):void
		{
			_animationLoop = animationLoop;
		}
		
		public function set currentTile(currentTile:int):void
		{
			_currentTile = currentTile;
		}
		
		
		//更新当前图块，计循环数
		public function updateCurrentTile():void {
		
			if (_animationLoop) {
				if (_animationCount > _animationDelay) {
					_animationCount = 0;
					_currentTile++;
					if (_currentTile > _tileList.length - 1) {
						_currentTile = 0;
					}
				}
				_animationCount++;
			}
			else 
			{
				_currentTile = _tileList.length - 2;
			}

			this.bitmapData = _tileList[_currentTile];
			
		}
		
		
		
		public function dispose():void {
			this.bitmapData.dispose();
			_tileList = null;
		}
		
	}
	
}
