module vcliargs

// implement basic type check and converter, possible use for generics or only support for int, f64, bool and string?; requires map changes
// implement keys which can hold multiple values; requires map changes or csv style string or just a 1:1 copy from args input

[heap]
struct Key {
	value string
	description string
mut:
	alias []string
	is_valueless bool
	contains_multiple bool // TODO
	values []string // TODO
	uses_default bool
	default string
	uses_options bool
	options []string
}

fn Key.new(key string, description string) Key {
	return Key { value: key, description: description }
}

[deprecated: 'check is unnecessary, duplicates don\'t break anything, just use .alias()']
fn (mut k Key) add_alias(alias string) {
	if alias in k.alias {
		return
	}

	k.alias << alias
}

[deprecated: 'obsolete since options can be added with builder-like functions e.g., .alias(), .default(), etc.']
fn (mut k Key) set_options(def string, single bool, multiple bool) {
	k.is_valueless = single
	k.contains_multiple = multiple
	if def != "" { k.uses_default = true }
	k.default = def
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
