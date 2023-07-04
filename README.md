# vcliargs
A simple V module for handling command line arguments.

## Usage

```v
module main

import vcliargs

mut prep := vcliargs.Args.new('header', 'description', 'footer')
prep.add_key('path', ['-p', '--path'], 'path for input file')

args := prep.parse()
println('path contains: ' + args['path'])
```