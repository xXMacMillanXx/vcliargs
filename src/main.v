module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')
	x.add_key('count', ['-c', '--count'], 'Counts something.')
	x.add_key('path', ['-p', '--path'], 'Path to something')

	y := x.parse()

	for key in y.keys() {
		println(key + " ... " + y[key])
	}	
}
