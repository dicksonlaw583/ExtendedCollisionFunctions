///@func position_meeting_ext(x, y, obj, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param obj Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, objs;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 4:
		suchthatFunc = argument[3];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 3:
		xx = argument[0];
		yy = argument[1];
		objs = argument[2];
		break;
	default:
		show_error("Expected 3 or 4 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length_1d(objs);
	switch (nObjs) {
		case 0: return false; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					if (position_meeting(xx, yy, objs[i])) {
						return true;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (position_meeting(xx, yy, id) && script_execute(suchthatFunc, id, other.id, suchthatArg)) {
							return true;
						}
					}
				}
			}
			return false;
	}
}

// Single target, no filter
if (noFilter) {
	return position_meeting(xx, yy, objs);
}

// Single target with filter
with (objs) {
	if (position_meeting(xx, yy, id) && script_execute(suchthatFunc, id, other.id, suchthatArg)) {
		return true;
	}
}

// No collision
return false;
