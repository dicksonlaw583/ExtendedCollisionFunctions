///@desc Test step
script_execute(tests[currentTest++]);
if (currentTest >= array_length(tests)) {
	show_debug_message("Extended Collision Functions tests completed in " + string(current_time-startTime) + "ms.");
	layer_background_blend(layer_background_get_id(layer_get_id("Background")), (global.__test_fails__ == 0) ? c_green : c_red);
	instance_destroy();
} else {
	alarm[0] = 1;
}
