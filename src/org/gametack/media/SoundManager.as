package org.gametack.media {
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	public class SoundManager {
		//vars
		public const LOG_SIGNAL:Signal = new Signal(uint, String);
		public const EVENT_SIGNAL:Signal = new Signal(Boolean, String, String);
		
		private var _ids:Vector.<String> = new Vector.<String>;
		private var _sounds:Array = new Array();
		
		private var _channels:Vector.<SoundChannel> = new Vector.<SoundChannel>;
		private var _pausePositions:Vector.<uint> = new Vector.<uint>;
		private var _isPlaying:Vector.<Boolean> = new Vector.<Boolean>;
		
		//constructor
		public function SoundManager() {
			
		}
		
		//public
		public function addInternalSound(NewSound:Class, id:String):Boolean {
			if (!NewSound || !id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - addInternalSound: NewSound and/or id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					LOG_SIGNAL.dispatch(0, "SoundManager - addInternalSound: id is taken.");
					return false;
				}
			}
			
			_ids[_ids.length] = id;
			_sounds[id] = new NewSound() as Sound;
			_channels[_channels.length] = null;
			_pausePositions[_pausePositions.length] = 0;
			_isPlaying[_isPlaying.length] = false;
			
			return true;
		}
		
		public function addURLSound(url:String, id:String):Boolean {
			if (!url || !id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - addURLSound: url and/or id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					LOG_SIGNAL.dispatch(0, "SoundManager - addURLSound: id is taken.");
					return false;
				}
			}
			
			_ids[_ids.length] = id;
			_sounds[id] = new CustomSound(id);
			_channels[_channels.length] = null;
			_pausePositions[_pausePositions.length] = 0;
			_isPlaying[_isPlaying.length] = false;
			
			_sounds[id].addEventListener(Event.COMPLETE, onSoundComplete);
			_sounds[id].addEventListener(IOErrorEvent.IO_ERROR, onSoundIOError);
			
			try {
				_sounds[id].load(new URLRequest(url));
			}catch (error:IOError) {
				_sounds[id].removeEventListener(Event.COMPLETE, onSoundComplete);
				_sounds[id].removeEventListener(IOErrorEvent.IO_ERROR, onSoundIOError);
				
				_sounds.splice(_sounds.length - 1, 1);
				_ids.splice(_ids.length - 1, 1);
				_channels.splice(_channels.length - 1, 1);
				_pausePositions.splice(_pausePositions.length - 1, 1);
				_isPlaying.splice(_isPlaying.length - 1, 1);
				
				LOG_SIGNAL.dispatch(0, "SoundManager - addURLSound: " + error.message + "(" + error.errorID + ")");
				return false;
			}catch (error:SecurityError) {
				_sounds[id].removeEventListener(Event.COMPLETE, onSoundComplete);
				_sounds[id].removeEventListener(IOErrorEvent.IO_ERROR, onSoundIOError);
				
				_sounds.splice(_sounds.length - 1, 1);
				_ids.splice(_ids.length - 1, 1);
				_channels.splice(_channels.length - 1, 1);
				_pausePositions.splice(_pausePositions.length - 1, 1);
				_isPlaying.splice(_isPlaying.length - 1, 1);
				
				LOG_SIGNAL.dispatch(0, "SoundManager - addURLSound: " + error.message + "(" + error.errorID + ")");
				return false;
			}
			
			return true;
		}
		
		public function getSound(id:String):Sound {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - getSound: id given was null or undefined.");
				return null;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					if (_sounds[_ids[i]] is CustomSound) {
						return _sounds[_ids[i]] as Sound;
					}else {
						return _sounds[_ids[i]];
					}
				}
			}
			
			LOG_SIGNAL.dispatch(0, "SoundManager - getSound: id given was not found.");
			
			return null;
		}
		
		public function exists(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - exists: id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					return true;
				}
			}
			
			return false;
		}
		
		public function isPlaying(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - isPlaying: id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					return _isPlaying[i];
				}
			}
			
			return false;
		}
		
		public function playSound(id:String):Boolean {
			var tempSound:Sound;
			
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - playSound: id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					if (!_isPlaying[i]) {
						tempSound = _sounds[_ids[i]] as Sound;
						
						_isPlaying[i] = true;
						_channels[i] = tempSound.play(_pausePositions[i]);
					}
					
					return true;
				}
			}
			
			LOG_SIGNAL.dispatch(0, "SoundManager - playSound: id given was not found.");
			
			return false;
		}
		public function pauseSound(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - pauseSound: id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					if (_isPlaying[i]) {
						_isPlaying[i] = false;
						
						_pausePositions[i] = _channels[i].position;
						_channels[i].stop();
					}
					
					return true;
				}
			}
			
			LOG_SIGNAL.dispatch(0, "SoundManager - pauseSound: id given was not found.");
			
			return false;
		}
		public function stopSound(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - stopSound: id given was null or undefined.");
				return false;
			}
			
			for (var i:uint = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					if (_isPlaying[i]) {
						_isPlaying[i] = false;
						
						_pausePositions[i] = 0;
						_channels[i].stop();
					}
					
					return true;
				}
			}
			
			LOG_SIGNAL.dispatch(0, "SoundManager - stopSound: id given was not found.");
			
			return false;
		}
		
		public function removeSound(id:String):Boolean {
			var i:uint;
			
			if (!id) {
				LOG_SIGNAL.dispatch(0, "SoundManager - removeSound: id given was null or undefined.");
				return false;
			}
			
			for (i = 0; i < _ids.length; i++) {
				if (id == _ids[i]) {
					_ids.splice(i, 1);
					_sounds.splice(i, 1);
					_channels.splice(i, 1);
					_pausePositions.splice(i, 1);
					_isPlaying.splice(i, 1);
				}
			}
			
			LOG_SIGNAL.dispatch(0, "SoundManager - removeSound: id given was not found.");
			
			return false;
		}
		
		//private
		private function onSoundComplete(e:Event):void {
			_sounds[e.target.id].removeEventListener(Event.COMPLETE, onSoundComplete);
			_sounds[e.target.id].removeEventListener(IOErrorEvent.IO_ERROR, onSoundIOError);
			
			EVENT_SIGNAL.dispatch(true, "Sound fully loaded", e.target.id);
		}
		private function onSoundIOError(e:IOErrorEvent):void {
			_sounds[e.target.id].removeEventListener(Event.COMPLETE, onSoundComplete);
			_sounds[e.target.id].removeEventListener(IOErrorEvent.IO_ERROR, onSoundIOError);
			
			EVENT_SIGNAL.dispatch(false, e.text + "(" + e.errorID + ")", e.target.id);
		}
	}
}