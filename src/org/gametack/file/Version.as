package org.gametack.file {
	import flash.errors.IllegalOperationError;
	import flash.errors.MemoryError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.gametack.BaseClass;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class Version extends BaseClass {
		//vars
		private static var _version:URLRequest;
		private static var _download:URLRequest;
		private static var _versionFile:URLLoader = new URLLoader();
		private static var _downloadFile:FileReference = new FileReference();
		
		public static const LOG_SIGNAL:Signal = new Signal(uint, String);
		
		private static var _versionCompleteHandler:Function = null;
		private static var _versionProgressHandler:Function = null;
		private static var _versionIOErrorHandler:Function = null;
		private static var _versionSecurityErrorHandler:Function = null;
		
		private static var _downloadCompleteHandler:Function = null;
		private static var _downloadCancelHandler:Function = null;
		private static var _downloadIOErrorHandler:Function = null;
		private static var _downloadSecurityErrorHandler:Function = null;
		private static var _downloadProgressHandler:Function = null;
		
		//constructor
		public function Version() {
			
		}
		
		//public
		public function init(versionURL:String, downloadURL:String):void {
			_version = new URLRequest(versionURL);
			_download = new URLRequest(downloadURL);
		}
		
		public static function cleanVersionFile():void {
			_versionFile.removeEventListener(Event.COMPLETE, _versionCompleteHandler);
			_versionCompleteHandler = null;
			
			if (_versionProgressHandler != null) {
				_versionFile.removeEventListener(ProgressEvent.PROGRESS, _versionProgressHandler);
				_versionProgressHandler = null;
			}
			if (_versionIOErrorHandler != null) {
				_versionFile.removeEventListener(IOErrorEvent.IO_ERROR, _versionIOErrorHandler);
				_versionIOErrorHandler = null;
			}
			if (_versionSecurityErrorHandler != null) {
				_versionFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _versionSecurityErrorHandler);
				_versionSecurityErrorHandler = null;
			}
		}
		
		public static function cleanDownloadFile():void {
			if (_downloadCompleteHandler != null) {
				_downloadFile.removeEventListener(Event.COMPLETE, _downloadCompleteHandler);
				_downloadCompleteHandler = null;
			}
			if (_downloadCancelHandler != null) {
				_downloadFile.removeEventListener(Event.CANCEL, _downloadCancelHandler);
				_downloadCancelHandler = null;
			}
			if (_downloadProgressHandler != null) {
				_downloadFile.removeEventListener(ProgressEvent.PROGRESS, _downloadProgressHandler);
				_downloadProgressHandler = null;
			}
			if (_downloadIOErrorHandler != null) {
				_downloadFile.removeEventListener(IOErrorEvent.IO_ERROR, _downloadIOErrorHandler);
				_downloadIOErrorHandler = null;
			}
			if (_downloadSecurityErrorHandler != null) {
				_downloadFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _downloadSecurityErrorHandler);
				_downloadSecurityErrorHandler = null;
			}
		}
		
		public static function getVersionFile(completeHandler:Function, IOErrorHandler:Function = null, securityErrorHandler:Function = null, progressHandler:Function = null):Boolean {
			try {
				_versionCompleteHandler = completeHandler;
				_versionFile.addEventListener(Event.COMPLETE, _versionCompleteHandler);
				if (progressHandler != null) {
					_versionProgressHandler = progressHandler;
					_versionFile.addEventListener(ProgressEvent.PROGRESS, _versionProgressHandler);
				}
				if (IOErrorHandler != null) {
					_versionIOErrorHandler = IOErrorHandler;
					_versionFile.addEventListener(IOErrorEvent.IO_ERROR, _versionIOErrorHandler);
				}
				if (securityErrorHandler != null) {
					_versionSecurityErrorHandler = securityErrorHandler;
					_versionFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _versionSecurityErrorHandler);
				}
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			try {
				_versionFile.load(_version);
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:MemoryError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:TypeError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		public static function downloadFile(newName:String, completeHandler:Function = null, cancelHandler:Function = null, IOErrorHandler:Function = null, securityErrorHandler:Function = null, progressHandler:Function = null):Boolean {
			if (completeHandler != null) {
				try {
					_downloadCompleteHandler = completeHandler;
					_downloadFile.addEventListener(Event.COMPLETE, _downloadCompleteHandler);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			if (cancelHandler != null) {
				try {
					_downloadCancelHandler = cancelHandler;
					_downloadFile.addEventListener(Event.CANCEL, _downloadCancelHandler);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			if (progressHandler != null) {
				try {
					_downloadProgressHandler = progressHandler;
					_downloadFile.addEventListener(ProgressEvent.PROGRESS, _downloadProgressHandler);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			if (IOErrorHandler != null) {
				try {
					_downloadIOErrorHandler = IOErrorHandler;
					_downloadFile.addEventListener(IOErrorEvent.IO_ERROR, _downloadIOErrorHandler);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			if (securityErrorHandler != null) {
				try {
					_downloadSecurityErrorHandler = securityErrorHandler;
					_downloadFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _downloadSecurityErrorHandler);
				}catch (error:ArgumentError) {
					LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
					return false;
				}
			}
			
			try {
				_downloadFile.download(_download, newName);
			}catch (error:IllegalOperationError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:SecurityError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:ArgumentError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:MemoryError) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}catch (error:Error) {
				LOG_SIGNAL.dispatch(0, "File - Version: " + error.message + " (" + error.name + ")");
				return false;
			}
			
			return true;
		}
		
		//private
	}
}