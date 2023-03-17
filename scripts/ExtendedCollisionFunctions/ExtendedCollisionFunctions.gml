///@func collision_circle_ext(x1, y1, rad, objs, prec, notme, [suchthat])
///@param {Real} x1 X position to check
///@param {Real} y1 Y position to check
///@param {Real} rad Radius to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function collision_circle_ext(x1, y1, rad, objs, prec, notme, suchthat=undefined) {
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
						var found = collision_circle(x1, y1, rad, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							if (collision_circle(x1, y1, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
		return collision_circle(x1, y1, rad, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_circle(x1, y1, rad, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func collision_circle_list_ext(x1, y1, rad, objs, prec, notme, list, ordered, [suchthat])
///@param {Real} x1 X position of the circle's centre
///@param {Real} y1 Y position of the circle's centre
///@param {Real} rad Radius of the circle
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the centre of the shape
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function collision_circle_list_ext(x1, y1, rad, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_circle_list(x1, y1, rad, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_circle_list(x1, y1, rad, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_circle_list(x1, y1, rad, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func collision_ellipse_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param {Real} x1 X position to start
///@param {Real} y1 Y position to start
///@param {Real} x2 X position to end
///@param {Real} y2 Y position to end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
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
							if (collision_ellipse(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
		return collision_ellipse(x1, y1, x2, y2, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_ellipse(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
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
///@param {Real} x1 X position to start
///@param {Real} y1 Y position to start
///@param {Real} x2 X position to end
///@param {Real} y2 Y position to end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
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
							if (collision_line(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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

///@func collision_point_ext(x1, y1, objs, prec, notme, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function collision_point_ext(x1, y1, objs, prec, notme, suchthat=undefined) {
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
						var found = collision_point(x1, y1, objs[i], prec, notme);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (notme && id == other.id) continue;
							if (collision_point(x1, y1, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
		return collision_point(x1, y1, objs, prec, notme);
	}

	// Single target with filter
	with (objs) {
		if (notme && id == other.id) continue;
		if (collision_point(x1, y1, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func collision_point_list_ext(x1, y1, objs, prec, notme, list, ordered, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the checked position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function collision_point_list_ext(x1, y1, objs, prec, notme, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = collision_point_list(x1, y1, all, prec, notme, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return collision_point_list(x1, y1, objs, prec, notme, list, ordered);
	}

	// Single target with filter
	for (var i = collision_point_list(x1, y1, objs, prec, notme, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func collision_rectangle_ext(x1, y1, x2, y2, objs, prec, notme, [suchthat])
///@param {Real} x1 X position to start
///@param {Real} y1 Y position to start
///@param {Real} x2 X position to end
///@param {Real} y2 Y position to end
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Bool} prec Whether to enable precise collisions
///@param {Bool} notme Whether the calling instance should be excluded
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
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
							if (collision_rectangle(x1, y1, x2, y2, id, prec, false) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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

///@func instance_furthest_ext(x1, y1, objs, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_furthest_ext(x1, y1, objs, suchthat=undefined) {
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
						currentInst = instance_furthest(x1, y1, objs[i]);
						with (currentInst) currentDist = distance_to_point(x1, y1);
						if (furthestInst == noone || currentDist > furthestDist) {
							furthestInst = currentInst;
							furthestDist = currentDist;
						}
					}
				} else {
					var dx = x-x1,
						dy = y-y1;
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
								currentInst = id;
								currentDist = distance_to_point(x1, y1);
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
		return instance_furthest(x1, y1, objs);
	}

	// Single target with filter; place backwards and check collisions
	var dx = x-x1,
		dy = y-y1;
	with (objs) {
		if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
			currentInst = id;
			currentDist = distance_to_point(x1, y1);
			if (furthestInst == noone || currentDist > furthestDist) {
				furthestInst = currentInst;
				furthestDist = currentDist;
			}
		}
	}

	// Return furthest
	return furthestInst;
}

///@func instance_nearest_ext(x1, y1, objs, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_nearest_ext(x1, y1, objs, suchthat=undefined) {
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
						currentInst = instance_nearest(x1, y1, objs[i]);
						with (currentInst) currentDist = distance_to_point(x1, y1);
						if (nearestInst == noone || currentDist < nearestDist) {
							nearestInst = currentInst;
							nearestDist = currentDist;
						}
					}
				} else {
					var dx = x-x1,
						dy = y-y1;
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
								currentInst = id;
								currentDist = distance_to_point(x1, y1);
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
		return instance_nearest(x1, y1, objs);
	}

	// Single target with filter; place backwards and check collisions
	var dx = x-x1,
		dy = y-y1;
	with (objs) {
		if (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg)) {
			currentInst = id;
			currentDist = distance_to_point(x1, y1);
			if (nearestInst == noone || currentDist < nearestDist) {
				nearestInst = currentInst;
				nearestDist = currentDist;
			}
		}
	}

	// Return nearest
	return nearestInst;
}

///@func instance_place_ext(x1, y, objs, [suchthat])
///@param x1 X position to place at
///@param y1 Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_place_ext(x1, y1, objs, suchthat=undefined) {
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
						var found = instance_place(x1, y1, objs[i]);
						if (found != noone) {
							return found;
						}
					}
				} else {
					var dx = x-x1,
						dy = y-y1;
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
		return instance_place(x1, y1, objs);
	}

	// Single target with filter; place backwards and check collisions
	var dx = x-x1,
		dy = y-y1;
	with (objs) {
		if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func instance_place_list_ext(x1, y1, objs, list, ordered, [suchthat])
///@param x1 X position to place at
///@param y1 Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the calling instance's position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_place_list_ext(x1, y1, objs, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = instance_place_list(x1, y1, all, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return instance_place_list(x1, y1, objs, list, ordered);
	}

	// Single target with filter
	for (var i = instance_place_list(x1, y1, objs, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func instance_position_ext(x1, y1, objs, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_position_ext(x1, y1, objs, suchthat=undefined) {
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
						var found = instance_position(x1, y1, objs[i]);
						if (found != noone) {
							return found;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (position_meeting(x1, y1, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
		return instance_position(x1, y1, objs);
	}

	// Single target with filter
	with (objs) {
		if (position_meeting(x1, y1, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return id;
		}
	}

	// No collision
	return noone;
}

///@func instance_position_list_ext(x1, y1, objs, list, ordered, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Id.DsList} list The list to deposit instance IDs into
///@param {Bool} ordered Whether to order by distance to the checked position
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function instance_position_list_ext(x1, y1, objs, list, ordered, suchthat=undefined) {
	ECF_CAPTURE_SUCHTHAT;

	// Array for targets
	if (is_array(objs)) {
		var nObjs = array_length(objs);
		switch (nObjs) {
			case 0: return 0; // No targets, no collisions
			case 1: objs = objs[0]; break; // Reduce to single target; pass to next if
			default: // Multiple targets
				for (var i = instance_position_list(x1, y1, all, list, ordered)-1; i >= 0; --i) {
					if (!(__instance_is_instance_of_any__(list[| i], objs) && (noFilter || (is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))))) {
						ds_list_delete(list, i);
					}
				}
				return ds_list_size(list);
		}
	}

	// Single target, no filter
	if (noFilter) {
		return instance_position_list(x1, y1, objs, list, ordered);
	}

	// Single target with filter
	for (var i = instance_position_list(x1, y1, objs, list, ordered)-1; i >= 0; --i) {
		if (!(is_method(suchthatFunc) ? suchthatFunc(list[| i], id, suchthatArg) : script_execute(suchthatFunc, list[| i], id, suchthatArg))) {
			ds_list_delete(list, i);
		}
	}

	// Return collision size
	return ds_list_size(list);
}

///@func place_meeting_ext(x1, y1, objs, [suchthat])
///@param x1 X position to place at
///@param y1 Y position to place at
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function place_meeting_ext(x1, y1, objs, suchthat=undefined) {
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
						if (place_meeting(x1, y1, objs[i])) {
							return true;
						}
					}
				} else {
					var dx = x-x1,
						dy = y-y1;
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
		return place_meeting(x1, y1, objs);
	}

	// Single target with filter; place backwards and check collisions
	var dx = x-x1,
		dy = y-y1;
	with (objs) {
		if (place_meeting(x+dx, y+dy, other) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return true;
		}
	}

	// No collision
	return false;
}

///@func position_meeting_ext(x1, y1, objs, [suchthat])
///@param x1 X position to check
///@param y1 Y position to check
///@param {Asset.GMObject,Id.Instance,Constant.All,Array} objs Any object ID, instance ID, self, other, all, or an array of any of the preceding
///@param {Function,Array,Undefined} [suchthat] (optional) A 2-argument function, first for detected instance, second for calling instance, returning true/false; or a 2-entry array of a 3-argument function and the value to pass into the third argument
function position_meeting_ext(x1, y1, objs, suchthat=undefined) {
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
						if (position_meeting(x1, y1, objs[i])) {
							return true;
						}
					}
				} else {
					for (var i = 0; i < nObjs; ++i) {
						with (objs[i]) {
							if (position_meeting(x1, y1, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
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
		return position_meeting(x1, y1, objs);
	}

	// Single target with filter
	with (objs) {
		if (position_meeting(x1, y1, id) && (is_method(suchthatFunc) ? suchthatFunc(id, other.id, suchthatArg) : script_execute(suchthatFunc, id, other.id, suchthatArg))) {
			return true;
		}
	}

	// No collision
	return false;
}
