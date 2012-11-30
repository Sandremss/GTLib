package pl.mooska.asql.commands.parsers.types
{
	import flash.utils.ByteArray;	

	public class TimeStampType implements IType
	{
		public function TimeStampType ()
		{
			
		}
		public function convert(data:ByteArray):*
		{
			
			
			var d:String = data.readUTFBytes( data.length );
			
			var year:int = int(d.substr(0, 4));
			var month:int = int(d.substr(5, 2))-1;
			var day:int = int(d.substr(8, 2));
			var hours:int = int(d.substr(11, 2));
			var minutes:int = int(d.substr(14, 2));
			var seconds:int = int(d.substr(17, 2));
			
			/*
			trace("year: "+year);
			trace("month: "+month);
			trace("day: "+day);
			trace("hours: "+hours);
			trace("minutes: "+minutes);
			trace("seconds: "+seconds);
			*/
			
			return new Date( year, month, day, hours, minutes, seconds );
		}
		
	}
}