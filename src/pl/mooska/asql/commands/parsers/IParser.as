package pl.mooska.asql.commands.parsers
{
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;	

	public interface IParser extends IEventDispatcher
	{
		function parse ( data:ByteArray ) :void;
	}
}