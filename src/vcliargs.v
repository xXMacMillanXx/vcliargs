module vcliargs

import os

struct Key {
	value string
	description string
mut:
	alias []string
}

fn Key.new(key string, description string) Key {
	return Key { value: key, description: description }
}

fn (mut k Key) add_alias(alias string) {
	if alias in k.alias {
		return
	}

	k.alias << alias
}

fn (k Key) is_key(test string) bool {
	if test == k.value { return true }
	if test in k.alias { return true }
	
	return false
}

struct Args {
	texts []string
mut:
	keys []Key
}

pub fn Args.new(name string, desc string, epi string) Args {
	mut x := Args { texts: [name, desc, epi] }
	x.add_key('-h', ['--help'], 'Shows the help text.')

	return x
}

pub fn (mut a Args) add_key(key string, alias []string, description string) {
	mut new_key := Key.new(key, description)
	for x in alias {
		new_key.add_alias(x)
	}

	a.keys << new_key
}

fn (a Args) get_all_keys() []string {
	mut keys := []string{}
	for key in a.keys {
		keys << key.value
		for al in key.alias {
			keys << al
		}
	}

	return keys
}

pub fn (mut a Args) parse() map[string]string {
	mut ret := map[string]string{}
	a.keys.sort(a.value < b.value)

	for key in a.keys {
		for arg in os.args {
			if key.is_key(arg) {
				ret[arg] = "test"
			}
		}
	}

	return ret
}

pub fn (a Args) print_help() {
	println(a.texts[0]) // program name
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	for key in a.keys {
		print(key.value + " ")
		for al in key.alias {
			print(al + " ")
		}
		print(key.description + '\n')
	}
	println('')
	println(a.texts[2]) // program epilog
}
