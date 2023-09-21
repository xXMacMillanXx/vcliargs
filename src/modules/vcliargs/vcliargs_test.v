module vcliargs

fn test_parse() {
	mut arg := Args.new('vcliargs test', 'testing the functionality', 'tests')
	arg.set_args()
	mut x := arg.parse()

	assert x.len == 0

	arg.add_key(arg.key('path', 'test path'))
	x = arg.parse()

	assert x.len == 1
}
