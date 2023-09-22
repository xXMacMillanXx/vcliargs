module vcliargs

fn test_parse_key_count() {
	mut arg := Args.new('vcliargs test', 'testing the functionality', 'tests')
	arg.set_args()
	mut x := arg.parse()

	assert x.len == 0

	arg.add_key(arg.key('path', 'test path'))
	x = arg.parse()

	assert x.len == 1
}

fn test_parse_basics_alias() {
	mut arg := Args.new('vcliargs test', 'testing the functionality', 'tests')
	arg.set_args('-t1', 'test1', '-t2', 'test2', '-t3', 'test3', '-t4', 'test4', '-t5', 'test5')
	arg.add_key(arg.key('test1', 'test1').alias(['-t1']))
	arg.add_key(arg.key('test2', 'test2').alias(['-t2', '--test2']))
	arg.add_key(arg.key('test3', 'test3').alias(['-t3']).alias(['--test3']))
	arg.add_key(arg.key('test4', 'test4').alias(['-t4']).alias(['--test4', '--test4too']))
	arg.add_key(arg.key('test5', 'test5').alias(['-t5', '--test5']).alias(['--test5too']))
	mut x := arg.parse()

	assert x.len == 5
	assert x['test1'] == 'test1'
	assert x['test2'] == 'test2'
	assert x['test3'] == 'test3'
	assert x['test4'] == 'test4'
	assert x['test5'] == 'test5'

	arg.set_args('--test2', 'test2', '--test3', 'test3', '--test4', 'test4', '--test5', 'test5')
	x = arg.parse()

	assert x.len == 4
	assert x['test2'] == 'test2'
	assert x['test3'] == 'test3'
	assert x['test4'] == 'test4'
	assert x['test5'] == 'test5'

	arg.set_args('--test4too', 'test4', '--test5too', 'test5')
	x = arg.parse()

	assert x.len == 2
	assert x['test4'] == 'test4'
	assert x['test5'] == 'test5'
}
