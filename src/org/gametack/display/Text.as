package org.gametack.display {
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Text {
		//vars
		public static const CENTER:String = TextFieldAutoSize.CENTER;
		public static const LEFT:String = TextFieldAutoSize.LEFT;
		public static const NONE:String = TextFieldAutoSize.NONE;
		public static const RIGHT:String = TextFieldAutoSize.RIGHT;
		
		//constructor
		public function Text() {
			
		}
		
		//public
		
		/**
		 * Creates a new TextField object.
		 * 
		 * @param font A string describing the text field's font type.
		 * @param color A hex number (0x000000) describing the color of the text.
		 * @param size A number describing the text's font size.
		 * @param autoSize A string describing the text's alignment.
		 * @param selectable A boolean dictating whether or not the text may be selected.
		 * @param multiline A boolean dictating whether or not to allow the use of multiline in the text field.
		 * @param input A boolean dictating whether or not to allow user input to the text field.
		 * 
		 * @return TextField A new TextField object.
		 */
		public static function makeText(font:String, color:uint, size:uint = 14, autoSize:String = LEFT, selectable:Boolean = false, multiline:Boolean = false):TextField {
			var text:TextField = new TextField();
			
			text.textColor = color;
			text.selectable = selectable;
			text.defaultTextFormat = new TextFormat(font, size);
			text.embedFonts = true;
			text.selectable = selectable;
			text.multiline = multiline;
			text.autoSize = autoSize;
			
			return text;
		}
		
		public static function makeInput(text:TextField, defaultText:String = null):TextField {
			text.type = TextFieldType.INPUT;
			
			if (defaultText) {
				text.text = defaultText;
				text.addEventListener(FocusEvent.FOCUS_IN, clearText);
			}
			
			return text;
		}
		
		/**
		 * Anti-alias a text field for readability.
		 * 
		 * @param text A TextField object.
		 * @param sharpness A number describing the text's sharpness. A value of 0 is recommended for custom fonts.
		 * 
		 * @return TextField The TextField object passed in.
		 */
		public static function makePretty(text:TextField, sharpness:Number = 0):TextField {
			text.antiAliasType = AntiAliasType.ADVANCED;
			if(sharpness > 255){
				text.sharpness = 255;
			}else if (sharpness < 0) {
				text.sharpness = 0;
			}else {
				text.sharpness = sharpness;
			}
			text.gridFitType = GridFitType.SUBPIXEL;
			
			return text;
		}
		
		/**
		 * Anti-alias a text field for animation.
		 * 
		 * @param text A TextField object.
		 * @param sharpness A number describing the text's sharpness. A value of 100 is recommended.
		 * 
		 * @return TextField The TextField object passed in.
		 */
		public static function makeFast(text:TextField, sharpness:Number = 100):TextField {
			text.antiAliasType = AntiAliasType.NORMAL;
			if(sharpness > 255){
				text.sharpness = 255;
			}else if (sharpness < 0) {
				text.sharpness = 0;
			}else {
				text.sharpness = sharpness;
			}
			text.gridFitType = GridFitType.NONE;
			
			return text;
		}
		
		//private
		private static function clearText(e:FocusEvent):void {
			e.target.removeEventListener(FocusEvent.FOCUS_IN, clearText);
			e.target.text = "";
		}
	}
}