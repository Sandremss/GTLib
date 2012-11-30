package pl.mooska.asql
{
	import pl.mooska.asql.commands.ICommand;
	import pl.mooska.asql.packets.IPacket;
	import pl.mooska.asql.query.IQueryObject;
	
	import flash.events.Event;	
	public interface IAsqlBase
	{
		function connect ( host:String, user:String, pass:String, initialDBase:String, port:uint = 3306 ) :void;
		function disconnect () :void;
		function selectDBase ( baseName:String ) :void;
		function query ( queryObject:IQueryObject ) :void;
		function handleEvent ( evt:Event ) :void;
		function sendPacket ( packet:IPacket ) :void
		function addCmd ( command:ICommand ) :void;
		function invokeCmd ( command:ICommand = null ) :void
		function get connected () :Boolean;
	}
}