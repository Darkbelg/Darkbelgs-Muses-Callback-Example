
sogCallback = {
	params ["_response"];
	diag_log format ["response: %1", _response];
	_coordinatesArr = _response#1;
	_xCoordinate = ((parseNumber(_coordinatesArr#2)) * 100);
	_yCoordinate = ((parseNumber(_coordinatesArr#3)) * 100);
	_myNearestEnemy = player findNearestEnemy [_xCoordinate, _yCoordinate];
	_nearestEnemyPosition = [_xCoordinate, _yCoordinate,0];

	diag_log format ["_myNearestEnemy:%1", str _myNearestEnemy];

	
	if ( not (isNull _myNearestEnemy) && getPosASL _myNearestEnemy distance2D  [_xCoordinate, _yCoordinate] <= 100) then {
		_nearestEnemyPosition = getPosATL _myNearestEnemy;
	};

	diag_log format ["_nearestEnemyPosition:%1", _nearestEnemyPosition];

	if((str (_coordinatesArr)) find "vn_fnc_artillery_arc_light" > -1) then {
		he_fak sideChat format ["%1", _coordinatesArr#0];
		[_nearestEnemyPosition, objNull, _nearestEnemyPosition] spawn VN_fnc_artillery_arc_light;

	};

	if((str (_coordinatesArr)) find "vn_fnc_artillery_plane" > -1) then {
		he_fak sideChat format ["%1", _coordinatesArr#0];
		vn_artillery_captive = false;
		[0, configfile >> "CfgVehicles" >> "vn_b_air_f4b_navy_at", "vn_b_air_f4b_navy_at", _nearestEnemyPosition, _nearestEnemyPosition vectorAdd [100,100,0], 0, [_coordinatesArr#4], objNull, 0] spawn VN_fnc_artillery_plane;
	};

	if((str (_coordinatesArr)) find "vn_fnc_artillery_heli" > -1) then {
		he_fak sideChat format ["%1", _coordinatesArr#0];
		vn_artillery_captive = false;
		[0, configfile >> "CfgVehicles" >> "vn_b_air_uh1c_01_03", "vn_b_air_uh1c_01_03", _nearestEnemyPosition, _nearestEnemyPosition vectorAdd [100,100,0],0,[_coordinatesArr#4],objNull,0] spawn VN_fnc_artillery_heli;
	
	};

	if(_coordinatesArr#1 == "" || _coordinatesArr#0 == "") then {
		he_fak sideChat format ["%1", _coordinatesArr#0];
	}

};

[] spawn {
	(loadFile "ao_outside_instructions.txt") call DBMU_fnc_setInstructions;
	[sogCallback] call DBMU_fnc_setCallback;
};
