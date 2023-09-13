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

prep.add_key(prep.key('path', 'Path for input file').alias(['-p', '--path']).default('~/').multiple(true))
// these function can be used together to have more control over the accepted input

```