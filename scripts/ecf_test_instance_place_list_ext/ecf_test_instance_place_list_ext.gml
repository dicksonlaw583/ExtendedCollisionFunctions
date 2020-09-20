///@func ecf_test_instance_place_list_ext()
///@desc Test instance_place_list_ext(x, y, objs, list, ordered, [suchthat])
function ecf_test_instance_place_list_ext() {
	// Create test objects
	var t1a = instance_create_layer(x+4, y, layer, objTarget1); t1a.value = 3;
	var t1b = instance_create_layer(x+8, y, layer, objTarget1); t1b.value = 5;
	var t2a = instance_create_layer(x+12, y, layer, objTarget2); t2a.value = 3;
	var t2b = instance_create_layer(x+16, y, layer, objTarget2); t2b.value = 5;
	var t2c = instance_create_layer(x+20, y, layer, objTarget2); t2c.value = 6;
	var list = ds_list_create();

	// Run tests without conditions
	assert_equal(instance_place_list_ext(x, y, pobjTarget, list, true), 5);
	assert_equal(ds_list_to_array(list), [t1a, t1b, t2a, t2b, t2c]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, objTarget1, list, true), 2);
	assert_equal(ds_list_to_array(list), [t1a, t1b]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget1, objTarget2], list, true), 5);
	assert_equal(ds_list_to_array(list), [t1a, t1b, t2a, t2b, t2c]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget3, objTarget2], list, true), 3);
	assert_equal(ds_list_to_array(list), [t2a, t2b, t2c]);
	ds_list_clear(list);

	// Run tests with conditions
	assert_equal(instance_place_list_ext(x, y, pobjTarget, list, true, valueBiggerThanMe), 3);
	assert_equal(ds_list_to_array(list), [t1b, t2b, t2c]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, objTarget2, list, true, valueBiggerThanMe), 2);
	assert_equal(ds_list_to_array(list), [t2b, t2c]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget1, objTarget2], list, true, valueBiggerThanMe), 3);
	assert_equal(ds_list_to_array(list), [t1b, t2b, t2c]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget3, objTarget1], list, true, valueBiggerThanMe), 1);
	assert_equal(ds_list_to_array(list), [t1b]);
	ds_list_clear(list);

	// Run tests with conditions and argument
	assert_equal(instance_place_list_ext(x, y, pobjTarget, list, true, [valueEqualTo, 5]), 2);
	assert_equal(ds_list_to_array(list), [t1b, t2b]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, objTarget2, list, true, [valueEqualTo, 5]), 1);
	assert_equal(ds_list_to_array(list), [t2b]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget1, objTarget2], list, true, [valueEqualTo, 5]), 2);
	assert_equal(ds_list_to_array(list), [t1b, t2b]);
	ds_list_clear(list);
	assert_equal(instance_place_list_ext(x, y, [objTarget3, objTarget1], list, true, [valueEqualTo, 5]), 1);
	assert_equal(ds_list_to_array(list), [t1b]);
	ds_list_clear(list);

	// Destroy test objects
	with (objTarget1) instance_destroy();
	with (objTarget2) instance_destroy();
	ds_list_destroy(list);
}
