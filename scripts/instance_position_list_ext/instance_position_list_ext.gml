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
	var nObjs = array_length_1d(objs);
	switch (nObjs) {
		case 0: return 0; // No targets, no collisions
		case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
		default: // Multiple targets
			for (var i = instance_position_list(xx, yy, all, list, ordered)-1; i >= 0; --i) {
				if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || script_execute(suchthatFunc, list[| i], id, suchthatArg)))) {
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
	if (!script_execute(suchthatFunc, list[| i], id, suchthatArg)) {
		ds_list_delete(list, i);
	}
}

// Return collision size
return ds_list_size(list);
