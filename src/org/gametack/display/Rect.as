package org.gametack.display {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Rect extends Sprite {
		//vars
		
		//constructor
		
		/**
		 * Creates a new Sprite object with a rectangle in it. The rectangle's registration point is top-left.
		 * 
		 * @param rect A point describing the rectangle's width and height (from 0, 0)
		 * @param color A hex number (0x000000) describing the rectangle's background color. A value of -1 will make a rectangle with no background.
		 * @param colorAlpha A number describing the alpha channel of the rectangle's background.
		 * @param lineThickness A number describing the thickness of the rectangle's edge line. A value of zero will make a rectangle with no edge line.
		 * @param lineColor A hex number (0x000000) describing the edge line's color. A value of -1 will make a rectangle with no edge line.
		 * @param lineAlpha A number describing the alpha channel of the rectangle's edge line.
		 */
		public function Rect(rect:Point, color:int = -1, colorAlpha:Number = 1, lineThickness:Number = 0, lineColor:int = -1, lineAlpha:Number = 1) {
			if (lineThickness > 0) {
				if (lineColor < 0) {
					lineColor = 0xFFFFFF;
				}
				
				graphics.lineStyle(lineThickness, lineColor, lineAlpha);
			}
			
			if (!(color < 0)) {
				graphics.beginFill(color, colorAlpha);
			}
			
			graphics.drawRect(0, 0, rect.x, rect.y);
			
			if (!(color < 0)) {
				graphics.endFill();
			}
		}
		
		//public
		
		//private
	}
}