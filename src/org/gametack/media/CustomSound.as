package org.gametack.media {
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class CustomSound extends Sound {
		//vars
		private var _id:String;
		
		//constrcutor
		public function CustomSound(id:String, stream:URLRequest = null, context:SoundLoaderContext = null) {
			_id = id;
			
			super(stream, context);
		}
		
		//public
		public function get id():String {
			return _id;
		}
		public function set id(idStr:String):void {
			_id = idStr;
		}
		
		//private
	}
}