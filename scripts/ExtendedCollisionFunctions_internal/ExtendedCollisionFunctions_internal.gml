#macro ECF_CAPTURE_SUCHTHAT var suchthatFunc = suchthat, suchthatArg = undefined; if (is_array(suchthatFunc)) { suchthatArg = suchthatFunc[1]; suchthatFunc = suchthatFunc[0]; } var noFilter = is_undefined(suchthatFunc)

///@func __instance_is_instance_of_any__(this, objs)
///@param {Id.Instance} this The ID of the instance
///@param {Array<Asset.GMObject,Id.Instance>} objs Array of object identities
///@ignore
///@desc (INTERNAL: Extended Collision Functions) Return whether the given instance counts as anything in objs.
function __instance_is_instance_of_any__(this, objs) {
	for (var i = array_length(objs)-1; i >= 0; --i) {
		var obji = objs[i];
		switch (obji) {
			case all: return true;
			case noone: break;
			default:
				if (this == obji || (object_exists(obji) && (this.object_index == obji || object_is_ancestor(this.object_index, obji)))) return true;
		}
	}
	return false;
}
