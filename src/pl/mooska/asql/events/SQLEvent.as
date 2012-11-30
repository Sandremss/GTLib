package pl.mooska.asql.events
{
	import flash.events.Event;	

	public class SQLEvent extends Event
	{
		public static const CONNECT:String = "connect";
		public static const DISCONNECT:String = "disconnect";
		public static const SQL_DATA:String = "sql_data";
		public static const SQL_OK:String = "sql_ok";
		
		private var _data:Array;
		
		public function get data () :Array
		{
			return _data;
		}
		
		public function SQLEvent ( type:String, data:Array = null )
		{
			super( type );
			_data = data;
		}
		public override function clone () :Event
		{
			return new SQLEvent ( super.type, _data );
		}
	}
}