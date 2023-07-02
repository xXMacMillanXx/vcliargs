module main

import vcliargs as vc

fn main() {
	mut x := vc.Args.new('Arg Tester', 'This is testing the module', 'Don\'t know what should be here.')
	x.add_argument(['-c', '--count'], 'Counts something.')
	x.print_help()
}
