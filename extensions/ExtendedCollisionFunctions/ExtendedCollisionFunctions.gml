#define __instance_is_instance_of_any__
///@func __instance_is_instance_of_any__(id, objs)
///@param id The ID of the instance
///@param objs Array of object identities
for (var i = array_length(argument1)-1; i >= 0; --i) {
	var obji = argument1[i];
	switch (obji) {
		case all: return true;
		case noone: break;
		/*
		case other:
			if (argument0 == other.id) return true;
			break;
		case self:
			if (argument0 == id) return true;
			break;
		*/
		default:
			if (argument0 == obji || (object_exists(obji) && (argument0.object_index == obji || object_is_ancestor(argument0.object_index, obji)))) return true;
	}
}
return false;

#define collision_circle_ext
///@func collision_circle_ext(x, y, rad, objs, prec, notme, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param rad Radius to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, rad, objs, prec, notme;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 7:
		suchthatFunc = argument[6];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 6:
		xx = argument[0];
		yy = argument[1];
		rad = argument[2];
		objs = argument[3];
		prec = argument[4];
		notme = argument[5];
		break;
	default:
		show_error("Expected 6 or 7 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = collision_circle(xx, yy, rad, objs[i], prec, notme);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (notme && id == other.id) continue;
						if (collision_circle(xx, yy, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return collision_circle(xx, yy, rad, objs, prec, notme);
}

// Single target with filter
with (objs) {
	if (notme && id == other.id) continue;
	if (collision_circle(xx, yy, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define collision_circle_list_ext
///@func collision_circle_list_ext(x, y, rad, objs, prec, notme, list, ordered, [suchthat])
///@param x X position of the circle's centre
///@param y Y position of the circle's centre
///@param rad Radius of the circle
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the centre of the shape
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, rad, objs, prec, notme, list, ordered;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 9:
		suchthatFunc = argument[8];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 8:
		xx = argument[0];
		yy = argument[1];
		rad = argument[2];
		objs = argument[3];
		prec = argument[4];
		notme = argument[5];
		list = argument[6];
		ordered = argument[7];
		break;
	default:
		show_error("Expected 8 or 9 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = collision_circle_list(xx, yy, rad, all, prec, notme, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_circle_list(xx, yy, rad, objs, prec, notme, list, ordered);
}

// Single target with filter
for (var i = collision_circle_list(xx, yy, rad, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define collision_ellipse_ext
///@func collision_ellipse_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param x1 X position to start
///@param y1 Y position to start
///@param x2 X position to end
///@param y2 Y position to end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 8:
		suchthatFunc = argument[7];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 7:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		break;
	default:
		show_error("Expected 7 or 8 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = collision_ellipse(xx, yy, xxx, yyy, objs[i], prec, notme);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (notme && id == other.id) continue;
						if (collision_ellipse(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return collision_ellipse(xx, yy, xxx, yyy, objs, prec, notme);
}

// Single target with filter
with (objs) {
	if (notme && id == other.id) continue;
	if (collision_ellipse(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define collision_ellipse_list_ext
///@func collision_ellipse_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param x1 X position of the ellipse's start
///@param y1 Y position of the ellipse's start
///@param x2 X position of the ellipse's end
///@param y2 Y position of the ellipse's end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the centre of the shape
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme, list, ordered;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 10:
		suchthatFunc = argument[9];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 9:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		list = argument[7];
		ordered = argument[8];
		break;
	default:
		show_error("Expected 9 or 10 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = collision_ellipse_list(xx, yy, xxx, yyy, all, prec, notme, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_ellipse_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered);
}

// Single target with filter
for (var i = collision_ellipse_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define collision_line_ext
///@func collision_line_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param x1 X position to start
///@param y1 Y position to start
///@param x2 X position to end
///@param y2 Y position to end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 8:
		suchthatFunc = argument[7];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 7:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		break;
	default:
		show_error("Expected 7 or 8 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = collision_line(xx, yy, xxx, yyy, objs[i], prec, notme);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (notme && id == other.id) continue;
						if (collision_line(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return collision_line(xx, yy, xxx, yyy, objs, prec, notme);
}

// Single target with filter
with (objs) {
	if (notme && id == other.id) continue;
	if (collision_line(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define collision_line_list_ext
///@func collision_line_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param x1 X position of the line's start
///@param y1 Y position of the line's start
///@param x2 X position of the line's end
///@param y2 Y position of the line's end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the centre of the shape
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme, list, ordered;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 10:
		suchthatFunc = argument[9];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 9:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		list = argument[7];
		ordered = argument[8];
		break;
	default:
		show_error("Expected 9 or 10 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = collision_line_list(xx, yy, xxx, yyy, all, prec, notme, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_line_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered);
}

// Single target with filter
for (var i = collision_line_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define collision_point_ext
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
	var nObjs = array_length(objs);
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
						if (collision_point(xx, yy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	if (collision_point(xx, yy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define collision_point_list_ext
///@func collision_point_list_ext(x, y, objs, prec, notme, list, ordered, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the checked position
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, objs, prec, notme, list, ordered;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 8:
		suchthatFunc = argument[7];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 7:
		xx = argument[0];
		yy = argument[1];
		objs = argument[2];
		prec = argument[3];
		notme = argument[4];
		list = argument[5];
		ordered = argument[6];
		break;
	default:
		show_error("Expected 7 or 8 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = collision_point_list(xx, yy, all, prec, notme, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_point_list(xx, yy, objs, prec, notme, list, ordered);
}

// Single target with filter
for (var i = collision_point_list(xx, yy, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define collision_rectangle_ext
///@func collision_rectangle_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param x1 X position to start
///@param y1 Y position to start
///@param x2 X position to end
///@param y2 Y position to end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 8:
		suchthatFunc = argument[7];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 7:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		break;
	default:
		show_error("Expected 7 or 8 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = collision_rectangle(xx, yy, xxx, yyy, objs[i], prec, notme);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (notme && id == other.id) continue;
						if (collision_rectangle(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return collision_rectangle(xx, yy, xxx, yyy, objs, prec, notme);
}

// Single target with filter
with (objs) {
	if (notme && id == other.id) continue;
	if (collision_rectangle(xx, yy, xxx, yyy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define collision_rectangle_list_ext
///@func collision_rectangle_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param x1 X position of the rectangle's start
///@param y1 Y position of the rectangle's start
///@param x2 X position of the rectangle's end
///@param y2 Y position of the rectangle's end
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param prec Whether to enable precise collisions
///@param notme Whether the calling instance should be excluded
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the centre of the shape
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, xxx, yyy, objs, prec, notme, list, ordered;
var suchthatFunc = undefined,
	suchthatArg = undefined;
switch (argument_count) {
	case 10:
		suchthatFunc = argument[9];
		if (is_array(suchthatFunc)) {
			suchthatArg = suchthatFunc[1];
			suchthatFunc = suchthatFunc[0];
		}
	case 9:
		xx = argument[0];
		yy = argument[1];
		xxx = argument[2];
		yyy = argument[3];
		objs = argument[4];
		prec = argument[5];
		notme = argument[6];
		list = argument[7];
		ordered = argument[8];
		break;
	default:
		show_error("Expected 9 or 10 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = collision_rectangle_list(xx, yy, xxx, yyy, all, prec, notme, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return collision_rectangle_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered);
}

// Single target with filter
for (var i = collision_rectangle_list(xx, yy, xxx, yyy, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define instance_furthest_ext
///@func instance_furthest_ext(x, y, objs, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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

// Nothing is best for now
var furthestInst = noone,
	furthestDist = undefined,
	currentInst = noone,
	currentDist = undefined;

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets; place the targets backwards and check collisions that way
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					currentInst = instance_furthest(xx, yy, objs[i]);
					with (currentInst) currentDist = distance_to_point(xx, yy);
					if (furthestInst == noone || currentDist > furthestDist) {
						furthestInst = currentInst;
						furthestDist = currentDist;
					}
				}
			} else {
				var dx = x-xx,
					dy = y-yy;
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
							currentInst = id;
							currentDist = distance_to_point(xx, yy);
							if (furthestInst == noone || currentDist > furthestDist) {
								furthestInst = currentInst;
								furthestDist = currentDist;
							}
						}
					}
				}
			}
			return furthestInst;
	}
}

// Single target, no filter
if (noFilter) {
	return instance_furthest(xx, yy, objs);
}

// Single target with filter; place backwards and check collisions
var dx = x-xx,
	dy = y-yy;
with (objs) {
	if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
		currentInst = id;
		currentDist = distance_to_point(xx, yy);
		if (furthestInst == noone || currentDist > furthestDist) {
			furthestInst = currentInst;
			furthestDist = currentDist;
		}
	}
}

// Return furthest
return furthestInst;

#define instance_nearest_ext
///@func instance_nearest_ext(x, y, objs, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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

// Nothing is best for now
var nearestInst = noone,
	nearestDist = undefined,
	currentInst = noone,
	currentDist = undefined;

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets; place the targets backwards and check collisions that way
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					currentInst = instance_nearest(xx, yy, objs[i]);
					with (currentInst) currentDist = distance_to_point(xx, yy);
					if (nearestInst == noone || currentDist < nearestDist) {
						nearestInst = currentInst;
						nearestDist = currentDist;
					}
				}
			} else {
				var dx = x-xx,
					dy = y-yy;
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
							currentInst = id;
							currentDist = distance_to_point(xx, yy);
							if (nearestInst == noone || currentDist < nearestDist) {
								nearestInst = currentInst;
								nearestDist = currentDist;
							}
						}
					}
				}
			}
			return nearestInst;
	}
}

// Single target, no filter
if (noFilter) {
	return instance_nearest(xx, yy, objs);
}

// Single target with filter; place backwards and check collisions
var dx = x-xx,
	dy = y-yy;
with (objs) {
	if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
		currentInst = id;
		currentDist = distance_to_point(xx, yy);
		if (nearestInst == noone || currentDist < nearestDist) {
			nearestInst = currentInst;
			nearestDist = currentDist;
		}
	}
}

// Return nearest
return nearestInst;

#define instance_place_ext
///@func instance_place_ext(x, y, objs, [suchthat])
///@param x X position to place at
///@param y Y position to place at
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets; place the targets backwards and check collisions that way
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = instance_place(xx, yy, objs[i]);
					if (found != noone) {
						return found;
					}
				}
			} else {
				var dx = x-xx,
					dy = y-yy;
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return instance_place(xx, yy, objs);
}

// Single target with filter; place backwards and check collisions
var dx = x-xx,
	dy = y-yy;
with (objs) {
	if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define instance_place_list_ext
///@func instance_place_list_ext(x, y, objs, list, ordered, [suchthat])
///@param x X position to place at
///@param y Y position to place at
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the calling instance's position
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, objs, list, ordered;
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
		list = argument[3];
		ordered = argument[4];
		break;
	default:
		show_error("Expected 5 or 6 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = instance_place_list(xx, yy, all, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return instance_place_list(xx, yy, objs, list, ordered);
}

// Single target with filter
for (var i = instance_place_list(xx, yy, objs, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define instance_position_ext
///@func instance_position_ext(x, y, objs, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return noone; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					var found = instance_position(xx, yy, objs[i]);
					if (found != noone) {
						return found;
					}
				}
			} else {
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (position_meeting(xx, yy, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return instance_position(xx, yy, objs);
}

// Single target with filter
with (objs) {
	if (position_meeting(xx, yy, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return id;
	}
}

// No collision
return noone;

#define instance_position_list_ext
///@func instance_position_list_ext(x, y, objs, list, ordered, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param list The list to deposit instance IDs into
///@param ordered Whether to order by distance to the checked position
///@param [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument

// Capture arguments
var xx, yy, objs, list, ordered;
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
		list = argument[3];
		ordered = argument[4];
		break;
	default:
		show_error("Expected 5 or 6 arguments, got " + string(argument_count) + ".", true);
		exit;
}
var noFilter = is_undefined(suchthatFunc);

// Array for targets
if (is_array(objs)) {
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = instance_position_list(xx, yy, all, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
					ds_list_delete(list, i);
				}
			}
			return ds_list_size(list);;
	}
}

// Single target, no filter
if (noFilter) {
	return instance_position_list(xx, yy, objs, list, ordered);
}

// Single target with filter
for (var i = instance_position_list(xx, yy, objs, list, ordered)-1; i >= 0; --i) {
	if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);

#define place_meeting_ext
///@func place_meeting_ext(x, y, objs, [suchthat])
///@param x X position to place at
///@param y Y position to place at
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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
	var nObjs = array_length(objs);
	switch (nObjs) {
		case 0: return false; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets; place the targets backwards and check collisions that way
			if (noFilter) {
				for (var i = 0; i < nObjs; ++i) {
					if (place_meeting(xx, yy, objs[i])) {
						return true;
					}
				}
			} else {
				var dx = x-xx,
					dy = y-yy;
				for (var i = 0; i < nObjs; ++i) {
					with (objs[i]) {
						if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	return place_meeting(xx, yy, objs);
}

// Single target with filter; place backwards and check collisions
var dx = x-xx,
	dy = y-yy;
with (objs) {
	if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return true;
	}
}

// No collision
return false;

#define position_meeting_ext
///@func position_meeting_ext(x, y, objs, [suchthat])
///@param x X position to check
///@param y Y position to check
///@param objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
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
	var nObjs = array_length(objs);
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
						if (position_meeting(xx, yy, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
	if (position_meeting(xx, yy, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
		return true;
	}
}

// No collision
return false;
