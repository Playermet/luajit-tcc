local tcc = require 'tcc' ('libtcc')

local state = tcc.new()

state:set_output_type('output_memory')

state:add_symbol('lua_sqrt', math.sqrt, 'float(*)(float)')

state:compile_string [[
  float lua_sqrt(float);

  float vec2_length(float x, float y)
  {
    return lua_sqrt(x*x + y*y);
  }
]]

state:relocate('relocate_auto')

local vec2_length = state:get_symbol('vec2_length', 'float(*)(float,float)')

print('length(10,0) = ' .. vec2_length(10,0))
print('length(10,10) = ' .. vec2_length(10,10))

state:delete()
