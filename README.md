# vcliargs
A simple V module for handling command line arguments.

## Usage

The module has a builder like way to be used:

```v
module main

import vcliargs

mut prep := vcliargs.Args.new('header', 'description', 'footer')
prep.add_key(prep.key('path', 'path for input file').alias(['-p', '--path']).multiple(true))

args := prep.parse()
println('path contains: ' + args['path'])

```

Currently the following functions can be used:

```v
module main

import vcliargs

mut prep := vcliargs.Args.new('CLI Tool Header', 'CLI Tool Description', 'CLI Tool Footer')

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']))
// .alias sets the parameter specifiers for the cli tool

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).default('~/Documents/'))
// .default sets a default value, which will be used if the parameter wasn't used by the user

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).valueless(true))
// .valueless(true) treats the parameter as a flag, if it was used (e.g., -p) it exist after parse(), otherwise it doesn't

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).multiple(true))
// .multiple(true) lets the parameter accept multiple values (e.g., -p /mnt/ /var/log/)

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).options(['ABC', 'XYZ']))
// .options([...]) specifies values, which will be accepted by the parameter, other values will be rejected

prep.add_key(prep.key('count', 'Count down from the given integer').alias(['-c', '--count']).type_check(vcliargs.ArgTypes.integer))
// .type_check(ArgTypes) checks if the user input is convertable into the specified data type. Supported types are string, integer (int), float (f64) and boolean (bool).
// use the vcliargs.convert[T](input string) function to convert strings form the map you receive from parse() or cast it yourself.

prep.add_key(prep.key('count', 'Count down from the given integer').alias(['-c', '--count']).required(true))
// .required(true) makes it necessary for the parameter to need a value. THe value can come from default or user input.

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).default('~/').multiple(true))
// these function can be used together to have more control over the accepted input

```

## Documentation

### Args

The Args struct is used to collect all the needed data to parse user input received through parameters.

#### new()

```v
fn Args.new(program_name string, description string, epilog_or_footer string) Args
```

Creates a new Args, with three strings which will be shown in the help. (-h or --help)

#### add_key()

```v
fn (mut a Args) add_key(k Key)
```

Adds a Key to Args, which will be used for parsing.

#### key()

```v
fn (a Args) key(var_name string, description string) Key
```

Creates a new Key, which will be accessible with the var_name after parsing. The description will be shown in the help. (-h or --help)

### Key

The Key struct contains all the information needed to parse and check the input of the user.

#### alias()

```v
fn (k Key) alias(s []string) Key
```

This function is necessary. Sets the parameter names, which the user uses to specify parameter values.

#### default()

```v
fn (k Key) default(s string) Key
```

Sets the default value for this parameter, which will be used if the user doesn't change or set the parameter value.

#### valueless()

```v
fn (k Key) valueless(b bool) Key
```

Specifies if this parameter receives a value from the user or if it's used without values. For example '-h' doesn't use a value, it's used like a flag.

#### multiple()

```v
fn (k Key) multiple(b bool) Key
```

Specifies if this parameter expects multiple values. If set to true, one or more values will be accepted for this parameter.

#### options()

```v
fn (k Key) options(s []string) Key
```

Sets values, which will be accepted as input for this parameter.

#### type_check()

```v
fn (k Key) type_check(a ArgTypes) Key
```

Specifies a type, which will be checked for this parameter. Possible types are: string, int, f64 and bool

#### required()

```v
fn (k Key) required(b bool) Key
```

Specifies if a parameter is required to have a value. This means either a default value or user input is needed.

### ArgTypes

```v
enum ArgTypes {
    string
    float
    integer
    boolean
}
```

An enum, which is used for checking types of user input.


### convert()

```v
fn convert[T](s string) ?T
```

Trys to convert the given string s into the given type T. If type T is not string, f64, int or bool, the function will return none, otherwise it will return the converted value or the default value of the given type.
