module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')
	
	x.add_key(x.key('count', 'Counts something.').alias(['-c', '--count']).default('100'))
	x.add_key(x.key('path', 'Path to something').alias(['-p', '--path']).multiple(true))
	x.add_key(x.key('param1', 'Tests new key creation').alias(['-p1', '--param1']).options(['XYZ', 'ABC', 'JKL']))
	x.add_key(x.key('param2', 'Tests new key creation').alias(['-p2', '--param2']).default('ABC').options(['XYZ', 'ABC', 'JKL']))
	x.add_key(x.key('param3', 'Tests new key creation').alias(['-p3', '--param3']).default('ABC').multiple(true))

	y := x.parse()

	for key in y.keys() {
		println(key + " ... " + y[key])
	}	
}
