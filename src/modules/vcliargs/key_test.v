module vcliargs

fn test_key() {
	mut k_test := Key.new('test', 'Test description')
	mut k_control := Key { value: 'test', description: 'Test description' }

	assert k_test == k_control

	k_test = k_test.alias(['-t', '--test'])
	k_control.alias = ['-t', '--test']

	assert k_test == k_control

	k_test = k_test.default('testing')
	k_control.uses_default = true
	k_control.default = 'testing'

	assert k_test == k_control

	k_test = k_test.valueless(true)
	k_control.is_valueless = true

	assert k_test == k_control

	k_test = k_test.multiple(true)
	k_control.contains_multiple = true

	assert k_test == k_control

	k_test = k_test.options(['ABC', 'testing', 'XYZ'])
	k_control.uses_options = true
	k_control.options = ['ABC', 'testing', 'XYZ']

	assert k_test == k_control

	k_test = k_test.type_check(ArgTypes.float)
	k_control.type_checker = true
	k_control.check_type = ArgTypes.float

	assert k_test == k_control

	k_test = k_test.required(true)
	k_control.is_required = true

	assert k_test == k_control

	assert true == k_test.is_key('-t')
	assert true == k_test.is_key('--test')
	assert false == k_test.is_key('-t1')

	assert true == k_test.is_valid_option('testing')
	assert false == k_test.is_valid_option('QTP')

	assert k_test.gen_usage() == '-t|--test'
	assert k_test.gen_help() == '-t --test                                           Test description'
}
