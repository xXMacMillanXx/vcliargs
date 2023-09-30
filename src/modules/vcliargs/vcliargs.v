module vcliargs

import os

struct Args {
	texts []string
mut:
	keys []Key
	args []string
}

pub fn Args.new(name string, desc string, epi string) Args {
	mut x := Args { texts: [name, desc, epi] }
	x.args = os.args
	x.add_key(x.key('help', 'Shows the help text.').alias(['-h', '--help']).valueless(true))

	return x
}

pub fn (a Args) key(key string, description string) Key {
	return Key.new(key, description)
}

pub fn (mut a Args) add_key(key Key) {
	a.keys << key
}

fn (a Args) get_key_alias(key string) ?[]string {
	for x in a.keys {
		if key == x.value {
			return x.alias
		}
	}
	return none
}

fn (a Args) get_key(s string) ?Key {
	for key in a.keys {
		if s in key.alias {
			return key
		}
	}
	return none
}

// used for tests, setting custom "os.args"
fn (mut a Args) set_args(s ...string) {
	a.args = s
}

fn (a Args) is_key(s string) bool {
	for key in a.keys {
		if s in key.alias {
			return true
		}
	}
	return false
}

fn check_option(key Key, input string) {
	if !key.is_valid_option(input) {
		println('The option "${input}" is not available for parameter ${key.alias}. Possible options are: ${key.options}')
		exit(1)
	}
}

fn check_type(key Key, input string) {
	if key.type_checker {
		type_error := match key.check_type {
			.string { false }
			.float {
				test := convert[f64](input) or { 0.0 }
				if test == 0.0 && input != '0.0' {
					true
				} else { false }
			}
			.integer {
				test := convert[int](input) or { 0 }
				if test == 0 && input != '0' {
					true
				} else { false }
			}
			.boolean {
				test := convert[bool](input) or { false }
				if test == false && input != 'false' {
					true
				} else { false }
			}
		}

		if type_error {
			println('The parameter ${key.alias} expects a(n) ${key.check_type}, but found "${input}"')
			exit(1)
		}
	}
}

pub fn (mut a Args) parse() map[string]string {
	// a.keys.sort(a.alias[0] < b.alias[0]) // why did I sort the keys here?
	h := a.get_key_alias('help')
	for v in h {
		if v in a.args {
			a.print_help()
			exit(0)
		}
	}

	mut ret := map[string]string{}

	for key in a.keys { // could use a clean up
		if key.alias.len == 0 {
			ret[key.value] = ''
		}
		if key.uses_default {
			ret[key.value] = key.default
			check_option(key, key.default)
			check_type(key, key.default)
		}
		if key.is_required {
			mut con := false
			for v in key.alias {
				if v in a.args || key.uses_default {
					con = true
				}
			}
			if !con {
				println('The parameter ${key.alias} is required, but was not used.')
				exit(1)
			}
		}
	}

	for i, arg in a.args {
		if a.is_key(arg) {
			key := a.get_key(arg) or { panic(err) }
			if key.is_valueless { // currently doesn't care if it receives a value -> ignored; could be changed to give an error, but not sure
				ret[key.value] = key.value // could also be true, to indicate that the flag was used
				continue
			}
			if i+1 >= a.args.len {
				ret[key.value] = ''
				check_option(key, '')
				check_type(key, '')
				break
			}
			if a.is_key(a.args[i+1]) {
				println('The parameter ${key.alias} requires a value, but received none.')
				exit(1)
			}
			mut ii := 1
			for !a.is_key(a.args[i+ii]) {
				check_option(key, a.args[i+ii])
				check_type(key, a.args[i+ii])
				ii++
				if i+ii >= a.args.len { break }
			}
			if !key.contains_multiple && ii > 2 {
				println('The parameter ${key.alias} does not accept multiple values, but received ${a.args[i+1..i+ii]}. Only first value will be accepted.')
				ii = 2
			}
			ret[key.value] = a.args[i+1..i+ii].join(';')
		}
	}

	return ret
}

pub fn (a Args) print_help() {
	println(a.texts[0]) // program name
	println('')
	print('usage: ')
	mut usage := []string{}
	for key in a.keys {
		if key.alias.len == 0 { continue }
		usage << key.gen_usage()
	}
	usage.sort()
	println(usage.join(' '))
	println('')
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	mut help := []string{}
	for key in a.keys {
		if key.alias.len == 0 { continue }
		help << key.gen_help()
	}
	help.sort()
	println(help.join('\n'))
	println('')
	println(a.texts[2]) // program epilog
}
