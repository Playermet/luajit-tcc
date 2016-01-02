# Features
 - Full support of 0.9.26 API
```lua
 -- Additional OO style for TCCState
 tcc.delete(state)
 -- or
 state:delete()
```
```lua
 -- Constants can be used in two ways
 state:set_output_type(tcc.const.output_dll)
 -- or
 state:set_output_type('output_dll')
```
# Differences from the C API
Binding is so close to the original API as possible, but some things still differ.
 1. Names lost 'tcc_' prefix as not needed.
 2. 'tcc.add_symbol' and 'tcc.get_symbol' have optional argument for in-place cast.
 3. 'tcc.run' accept table instead of argc-argv pair.

# Start using
Before calling tcc functions you need to initialize binding with library name or path.
Luajit uses dynamic library loading API directly, so behaviour may be different on each OS.
Filename and location of tcc library may also vary.
Several examples:
```lua
-- Windows
local tcc = require 'tcc' ('libtcc')
local tcc = require 'tcc' ('../some/path/libtcc.dll')
```

# Example code
```lua
  local tcc = require 'tcc' ('libtcc')

  local state = tcc.new()

  state:set_output_type('output_memory')

  state:compile_string [[
    int summ(int a, int b)
    {
      return a + b;
    }
  ]]

  state:relocate('relocate_auto')

  local summ = state:get_symbol('summ', 'int(*)(int,int)')

  print('5 + 7 = ' .. summ(5,7))

  state:delete()

```
