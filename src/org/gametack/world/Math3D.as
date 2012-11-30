package org.gametack.world {
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Math3D {
		//vars
		
		//constructor
		public function Math3D() {
			
		}
		
		//public
		public static function toRads(degrees:Number):Number {
			return degrees / (180 / Math.PI);
		}
		public static function toDegrees(rads:Number):Number {
			return rads * (180 / Math.PI);
		}
		
		public static function getRads(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			return Math.atan2(y1 - y2, x1 - x2);
		}
		
		public static function radsToX(rads:Number):Number {
			return Math.cos(rads);
		}
		public static function radsToY(rads:Number):Number {
			return Math.sin(rads);
		}
		
		public static function recalDegrees(degrees:Number):Number {
			while (degrees >= 360) {
				degrees -= 360;
			}
			while (degrees < 0) {
				degrees += 360;
			}
			
			return degrees;
		}
		
		//private
	}
}