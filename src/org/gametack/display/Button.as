package org.gametack.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Button extends Sprite {
		//vars
		private var _callback:Function;
		private var _callbackParams:Array;
		
		private var _normal:Bitmap;
		private var _hover:Bitmap;
		private var _changeToHand:Boolean;
		private var _down:Bitmap;
		
		//constructor
		
		/**
		 * Creates a button.
		 * 
		 * @param	normal A DisplayObject dictating the button's "normal" state
		 * @param	callback A function the button called when clicked
		 * @param	callbackParams An array describing the callback's parameters
		 * @param	hover A DisplayObject dictating the button's "over" state
		 * @param	changeToHand A boolean dictating whether or not to use the hand cursor when hovering over the button
		 * @param	down A DisplayObject dictating the button's "down" state
		 */
		public function Button(normal:DisplayObject, callback:Function = null, callbackParams:Array = null, hover:DisplayObject = null, changeToHand:Boolean = true, down:DisplayObject = null) {
			var normalBMD:BitmapData = new BitmapData(normal.width, normal.height, true, 0x00000000);
			var hoverBMD:BitmapData;
			var downBMD:BitmapData;
			
			normalBMD.draw(normal);
			
			if (hover) {
				hoverBMD = new BitmapData(hover.width, hover.height, true, 0x00000000);
				hoverBMD.draw(hover);
			}else {
				hoverBMD = normalBMD;
			}
			
			if (down) {
				downBMD = new BitmapData(down.width, down.height, true, 0x00000000);
				downBMD.draw(down);
			}else {
				downBMD = normalBMD;
			}
			
			_callback = callback;
			_callbackParams = callbackParams;
			_normal = new Bitmap(normalBMD);
			_hover = new Bitmap(hoverBMD);
			_changeToHand = changeToHand;
			_down = new Bitmap(downBMD);
			
			toNormal();
		}
		
		//public
		
		//private
		private function toNormal(e:MouseEvent = null):void {
			if (_changeToHand) {
				Mouse.cursor = MouseCursor.ARROW;
			}
			
			if (hasEventListener(MouseEvent.MOUSE_DOWN)) {
				removeEventListener(MouseEvent.MOUSE_DOWN, toDown);
			}
			if (hasEventListener(MouseEvent.MOUSE_UP)) {
				removeEventListener(MouseEvent.MOUSE_UP, toHover);
			}
			if (hasEventListener(MouseEvent.MOUSE_OUT)) {
				removeEventListener(MouseEvent.MOUSE_OUT, toNormal);
			}
			
			addEventListener(MouseEvent.MOUSE_OVER, toHover);
			
			addChild(_normal);
			
			if (_hover && contains(_hover)) {
				removeChild(_hover);
			}
		}
		
		private function toHover(e:MouseEvent):void {
			if (_changeToHand) {
				Mouse.cursor = MouseCursor.BUTTON;
			}
			
			if (hasEventListener(MouseEvent.MOUSE_UP)) {
				removeEventListener(MouseEvent.MOUSE_UP, toHover);
			}
			if (hasEventListener(MouseEvent.MOUSE_OVER)) {
				removeEventListener(MouseEvent.MOUSE_OVER, toHover);
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, toDown);
			addEventListener(MouseEvent.MOUSE_OUT, toNormal);
			
			if (_hover) {
				addChild(_hover);
				if (contains(_normal)) {
					removeChild(_normal);
				}else if (_down && contains(_down)) {
					removeChild(_down);
				}
			}
		}
		
		private function toDown(e:MouseEvent):void {
			if (_callback != null) {
				_callback.apply(null, _callbackParams);
			}
			
			if (hasEventListener(MouseEvent.MOUSE_DOWN)) {
				removeEventListener(MouseEvent.MOUSE_DOWN, toDown);
			}
			
			addEventListener(MouseEvent.MOUSE_UP, toHover);
			
			if (_down) {
				addChild(_down);
				removeChild(_hover);
			}
		}
	}
}