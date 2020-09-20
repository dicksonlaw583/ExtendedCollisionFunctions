///@func ecf_test_place_meeting_ext()
///@desc Test place_meeting_ext(x, y, objs, [suchthat])
function ecf_test_place_meeting_ext() {
	// Create test objects
	instance_create_layer(x-200, y-200, layer, objTarget1);
	instance_create_layer(x-200, y-200, layer, objTarget2);
	with (instance_create_layer(x+200, y+200, layer, objTarget1)) value = 3;
	with (instance_create_layer(x+200, y+200, layer, objTarget2)) value = 5;

	// Run tests without conditions
	assert(place_meeting_ext(x-200, y-200, objTarget1));
	assert(place_meeting_ext(x-200, y-200, objTarget2));
	assert(place_meeting_ext(x-200, y-200, [objTarget2, objTarget3]));
	assert_fail(place_meeting_ext(x-200, y-200, objTarget3));

	// Run tests with conditions
	assert_fail(place_meeting_ext(x-200, y+200, [objTarget1, objTarget2, objTarget3], valueBiggerThanMe));
	assert_fail(place_meeting_ext(x-200, y-200, pobjTarget, valueBiggerThanMe));
	assert(place_meeting_ext(x+200, y+200, pobjTarget, valueBiggerThanMe));
	assert(place_meeting_ext(x+200, y+200, [objTarget2, objTarget3], valueBiggerThanMe));
	assert(place_meeting_ext(x+200, y+200, [objTarget2], valueBiggerThanMe));
	assert_fail(place_meeting_ext(x+200, y+200, [objTarget1, objTarget3], valueBiggerThanMe));

	// Run tests with conditions and argument
	assert_fail(place_meeting_ext(x-200, y+200, [objTarget1, objTarget2, objTarget3], [valueEqualTo, 5]));
	assert_fail(place_meeting_ext(x-200, y-200, pobjTarget, [valueEqualTo, 5]));
	assert(place_meeting_ext(x+200, y+200, pobjTarget, [valueEqualTo, 5]));
	assert(place_meeting_ext(x+200, y+200, [objTarget2, objTarget3], [valueEqualTo, 5]));
	assert(place_meeting_ext(x+200, y+200, [objTarget2], [valueEqualTo, 5]));
	assert_fail(place_meeting_ext(x+200, y+200, [objTarget1, objTarget3], [valueEqualTo, 5]));

	// Destroy test objects
	with (objTarget1) instance_destroy();
	with (objTarget2) instance_destroy();
}
