module vcliargs

// TODO list
// keys without alias could be handled as hidden value, accessible after parse, but not changable by the user
// think about multi-values; currently csv in string; maybe convert() could also return []T?; an array would be good...
// write tests to insure functionality; and see if changes break said functionality

[heap]
struct Key {
	value string
	description string
mut:
	alias []string
	is_valueless bool
	contains_multiple bool
	uses_default bool
	default string
	uses_options bool
	options []string
	type_checker bool
	check_type ArgTypes
	is_required bool
}

fn Key.new(key string, description string) Key {
	return Key { value: key, description: description }
}

pub fn (k Key) alias(alias []string) Key {
	mut k2 := k
	k2.alias.insert(k2.alias.len, alias)
	return k2
}

pub fn (k Key) default(def string) Key {
	mut k2 := k
	k2.uses_default = true
	k2.default = def
	return k2
}

pub fn (k Key) valueless(single bool) Key {
	mut k2 := k
	k2.is_valueless = single
	return k2
}

pub fn (k Key) multiple(mult bool) Key {
	mut k2 := k
	k2.contains_multiple = mult
	return k2
}

pub fn (k Key) options(options []string) Key {
	mut k2 := k
	k2.uses_options = true
	k2.options.insert(k2.options.len, options)
	return k2
}

pub fn (k Key) type_check(typ ArgTypes) Key {
	mut k2 := k
	k2.type_checker = true
	k2.check_type = typ
	return k2
}

pub fn (k Key) required(b bool) Key {
	mut k2 := k
	k2.is_required = true
	return k2
}

fn (k Key) is_key(test string) bool {
	if test in k.alias { return true }
	
	return false
}

fn (k Key) is_valid_option(testing string) bool {
	if k.uses_options {
		if testing in k.options {
			return true
		}
		return false
	}
	return true
}

fn (k Key) gen_usage() string {
	mut ret := []string{}

	if !k.is_required {
		ret << '['
	}
	ret << k.alias.join('|')

	if !k.is_valueless {
		if !k.contains_multiple {
			ret << ' <' + k.check_type.abbreviation() + '>'
		} else {
			ret << ' <' + k.check_type.abbreviation() + ',...>'
		}
		if k.uses_default {
			ret << '{' + k.default + '}'
		}
		if k.uses_options {
			ret << '[' + k.options.join('|') + ']'
		}
	}

	if !k.is_required {
		ret << ']'
	}

	return ret.join('')
}

fn (k Key) gen_help() string {
	mut collection := map[string][]string{}

	collection['alias'] << k.alias.join(' ')

	if k.is_valueless {
		collection['value'] << ''
	} else {
		if !k.contains_multiple {
			if k.is_required {
				collection['value'] << k.check_type.abbreviation()
			} else {
				collection['value'] << '<' + k.check_type.abbreviation() + '>'
			}
		}
		if k.contains_multiple {
			if k.is_required {
				collection['value'] << k.check_type.abbreviation() + ',...'
			} else {
				collection['value'] << '<' + k.check_type.abbreviation() + ',...>'
			}
		}
		if k.uses_default {
			collection['value'] << '{' + k.default + '}'
		}
		if k.uses_options {
			collection['value'] << '[' + k.options.join(', ') + ']'
		}
	}

	params := '${collection['alias'][0]}'
	param_vals := '${collection['value'].join(' ')}'

	return '${params:-20} ${param_vals:-30} ${k.description}'
}
