package org.gametack.display {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Circle extends Sprite {
		//vars
		
		//constructor
		
		 /**
		  * Creates a circle.
		  * 
		  * @param	radius A number describing the circle's radius.
		  * @param	color A hex number (0x000000) describing the circle's background color. A value of -1 will make a circle with no background.
		  * @param	colorAlpha A number describing the alpha channel of the circle's background.
		  * @param	lineThickness A number describing the thickness of the circle's edge line. A value of zero will make a circle with no edge line.
		  * @param	lineColor A hex number (0x000000) describing the edge line's color. A value of -1 will make a circle with no edge line.
		  * @param	lineAlpha A number describing the alpha channel of the circle's edge line.
		  */
		public function Circle(radius:Number, color:int = -1, colorAlpha:Number = 1, lineThickness:Number = 0, lineColor:int = -1, lineAlpha:Number = 1) {
			if (radius < 1) {
				radius = 1;
			}
			
			if (lineThickness > 0 && !(lineColor < 0)) {
				graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			}
			
			if (!(color < 0)) {
				graphics.beginFill(color, colorAlpha);
			}
			
			graphics.drawCircle(radius, radius, radius);
			
			if (!(color < 0)) {
				graphics.endFill();
			}
		}
		
		//public
		
		//private
	}
}