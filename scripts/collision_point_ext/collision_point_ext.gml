///@func collision_point_ext(x, y, objs, prec, notme, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, objs, prec, notme;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 6:
		suchthatFunc = argument[5];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 5:
		xx = argument[0];
		yy = argument[1];
		objs = argument[2];
		prec = argument[3];
		notme = argument[4];
		break;
	default:
		show_error("Expected 5 or 6 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length_1d(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = collision_point(xx, yy, objs[i], prec, notme);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (notme && id == other.id) continue;
						if (collision_point(xx, yy, id, prec, false) && script_execute(suchthatFunc, id, other.id, suchthatArg)) {
							return id;
						}
					}
				}
			}
			return noone;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_point(xx, yy, objs, prec, notme);
}

// Single target with filter
with (objs) {
	if (notme && id == other.id) continue;
	if (collision_point(xx, yy, id, prec, false) && script_execute(suchthatFunc, id, other.id, suchthatArg)) {
		return id;
	}
}

// No collision
return noone;