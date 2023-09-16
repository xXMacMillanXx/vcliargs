module vcliargs

pub enum ArgTypes {
	string
	float
	integer
	boolean
}

union Any {
mut:
	s []string
	i []int
	f []f64
	b []bool
}

fn (mut a Any) set[T](input T) {
	$if T is string {
		a.s = [input]
		return
	}
	$if T is int {
		a.i = [input]
		return
	}
	$if T is f64 {
		a.f = [input]
		return
	}
	$if T is bool {
		a.b = [input]
	}
}

fn (mut a Any) add[T](input T) {
	$if T is string {
		a.s << input
		return
	}
	$if T is int {
		a.i << input
		return
	}
	$if T is f64 {
		a.f << input
		return
	}
	$if T is bool {
		a.b << input
	}
}

fn (a Any) get[T]() ?[]T {
	$if T is string {
		return a.s
	}
	$if T is int {
		return a.i
	}
	$if T is f64 {
		return a.f
	}
	$if T is bool {
		return a.b
	}
	return none
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
		return s.bool()
	}
	return none
}
