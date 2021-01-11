///@func ecf_test_all()
function ecf_test_all() {
	global.__test_fails__ = 0;
	
	// Create the tester --- add tests here
	instance_create_layer(480, 272, "Instances", objEcfTester);
}
