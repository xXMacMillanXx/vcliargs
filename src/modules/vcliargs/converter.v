module vcliargs

pub enum ArgTypes {
	string
	float
	integer
	boolean
}

fn (a ArgTypes) abbreviation() string {
	return match a {
		.string { 'STR' }
		.float { 'F64' }
		.integer { 'INT' }
		.boolean { 'BOOL' }
	}
}

pub fn convert[T](s string) ?T {
	$if T is string {
		return s
	}
	$if T is int {
		return s.int()
	}
	$if T is f64 {
		return s.f64()
	}
	$if T is bool {
		return s.to_lower().bool()
	}
	return none
}
