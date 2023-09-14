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
		if a.is_key(arg) {
			key := a.get_key(arg) or { panic(err) }
			if key.is_valueless {
				ret[key.value] = key.value
				continue
			}
			if i+1 >= os.args.len {
				ret[key.value] = ''
				break
			}
			if a.is_key(os.args[i+1]) {
				println('The parameter ${key.alias} requires a value, but received none.')
				exit(1)
			}
			ret[key.value] = os.args[i+1] // weave single value and multi-value together; single = 1x loop, multi = Xx loop
			check_option(key, os.args[i+1])
			if key.contains_multiple {
				mut ii := 2
				if i+ii < os.args.len {
					for !a.is_key(os.args[i+ii]) {
						ret[key.value] += ';' + os.args[i+ii]
						ii++
						if i+ii >= os.args.len { break }
					}
				}
			}
		}
	}

	return ret
}

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
	println('usage: ') // TODO, automatic usage gen
	println('')
	println(a.texts[1]) // program description
	println('')
	println('Options')
	for key in a.keys {
		print_help_line(key)
	}
	println('')
	println(a.texts[2]) // program epilog
}
