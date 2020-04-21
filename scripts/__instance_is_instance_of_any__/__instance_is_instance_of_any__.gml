///@func __instance_is_instance_of_any__(id, objs)
///@param id The ID of the instance
///@param objs Array of object identities
for (var i = array_length_1d(argument1)-1; i >= 0; --i) {
	var obji = argument1[i];
	switch (obji) {
		case all: return true;
		case noone: break;
		case other:
			if (argument0 == other.id) return true;
			break;
		case self:
			if (argument0 == id) return true;
			break;
		default:
			if (argument0 == obji || (object_exists(obji) && (argument0.object_index == obji || object_is_ancestor(argument0.object_index, obji)))) return true;
	}
}
return false;
