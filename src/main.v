module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')
	// x.add_key('count', ['-c', '--count'], 'Counts something.')
	x.add_advanced_key('count', ['-c', '--count'], 'Counts something.', '100', false, false)
	x.add_key('path', ['-p', '--path'], 'Path to something')

	x.inject_key(x.key('param1', 'Tests new key creation').alias(['-p1', '--param1']).default('XYZ').valueless(false).multiple(true))

	y := x.parse()

	for key in y.keys() {
		println(key + " ... " + y[key])
	}	
}
