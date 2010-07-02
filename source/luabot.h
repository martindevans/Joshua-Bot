extern "C" {
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
}
#include "import_from_defcon.h"

#define FUNCTION_NAMES 1
#define EVENT_ENUM_NAMES 4
#define TYPE_ENUM_NAMES 20
#define TERRITORY_ENUM_NAMES 37

extern const char* lbot_enum_names[];

void lbot_openlibs(lua_State *L, Funct* pDefconInterface, std::vector< std::vector<std::string> > &vvCommandLineOptions);
void lbot_loadfile(lua_State *L, const char* sFilename);
void lbot_pcall(lua_State *L, int nArgs, int nRes, const char* sContext);
void lbot_pusherrorhandler(lua_State *L);
void lbot_pushstdstring(lua_State *L, const std::string& s);
inline int lbot_checkID(lua_State *L, int idx);
inline int lbot_optID(lua_State *L, int idx, int def);
int lbot_checkTypeName(lua_State *L, int idx);
int lbot_optTypeName(lua_State *L, int idx, int def);

#define lbot_pushint(L, i) lua_pushlightuserdata((L), reinterpret_cast<void*>((i)))
#define lbot_pushnumber(L, n) lua_pushnumber((L), static_cast<lua_Number>((n)));