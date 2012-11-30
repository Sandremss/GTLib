/**
 * stats.as
 * https://github.com/mrdoob/Hi-ReS-Stats
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 *	addChild( new Stats() );
 *
 **/

package net.hires.debug {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;	

	public class Stats extends Sprite {	

		protected const WIDTH : uint = 70;
		protected const HEIGHT : uint = 100;

		protected var _stage : DisplayObjectContainer;

		protected var xml : XML;

		protected var text : TextField;
		protected var style : StyleSheet;

		protected var timer : uint;
		protected var fps : uint;
		protected var ms : uint;
		protected var ms_prev : uint;
		protected var mem : Number;
		protected var mem_max : Number;
		protected var garbage : Number;
		protected var children : uint;

		protected var graph : BitmapData;
		protected var rectangle : Rectangle;

		protected var fps_graph : uint;
		protected var garbage_graph : uint;
		protected var mem_graph : uint;
		protected var mem_max_graph : uint;

		protected var colors : Colors = new Colors();

		/**
		 * <b>Stats</b> FPS, MS, MEM, garbage, and children counter all in one.
		 */
		public function Stats(stage:DisplayObjectContainer) : void {
			
			_stage = stage;

			mem_max = 0;

			xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax><garbage>GBG:</garbage><children>CHLDN:</children></xml>;
		
			style = new StyleSheet();
			style.setStyle('xml', {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			style.setStyle('fps', {color: hex2css(colors.fps)});
			style.setStyle('ms', {color: hex2css(colors.ms)});
			style.setStyle('mem', {color: hex2css(colors.mem)});
			style.setStyle('memMax', { color: hex2css(colors.memmax) } );
			style.setStyle('garbage', { color: hex2css(colors.garbage) } );
			style.setStyle('children', {color: hex2css(colors.children)});
			
			text = new TextField();
			text.width = WIDTH;
			text.height = 66;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);			
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
		}

		private function init(e : Event) : void {
			
			graphics.beginFill(colors.bg);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();

			addChild(text);
			
			graph = new BitmapData(WIDTH, HEIGHT - 50, false, colors.bg);
			graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, 50));
			graphics.drawRect(0, 50, WIDTH, HEIGHT - 50);
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
			
		}

		private function destroy(e : Event) : void {
			
			graphics.clear();
			
			while(numChildren > 0)
				removeChildAt(0);			
			
			graph.dispose();
			
			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ENTER_FRAME, update);
			
		}

		private function update(e : Event) : void {
			
			timer = getTimer();
			
			if( timer - 1000 > ms_prev ) {
				
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				garbage = Number((System.freeMemory / 1048576).toFixed(3));
				
				fps_graph = Math.min(graph.height - 15, ( fps / stage.frameRate ) * graph.height - 15);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;
				garbage_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(garbage * 5000))) - 2;
				
				graph.scroll(-1, 0);
				
				graph.fillRect(rectangle, colors.bg);
				graph.setPixel(graph.width - 1, graph.height - fps_graph, colors.fps);
				graph.setPixel(graph.width - 1, graph.height - garbage_graph, colors.garbage);
				graph.setPixel(graph.width - 1, graph.height - ( ( timer - ms ) >> 1 ), colors.ms);
				graph.setPixel(graph.width - 1, graph.height - mem_graph, colors.mem);
				graph.setPixel(graph.width - 1, graph.height - mem_max_graph, colors.memmax);
				
				xml.fps = "FPS: " + fps + " / " + stage.frameRate; 
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;	
				xml.garbage = "GBG: " + garbage;
				xml.children = "CHLDN: " + children;
				
				fps = 0;
				
			}

			children = countChildren(_stage);

			fps++;
			
			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			
			text.htmlText = xml;
		}

		private function onClick(e : MouseEvent) : void {
			
			mouseY / height > .5 ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + stage.frameRate;  
			text.htmlText = xml;
			
		}

		// .. Utils

		private function hex2css( color : int ) : String {
			
			return "#" + color.toString(16);
			
		}
		
		private function countChildren(container:DisplayObjectContainer):uint {
			var temp:uint = container.numChildren;
			
			for (var i:uint = 0; i < container.numChildren; i++) {
				if (container.getChildAt(i) is DisplayObjectContainer) {
					temp += countChildren(DisplayObjectContainer(container.getChildAt(i)));
				}
			}
			
			return temp;
		}
		
	}
	
}

class Colors {

	public var bg : uint = 0x000033;
	public var fps : uint = 0xffff00;
	public var ms : uint = 0x00ff00;
	public var mem : uint = 0x00ffff;
	public var memmax : uint = 0xff0070;
	public var garbage : uint = 0xff80ff;
	public var children : uint = 0xcccccc;
	
}