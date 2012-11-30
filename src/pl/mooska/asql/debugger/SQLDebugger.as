package pl.mooska.asql.debugger
{
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;	

	public class SQLDebugger
	{
		private static var _level:uint = 1;
		private static var local:LocalConnection = new LocalConnection();
		
		public static function write ( text:String, level:uint=0 ) :void
		{
			if ( !local.hasEventListener( StatusEvent.STATUS ) )
			{
				local.addEventListener(StatusEvent.STATUS, function( evt:Event ) :void 
				{
					//just to prevent showing the error
				});
			}
			if ( level >= _level)
			{
				//trace("\tSQL::"+ text );
				try 
				{
					local.send( "debugger", "onText", [text] );
	            }
	            catch (error:*)
	            {
	                // server already created/connected
	            }
			}
		}
		/*
		public static function print ( data:ByteArray ) :void
		{
			var p = data.position
			data.position = 0
			var s = ''
			for(i=0; i < data.length ; i ++)
			{
				s+= data.readUnsignedByte().toString(16)+"_";
			}
			trace(s + " counter "+i);
			data.position = p;

		}
		public static function printShort ( data:ByteArray ) :void
		{
			var s = ''
			for( var i=0; i<10; i++){
				s+= data.readUnsignedByte().toString(16)+"_";
			}
			trace("--- Short data: "+s);
		}
		*/
	}
}