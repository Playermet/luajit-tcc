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
