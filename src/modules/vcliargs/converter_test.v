module vcliargs

fn test_convert_intended() {
	assert 'abc' == convert[string]('abc') or { '' }

	assert 5 == convert[int]('5') or { 0 }
	assert 5 == convert[int]('5.5') or { 0 }
	assert 0 == convert[int]('hello') or { 5 }
	assert 0 == convert[int]('true') or { 5 }
	
	assert 12.34 == convert[f64]('12.34') or { 0.0 }
	assert 5.0 == convert[f64]('5') or { 0.0 }
	assert 0.0 == convert[f64]('hello') or { 12.34 }
	assert 0.0 == convert[f64]('true') or { 5.0 }

	assert true == convert[bool]('true') or { false }
	assert false == convert[bool]('false') or { true }
	assert false == convert[bool]('hello') or { true }
	assert false == convert[bool]('1') or { true }
	assert false == convert[bool]('5.5') or { true }
}

fn test_convert_negatives() {
	assert 5 != convert[int]('five') or { 5 }
	assert -5 == convert[int]('-5') or { 0 }

	assert 5.0 != convert[f64]('five') or { 5.0 }
	assert -5.0 == convert[f64]('-5.0') or { 0.0 }

	assert true != convert[bool]('1') or { true }
}
