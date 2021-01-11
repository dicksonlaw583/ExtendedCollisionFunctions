///@desc Setup
value = 4;

/* vv Tests here vv */
tests = [
	ecf_test_place_meeting_ext,
	ecf_test_position_meeting_ext,
	ecf_test_instance_place_ext,
	ecf_test_instance_position_ext,
	ecf_test_collision_point_ext,
	ecf_test_collision_circle_ext,
	ecf_test_collision_line_ext,
	ecf_test_collision_rectangle_ext,
	ecf_test_collision_ellipse_ext,
	ecf_test_instance_place_list_ext,
	ecf_test_instance_position_list_ext,
	ecf_test_collision_point_list_ext,
	ecf_test_collision_circle_list_ext,
	ecf_test_collision_line_list_ext,
	ecf_test_collision_rectangle_list_ext,
	ecf_test_collision_ellipse_list_ext,
	ecf_test_instance_nearest_ext,
	ecf_test_instance_furthest_ext,
]
/* ^^ Tests here ^^ */

// Run tests
currentTest = 0;
startTime = current_time;
layer_background_blend(layer_background_get_id(layer_get_id("Background")), c_yellow);
alarm[0] = 1;
