package org.gametack.display {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import org.gametack.display.Text;
	import org.gametack.display.Rect;
	
	/**
	 * ...
	 * @author Alexander
	 * 
	 * Most inefficient class ever.
	 */
	
	public class GameMenu extends Sprite {
		//vars
		private static var _link:Vector.<String> = new Vector.<String>;
		private static var _list:Dictionary = new Dictionary();
		private static var _display:Vector.<TextField> = new Vector.<TextField>;
		private var _seperators:Vector.<Sprite> = new Vector.<Sprite>;
		
		private static var _background:Sprite;
		private var _visible:Boolean = false;
		
		private static var _backgroundColor:uint;
		private static var _backgroundAlpha:Number;
		private static var _backgroundBorderColor:uint;
		private static var _backgroundBorderAlpha:Number;
		private static var _font:String;
		private static var _fontColor:uint;
		private var _seperatorColor:uint;
		
		//constructor
		public function GameMenu() {
			tabEnabled = tabChildren = false;
		}
		
		//public
		public function init(font:String, backgroundColor:uint = 0x0080FF, backgroundAlpha:Number = 0.2, backgroundBorderColor:uint = 0xCCCCCC, backgroundBorderAlpha:Number = 1, fontColor:uint = 0xCCCCCC, seperatorColor:uint = 0xFFFFFF):void {
			_backgroundColor = backgroundColor;
			_backgroundAlpha = backgroundAlpha;
			_backgroundBorderColor = backgroundBorderColor;
			_backgroundBorderAlpha = backgroundBorderAlpha;
			_font = font;
			_fontColor = fontColor;
			_seperatorColor = seperatorColor;
			
			_background = new Rect(new Point(0, 0), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
		}
		
		public static function addItem(text:String, call:Function, position:int = -1):void {
			var displayText:TextField = Text.makeText(_font, _fontColor, 16);
			var tempLink:String;
			var tempDisplay:TextField;
			
			displayText.text = text;
			displayText = Text.makePretty(displayText, 255);
			
			for (var i:uint = 0; i < _link.length; i++) {
				if (text == _link[i]) {
					return;
				}
			}
			
			if (displayText.textWidth > _background.width - 10) {
				_background = new Rect(new Point(displayText.textWidth + 10, _background.height + displayText.textHeight), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
			}else {
				_background = new Rect(new Point(_background.width, _background.height + displayText.textHeight), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
			}
			
			_list[text.toLocaleLowerCase()] = call;
			
			if (position < 0 || position > _link.length) {
				_link[_link.length] = text;
				_display[_display.length] = displayText;
			}else {
				while (position < _link.length) {
					tempLink = _link[position];
					tempDisplay = _display[position];
					
					_link[position] = text;
					_display[position] = displayText;
					
					text = tempLink;
					displayText = tempDisplay;
					
					position++;
				}
				
				if (tempLink) {
					_link[_link.length] = tempLink;
					_display[_display.length] = tempDisplay;
				}else {
					_link[_link.length] = text;
					_display[_display.length] = displayText;
				}
			}
		}
		public static function removeItem(text:String, caseSensitive:Boolean = false):void {
			_background = new Rect(new Point(0, 0), 0x0080FF, 0.2, 1, 0xCCCCCC);
			
			_list[text.toLocaleLowerCase()] = undefined;
			
			for (var i:uint = 0; i < _link.length; i++) {
				if (caseSensitive) {
					if (text == _link[i]) {
						_link.splice(i, 1);
						_display.splice(i, 1);
						break;
					}
				}else {
					if (text.toLocaleLowerCase() == _link[i].toLocaleLowerCase()) {
						_link.splice(i, 1);
						_display.splice(i, 1);
						break;
					}
				}
			}
			
			for (i = 0; i < _display.length; i++) {
				if (_display[i].textWidth > _background.width - 10) {
					_background = new Rect(new Point(_display[i].textWidth + 10, _background.height + _display[i].textHeight), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
				}else {
					_background = new Rect(new Point(_background.width, _background.height + _display[i].textHeight), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
				}
			}
		}
		public static function removeAll():void {
			_list = new Dictionary();
			_link = new Vector.<String>;
			_display = new Vector.<TextField>;
			
			_background = new Rect(new Point(0, 0), _backgroundColor, _backgroundAlpha, 1, _backgroundBorderColor, _backgroundBorderAlpha);
		}
		
		public function showMenu(e:MouseEvent):void {
			if (_visible) {
				hideMenu();
			}
			
			if (_display.length == 0) {
				return;
			}
			
			_background.x = e.stageX;
			_background.y = e.stageY;
			
			_visible = true;
			
			addChild(_background);
			
			for (var i:uint = 0; i < _display.length; i++) {
				_display[i].x = _background.x + _background.width / 2 - _display[i].textWidth / 2 - 3;
				_display[i].y = _background.y + (i * 19) - 1;
				
				addChild(_display[i]);
				
				if (i < _display.length - 1) {
					_seperators[i] = new Rect(new Point(_background.width - _background.width / 10, 0), -1, 0, 1, _seperatorColor);
					
					_seperators[i].y = _display[i].y + 20;
					_seperators[i].x = _background.x + _background.width / 20;
					addChild(_seperators[i]);
				}
			}
		}
		
		public function hideMenu(e:MouseEvent = null):void {
			if (_visible) {
				for (var i:uint = 0; i < _display.length; i++) {
					removeChild(_display[i]);
					
					if (i < _display.length - 1) {
						removeChild(_seperators[i]);
					}
				}
				
				removeChild(_background);
				
				_visible = false;
			}
			
			if (e) {
				if ((e.stageX <= _background.x + _background.width && e.stageX >= _background.x) && (e.stageY <= _background.y + _background.height && e.stageY >= _background.y)) {
					runClicked(e.stageY);
				}
			}
		}
		
		//private
		private function runClicked(mouseY:Number):void {
			var functionString:String = _link[Math.floor((mouseY - _background.y) / 19)];
			var runFunction:Function = _list[functionString.toLocaleLowerCase()];
			
			if (runFunction != null) {
				runFunction.call();
			}
		}
	}
}