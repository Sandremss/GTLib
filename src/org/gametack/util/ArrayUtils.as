package org.gametack.util {
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class ArrayUtils {
		//vars
		
		//constructor
		public function ArrayUtils() {
			
		}
		
		//public
		public static function findArray(needle:*, haystack:Array, strict:Boolean = true, caseSensitive:Boolean = false):int {
			var i:uint;
			
			haystack = haystack.sort();
			
			if (strict) {
				if (caseSensitive || !(needle is String)) {
					for (i = 0; i < haystack.length; i++) {
						if (needle === haystack[i]) {
							return i;
						}
					}
					
					return -1;
				}else {
					for (i = 0; i < haystack.length; i++) {
						if (haystack[i] is String) {
							if (needle.toLocalLowerCase() == haystack[i].toLocalLowerCase()) {
								return i;
							}
						}
					}
					
					return -1;
				}
			}else {
				if (caseSensitive || !(needle is String)) {
					for (i = 0; i < haystack.length; i++) {
						if (needle == haystack[i]) {
							return i;
						}
					}
					
					return -1;
				}else {
					for (i = 0; i < haystack.length; i++) {
						if (haystack[i] is String) {
							if (needle.toLocaleLowerCase() == haystack[i].toLocaleLowerCase()) {
								return i;
							}
						}else {
							if (needle.toLocaleLowerCase() == String(haystack[i]).toLocaleLowerCase()) {
								return i;
							}
						}
					}
					
					return -1;
				}
			}
		}
		
		//private
	}
}