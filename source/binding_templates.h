#pragma once

// Psuedo-classes to describe types
template <int I> struct EnvEnum; // integer representing a enum whose names start in the environment table at index I
template <class T> struct Vector2; // two-element std::vector<T> returned to Lua as two values

// Mapping of types to C++ return types
template <typename T> struct RValTraits
{ typedef T RT; };
template <> struct RValTraits<void*>
{ typedef int RT; };
template <typename T> struct RValTraits< std::vector<T> >
{ typedef std::vector<typename RValTraits<T>::RT> RT; };
template <typename T> struct RValTraits< Vector2<T> >
{ typedef std::vector<T> RT; };
template <int I> struct RValTraits< EnvEnum<I> >
{ typedef int RT; };

// Mapping of types to C++ thunk<T>::push parameter types
template <typename T> struct PValTraits
{ typedef typename RValTraits<T>::RT PT; };
template <typename T> struct PValTraits< std::vector<T> >
{ typedef const std::vector<typename RValTraits<T>::RT>& PT; };
template <typename T> struct PValTraits< Vector2<T> >
{ typedef typename PValTraits<typename RValTraits<typename Vector2<T> >::RT>::PT PT; };

// thunk<T>::push(L, value) to push types onto the Lua stack
// implemented as static member on a template class to allow partial template specialisation
template <typename T> struct thunk {static int push(lua_State *L, typename PValTraits<T>::PT val)
{ lbot_pushnumber(L, val); return 1; }};
template <> struct thunk<bool> {static int push(lua_State *L, bool val)
{ lua_pushboolean(L, val ? 1 : 0); return 1; }};
template <> struct thunk<char*> {static int push(lua_State *L, char* val)
{ lua_pushstring(L, val); return 1; }};
template <> struct thunk<void*> {static int push(lua_State *L, int val)
{
  if(val == -1)
    lua_pushnil(L);
  else
    lbot_pushint(L, val);
  return 1;
}};
template <class T> struct thunk< std::vector<T> > {static int push(lua_State *L, const std::vector<typename PValTraits<T>::PT>& val)
{
  int iSize = static_cast<int>(val.size());
  lua_createtable(L, iSize, 0);
  for(int i = 0; i < iSize; )
  {
    lua_pop(L, thunk<T>::push(L, val[i]) - 1);
    lua_rawseti(L, -2, ++i);
  }
  return 1;
}};
template <int I> struct thunk< EnvEnum<I> > {static int push(lua_State *L, int val)
{
  if(val >= 0)
    lua_rawgeti(L, LUA_ENVIRONINDEX, I + val);
  else
    lua_pushnil(L);
  return 1;
}};
template <class T> struct thunk< Vector2<T> > {static int push(lua_State *L, const std::vector<float>& val)
{
  return thunk<T>::push(L, val[0])
   + thunk<T>::push(L, val[1]);
}};

// C<-->Lua thunker for a DEFCON function taking no arguments and returning type R
template <typename R, typename RValTraits<R>::RT (Funct::* F)(void)>
static int thunk_GetSimpleValue(lua_State *L)
{
  thunk<R>::push(L, (g_pDefconInterface->*F)());
  return 1;
}

// C<-->Lua thunker for a DEFCON function taking a single ID argument and returning type R
template <typename R, typename RValTraits<R>::RT (Funct::* F)(int)>
static int thunk_GetValueFromID(lua_State *L)
{
  thunk<R>::push(L, (g_pDefconInterface->*F)(lbot_checkID(L, 1)));
  return 1;
}

// C<-->Lua thunker for a DEFCON function taking a single ID argument and returning nothing
template <void (Funct::* F)(int)>
static int thunk_RequestUsingID(lua_State *L)
{
  (g_pDefconInterface->*F)(lbot_checkID(L, 1));
  return 0;
}

// C<-->Lua thunker for a DEFCON function taking two IDs argument and returning type R
template <typename R, typename RValTraits<R>::RT (Funct::* F)(int, int)>
static int thunk_GetValueDualID(lua_State *L)
{
  return thunk<R>::push(L, (g_pDefconInterface->*F)(
    lbot_checkID(L, 1),
    lbot_checkID(L, 2))
  );
}

// C<-->Lua thunker for a DEFCON function taking long and lat arguments and returning type R
template <typename R, typename RValTraits<R>::RT (Funct::* F)(float, float)>
static int thunk_GetValueLngLat(lua_State *L)
{
  return thunk<R>::push(L, (g_pDefconInterface->*F)(
    static_cast<float>(luaL_checknumber(L, 1)),
    static_cast<float>(luaL_checknumber(L, 2)))
  );
}

// C<-->Lua thunker for a DEFCON function taking 2 long/lat arguments and returning a float
template <float (Funct::* F)(float, float, float, float)>
static int thunk_GetMapDistance(lua_State *L)
{
  lbot_pushnumber(L, (g_pDefconInterface->*F)(
    static_cast<float>(luaL_checknumber(L, 1)),
    static_cast<float>(luaL_checknumber(L, 2)),
    static_cast<float>(luaL_checknumber(L, 3)),
    static_cast<float>(luaL_checknumber(L, 4)))
  );
  return 1;
}
