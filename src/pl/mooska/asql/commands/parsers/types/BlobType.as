package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class BlobType implements IType
	{
		public function BlobType ()
		{
		}
		public function convert( data:ByteArray ) :*
		{
			return data;
		}
		
	}
}