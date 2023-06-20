
calculateFibonachi = {
	params ["_fibNumber"];
_thread_id = ["thread_example.call_slow_fibonacci", [_fibNumber]] call py3_fnc_callExtension;

_number = 0;

while {
	! (["thread_example.has_call_finished", [_thread_id]] call py3_fnc_callExtension)
} do {
	_number = _number + 1;
	systemChat format ["%1:%2", _number ,["thread_example.has_call_finished", [_thread_id]] call py3_fnc_callExtension ];
	sleep 1;
};


systemChat format ["%1", ["thread_example.get_call_value", [_thread_id]] call py3_fnc_callExtension];
};

radioOn = false;


rhinoIsGo = {
	params ["_phrase"];

	if(_phrase find "This is FAK to B2. Rhino is a go" >= 0) then {
		sleep 1;
		he_b2 sideChat "This is B2 starting bombing run, out.";
		[[7147.03,11809.3,0],objNull,[7248.3,11798.1,0]] call VN_fnc_artillery_arc_light;
	} else {
		// systemChat "false";
	}
};

createAsync = {
	params ["_command"];
	diag_log format ["thread command: %1", _command];

	private _thread_id = [_command, []] call py3_fnc_callExtension;

	diag_log format ["thread id: %1", _thread_id];

	// diag_log format ["%1",["thread_example.has_call_finished", [_thread_id]] call py3_fnc_callExtension];

	// while {
	// 	! (["thread_example.has_call_finished", [_thread_id]] call py3_fnc_callExtension)
	// } do {
	// 	systemChat format ["%1",["thread_example.has_call_finished", [_thread_id]] call py3_fnc_callExtension];
	// 	sleep 1;
	// };

	waitUntil { ["record.has_call_finished", [_thread_id]] call py3_fnc_callExtension};

	_response = ["record.get_call_value", [_thread_id]] call py3_fnc_callExtension;

	// systemChat format ["Debug: %1: %2",str _response, count _response];

	if(str _response find "complete recording" >= 0) then {
		systemChat format ["%1",_response];
	};

	if(str _response find "complete transcription" >= 0) then {
		systemChat format ["%1",_response#0];
		player sideChat format ["%1", _response#1];
	};

	if(str _response find "complete communication chatGPT" >= 0) then {
		systemChat format ["%1",_response#0];
		he_fak sideChat format ["%1", _response#1];
		[_response#1] spawn rhinoIsGo;
	};
	// if(count _response < 1) then {
	// 	systemChat format ["%1",_response];
	// };

	// if(count _response < 2) then {
	// 	systemChat format ["%1",_response#0];
	// };

	// if(count _response < 3) then {
	// 	systemChat format ["%1",_response#0];
	// 	player sideChat format ["%1", _response#1];
	// };

};

pipeline = {
	params ["_keyDown"];
	_keyDown params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];


	if (_key isEqualTo 45 && radioOn == false) then {
		radioOn = true;
		hint "recording";
		_scriptHandle = ["record.recordAsync"] spawn createAsync;
		waitUntil { scriptDone _scriptHandle };
		_scriptHandle = ["record.transcribe_audioAsync"] spawn createAsync;
		waitUntil { scriptDone _scriptHandle };
		_scriptHandle = ["record.chat_with_gptAsync"] spawn createAsync;
		waitUntil { scriptDone _scriptHandle };
		// systemChat format ["%1", ["basic.hello", []] call py3_fnc_callExtension];
		// _response = ["record.record", []] call py3_fnc_callExtension;
		radioOn = false;
	}
};


transcribeAudio = {

};

waitUntil { !isNull (findDisplay 46) };

moduleName_keyDownEHId = findDisplay 46 displayAddEventHandler ["KeyDown", "[_this] spawn pipeline"];
// moduleName_keyDownEHId = findDisplay 46 displayAddEventHandler ["onKeyUp", "_radioOn = false"];
