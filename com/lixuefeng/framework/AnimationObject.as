package com.lixuefeng.framework
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 动画对象
	 * @author S_eVent
	 * 
	 */
	public class AnimationObject extends Bitmap
	{
		public static const PLAY_OVER_EVENT:String = "play over event";

		/** 当前播放的动画的图片序列 */
		private var _currentImgList:Array;

		/** 存储所有关键帧 */
		private var _frames:Array = new Array();

		private var _timer:Timer = new Timer(70);
		private var _currentIndex:int = 0;
		private var _currentFrame:*;
		private var _stopIndex:int = 0;
		public var start:Boolean = false;

		public function AnimationObject(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}
		
		/**
		 * 设置某一帧的动画 
		 * @param frame帧号或帧名
		 * @param imgList要在该帧播放的动画图片序列
		 * 
		 */
		public function setFrame( frame:*, imgList:Array ):void
		{
			if ( frame is int || frame is String )
			{
				_frames[frame] = imgList;
			}
		}
		
		public function setcurrentImgList(imgList:Array):void 
		{
			_currentImgList = imgList;
			this.bitmapData = _currentImgList[_currentIndex];
			
		}
		
		public function get currentImgList():Array
		{
			return _currentImgList;
		}


		/**
		 * 播放动画 
		 * 
		 */
		public function play():void
		{
			_timer.reset();
			_timer.start();
			start = true;
		}

		/**
		 * 停止动画 
		 * 
		 */
		public function stop():void
		{

			_timer.stop();
			_currentIndex = _stopIndex;
			this.bitmapData = _currentImgList[_currentIndex];
			start = false;
		}

		/**
		 * 跳到某一帧
		 * @param frame帧数或帧名
		 * 
		 */
		public function gotoFrame( frame:* ):void
		{
			if ( frame is int || frame is String )
			{
				_currentImgList = _frames[frame];
				if ( _currentImgList && _currentImgList.length > 0 )
				{
					_currentFrame = frame;
					_currentIndex = _stopIndex;
					this.bitmapData = _currentImgList[_currentIndex];
				}
			}
		}
		
		public function get currentFrame():*
		{
			return _currentFrame;
		}
		
		public function set currentIndex(i:int):void
		{
			_currentIndex = i;
		}
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}


		/**
		 * 设置动画帧率 
		 * @param value 多少时间切换一副图片，单位毫秒
		 * 
		 */
		public function set frameRate( value:int ):void
		{
			_timer.delay = value;
		}

		/**
		 * 设置动画播放次数 ，若为0，则不断运行，默认为0
		 * @param value 动画播放次数，单位：次
		 * 
		 */
		public function set repeatCount( value:int ):void
		{
			_timer.repeatCount = value * _currentImgList.length;
		}

		/**
		 * 设置静止时动画所处帧 
		 * @param value
		 * 
		 */
		public function set stopIndex( value:int ):void
		{
			_stopIndex = value;
			_currentIndex = _stopIndex;
			this.bitmapData = _currentImgList[_stopIndex];
		}

		private function onTimer(event:TimerEvent):void
		{


			_currentIndex++;

			this.bitmapData = _currentImgList[_currentIndex];

			if ( _currentIndex > _currentImgList.length - 1)
			{

				_currentIndex = _stopIndex;

				this.bitmapData = _currentImgList[_stopIndex];

				dispatchEvent( new Event(PLAY_OVER_EVENT) );

			}

		}
	}
}