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

# Differences from the C API
Binding is so close to the original API as possible, but some things still differ.
 1. Names lost 'tcc_' prefix as not needed.
 2. 'tcc.add_symbol' and 'tcc.get_symbol' have optional argument for in-place cast.
 3. 'tcc.run' accept table instead of argc-argv pair.
