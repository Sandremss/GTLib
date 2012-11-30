package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public interface IType
	{
		function convert ( data:ByteArray ) :*
	}
}