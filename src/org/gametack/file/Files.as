package org.gametack.file {
	import flash.errors.EOFError;
	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import org.gametack.BaseClass;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Files extends BaseClass {
		//vars
		public static var saveLocation:File;
		public static var saveParentFolder:String;
		public static var saveGameFolder:String;
		public static var clientSaveFolder:String;
		public static var serverSaveFolder:String;
		
		public static const SEPARATOR:String = File.separator;
		public static const LINE_ENDING:String = File.lineEnding;
		public static var encoding:String;
		
		public static const LOG_SIGNAL:Signal = new Signal(uint, String);
		
		//constructor
		public function Files() {
			
		}
		
		//public
		
		/**
		 * Initializes the system to recieve file and folder requests.
		 * 
		 * @param gameName A string decribing the name of the application.
		 * @param companyName A string describing the name of the Owner, Organization, Company, etc.
		 * @param clientFolder A string describing the name of the client's save folder.
		 * @param serverFolder A string describing the name of the server's save folder.
		 * @param server A boolean dictating whether or not server functionality is used in the current application.
		 * @param fileEncoding A string describing the encoding used for file read/write.
		 * @param filesLocation A file object describing the "root folder" of the game folder - defaults to "Documents."
		 * @return A boolean descibing a successful (or unsuccessful) initialization.
		 */
		public function init(gameName:String, companyName:String = "Gametack", clientFolder:String = "Client", serverFolder:String = "Server", server:Boolean = true, fileEncoding:String = "us-ascii", filesLocation:File = null):Boolean {
			if (filesLocation) {
				saveLocation = filesLocation;
			}else {
				saveLocation = File.documentsDirectory;
			}
			
			if (companyName) {
				saveParentFolder = companyName;
			}else {
				saveParentFolder = "Gametack";
			}
			
			if (gameName) {
				saveGameFolder = gameName;
			}else {
				LOG_SIGNAL.dispatch(0, "File - Files: gameName not given");
				return false;
			}
			
			if (clientFolder) {
				clientSaveFolder = clientFolder;
			}else {
				clientSaveFolder = "Client";
			}
			
			if (serverFolder) {
				serverSaveFolder = serverFolder;
			}else {
				serverSaveFolder = "Server";
			}
			
			if (fileEncoding) {
				encoding = fileEncoding;
			}else {
				encoding = "us-ascii";
			}
			
			try {
				saveLocation.resolvePath(saveParentFolder + SEPARATOR + saveGameFolder + SEPARATOR + clientSaveFolder).createDirectory();
				if (server) {
					saveLocation.resolvePath(saveParentFolder + SEPARATOR + saveGameFolder + SEPARATOR + serverSaveFolder).createDirectory();
				}
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Creates a directory.
		 * 
		 * @param directory A file object describing the directory to create.
		 * @return A boolean descibing a successful (or unsuccessful) creation.
		 */
		public static function createDir(directory:File):Boolean {
			try {
				directory.createDirectory();
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Removes a directory.
		 * 
		 * @param directory A file object describing the directory to remove.
		 * @return A boolean descibing a successful (or unsuccessful) removal.
		 */
		public static function removeDir(directory:File):Boolean {
			try {
				directory.deleteDirectory(true);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Checks for the requested file's existance.
		 * 
		 * @param file A file object describing the file to check.
		 * @return A boolean descibing the existance (or nonexistance) of the file specified.
		 */
		public static function fileExists(file:File):Boolean {
			var fileStream:FileStream = new FileStream();
			
			try {
				fileStream.open(file, FileMode.READ);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}
			
			fileStream.close();
			
			return true;
		}
		
		/**
		 * Creates a file.
		 * 
		 * @param file A file object describing the file to create.
		 * @param defaultText A string describing the text to insert into the file during creation.
		 * @param overwrite A boolean dictating file overriding in the event that the file already exists.
		 * @return A boolean describing a successful (or unsuccessful) creation.
		 */
		public static function createFile(file:File, defaultText:String = null, overwrite:Boolean = true):Boolean {
			var fileStream:FileStream = new FileStream();
			
			if (overwrite && fileExists(file)) {
				LOG_SIGNAL.dispatch(0, "File - Files: File already exists and overwrite specified as false.");
				return false;
			}
			
			try {
				fileStream.open(file, FileMode.WRITE);
				if (defaultText) {
					fileStream.writeMultiByte(defaultText, encoding);
				}
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}
			
			fileStream.close();
			
			return true;
		}
		
		/**
		 * Reads the specified file's contents.
		 * 
		 * @param file A file object describing the file to read.
		 * @return A string with the file's contents. A null value means the file could not be read.
		 */
		public static function readFile(file:File):String {
			var fileStream:FileStream = new FileStream();
			var fileContents:String;
			
			try {
				fileStream.open(file, FileMode.READ);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return null;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return null;
			}
			
			try {
				fileContents = fileStream.readMultiByte(fileStream.bytesAvailable, encoding);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return null;
			}catch (error:EOFError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return null;
			}
			
			fileStream.close();
			
			return fileContents;
		}
		
		/**
		 * Writes to the specified file.
		 * 
		 * @param file A file object describing the file to write to.
		 * @param text A string describing the text to be written to the file.
		 * @param A boolean dictating whether or not to append the text instead of writing over the current file.
		 * @return A boolean descibing a successful (or unsuccessful) write.
		 */
		public static function writeFile(file:File, text:String, append:Boolean = true):Boolean {
			var fileStream:FileStream = new FileStream();
			
			try {
				if (append) {
					fileStream.open(file, FileMode.APPEND);
				}else {
					fileStream.open(file, FileMode.WRITE);
				}
				fileStream.writeMultiByte(text, encoding);
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				fileStream.close();
				return false;
			}
			
			fileStream.close();
			
			return true;
		}
		
		/**
		 * Removes the specified file.
		 * 
		 * @param file A file object describing the file to remove.
		 * @return A boolean descibing a successful (or unsuccessful) removal.
		 */
		public static function removeFile(file:File):Boolean {
			try {
				file.deleteFile();
			}catch (error:IOError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Files: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		//private
	}
}