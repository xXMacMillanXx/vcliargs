module vcliargs

// implement builder like use for key
// implement basic type check and converter, possible use for union?
// add acceptable options; stop program with explaination if option doesn't exist

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

fn (mut k Key) set_options(def string, single bool, multiple bool) {
	k.is_valueless = single
	k.contains_multiple = multiple
	if def != "" { k.uses_default = true }
	k.default = def
}

pub fn (k Key) alias(alias string) Key {
	mut k2 := k
	if alias in k2.alias {
		return k2
	}

	k2.alias << alias
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

fn (k Key) is_key(test string) bool {
	if test in k.alias { return true }
	
	return false
}
