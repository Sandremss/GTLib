package pl.mooska.asql.commands
{
	import flash.utils.ByteArray;	

	public interface ICommand
	{
		function execute () :void;
		function handleResult ( data:ByteArray ) :void;
		function finalize () :void;
	}
}