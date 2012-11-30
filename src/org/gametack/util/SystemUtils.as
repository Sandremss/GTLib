package org.gametack.util {
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import org.gametack.BaseClass;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class SystemUtils extends BaseClass {
		//vars
		private static var _resolution:Point;
		private static var _environment:String;
		private static var _arch:String;
		private static var _debugger:Boolean;
		private static var _mouse:Boolean;
		private static var _os:String;
		private static var _osVersion:String;
		private static var _version:Vector.<uint> = new Vector.<uint>;
		private static var _bits:uint = 0;
		private static var _touchPad:Boolean;
		
		//constructor
		public function SystemUtils() {
			
		}
		
		//public
		public function init():Boolean {
			var tempArray:Array = Capabilities.version.substr(3).split(",");
			
			_resolution = new Point(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
			_environment = Capabilities.playerType.toLocaleLowerCase();
			_arch = Capabilities.cpuArchitecture.toLocaleLowerCase();
			_debugger = Capabilities.isDebugger;
			_mouse = Mouse.supportsCursor;
			
			for (var i:uint = 0; i < tempArray.length; i++) {
				version[i] = uint(tempArray[i]);
			}
			
			_os = Capabilities.version.substr(0, 3).toLocaleLowerCase();
			if (_os == "mac") {
				_osVersion = Capabilities.os.substr(Capabilities.os.indexOf(" ", Capabilities.os.indexOf(" ")) + 1).toLocaleLowerCase();
			}else if (Capabilities.os.substr(0, Capabilities.os.indexOf(",") - 1).toLocaleLowerCase() == "iphone") {
				_tempArray = Capabilities.os.substr(Capabilities.os.indexOf(",") - 1).split(",");
				_osVersion = tempArray.join(".").toLocaleLowerCase();
			}else if (_os == "and") {
				_osVersion = "";
			}else {
				_osVersion = Capabilities.os.substr(Capabilities.os.indexOf(" ") + 1).toLocaleLowerCase();
			}
			
			if (Capabilities.supports32BitProcesses) {
				_bits = 32;
			}
			if (Capabilities.supports64BitProcesses) {
				_bits = 64;
			}
			
			_touchPad = (Capabilities.touchscreenType == "none") ? false : true
			
			return true;
		}
		
		public static function hasAudioBasics():Boolean {
			if (!Capabilities.hasAudio) {
				return false;
			}
			if (!Capabilities.hasAudioEncoder) {
				return false;
			}
			if (!Capabilities.hasMP3) {
				return false;
			}
			
			return true;
		}
		
		public static function hasVideoBasics():Boolean {
			if (!Capabilities.hasEmbeddedVideo) {
				return false;
			}
			if (!Capabilities.hasVideoEncoder) {
				return false;
			}
			
			return true;
		}
		
		public static function hasStreamBasics():Boolean {
			if (!Capabilities.hasStreamingAudio) {
				return false;
			}
			if (!Capabilities.hasStreamingVideo) {
				return false;
			}
			
			return true;
		}
		
		public static function get resolution():Point {
			return _resolution;
		}
		public static function get environment():String {
			return _environment;
		}
		public static function get arch():String {
			return _arch;
		}
		public static function get debugger():Boolean {
			return _debugger;
		}
		public static function get mouse():Boolean {
			return _mouse;
		}
		public static function get os():String {
			return _os;
		}
		public static function get osVersion():String {
			return _osVersion;
		}
		public static function get playerVersion():Vector.<uint> {
			return _version;
		}
		public static function get bits():uint {
			return _bits;
		}
		public static function get touchPad():Boolean {
			return _touchPad;
		}
		
		//private
	}
}