///@func ecf_test_all()
function ecf_test_all() {
	global.__test_fails__ = 0;
	var timeA = current_time;
	
	// Create the tester --- add tests here
	instance_create_layer(480, 272, "Instances", objEcfTester);
	
	var timeB = current_time;
	show_debug_message("Extended Collision Functions tests completed in " + string(timeB-timeA) + "ms.");
	return global.__test_fails__ == 0;
}
