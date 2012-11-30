package  {
	import flash.display.Sprite;
	import flash.events.Event;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Main extends Sprite {
		//classes
		
		//vars
		
		//constructor
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//init
		public function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(new Stats(stage));
		}
		
		//functions
	}
}