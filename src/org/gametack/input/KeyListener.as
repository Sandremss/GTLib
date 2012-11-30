package org.gametack.input {
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.gametack.util.CustomTimer;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Alexander
	 */
	
	 //TODO Code cleanup. This class is both inefficient and slow
	
	public class KeyListener {
		//vars
		public const LOG_SIGNAL:Signal = new Signal(uint, String);
		
		private var _stage:Stage;
		private var _keys:Vector.<Boolean> = new Vector.<Boolean>;
		
		private var _keyDownListenerIds:Vector.<String> = new Vector.<String>;
		private var _keyDownListeners:Array = new Array();
		private var _keyDownListenerFunctions:Array = new Array();
		private var _keyDownListenerParameters:Array = new Array();
		private var _keyDownListenerTimers:Array = new Array();
		
		private var _keyUpListenerIds:Vector.<String> = new Vector.<String>;
		private var _keyUpListeners:Array = new Array();
		private var _keyUpListenerFunctions:Array = new Array();
		private var _keyUpListenerParameters:Array = new Array();
		private var _keyUpListenerTimers:Array = new Array();
		
		private var _keyComboListenerIds:Vector.<String> = new Vector.<String>;
		private var _keyComboListeners:Array = new Array();
		private var _keyComboListenerFunctions:Array = new Array();
		private var _keyComboListenerParameters:Array = new Array();
		private var _keyComboListenerTimers:Array = new Array();
		private var _keyComboListenerStrict:Array = new Array();
		
		private var _currentCombo:Vector.<uint> = new Vector.<uint>;
		private var _longestCombo:uint = 0;
		
		private var _keySequenceListenerIds:Vector.<String> = new Vector.<String>;
		private var _keySequenceListeners:Array = new Array();
		private var _keySequenceListenerFunctions:Array = new Array();
		private var _keySequenceListenerParameters:Array = new Array();
		private var _keySequenceListenerTimers:Array = new Array();
		private var _keySequenceListenerStrict:Array = new Array();
		
		private var _sequenceTimer:Timer = new Timer(3000, 1);
		private var _currentSequence:Vector.<uint> = new Vector.<uint>;
		private var _longestSequence:uint = 0;
		
		//constructor
		public function KeyListener() {
			
		}
		
		//public
		
		/**
		 * Initializes this instance of the key listener, adding events and setting default values.
		 * 
		 * @param	stage The stage instance. Needed for proper keyboard/application communication
		 */
		public function init(stage:Stage):void {
			if (!stage) {
				LOG_SIGNAL.dispatch(0, "KeyListener - init: stage given was null or undefined");
				return;
			}
			
			_stage = stage;
			
			for (var i:uint = 0; i <= 250; i++) {
				_keys[i] = false;
			}
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		/**
		 * Destroys this instance of the key listener, releasing events and setting values to null.
		 */
		public function destroy():void {
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			_keys = new Vector.<Boolean>;
			
			_stage = null;
		}
		
		/**
		 * return the boolean value determining whether or not the specified key is down.
		 * 
		 * @param	keyCode The key code of the key to test
		 * @return The boolean value determining whether or not the specified key is down
		 */
		public function keyIsDown(keyCode:uint):Boolean {
			if (keyCode < _keys.length && keyCode > 0) {
				return _keys[keyCode];
			}else {
				return false;
			}
		}
		
		/**
		 * Adds a single key down listener which fires on a raw keyboard event.
		 * 
		 * @param	key The key code to listen for
		 * @param	id The listener ID
		 * @param	functions An array of functions to call when the event fires
		 * @param	parameters An array of parameters to pass the functions when the event fires. Arrays of arrays are used with multiple functions
		 * @return A boolean value describing whether or not the listener was successfully added
		 */
		public function addKeyDownListener(key:uint, id:String, functions:Array, parameters:Array = null):Boolean {
			var functionCheck:Boolean = false;
			var length:uint;
			var i:uint;
			var j:uint;
			
			if (!key || !id || !functions || functions.length == 0) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: key, id, and/or functions given were null or undefined");
				return false;
			}
			
			if (_keyDownListeners[id] || _keyUpListeners[id] || _keyComboListeners[id] || _keySequenceListeners[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: id taken. Remove the current listener with that id first, or use another id.");
				return false;
			}
			
			if (functions.length == 1) {
				if (!(functions[0] is Function)) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: No functions given.");
					return false;
				}
				
				_keyDownListeners[id] = key;
				_keyDownListenerIds[_keyDownListenerIds.length] = id;
				_keyDownListenerFunctions[id] = functions[0] as Function;
				
				if (parameters && parameters.length > 0) {
					for (i = 0; i < parameters.length; i++) {
						if (parameters[i]) {
							if (!(parameters[i] is Array)) {
								if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
									parameters[i] = new Array(parameters[i].toString());
								}else {
									parameters[i] = new Array(parameters[i]);
								}
							}
						}else {
							parameters[i] = null;
						}
					}
					
					_keyDownListenerParameters[id] = parameters;
				}else {
					_keyDownListenerParameters[id] = null;
				}
			}else {
				length = functions.length;
				
				for (i = 0; i < length; i++) {
					if (functions[i] is Function) {
						functionCheck = true;
						
						if (parameters && parameters.length > 0) {
							if (parameters.length == i) {
								parameters[i] = null;
							}else {
								if (parameters[i]) {
									if (!(parameters[i] is Array)) {
										if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
											parameters[i] = new Array(parameters[i].toString());
										}else {
											parameters[i] = new Array(parameters[i]);
										}
									}
								}else {
									parameters[i] = null;
								}
							}
						}
					}else {
						if (parameters && parameters.length > 0) {
							parameters[i] = null;
						}
					}
				}
				
				if (!functionCheck) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: No functions given.");
					return false;
				}
				
				_keyDownListeners[id] = key;
				_keyDownListenerIds[_keyDownListenerIds.length] = id;
				_keyDownListenerFunctions[id] = functions;
				_keyDownListenerParameters[id] = parameters;
			}
			
			return true;
		}
		/**
		 * Adds a single key up listener which fires on a raw keyboard event.
		 * 
		 * @param	key The key code to listen for
		 * @param	id The listener ID
		 * @param	functions An array of functions to call when the event fires
		 * @param	parameters An array of parameters to pass the functions when the event fires. Arrays of arrays are used with multiple functions
		 * @return A boolean value describing whether or not the listener was successfully added
		 */
		public function addKeyUpListener(key:uint, id:String, functions:Array, parameters:Array = null):Boolean {
			var functionCheck:Boolean = false;
			var length:uint;
			var i:uint;
			var j:uint;
			
			if (!key || !id || !functions || functions.length == 0) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: key, id, and/or functions given were null or undefined");
				return false;
			}
			
			if (_keyDownListeners[id] || _keyUpListeners[id] || _keyComboListeners[id] || _keySequenceListeners[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: id taken. Remove the current listener with that id first, or use another id.");
				return false;
			}
			
			if (functions.length == 1) {
				if (!(functions[0] is Function)) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: No functions given.");
					return false;
				}
				
				_keyUpListeners[id] = key;
				_keyUpListenerIds[_keyUpListenerIds.length] = id;
				_keyUpListenerFunctions[id] = functions[0] as Function;
				
				if (parameters && parameters.length > 0) {
					for (i = 0; i < parameters.length; i++) {
						if (parameters[i]) {
							if (!(parameters[i] is Array)) {
								if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
									parameters[i] = new Array(parameters[i].toString());
								}else {
									parameters[i] = new Array(parameters[i]);
								}
							}
						}else {
							parameters[i] = null;
						}
					}
					
					_keyUpListenerParameters[id] = parameters;
				}else {
					_keyUpListenerParameters[id] = null;
				}
			}else {
				length = functions.length;
				
				for (i = 0; i < length; i++) {
					if (functions[i] is Function) {
						functionCheck = true;
						
						if (parameters && parameters.length > 0) {
							if (parameters.length == i) {
								parameters[i] = null;
							}else {
								if (parameters[i]) {
									if (!(parameters[i] is Array)) {
										if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
											parameters[i] = new Array(parameters[i].toString());
										}else {
											parameters[i] = new Array(parameters[i]);
										}
									}
								}else {
									parameters[i] = null;
								}
							}
						}
					}else {
						if (parameters && parameters.length > 0) {
							parameters[i] = null;
						}
					}
				}
				
				if (!functionCheck) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownListener: No functions given.");
					return false;
				}
				
				_keyUpListeners[id] = key;
				_keyUpListenerIds[_keyUpListenerIds.length] = id;
				_keyUpListenerFunctions[id] = functions;
				_keyUpListenerParameters[id] = parameters;
			}
			
			return true;
		}
		/**
		 * Adds a key combo listener which fires on a raw keyboard event.
		 * @param	keys The key codes to listen for
		 * @param	id The listener ID
		 * @param	functions An array of functions to call when the event fires
		 * @param	strict A boolean dictating whether or not the keys must be pressed in the order given
		 * @param	parameters An array of parameters to pass the functions when the event fires. Arrays of arrays are used with multiple functions
		 * @return A boolean value describing whether or not the listener was successfully added
		 */
		public function addKeyDownComboListener(keys:Array, id:String, functions:Array, strict:Boolean = false, parameters:Array = null):Boolean {
			var functionCheck:Boolean = false;
			var length:uint;
			var i:uint;
			var j:uint;
			
			if (!keys || !id || !functions || functions.length == 0) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: keys, id, and/or functions given were null or undefined");
				return false;
			}
			
			if (keys.length == 1) {
				if (keys[0] is uint || keys[0] is int || keys[0] is Number) {
					return addKeyDownListener(keys[0], id, functions, parameters);
				}
			}
			
			if (_keyDownListeners[id] || _keyUpListeners[id] || _keyComboListeners[id] || _keySequenceListeners[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: id taken. Remove the current listener with that id first, or use another id.");
				return false;
			}
			
			length = keys.length;
			for (i = 0; i < length; i++) {
				if (keys[i] is int || keys[i] is Number) {
					keys[i] = keys[i] as uint;
				}else if (!(keys[i] is uint)) {
					keys.splice(i, 1);
				}
			}
			
			if (functions.length == 1) {
				if (!(functions[0] is Function)) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: No functions given.");
					return false;
				}
				
				_keyComboListeners[id] = keys;
				_keyComboListenerIds[_keyComboListenerIds.length] = id;
				_keyComboListenerFunctions[id] = functions[0] as Function;
				
				if (parameters && parameters.length > 0) {
					for (i = 0; i < parameters.length; i++) {
						if (parameters[i]) {
							if (!(parameters[i] is Array)) {
								if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
									parameters[i] = new Array(parameters[i].toString());
								}else {
									parameters[i] = new Array(parameters[i]);
								}
							}
						}else {
							parameters[i] = null;
						}
					}
					
					_keyComboListenerParameters[id] = parameters;
				}else {
					_keyComboListenerParameters[id] = null;
				}
				
				_keyComboListenerStrict[id] = strict;
			}else {
				length = functions.length;
				
				for (i = 0; i < length; i++) {
					if (functions[i] is Function) {
						functionCheck = true;
						
						if (parameters && parameters.length > 0) {
							if (parameters.length == i) {
								parameters[i] = null;
							}else {
								if (parameters[i]) {
									if (!(parameters[i] is Array)) {
										if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
											parameters[i] = new Array(parameters[i].toString());
										}else {
											parameters[i] = new Array(parameters[i]);
										}
									}
								}else {
									parameters[i] = null;
								}
							}
						}
					}else {
						if (parameters && parameters.length > 0) {
							parameters[i] = null;
						}
					}
				}
				
				if (!functionCheck) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: No functions given.");
					return false;
				}
				
				_keyComboListeners[id] = keys;
				_keyComboListenerIds[_keyComboListenerIds.length] = id;
				_keyComboListenerFunctions[id] = functions;
				_keyComboListenerParameters[id] = parameters;
				
				_keyComboListenerStrict[id] = strict;
			}
			
			if (keys.length > _longestCombo) {
				_longestCombo = keys.length;
			}
			
			return true;
		}
		/**
		 * Adds a key sequence listener which fires on a raw keyboard event.
		 * 
		 * @param	keys The key codes to listen for
		 * @param	id The listener ID
		 * @param	functions An array of functions to call when the event fires
		 * @param	strict A boolean dictating whether or not the keys must be pressed in the order given
		 * @param	parameters An array of parameters to pass the functions when the event fires. Arrays of arrays are used with multiple functions
		 * @return A boolean value describing whether or not the listener was successfully added
		 */
		public function addKeyUpComboListener(keys:Array, id:String, functions:Array, strict:Boolean = true, parameters:Array = null):Boolean {
			var functionCheck:Boolean = false;
			var length:uint;
			var i:uint;
			var j:uint;
			
			if (!keys || !id || !functions || functions.length == 0) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: keys, id, and/or functions given were null or undefined");
				return false;
			}
			
			if (keys.length == 1) {
				if (keys[0] is uint || keys[0] is int || keys[0] is Number) {
					return addKeyUpListener(keys[0], id, functions, parameters);
				}
			}
			
			if (_keyDownListeners[id] || _keyUpListeners[id] || _keyComboListeners[id] || _keySequenceListeners[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: id taken. Remove the current listener with that id first, or use another id.");
				return false;
			}
			
			length = keys.length;
			for (i = 0; i < length; i++) {
				if (keys[i] is int || keys[i] is Number) {
					keys[i] = keys[i] as uint;
				}else if (!(keys[i] is uint)) {
					keys.splice(i, 1);
				}
			}
			
			if (functions.length == 1) {
				if (!(functions[0] is Function)) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: No functions given.");
					return false;
				}
				
				_keySequenceListeners[id] = keys;
				_keySequenceListenerIds[_keySequenceListenerIds.length] = id;
				_keySequenceListenerFunctions[id] = functions[0] as Function;
				
				if (parameters && parameters.length > 0) {
					for (i = 0; i < parameters.length; i++) {
						if (parameters[i]) {
							if (!(parameters[i] is Array)) {
								if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
									parameters[i] = new Array(parameters[i].toString());
								}else {
									parameters[i] = new Array(parameters[i]);
								}
							}
						}else {
							parameters[i] = null;
						}
					}
					
					_keySequenceListenerParameters[id] = parameters;
				}else {
					_keySequenceListenerParameters[id] = null;
				}
				
				_keySequenceListenerStrict[id] = strict;
			}else {
				length = functions.length;
				
				for (i = 0; i < length; i++) {
					if (functions[i] is Function) {
						functionCheck = true;
						
						if (parameters && parameters.length > 0) {
							if (parameters.length == i) {
								parameters[i] = null;
							}else {
								if (parameters[i]) {
									if (!(parameters[i] is Array)) {
										if (parameters[i] is uint || parameters[i] is int || parameters[i] is Number) {
											parameters[i] = new Array(parameters[i].toString());
										}else {
											parameters[i] = new Array(parameters[i]);
										}
									}
								}else {
									parameters[i] = null;
								}
							}
						}
					}else {
						if (parameters && parameters.length > 0) {
							parameters[i] = null;
						}
					}
				}
				
				if (!functionCheck) {
					LOG_SIGNAL.dispatch(0, "KeyListener - addKeyDownComboListener: No functions given.");
					return false;
				}
				
				_keySequenceListeners[id] = keys;
				_keySequenceListenerIds[_keySequenceListenerIds.length] = id;
				_keySequenceListenerFunctions[id] = functions;
				_keySequenceListenerParameters[id] = parameters;
				
				_keySequenceListenerStrict[id] = strict;
			}
			
			if (keys.length > _longestSequence) {
				_longestSequence = keys.length;
			}
			
			return true;
		}
		
		/**
		 * Adds a timer to an existing key listener with the specified id.
		 * 
		 * @param	id The listener ID
		 * @param	time A usint value distating the amount of time (in milliseconds) to wait before firing the event
		 * @param	hold A boolean value dictating whether or not the event fires contually. Only used for keyDown listeners
		 * @return A boolean value describing whether or not the timer was successfully added
		 */
		public function addTimer(id:String, time:uint, hold:Boolean = true):Boolean {
			var type:String = "";
			var i:uint;
			var length:uint;
			
			if (!id || !time) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id and/or time given was null or undefined.");
				return false;
			}
			
			if (_keyDownListeners[id]) {
				type = "keyDown";
			}else if (_keyUpListeners[id]) {
				type = "keyUp";
			}else if (_keyComboListeners[id]) {
				type = "combo";
			}else if (_keySequenceListeners[id]) {
				type = "sequence";
			}else {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id given was not found.");
				return false;
			}
			
			if (type == "keyDown" && _keyDownListenerTimers[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id given already has a timer. Remove that timer before adding another one.");
				return false;
			}else if (type == "keyUp" && _keyUpListenerTimers[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id given already has a timer. Remove that timer before adding another one.");
				return false;
			}else if (type == "combo" && _keyComboListenerTimers[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id given already has a timer. Remove that timer before adding another one.");
				return false;
			}else if (_keySequenceListenerTimers[id]) {
				LOG_SIGNAL.dispatch(0, "KeyListener - addTimer: id given already has a timer. Remove that timer before adding another one.");
				return false;
			}
			
			if (type == "keyDown") {
				if (hold) {
					_keyDownListenerTimers[id] = new CustomTimer(id, time, 0);
				}else {
					_keyDownListenerTimers[id] = new CustomTimer(id, time, 1);
				}
			}else if (type == "keyUp") {
				_keyUpListenerTimers[id] = new CustomTimer(id, time, 1);
			}else if (type == "combo") {
				if (hold) {
					_keyComboListenerTimers[id] = new CustomTimer(id, time, 0);
				}else {
					_keyComboListenerTimers[id] = new CustomTimer(id, time, 1);
				}
			}else {
				_keySequenceListenerTimers[id] = new CustomTimer(id, time, 1);
			}
			
			return true;
		}
		
		/**
		 * Removes an existing timer from the keyListener with the specified id.
		 * 
		 * @param	id
		 * @return
		 */
		public function removeTimer(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "KeyListener - removeTimer: id given was null or undefined.");
				return false;
			}
			
			if (_keyDownListeners[id]) {
				if (_keyDownListenerTimers[id]) {
					_keyDownListenerTimers[id] = null;
				}
			}else if (_keyUpListeners[id]) {
				if (_keyUpListenerTimers[id]) {
					_keyUpListenerTimers[id] = null;
				}
			}else if (_keyComboListeners[id]) {
				if (_keyComboListenerTimers[id]) {
					_keyComboListenerTimers[id] = null;
				}
			}else if (_keySequenceListeners[id]) {
				if (_keySequenceListenerTimers[id]) {
					_keySequenceListenerTimers[id] = null;
				}
			}else {
				LOG_SIGNAL.dispatch(0, "KeyListener - removeTimer: id given was not found.");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Removes an existing key listener with the specified id.
		 * 
		 * @param	id
		 * @return
		 */
		public function removeListener(id:String):Boolean {
			var i:uint;
			var j:uint;
			
			if (!id) {
				LOG_SIGNAL.dispatch(0, "KeyListener - removeListener: id given was null or undefined.");
				return false;
			}
			
			if (_keyDownListeners[id]) {
				for (i = 0; i < _keyDownListenerIds.length; i++) {
					if (_keyDownListenerIds[i] == id) {
						_keyDownListenerIds.splice(i, 1);
						break;
					}
				}
				
				_keyDownListeners[id] = null;
				_keyDownListenerFunctions[id] = null;
				_keyDownListenerParameters[id] = null;
				if (_keyDownListenerTimers[id]) {
					_keyDownListenerTimers[id] = null;
				}
			}else if (_keyUpListeners[id]) {
				for (i = 0; i < _keyUpListenerIds.length; i++) {
					if (_keyUpListenerIds[i] == id) {
						_keyUpListenerIds.splice(i, 1);
						break;
					}
				}
				
				_keyUpListeners[id] = null;
				_keyUpListenerFunctions[id] = null;
				_keyUpListenerParameters[id] = null;
				if (_keyUpListenerTimers[id]) {
					_keyUpListenerTimers[id] = null;
				}
			}else if (_keyComboListeners[id]) {
				for (i = 0; i < _keyComboListenerIds.length; i++) {
					if (_keyComboListenerIds[i] == id) {
						if (_keyComboListenerIds[i].length == _longestCombo) {
							_keyComboListenerIds.splice(i, 1);
							
							_longestCombo = 0;
							for (j = 0; j < _keyComboListenerIds.length; j++) {
								if (_keyComboListenerIds.length > _longestCombo) {
									_longestCombo = _keyComboListenerIds.length;
								}
							}
						}else {
							_keyComboListenerIds.splice(i, 1);
						}
						
						break;
					}
				}
				
				_keyComboListeners[id] = null;
				_keyComboListenerFunctions[id] = null;
				_keyComboListenerParameters[id] = null;
				if (_keyComboListenerTimers[id]) {
					_keyComboListenerTimers[id] = null;
				}
			}else if (_keySequenceListeners[id]) {
				for (i = 0; i < _keySequenceListenerIds.length; i++) {
					if (_keySequenceListenerIds[i] == id) {
						if (_keySequenceListenerIds[i].length == _longestSequence) {
							_keySequenceListenerIds.splice(i, 1);
							
							_longestSequence = 0;
							for (j = 0; j < _keySequenceListenerIds.length; j++) {
								if (_keySequenceListenerIds.length > _longestSequence) {
									_longestSequence = _keySequenceListenerIds.length;
								}
							}
						}else {
							_keySequenceListenerIds.splice(i, 1);
						}
						
						break;
					}
				}
				
				_keySequenceListeners[id] = null;
				_keySequenceListenerFunctions[id] = null;
				_keySequenceListenerParameters[id] = null;
				if (_keySequenceListenerTimers[id]) {
					_keySequenceListenerTimers[id] = null;
				}
			}else {
				LOG_SIGNAL.dispatch(0, "KeyListener - removeListener: id given was not found.");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Edits the parameters of an existing key listener with the specified id.
		 * 
		 * @param	id
		 * @param	params
		 */
		public function modifyParams(id:String, params:Array):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "KeyListener - modifyParams: id given was null or undefined.");
				return false;
			}
			
			if (_keyDownListeners[id]) {
				
			}else if (_keyUpListeners[id]) {
				
			}else if (_keyComboListeners[id]) {
				
			}else if (_keySequenceListeners[id]) {
				
			}else {
				LOG_SIGNAL.dispatch(0, "KeyListener - modifyParams: id given was not found.");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Forces a key event to trigger.
		 * 
		 * @param	id The id of the key event to force trigger
		 */
		public function force(id:String):Boolean {
			if (!id) {
				LOG_SIGNAL.dispatch(0, "KeyListener - force: id given was null or undefined.");
				return false;
			}
			
			if (_keyDownListeners[id]) {
				callKeyDownFunction(id);
			}else if (_keyUpListeners[id]) {
				callKeyUpFunction(id);
			}else if (_keyComboListeners[id]) {
				callComboFunction(id);
			}else if (_keySequenceListeners[id]) {
				callSequenceFunction(id);
			}else {
				LOG_SIGNAL.dispatch(0, "KeyListener - force: id given was not found.");
				return false;
			}
			
			return true;
		}
		
		//private
		private function onKeyDown(e:KeyboardEvent):void {
			var inVector:Boolean = false;
			
			if (e.keyCode > 0) {
				_keys[e.keyCode] = true;
				
				checkDownKeyListener(e.keyCode);
				
				if (_currentCombo.length <= _longestCombo) {
					for (var i:uint = 0; i < _currentCombo.length; i++) {
						if (_currentCombo[i] == e.keyCode) {
							inVector = true;
						}
					}
					
					if (!inVector) {
						_currentCombo[_currentCombo.length] = e.keyCode;
					}
					
					checkComboListener(e.keyCode);
				}
			}
		}
		private function onKeyUp(e:KeyboardEvent):void {
			var i:uint;
			
			if (e.keyCode > 0) {
				_keys[e.keyCode] = false;
				
				removeDownKeyListener(e.keyCode);
				checkUpKeyListener(e.keyCode);
				
				for (i = 0; i < _currentCombo.length; i++) {
					if (_currentCombo[i] == e.keyCode) {
						_currentCombo.splice(i, 1);
					}
				}
				
				removeComboListener(e.keyCode);
				
				if (_currentSequence.length <= _longestSequence) {
					_currentSequence[_currentSequence.length] = e.keyCode;
					
					if (!_sequenceTimer.hasEventListener(TimerEvent.TIMER_COMPLETE)) {
						_sequenceTimer.addEventListener(TimerEvent.TIMER_COMPLETE, resetSequence);
					}
					
					_sequenceTimer.reset();
					_sequenceTimer.start();
					
					checkSequenceListener(e.keyCode);
				}else {
					resetSequence();
				}
			}
		}
		
		private function onKeyListenerTimer(e:TimerEvent):void {
			if (_keyDownListeners[e.target.id]) {
				callKeyDownFunction(e.target.id);
			}else if (_keyUpListeners[e.target.id]) {
				callKeyUpFunction(e.target.id);
				
				e.target.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
			}else if (_keyComboListeners[e.target.id]) {
				callComboFunction(e.target.id);
			}else {
				callSequenceFunction(e.target.id);
				
				e.target.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
			}
		}
		
		private function resetSequence(e:TimerEvent = null):void {
			_currentSequence = new Vector.<uint>;
			
			_sequenceTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, resetSequence);
		}
		
		private function checkDownKeyListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			var i:uint;
			
			if (_keyDownListenerIds.length > 0) {
				for (i = 0; i < _keyDownListenerIds.length; i++) {
					if (keyCode == _keyDownListeners[_keyDownListenerIds[i]]) {
						if (_keyDownListenerTimers[_keyDownListenerIds[i]]) {
							tempTimer = _keyDownListenerTimers[_keyDownListenerIds[i]] as CustomTimer;
							
							if (!tempTimer.hasEventListener(TimerEvent.TIMER)) {
								tempTimer.addEventListener(TimerEvent.TIMER, onKeyListenerTimer);
								tempTimer.start();
							}
						}else {
							callKeyDownFunction(_keyDownListenerIds[i]);
						}
					}
				}
			}
		}
		private function checkUpKeyListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			
			if (_keyUpListenerIds.length > 0) {
				for (var i:uint = 0; i < _keyUpListenerIds.length; i++) {
					if (keyCode == _keyUpListeners[_keyUpListenerIds[i]]) {
						if (_keyUpListenerTimers[_keyUpListenerIds[i]]) {
							tempTimer = _keyUpListenerTimers[_keyUpListenerIds[i]] as CustomTimer;
							
							if (!tempTimer.hasEventListener(TimerEvent.TIMER)) {
								tempTimer.addEventListener(TimerEvent.TIMER, onKeyListenerTimer);
								tempTimer.start();
							}
						}else {
							callKeyUpFunction(_keyUpListenerIds[i]);
						}
					}
				}
			}
		}
		private function checkComboListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			
			for (var i:uint = 0; i < _keyComboListenerIds.length; i++) {
				if (checkComboKeys(i)) {
					if (_keyComboListenerTimers[_keyComboListenerIds[i]]) {
						tempTimer = _keyComboListenerTimers[_keyComboListenerIds[i]] as CustomTimer;
						
						if (!tempTimer.hasEventListener(TimerEvent.TIMER)) {
							tempTimer.addEventListener(TimerEvent.TIMER, onKeyListenerTimer);
							tempTimer.start();
						}
					}else {
						callComboFunction(_keyComboListenerIds[i]);
					}
				}else {
					if (_keyComboListenerTimers[_keyComboListenerIds[i]]) {
						tempTimer = _keyComboListenerTimers[_keyComboListenerIds[i]] as CustomTimer;
						
						if (tempTimer.hasEventListener(TimerEvent.TIMER)) {
							tempTimer.stop();
							tempTimer.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
						}
					}
				}
			}
		}
		private function checkSequenceListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			var keyGood:Boolean = false;
			
			for (var i:uint = 0; i < _keySequenceListenerIds.length; i++) {
				if (checkSequenceKeys(i)) {
					keyGood = true;
					
					if (_keySequenceListenerTimers[_keySequenceListenerIds[i]]) {
						tempTimer = _keySequenceListenerTimers[_keySequenceListenerIds[i]] as CustomTimer;
						
						if (!tempTimer.hasEventListener(TimerEvent.TIMER)) {
							tempTimer.addEventListener(TimerEvent.TIMER, onKeyListenerTimer);
							tempTimer.start();
						}
					}else {
						callSequenceFunction(_keySequenceListenerIds[i]);
					}
				}
			}
			
			if (keyGood) {
				_currentSequence = new Vector.<uint>;
			}
		}
		
		private function removeDownKeyListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			var i:uint;
			
			if (_keyDownListenerIds.length > 0) {
				for (i = 0; i < _keyDownListenerIds.length; i++) {
					if (keyCode == _keyDownListeners[_keyDownListenerIds[i]]) {
						if (_keyDownListenerTimers[_keyDownListenerIds[i]]) {
							tempTimer = _keyDownListenerTimers[_keyDownListenerIds[i]] as CustomTimer;
							
							if (tempTimer.hasEventListener(TimerEvent.TIMER)) {
								tempTimer.stop();
								tempTimer.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
							}
						}
					}
				}
			}
		}
		private function removeUpKeyListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			
			if (_keyUpListenerIds.length > 0) {
				for (var i:uint = 0; i < _keyUpListenerIds.length; i++) {
					if (keyCode == _keyUpListeners[_keyUpListenerIds[i]]) {
						if (_keyUpListenerTimers[_keyUpListenerIds[i]]) {
							tempTimer = _keyUpListenerTimers[_keyUpListenerIds[i]] as CustomTimer;
							
							if (tempTimer.hasEventListener(TimerEvent.TIMER)) {
								tempTimer.stop();
								tempTimer.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
							}
						}
					}
				}
			}
		}
		private function removeComboListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			
			for (var i:uint = 0; i < _keyComboListenerIds.length; i++) {
				if (_keyComboListenerTimers[_keyComboListenerIds[i]]) {
					tempTimer = _keyComboListenerTimers[_keyComboListenerIds[i]] as CustomTimer;
					
					if (tempTimer.hasEventListener(TimerEvent.TIMER)) {
						tempTimer.stop();
						tempTimer.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
					}
				}
			}
		}
		private function removeSequenceListener(keyCode:uint):void {
			var tempTimer:CustomTimer;
			
			for (var i:uint = 0; i < _keySequenceListenerIds.length; i++) {
				if (_keySequenceListenerTimers[_keySequenceListenerIds[i]]) {
					tempTimer = _keySequenceListenerTimers[_keySequenceListenerIds[i]] as CustomTimer;
					
					if (tempTimer.hasEventListener(TimerEvent.TIMER)) {
						tempTimer.stop();
						tempTimer.removeEventListener(TimerEvent.TIMER, onKeyListenerTimer);
					}
				}
			}
		}
		
		private function callKeyDownFunction(id:String):void {
			var tempFunction:Function;
			var length:uint;
			var i:uint;
			
			if (_keyDownListenerFunctions[id] is Array) {
				length = _keyDownListenerFunctions[id].length;
				for (i = 0; i < length; i++) {
					if (_keyDownListenerFunctions[id][i]) {
						tempFunction = _keyDownListenerFunctions[id][i];
						
						tempFunction.apply(null, _keyDownListenerParameters[id][i]);
					}
				}
			}else {
				tempFunction = _keyDownListenerFunctions[id];
				
				tempFunction.apply(null, _keyDownListenerParameters[id]);
			}
		}
		private function callKeyUpFunction(id:String):void {
			var tempFunction:Function;
			var length:uint;
			var i:uint;
			
			if (_keyUpListenerFunctions[id] is Array) {
				length = _keyUpListenerFunctions[id].length;
				for (i = 0; i < length; i++) {
					if (_keyUpListenerFunctions[id][i]) {
						tempFunction = _keyUpListenerFunctions[id][i];
						
						tempFunction.apply(null, _keyUpListenerParameters[id][i]);
					}
				}
			}else {
				tempFunction = _keyUpListenerFunctions[id];
				
				tempFunction.apply(null, _keyUpListenerParameters[id]);
			}
		}
		private function callComboFunction(id:String):void {
			var tempFunction:Function;
			var length:uint;
			var i:uint;
			
			if (_keyComboListenerFunctions[id] is Array) {
				length = _keyComboListenerFunctions[id].length;
				for (i = 0; i < length; i++) {
					if (_keyComboListenerFunctions[id][i]) {
						tempFunction = _keyComboListenerFunctions[id][i];
						
						tempFunction.apply(null, _keyComboListenerParameters[id][i]);
					}
				}
			}else {
				tempFunction = _keyComboListenerFunctions[id];
				
				tempFunction.apply(null, _keyComboListenerParameters[id]);
			}
		}
		private function callSequenceFunction(id:String):void {
			var tempFunction:Function;
			var length:uint;
			var i:uint;
			
			if (_keySequenceListenerFunctions[id] is Array) {
				length = _keySequenceListenerFunctions[id].length;
				for (i = 0; i < length; i++) {
					if (_keySequenceListenerFunctions[id][i]) {
						tempFunction = _keySequenceListenerFunctions[id][i];
						
						tempFunction.apply(null, _keySequenceListenerParameters[id][i]);
					}
				}
			}else {
				tempFunction = _keySequenceListenerFunctions[id];
				
				tempFunction.apply(null, _keySequenceListenerParameters[id]);
			}
		}
		
		private function checkComboKeys(arrayNum:uint):Boolean {
			var keyArray:Array = _keyComboListeners[_keyComboListenerIds[arrayNum]] as Array;
			var goodKey:Boolean;
			
			if (keyArray.length != _currentCombo.length) {
				return false;
			}
			
			for (var i:uint = 0; i < keyArray.length; i++) {
				if (_keyComboListenerStrict[_keyComboListenerIds[arrayNum]]) {
					if (_currentCombo[i] != keyArray[i]) {
						return false;
					}
				}else {
					goodKey = false;
					for (var j:uint = 0; j < _currentCombo.length; j++) {
						if (_currentCombo[j] == keyArray[i]) {
							goodKey = true;
						}
					}
					
					if (!goodKey) {
						return false;
					}
				}
			}
			
			return true;
		}
		private function checkSequenceKeys(arrayNum:uint):Boolean {
			var keyArray:Array = _keySequenceListeners[_keySequenceListenerIds[arrayNum]] as Array;
			var goodKey:Boolean;
			
			if (keyArray.length != _currentSequence.length) {
				return false;
			}
			
			for (var i:uint = 0; i < keyArray.length; i++) {
				if (_keySequenceListenerStrict[_keySequenceListenerIds[arrayNum]]) {
					if (_currentSequence[i] != keyArray[i]) {
						return false;
					}
				}else {
					goodKey = false;
					for (var j:uint = 0; j < _currentSequence.length; j++) {
						if (_currentSequence[j] == keyArray[i]) {
							goodKey = true;
						}
					}
					
					if (!goodKey) {
						return false;
					}
				}
			}
			
			return true;
		}
	}
}