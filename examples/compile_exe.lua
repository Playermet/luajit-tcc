local tcc = require 'tcc' ('libtcc')

local state = tcc.new()

state:set_output_type('output_exe')

state:compile_string [[
  #include <stdio.h>

  int main()
  {
  	printf("Hello World!\n");
  	getch();
    return 0;
  }
]]

state:output_file('main.exe')

state:delete()
