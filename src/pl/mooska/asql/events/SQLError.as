package pl.mooska.asql.events
{
	import flash.events.Event;	

	public class SQLError extends SQLEvent
	{
		public static const SQL_ERROR:String = "sql_error";
		
		public var text:String = '';
		
		public function SQLError ( error_text:String )
		{
			text = error_text;
			super(SQL_ERROR);
		}
		public override function clone () :Event
		{
			return new SQLError( text );
		}
	}
}