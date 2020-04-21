///@func ds_list_to_array(list)
///@param list
var siz = ds_list_size(argument0);
var arr = array_create(siz);
for (var i = siz-1; i >= 0; --i) {
	arr[i] = argument0[| i];
}
return arr;
