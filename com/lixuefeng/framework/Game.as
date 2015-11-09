package  com.lixuefeng.framework
{
	// Import necessary classes from the flash libraries
	import flash.display.MovieClip;
	//import com.efg.framework.CustomEventScoreBoardUpdate;
	//import com.efg.framework.CustomEventLevelScreenUpdate;
	
	/**
	 * ...
	 * @author Jeff Fulton
	 */
	public class Game extends MovieClip
	{
		//Create constants for simple custom events
		public static const GAME_OVER:String = "game over";
		public static const BACK_TO_TITLE:String = "back to title";
		public static const NEW_LEVEL:String = "new level";
		
		public var timeBasedUpdateModifier:Number = 40;
		public var frameRateMultiplier:Number = 1;
		public var lastScore:Number = 0;
		
		public var reload:Boolean = false;
		public var firstOpen:Boolean = true;
		public var backToTitle:Boolean = false;
		
		public var hasReload:Boolean;
		public var gameAllOver:Boolean;
	
		//Constructor calls init() only
		public function Game() {
			
			 // added chapter 11 
			//new chapter 11
			
		}
		
		public function setRendering(profiledRate:int, framerate:int):void {
			
		}
		
		public function initGame():void {
			
		}
	
		public function newGame():void {
			
		}
		
		
		public function reloadGame():void {
			
		}
		
		
		public function runGame():void {
			
		}
		
		public function overGame():void {
			
		}
		
		
		public function runGameTimeBased(paused:Boolean=false,timeDifference:Number=1):void {
			
		}
		
		
	}
	
}