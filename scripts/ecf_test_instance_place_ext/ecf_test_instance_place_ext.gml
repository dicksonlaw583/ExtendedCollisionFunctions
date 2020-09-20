///@func ecf_test_instance_place_ext()
///@desc Test instance_place_ext(x, y, objs, [suchthat])
function ecf_test_instance_place_ext() {
	// Create test objects
	var t1a = instance_create_layer(x-200, y-200, layer, objTarget1);
	var t2a = instance_create_layer(x-200, y-200, layer, objTarget2);
	var t1b = instance_create_layer(x+200, y+200, layer, objTarget1); t1b.value = 3;
	var t2b = instance_create_layer(x+200, y+200, layer, objTarget2); t2b.value = 5;

	// Run tests without conditions
	assert_equal(instance_place_ext(x-200, y-200, objTarget1), t1a);
	assert_equal(instance_place_ext(x-200, y-200, objTarget2), t2a);
	assert_equal(instance_place_ext(x-200, y-200, [objTarget2, objTarget3]), t2a);
	assert_equal(instance_place_ext(x-200, y-200, objTarget3), noone);

	// Run tests with conditions
	assert_equal(instance_place_ext(x-200, y+200, [objTarget1, objTarget2, objTarget3], valueBiggerThanMe), noone);
	assert_equal(instance_place_ext(x-200, y-200, pobjTarget, valueBiggerThanMe), noone);
	assert_equal(instance_place_ext(x+200, y+200, pobjTarget, valueBiggerThanMe), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget2, objTarget3], valueBiggerThanMe), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget2], valueBiggerThanMe), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget1, objTarget3], valueBiggerThanMe), noone);

	// Run tests with conditions and argument
	assert_equal(instance_place_ext(x-200, y+200, [objTarget1, objTarget2, objTarget3], [valueEqualTo, 5]), noone);
	assert_equal(instance_place_ext(x-200, y-200, pobjTarget, [valueEqualTo, 5]), noone);
	assert_equal(instance_place_ext(x+200, y+200, pobjTarget, [valueEqualTo, 5]), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget2, objTarget3], [valueEqualTo, 5]), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget2], [valueEqualTo, 5]), t2b);
	assert_equal(instance_place_ext(x+200, y+200, [objTarget1, objTarget3], [valueEqualTo, 5]), noone);

	// Destroy test objects
	with (objTarget1) instance_destroy();
	with (objTarget2) instance_destroy();
}
