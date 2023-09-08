module vcliargs

// implement builder like use for key

[heap]
struct Key {
	value string
	description string
mut:
	alias []string
	is_valueless bool
	contains_multiple bool
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
	k.default = def
}

fn (k Key) is_key(test string) bool {
	if test in k.alias { return true }
	
	return false
}
