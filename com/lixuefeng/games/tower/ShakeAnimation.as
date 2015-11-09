package  com.lixuefeng.games.tower
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.events.Event;
	/**
	 * ...
	 * @author li xuefeng
	 */
	public class ShakeAnimation 
	{
		private var shaker_mc:DisplayObject;
		private var coordX:Number;
		private var coordY:Number;
		private var xoryExtend:int;
		private var rotationExtend:int;
		private var randExtend:int;
		private var timer:Timer = new Timer(10);
		
		public function ShakeAnimation(obj:DisplayObject, xoryExtend:int = 2, rotationExtend:int = 6, randExtend:int = 2) 
		{
			shaker_mc = obj;
			this.xoryExtend = xoryExtend;
			this.rotationExtend = rotationExtend;
			this.randExtend = randExtend;
			init();
			timer.addEventListener(TimerEvent.TIMER, shakeImage);
			
		}
		
		private function init():void {
			coordX = shaker_mc.x;
			coordY = shaker_mc.y;
		}
		

		public function startShake():void{
			timer.start();
		}

		public function stopShake():void{
			timer.stop();
			shaker_mc.x = coordX;
			shaker_mc.y = coordY;
			shaker_mc.rotation = 0;
		}

		private function shakeImage(event:TimerEvent):void {
			shaker_mc.x = coordX+ getMinusOrPlus()*(Math.random()*xoryExtend);
			shaker_mc.y = coordY+ getMinusOrPlus()*(Math.random()*xoryExtend);
			//shaker_mc.rotation = getMinusOrPlus()* Math.random()*rotationExtend;
		}

		private function getMinusOrPlus():int{
			var rand:Number = Math.random()*randExtend;
			if (rand<1) return -1
			else return 1;
		}

		
	}

}