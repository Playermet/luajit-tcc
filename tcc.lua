-----------------------------------------------------------
--  Binding for TCC v0.9.26
-----------------------------------------------------------
local ffi = require 'ffi'
local jit = require 'jit'


local const = {}

const.output_memory     = 0
const.output_exe        = 1
const.output_dll        = 2
const.output_obj        = 3
const.output_preprocess = 4

const.relocate_auto = ffi.cast('void*', 1)


local function get_const(value)
  if type(value) == 'string' then
    if const[value] then
      return const[value]
    else
      error('unknown const name', 3)
    end
  end

  return value
end


local header = [[
  typedef struct TCCState TCCState;

  TCCState *tcc_new(void);
  void tcc_delete(TCCState *s);
  void tcc_set_lib_path(TCCState *s, const char *path);
  void tcc_set_error_func(TCCState *s, void *error_opaque, void (*error_func)(void *opaque, const char *msg));
  int tcc_set_options(TCCState *s, const char *str);

  int tcc_add_include_path(TCCState *s, const char *pathname);
  int tcc_add_sysinclude_path(TCCState *s, const char *pathname);
  void tcc_define_symbol(TCCState *s, const char *sym, const char *value);
  void tcc_undefine_symbol(TCCState *s, const char *sym);

  int tcc_add_file(TCCState *s, const char *filename);
  int tcc_compile_string(TCCState *s, const char *buf);

  int tcc_set_output_type(TCCState *s, int output_type);
  int tcc_add_library_path(TCCState *s, const char *pathname);
  int tcc_add_library(TCCState *s, const char *libraryname);
  int tcc_add_symbol(TCCState *s, const char *name, const void *val);
  int tcc_output_file(TCCState *s, const char *filename);
  int tcc_run(TCCState *s, int argc, char **argv);
  int tcc_relocate(TCCState *s1, void *ptr);

  void *tcc_get_symbol(TCCState *s, const char *name);
]]

local bind = {}
local mod = {}

function mod.new()
  return bind.tcc_new()
end

function mod.delete(s)
  bind.tcc_delete(s)
end

function mod.set_lib_path(s, path)
  bind.tcc_set_lib_path(s, path)
end

function mod.set_error_func(s, opaque, error_func)
  bind.tcc_set_error_func(s, opaque, error_func)
end

function mod.set_options(s, str)
  return bind.tcc_set_options(s, str)
end

function mod.add_include_path(s, pathname)
  return bind.tcc_add_include_path(s, pathname)
end

function mod.add_sysinclude_path(s, pathname)
  return bind.tcc_add_sysinclude_path(s, pathname)
end

function mod.define_symbol(s, sym, value)
  bind.tcc_define_symbol(s, sym, value)
end

function mod.undefine_symbol(s, sym)
  bind.tcc_undefine_symbol(s, sym)
end

function mod.add_file(s, filename)
  return bind.tcc_add_file(s, filename)
end

function mod.compile_string(s, buf)
  return bind.tcc_compile_string(s, buf)
end

function mod.set_output_type(s, type)
  return bind.tcc_set_output_type(s, get_const(type))
end

function mod.add_library_path(s, pathname)
  return bind.tcc_add_library_path(s, pathname)
end

function mod.add_library(s, libraryname)
  return bind.tcc_add_library(s, libraryname)
end

function mod.add_symbol(s, name, val, ctype)
  val = ctype and ffi.cast(ctype, val) or val
  return bind.tcc_add_symbol(s, name, val)
end

function mod.output_file(s, filename)
  return bind.tcc_output_file(s, filename)
end

function mod.run(s, t)
  local argc = #t
  local argv = ffi.new('char*[?]', argc)
  for i = 1, argc do
    local str = tostring(t[i])
    argv[i - 1] = ffi.new('char[?]', #str + 1, str)
  end
  return bind.tcc_run(s, argc, argv)
end

function mod.relocate(s, ptr)
  return bind.tcc_relocate(s, get_const(ptr))
end

function mod.get_symbol(s, name, ctype)
  local symbol = bind.tcc_get_symbol(s, name)
  return ctype and ffi.cast(ctype, symbol) or symbol
end


state_mt = {}
state_mt.__index = state_mt
state_mt.delete              = mod.delete
state_mt.set_lib_path        = mod.set_lib_path
state_mt.set_error_func      = mod.set_error_func
state_mt.set_options         = mod.set_options
state_mt.add_include_path    = mod.add_include_path
state_mt.add_sysinclude_path = mod.add_sysinclude_path
state_mt.define_symbol       = mod.define_symbol
state_mt.undefine_symbol     = mod.undefine_symbol
state_mt.add_file            = mod.add_file
state_mt.compile_string      = mod.compile_string
state_mt.set_output_type     = mod.set_output_type
state_mt.add_library_path    = mod.add_library_path
state_mt.add_library         = mod.add_library
state_mt.add_symbol          = mod.add_symbol
state_mt.output_file         = mod.output_file
state_mt.run                 = mod.run
state_mt.relocate            = mod.relocate
state_mt.get_symbol          = mod.get_symbol


mod.const = const

setmetatable(mod, {
  __call = function(self, name)
    ffi.cdef(header)

    bind = ffi.load(name)

    ffi.metatype('TCCState', state_mt)

    return self
  end
})

return mod
