module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')
	
	x.inject_key(x.key('count', 'Counts something.').alias(['-c', '--count']).default('100'))
	x.inject_key(x.key('path', 'Path to something').alias(['-p', '--path']))
	x.inject_key(x.key('param1', 'Tests new key creation').alias(['-p1', '--param1']).default('XYZ').options(['XYZ', 'ABC', 'JKL']))

	y := x.parse()

	for key in y.keys() {
		println(key + " ... " + y[key])
	}	
}
