package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class NumberType implements IType
	{
		public function NumberType ()
		{
			
		}
		public function convert( data:ByteArray ):*
		{
			return Number ( data.readUTFBytes( data.length ) );
		}
		
	}
}