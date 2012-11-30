package pl.mooska.asql.utils
{
	import pl.mooska.asql.commands.parsers.types.BlobType;	
	import pl.mooska.asql.commands.parsers.types.GeometryType;	
	import pl.mooska.asql.commands.parsers.types.VarcharType;	
	import pl.mooska.asql.commands.parsers.types.YearType;	
	import pl.mooska.asql.commands.parsers.types.TimeType;	
	import pl.mooska.asql.commands.parsers.types.NullType;	
	import pl.mooska.asql.commands.parsers.types.TimeStampType;	
	import pl.mooska.asql.commands.parsers.types.LongType;	
	import pl.mooska.asql.commands.parsers.types.IntType;	
	import pl.mooska.asql.commands.parsers.types.NumberType;	
	import pl.mooska.asql.commands.parsers.types.IType;
	import pl.mooska.asql.debugger.SQLDebugger;	

	public class TypesUtil
	{
		public static function getParserFromCode(code:int) :IType 
		{
			//returns correct parser depending on hex value provided
			if(code < 0 || ( code > 17 && code < 0xf6 ) || code > 0xff)
			{
				SQLDebugger.write("Theres no such parser in the list");
				return null;
			}
			
			var a:Array = [NumberType,
							IntType,
							IntType,
							LongType,
							NumberType,
							NumberType,
							NullType,
							TimeStampType,
							IntType,
							IntType,
							TimeStampType,
							TimeType,
							TimeStampType,
							YearType,
							TimeStampType,
							VarcharType,
							IntType
			];
			/**
			* 
			*			var a:Array = [ "FIELD_TYPE_DECIMAL",
							"FIELD_TYPE_TINY",
							IntType,
							Long,
							"FIELD_TYPE_FLOAT",
							"FIELD_TYPE_DOUBLE",
							"FIELD_TYPE_NULL",
							TimeStamp,
							"FIELD_TYPE_LONGLONG",
							"FIELD_TYPE_INT24",
							"FIELD_TYPE_DATE",
							"FIELD_TYPE_TIME",
							"FIELD_TYPE_DATETIME",
							"FIELD_TYPE_YEAR",
							"FIELD_TYPE_NEWDATE",
							Varchar,
							"FIELD_TYPE_BIT"
			]; 
			* 
			* 
			* 
			*
			*/
			a[0xf6] = NumberType;
			a[0xf7] = VarcharType;
			a[0xf8] = VarcharType;
			a[0xf9] = BlobType;
			a[0xfa] = BlobType;
			a[0xfb] = BlobType;
			a[0xfc] = BlobType;
			a[0xfd] = VarcharType;
			a[0xfe] = VarcharType;
			a[0xff] = GeometryType;
			/*
			* 
			a[0xf6] = "FIELD_TYPE_NEWDECIMAL";
			a[0xf7] = "FIELD_TYPE_ENUM";
			a[0xf8] = "FIELD_TYPE_SET";
			a[0xf9] = "FIELD_TYPE_TINY_BLOB";
			a[0xfa] = "FIELD_TYPE_MEDIUM_BLOB";
			a[0xfb] = "FIELD_TYPE_LONG_BLOB";
			a[0xfc] = Blob;
			a[0xfd] = Varchar;
			a[0xfe] = Varchar;
			a[0xff] = "FIELD_TYPE_GEOMETRY";
			* 
			* 
			* 
			* 
			*/
			
			var type:IType;
			type = new a[code]();
			return (type);
			
		}
		
		public static function getTypeFromCode(c:int) :String
		{
			//return type name
			/*
			* 
			 0x00   FIELD_TYPE_DECIMAL
			 0x01   FIELD_TYPE_TINY
			 0x02   FIELD_TYPE_SHORT
			 0x03   FIELD_TYPE_LONG
			 0x04   FIELD_TYPE_FLOAT
			 0x05   FIELD_TYPE_DOUBLE
			 0x06   FIELD_TYPE_NULL
			 0x07   FIELD_TYPE_TIMESTAMP
			 0x08   FIELD_TYPE_LONGLONG
			 0x09   FIELD_TYPE_INT24
			 0x0a   FIELD_TYPE_DATE
			 0x0b   FIELD_TYPE_TIME
			 0x0c   FIELD_TYPE_DATETIME
			 0x0d   FIELD_TYPE_YEAR
			 0x0e   FIELD_TYPE_NEWDATE
			 0x0f   FIELD_TYPE_VARCHAR (new in MySQL 5.0)
			 0x10   FIELD_TYPE_BIT (new in MySQL 5.0)
			*/
			var a:Array = [ "FIELD_TYPE_DECIMAL",
							"FIELD_TYPE_TINY",
							"FIELD_TYPE_SHORT",
							"FIELD_TYPE_LONG",
							"FIELD_TYPE_FLOAT",
							"FIELD_TYPE_DOUBLE",
							"FIELD_TYPE_NULL",
							"FIELD_TYPE_TIMESTAMP",
							"FIELD_TYPE_LONGLONG",
							"FIELD_TYPE_INT24",
							"FIELD_TYPE_DATE",
							"FIELD_TYPE_TIME",
							"FIELD_TYPE_DATETIME",
							"FIELD_TYPE_YEAR",
							"FIELD_TYPE_NEWDATE",
							"FIELD_TYPE_VARCHAR",
							"FIELD_TYPE_BIT"
			];
			/*
			* 
			 0xf6   FIELD_TYPE_NEWDECIMAL (new in MYSQL 5.0)
			 0xf7   FIELD_TYPE_ENUM
			 0xf8   FIELD_TYPE_SET
			 0xf9   FIELD_TYPE_TINY_BLOB
			 0xfa   FIELD_TYPE_MEDIUM_BLOB
			 0xfb   FIELD_TYPE_LONG_BLOB
			 0xfc   FIELD_TYPE_BLOB
			 0xfd   FIELD_TYPE_VAR_STRING
			 0xfe   FIELD_TYPE_STRING
			 0xff   FIELD_TYPE_GEOMETRY
			*/
			a[0xf6] = "FIELD_TYPE_NEWDECIMAL";
			a[0xf7] = "FIELD_TYPE_ENUM";
			a[0xf8] = "FIELD_TYPE_SET";
			a[0xf9] = "FIELD_TYPE_TINY_BLOB";
			a[0xfa] = "FIELD_TYPE_MEDIUM_BLOB";
			a[0xfb] = "FIELD_TYPE_LONG_BLOB";
			a[0xfc] = "FIELD_TYPE_BLOB";
			a[0xfd] = "FIELD_TYPE_VAR_STRING";
			a[0xfe] = "FIELD_TYPE_STRING";
			a[0xff] = "FIELD_TYPE_GEOMETRY";
			
			return a[c];
		}
		public static function getFlagsFromCode(c:int) :Array
		{
			//convert 2bytes options into string array
			/*
			* 
			*            0001 NOT_NULL_FLAG
                         0002 PRI_KEY_FLAG
                         0004 UNIQUE_KEY_FLAG
                         0008 MULTIPLE_KEY_FLAG
                         0010 BLOB_FLAG
                         0020 UNSIGNED_FLAG
                         0040 ZEROFILL_FLAG
                         0080 BINARY_FLAG
                         0100 ENUM_FLAG
                         0200 AUTO_INCREMENT_FLAG
                         0400 TIMESTAMP_FLAG
                         0800 SET_FLAG
			*/
			//sequence is quite important in these options;
			var options:Array = [ "BINARY_FLAG",
							"ZEROFILL_FLAG",
							"UNSIGNED_FLAG",
							"BLOB_FLAG",
							"MULTIPLE_KEY_FLAG",	
							"UNIQUE_KEY_FLAG",
							"PRI_KEY_FLAG",
							"NOT_NULL_FLAG",
							"","","","",
							"SET_FLAG",
							"TIMESTAMP_FLAG",
							"AUTO_INCREMENT_FLAG",
							"ENUM_FLAG"
			];
			
			var a:Array = [];
			
			for(var i:uint = 0 ; i<options.length; i++)
			{
			//creates an array with string names of the types
				var m:int = Math.pow(2, options.length-i -1);
				var res:int = (m & c);
				
				 if(m==res) 
				 {
					a.push(options[i]);
				}
			}
			
			return a;
		}
	}
}