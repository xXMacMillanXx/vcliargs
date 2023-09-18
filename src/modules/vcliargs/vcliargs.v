module vcliargs

import os

struct Args {
	texts []string
mut:
	keys []Key
}

pub fn Args.new(name string, desc string, epi string) Args {
	mut x := Args { texts: [name, desc, epi] }
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
	a.keys.sort(a.alias[0] < b.alias[0])
	h := a.get_key_alias('help')
	for v in h {
		if v in os.args {
			a.print_help()
			exit(0)
		}
	}

	mut ret := map[string]string{}

	for key in a.keys { // could use a clean up
		if key.uses_default {
			ret[key.value] = key.default
			check_option(key, key.default)
			check_type(key, key.default)
		}
		if key.is_required {
			mut con := false
			for v in key.alias {
				if v in os.args || key.uses_default {
					con = true
				}
			}
			if !con {
				println('The parameter ${key.alias} is required, but was not used.')
				exit(1)
			}
		}
	}

	for i, arg in os.args {
		if a.is_key(arg) {
			key := a.get_key(arg) or { panic(err) }
			if key.is_valueless {
				ret[key.value] = key.value
				continue
			}
			if i+1 >= os.args.len {
				ret[key.value] = ''
				check_option(key, '')
				check_type(key, '')
				break
			}
			if a.is_key(os.args[i+1]) {
				println('The parameter ${key.alias} requires a value, but received none.')
				exit(1)
			}
			mut ii := 1
			for !a.is_key(os.args[i+ii]) {
				check_option(key, os.args[i+ii])
				check_type(key, os.args[i+ii])
				ii++
				if i+ii >= os.args.len { break }
			}
			if !key.contains_multiple && ii > 2 {
				println('The parameter ${key.alias} does not accept multiple values, but received ${os.args[i+1..i+ii]}. Only first value will be accepted.')
				ii = 2
			}
			ret[key.value] = os.args[i+1..i+ii].join(';')
		}
	}

	return ret
}

[deprecated: 'help is now part of Key instead of Args']
fn print_help_line(key Key) {
	mut collection := map[string][]string{}

	collection['alias'] << key.alias.join(' ')

	if key.is_valueless {
		collection['value'] << ''
	} else {
		if !key.uses_options && !key.uses_default {
			collection['value'] << 'VALUE'
		}
		if key.contains_multiple {
			collection['value'] << '<VALUE ...>'
		}
		if key.uses_default {
			collection['value'] << '{' + key.default + '}'
		}
		if key.uses_options {
			collection['value'] << '[' + key.options.join(', ') + ']'
		}
	}

	params := '${collection['alias'][0]}'
	param_vals := '${collection['value'].join(' ')}'

	println('${params:-20} ${param_vals:-20} ${key.description}')
}

pub fn (a Args) print_help() {
	println(a.texts[0]) // program name
	println('')
	print('usage: ')
	mut usage := []string{}
	for key in a.keys {
		usage << key.gen_usage()
	}
	usage.sort()
	println(usage.join(' '))
	println('')
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	for key in a.keys {
		println(key.gen_help())
	}
	println('')
	println(a.texts[2]) // program epilog
}
