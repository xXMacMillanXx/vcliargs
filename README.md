# vcliargs
A simple V module for handling command line arguments.

## Usage

This way is curently possible, but is set to deprecated.

```v
module main

import vcliargs

mut prep := vcliargs.Args.new('header', 'description', 'footer')
prep.add_key('path', ['-p', '--path'], 'path for input file')

args := prep.parse()
println('path contains: ' + args['path'])
```

Added new way to create Keys, this will be the default way and the old way will be removed.
Once this happens, inject_key() will be renamed to add_key().

```v
module main

import vcliargs

mut prep := vcliargs.Args.new('header', 'description', 'footer')
prep.inject_key(prep.key('path', 'path for input file').alias('-p').alias('--path'))

args := prep.parse()
println('path contains: ' + args['path'])

```