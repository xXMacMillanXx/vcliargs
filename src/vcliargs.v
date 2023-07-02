module vcliargs

// import os

struct Args {
	texts []string
mut:
	args [][]string
	descs []string
	// values map[string]string
}

pub fn Args.new(prog string, description string, epilog string) Args {
	return Args { texts: [prog, description, epilog] }
}

pub fn (mut a Args) add_argument(arg []string, desc string) {
	a.args << arg
	a.descs << desc
}

pub fn (a Args) parse() {
	// todo
}

pub fn (a Args) print_help() {
	println(a.texts[0]) // program name
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	for i, arglist in a.args {
		for arg in arglist {
			print(arg + " ")
		}
		print(a.descs[i] + '\n')
	}
	println('')
	println(a.texts[2]) // program epilog
}
