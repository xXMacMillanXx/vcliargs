module vcliargs

import os

struct Args {
	texts []string
mut:
	keys []Key
}

pub fn Args.new(name string, desc string, epi string) Args {
	mut x := Args { texts: [name, desc, epi] }
	x.inject_key(x.key('help', 'Shows the help text.').alias(['-h', '--help']).valueless(true))

	return x
}

pub fn (a Args) key(key string, description string) Key {
	return Key.new(key, description)
}

pub fn (mut a Args) inject_key(key Key) {
	a.keys << key
}

[deprecated: 'use inject_key() with .alias(), .default(), etc. instead']
pub fn (mut a Args) add_key(key string, alias []string, description string) {
	mut new_key := Key.new(key, description)
	for x in alias {
		new_key.add_alias(x)
	}

	a.keys << new_key
}

[deprecated: 'use inject_key() with .alias(), .default(), etc. instead']
pub fn (mut a Args) add_advanced_key(key string, alias []string, description string, def string, single bool, multiple bool) {
	mut new_key := Key.new(key, description)
	for x in alias {
		new_key.add_alias(x)
	}
	new_key.set_options(def, single, multiple)

	a.keys << new_key
}

fn (a Args) get_key_alias(key string) ?[]string {
	for x in a.keys {
		if key == x.value {
			return x.alias
		}
	}
	return none
}

fn (a Args) get_all_alias() []string {
	mut keys := []string{}
	for key in a.keys {
		for al in key.alias {
			keys << al
		}
	}

	return keys
}

fn check_option(key Key, input string) {
	if !key.is_valid_option(input) {
		println('The option ${input} is not available for parameter ${key.alias}. Possible options are: ${key.options}')
		exit(1)
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

	for key in a.keys {
		if key.uses_default {
			ret[key.value] = key.default
			check_option(key, key.default)
		}
	}

	for i, arg in os.args {
		for key in a.keys {
			if key.is_key(arg) {
				ret[key.value] = os.args[i+1]
				check_option(key, os.args[i+1])
				break
			}
		}
	}

	return ret
}

pub fn (a Args) print_help() {
	println(a.texts[0]) // program name
	println('')
	println('usage: ') // TODO, automatic usage gen
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	for key in a.keys {
		for al in key.alias {
			print(al + " ")
		}
		print(key.description + ' ')
		if key.uses_default {
			print('Default: ' + key.default + ' ')
		}
		if key.uses_options {
			print('Options: ' + key.options.str())
		}
		print('\n')
	}
	println('')
	println(a.texts[2]) // program epilog
}
