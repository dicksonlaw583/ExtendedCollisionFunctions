///@func collision_circle_ext(cx, cy, rad, objs, prec, notme, [suchthat])
///@param {Real} cx X position of the circle's centre
///@param {Real} cy Y position of the circle's centre
///@param {Real} rad Radius to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of collision_circle accepting multiple targets and a filtering predicate.
function collision_circle_ext(cx, cy, rad, objs, prec, notme, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return noone; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				if (noFilter) {
					for (var i = 0; i < nObjs; ++i) {
						var found = collision_circle(cx, cy, rad, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							///Feather disable GM1044
							if (collision_circle(cx, cy, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
								return id;
							}
							///Feather enable GM1044
						}
					}
				}
				return noone;
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_circle(cx, cy, rad, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_circle(cx, cy, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func collision_circle_list_ext(cx, cy, rad, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} cx X position of the circle's centre
///@param {Real} cy Y position of the circle's centre
///@param {Real} rad Radius of the circle
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the centre of the shape
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of collision_circle_list accepting multiple targets and a filtering predicate.
function collision_circle_list_ext(cx, cy, rad, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_circle_list(cx, cy, rad, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_circle_list(cx, cy, rad, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_circle_list(cx, cy, rad, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func collision_ellipse_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param {Real} x1 X position of the ellipse's start
///@param {Real} y1 Y position of the ellipse's start
///@param {Real} x2 X position of the ellipse's end
///@param {Real} y2 Y position of the ellipse's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@desc Extended version of collision_ellipse accepting multiple targets and a filtering predicate.
function collision_ellipse_ext(x1, y1, x2, y2, objs, prec, notme, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;
	
	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return noone; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				if (noFilter) {
					for (var i = 0; i < nObjs; ++i) {
						var found = collision_ellipse(x1, y1, x2, y2, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							///Feather disable GM1044
							if (collision_ellipse(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
								return id;
							}
							///Feather enable GM1044
						}
					}
				}
				return noone;
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_ellipse(x1, y1, x2, y2, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		///Feather disable GM1044
		if (collision_ellipse(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
		///Feather enable GM1044
	}

	// No collision
	return noone;
}

///@func collision_ellipse_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} x1 X position of the ellipse's start
///@param {Real} y1 Y position of the ellipse's start
///@param {Real} x2 X position of the ellipse's end
///@param {Real} y2 Y position of the ellipse's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the centre of the shape
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of collision_ellipse_list accepting multiple targets and a filtering predicate.
function collision_ellipse_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_ellipse_list(x1, y1, x2, y2, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_ellipse_list(x1, y1, x2, y2, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_ellipse_list(x1, y1, x2, y2, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func collision_line_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param {Real} x1 X position of the line's start
///@param {Real} y1 Y position of the line's start
///@param {Real} x2 X position of the line's end
///@param {Real} y2 Y position of the line's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of collision_line accepting multiple targets and a filtering predicate.
function collision_line_ext(x1, y1, x2, y2, objs, prec, notme, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return noone; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				if (noFilter) {
					for (var i = 0; i < nObjs; ++i) {
						var found = collision_line(x1, y1, x2, y2, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							///Feather disable GM1044
							if (collision_line(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
								return id;
							}
							///Feather enable GM1044
						}
					}
				}
				return noone;
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_line(x1, y1, x2, y2, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_line(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func collision_line_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} x1 X position of the line's start
///@param {Real} y1 Y position of the line's start
///@param {Real} x2 X position of the line's end
///@param {Real} y2 Y position of the line's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the centre of the shape
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of collision_line_list accepting multiple targets and a filtering predicate.
function collision_line_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_line_list(x1, y1, x2, y2, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_line_list(x1, y1, x2, y2, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_line_list(x1, y1, x2, y2, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func collision_point_ext(xx, yy, objs, prec, notme, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of collision_point accepting multiple targets and a filtering predicate.
function collision_point_ext(xx, yy, objs, prec, notme, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
							///Feather disable GM1044
							if (collision_point(xx, yy, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
								return id;
							}
							///Feather enable GM1044
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
}

///@func collision_point_list_ext(xx, yy, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the checked position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of collision_point_list accepting multiple targets and a filtering predicate.
function collision_point_list_ext(xx, yy, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
				return ds_list_size(list);
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
}

///@func collision_rectangle_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param {Real} x1 X position of the rectangle's start
///@param {Real} y1 Y position of the rectangle's start
///@param {Real} x2 X position of the rectangle's end
///@param {Real} y2 Y position of the rectangle's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of collision_rectangle accepting multiple targets and a filtering predicate.
function collision_rectangle_ext(x1, y1, x2, y2, objs, prec, notme, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return noone; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				if (noFilter) {
					for (var i = 0; i < nObjs; ++i) {
						var found = collision_rectangle(x1, y1, x2, y2, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							///Feather disable GM1044
							if (collision_rectangle(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
								return id;
							}
							///Feather enable GM1044
						}
					}
				}
				return noone;
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_rectangle(x1, y1, x2, y2, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_rectangle(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func collision_rectangle_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} x1 X position of the rectangle's start
///@param {Real} y1 Y position of the rectangle's start
///@param {Real} x2 X position of the rectangle's end
///@param {Real} y2 Y position of the rectangle's end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the centre of the shape
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of collision_rectangle_list accepting multiple targets and a filtering predicate.
function collision_rectangle_list_ext(x1, y1, x2, y2, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;
	
	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_rectangle_list(x1, y1, x2, y2, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_rectangle_list(x1, y1, x2, y2, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_rectangle_list(x1, y1, x2, y2, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func instance_furthest_ext(xx, yy, objs, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of instance_furthest accepting multiple targets and a filtering predicate.
function instance_furthest_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;
	
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
}

///@func instance_nearest_ext(xx, yy, objs, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of instance_nearest accepting multiple targets and a filtering predicate.
function instance_nearest_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
}

///@func instance_place_ext(xx, y, objs, [suchthat])
///@param {Real} xx X position to place at
///@param {Real} yy Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of instance_place accepting multiple targets and a filtering predicate.
function instance_place_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
}

///@func instance_place_list_ext(xx, yy, objs, list, ordered, [suchthat])
///@param {Real} xx X position to place at
///@param {Real} yy Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the calling instance's position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of instance_place_list accepting multiple targets and a filtering predicate.
function instance_place_list_ext(xx, yy, objs, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
				return ds_list_size(list);
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
}

///@func instance_position_ext(xx, yy, objs, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Id.Instance}
///@desc Extended version of instance_position accepting multiple targets and a filtering predicate.
function instance_position_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
}

///@func instance_position_list_ext(xx, yy, objs, list, ordered, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the checked position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Real}
///@desc Extended version of instance_position_list accepting multiple targets and a filtering predicate.
function instance_position_list_ext(xx, yy, objs, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
				return ds_list_size(list);
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
}

///@func place_meeting_ext(xx, yy, objs, [suchthat])
///@param {Real} xx X position to place at
///@param {Real} yy Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Bool}
///@desc Extended version of place_meeting accepting multiple targets and a filtering predicate.
function place_meeting_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
}

///@func position_meeting_ext(xx, yy, objs, [suchthat])
///@param {Real} xx X position to check
///@param {Real} yy Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
///@return {Bool}
///@desc Extended version of position_meeting accepting multiple targets and a filtering predicate.
function position_meeting_ext(xx, yy, objs, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

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
}
