package com.lixuefeng.framework
{
	import flash.net.SharedObject;
	
	public class SCookie {

		public function SCookie() {
			
		}
	    
		static public function setCookie(cookieName:String,propertyName:String,value:Object){
			var so:SharedObject = SharedObject.getLocal(cookieName, "/");
			so.data[propertyName] = value;
			so.flush()
		}
		
		public static function getCookie(cookieName:String,propertyName:String )
		{ 
            var so:SharedObject = SharedObject.getLocal(cookieName, "/");
			//trace("cookie size is "+so.size)
			return so.data[propertyName]
			
		}
		
         public static function clearCookie(clearedCookieName:String )
		{ 
            var so:SharedObject = SharedObject.getLocal(clearedCookieName, "/");
			so.clear()
			
		}
		

	}
	
}
