///@func ecf_test_instance_furthest_ext()
///@desc Test instance_furthest_ext(x, y, objs, [suchthat])
function ecf_test_instance_furthest_ext() {
	// Create test objects
	var t1a = instance_create_layer(x+500, y, layer, objTarget1);
	var t2a = instance_create_layer(x+400, y, layer, objTarget2);
	var t1b = instance_create_layer(x+300, y, layer, objTarget1); t1b.value = 3;
	var t2b = instance_create_layer(x+200, y, layer, objTarget2); t2b.value = 5;
	var t2c = instance_create_layer(x+100, y, layer, objTarget2); t2c.value = 4;

	// Run tests without conditions
	assert_equal(instance_furthest_ext(x, y, objTarget1), t1a);
	assert_equal(instance_furthest_ext(x, y, objTarget2), t2a);
	assert_equal(instance_furthest_ext(x, y, [objTarget2, objTarget3]), t2a);
	assert_equal(instance_furthest_ext(x, y, objTarget3), noone);
	assert_equal(instance_furthest_ext(x+20, y+20, objEcfTester), id);

	// Run tests with conditions
	assert_equal(instance_furthest_ext(x, y, [objTarget1, objTarget2, objTarget3], valueBiggerThanMe), t2b);
	assert_equal(instance_furthest_ext(x, y, pobjTarget, valueBiggerThanMe), t2b);
	assert_equal(instance_furthest_ext(x, y, objTarget1, valueBiggerThanMe), noone);
	assert_equal(instance_furthest_ext(x, y, [objTarget1, objTarget3], valueBiggerThanMe), noone);

	// Run tests with conditions and argument
	assert_equal(instance_furthest_ext(x, y, [objTarget1, objTarget2, objTarget3], [valueEqualTo, 6]), noone);
	assert_equal(instance_furthest_ext(x, y, pobjTarget, [valueEqualTo, 6]), noone);
	assert_equal(instance_furthest_ext(x, y, pobjTarget, [valueEqualTo, 5]), t2b);
	assert_equal(instance_furthest_ext(x, y, [objTarget2, objTarget3], [valueEqualTo, 5]), t2b);
	assert_equal(instance_furthest_ext(x, y, [objTarget2], [valueEqualTo, 5]), t2b);
	assert_equal(instance_furthest_ext(x, y, [objTarget1, objTarget3], [valueEqualTo, 5]), noone);
	assert_equal(instance_furthest_ext(x, y, objEcfTester, [valueEqualTo, 4]), id);
	assert_equal(instance_furthest_ext(x-1000, y, [objEcfTester, pobjTarget], [valueEqualTo, 4]), t2c);

	// Destroy test objects
	with (objTarget1) instance_destroy();
	with (objTarget2) instance_destroy();
}
