local tcc = require 'tcc' ('libtcc')

local state = tcc.new()

state:set_output_type('output_memory')

state:compile_string [[
  #include <stdio.h>

  int main(int argc, char** argv)
  {
  	for (int i = 0; i < argc; i++){
		printf("%s \n", argv[i]);
  	}
    return 0;
  }
]]

state:run { 1, 2, 3, 'text', false }

state:delete()
