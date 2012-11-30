package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class VarcharType implements IType
	{
		public function VarcharType ()
		{
			
		}
		public function convert(data:ByteArray):*
		{
			return data.readUTFBytes(data.length);
		}
		
	}
}