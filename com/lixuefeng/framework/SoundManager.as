package com.lixuefeng.framework 
{
	// Import necessary classes from the flash libraries
	
	import flash.media.*;
	import flash.media.SoundMixer;

	/**
	 * ...
	 * @author Steve Fulton and Jeff Fulton
	 * Simplfied SoundManager
	 */
	public class SoundManager 
	{
	
		
				
		public var sounds:Array;		
		public var soundTrackChannel:SoundChannel=new SoundChannel();
		public var soundChannels:Array = []; 
		private var soundMute:Boolean = false; // added chapter 11
		public var tempSoundTransform:SoundTransform = new SoundTransform(); // changed chapter 11
		private var muteSoundTransform:SoundTransform = new SoundTransform(); 
		private var tempSound:Sound; //changed chapter 11
		
		public function SoundManager() 	{			
			
			sounds = new Array();
			
			
		}
			
		
		public function playSound(soundName:String, isSoundTrack:Boolean=false, loops:int=1, offset:Number=0, volume:Number=1):void{
			//trace("sound=" + snd);
			//var tsound:Object;
			
			tempSoundTransform.volume=volume;
			tempSound = sounds[soundName];
			
			if (isSoundTrack) {
				if (soundTrackChannel != null) {
					soundTrackChannel.stop();
				}
				soundTrackChannel = tempSound.play(offset,loops);								
				soundTrackChannel.soundTransform=tempSoundTransform;	
			}else {
				//trace("playing sound " + soundName);
				soundChannels[soundName] = tempSound.play(offset, loops);
			//trace("sndTransform=" + sndTransform);
				soundChannels[soundName].soundTransform=tempSoundTransform;		
			}
					
		}
		
		//*** funtion add chapter 12 for package structure
		public function addSound(soundName:String, sound:Sound):void {
			//trace("adding sound");
			sounds[soundName] = sound;
			
		}
		
		
		public function stopSound(soundName:String, isSoundTrack:Boolean = false):void {
			
			trace("stop sound");
			if (isSoundTrack) {
				trace("isSoundTrack");
				soundTrackChannel.stop();
			}else {
				trace("stopping sound");
				soundChannels[soundName].stop();
				
			}
			
			
		}
	
		
		//*** added chapter 11
		public function muteSound():void {
			//trace("sound manager got mute event");
			if (soundMute) {
				soundMute=false;
				muteSoundTransform.volume=1;
				SoundMixer.soundTransform=muteSoundTransform;
				//if (startMusicPlaying) playSound("startMusic", 2000, 1);
			}else{
				//flash.media.SoundMixer.stopAll();
				muteSoundTransform.volume=0;
				SoundMixer.soundTransform=muteSoundTransform;
				soundMute=true;
			}
		}
		//*** end added chapter 11
	}
	
}
