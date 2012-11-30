package org.gametack.util {
	import org.gametack.BaseClass;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class StringUtils extends BaseClass {
		//vars
		
		//constructor
		public function StringUtils() {
			
		}
		
		//public
		public static function trim(input:String):String {
			return input.replace(/^\s+/, "").replace(/\s+$/, "");
		}
		
		public static function find(haystack:String, needle:String, caseSensitive:Boolean = false):int {
			if(caseSensitive){
				return haystack.search(needle);
			}else {
				haystack = haystack.toLowerCase();
				return haystack.search(needle.toLowerCase());
			}
		}
		
		public static function findVector(needle:String, haystack:Vector.<String>, caseSensitive:Boolean = false):int {
			var i:uint;
			
			if (caseSensitive) {
				for (i = 0; i < haystack.length; i++) {
					if (needle == haystack[i]) {
						return i;
					}
				}
				
				return -1;
			}else {
				for (i = 0; i < haystack.length; i++) {
					if (needle.toLocaleLowerCase() == haystack[i].toLocaleLowerCase()) {
						return i;
					}
				}
				
				return -1;
			}
		}
		
		public static function parse(input:String, begin:String, end:String, caseSensitive:Boolean = false):String {
			var i:int;
			var j:int;
			
			if (caseSensitive) {
				i = input.indexOf(begin);
				j = input.indexOf(end, i);
				if (j == -1) {
					j = input.length;
				}
				
				if (i != -1) {
					return input.substring(i + begin.length, j);
				}else {
					return null;
				}
			}else {
				input = input.toLowerCase();
				i = input.indexOf(begin.toLowerCase());
				j = input.indexOf(end.toLowerCase(), i);
				if (j == -1) {
					j = input.length;
				}
				
				if (i != -1) {
					return input.substring(i + begin.length, j);
				}else {
					return null;
				}
			}
		}
		
		//private
	}
}