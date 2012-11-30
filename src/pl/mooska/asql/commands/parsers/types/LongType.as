package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class LongType implements IType
	{
		public function LongType ()
		{
			
		}
		public function convert(data:ByteArray):*
		{
			return uint ( data.readUTFBytes( data.length ) );
		}
		
	}
}