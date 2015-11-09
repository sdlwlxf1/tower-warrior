/**
* ...
* @author Jeff Fulton
* @version 0.1
*/

package com.lixuefeng.framework 
{
	import flash.display.*;
	import flash.events.*;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class FrameCounter extends Sprite{
		private var format:TextFormat=new TextFormat();
		private var framectrText:String;
		private var textColor:uint = 0xffffff;
		private var memoryUsedText:String;
		private var framectrTextField:TextField = new TextField();
		private var memoryUsed:TextField = new TextField();
		private var frameLast:int = getTimer();
		private var frameCtr:int = 0;	
		
		public var lastframecount:int = 0;
		public var showProfiledRate:Boolean = false;
		public var profiledRate:int;
		
		
		public function FrameCounter():void {
			
			format.size=12;
			format.font="Arial";
			format.color = String(textColor);
			format.bold = true;
			
			framectrText="0";
			framectrTextField.text=framectrText;
			framectrTextField.defaultTextFormat = format;
			framectrTextField.width=80;
			framectrTextField.height = 20;
			addChild(framectrTextField);
			
			memoryUsedText = "0";
			memoryUsed.text=memoryUsedText;
			memoryUsed.defaultTextFormat = format;
			memoryUsed.width=100;
			memoryUsed.height = 20;
			memoryUsed.x = 80;
			addChild(memoryUsed);
			
			
			
		}
	
		public function setTextColor(color:uint):void {
			format.color = String(color);
		}
		

		public function countFrames():Boolean {	
			
			frameCtr++;
	
			if (getTimer() >= frameLast + 1000) {
				lastframecount = frameCtr;
				if (showProfiledRate) {
					framectrText = frameCtr.toString() + "/" + profiledRate;
				}else{
					framectrText = frameCtr.toString();
				}
				framectrTextField.text =framectrText; 
				frameCtr = 0;
				frameLast = getTimer();
				
				memoryUsedText = String(System.totalMemory / 1024);
				//trace(memoryUsedText);
				memoryUsed.text=memoryUsedText+"kb";
				return(true);
			}else {
				
				return(false);
			}
			
		}
		
		
		
	} // end class

} // end package