package org.gametack.util {
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class CustomTimer extends Timer {
		//vars
		public var id:String;
		
		//constructor
		public function CustomTimer(idStr:String, delay:Number, repeatCount:int = 0) {
			id = idStr;
			
			super(delay, repeatCount);
		}
		
		//public
		
		//private
	}
}