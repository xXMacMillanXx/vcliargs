module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')

	x.add_key(x.key('count', 'Counts something.').alias(['-c', '--count']).default('100').type_check(vc.ArgTypes.integer))
	x.add_key(x.key('path', 'Path to something').alias(['-p', '--path']).multiple(true))
	x.add_key(x.key('param1', 'Tests new key creation').alias(['-p1', '--param1']).options(['XYZ', 'ABC', 'JKL']).required(true))
	x.add_key(x.key('param2', 'Tests new key creation').alias(['-p2', '--param2']).default('ABC').options(['XYZ', 'ABC', 'JKL']))
	x.add_key(x.key('param3', 'Tests new key creation').alias(['-p3', '--param3']).default('123').multiple(true).type_check(vc.ArgTypes.integer))
	x.add_key(x.key('hidden', 'Hidden value, which gets parsed for internal use.').default('hello'))

	// default doesn't work this way. Not sure why, needs investigation.
	x.add_key(x.key_new(value: 'format', description: 'Format for output.', alias: ['-f', '--format'], default: 'csv'))

	y := x.parse()

	for key in y.keys() {
		println(key + " ... " + y[key])
	}
}
