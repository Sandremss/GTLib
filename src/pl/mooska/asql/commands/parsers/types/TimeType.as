package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class TimeType implements IType
	{
		public function TimeType ()
		{
			
		}
		public function convert(data:ByteArray):*
		{
			var s:String = data.readUTFBytes(data.length);
			var hours:int = int(s.substr(0, 2));
			var minutes:int = int(s.substr(3, 2));
			var seconds:int = int(s.substr(6, 2));
			var d:Date = new Date();
			d.setHours(hours, minutes, seconds);
			
			return d;
		}
		
	}
}