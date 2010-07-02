#include "luabot.h"
#include "binding_templates.h"
#include "enums.h"
#include <algorithm>

Funct *g_pDefconInterface = NULL;

const char* lbot_enum_names[] = {
  "OnTick",
  "OnEvent",
  "",

  "PingSub",
  "PingCarrier",
  "NukeLaunchSilo",
  "NukeLaunchSub",
  "Hit",
  "Destroyed",
  "PingDetection",
  "CeasedFire",
  "UnceasedFire",
  "SharedRadar",
  "UnsharedRadar",
  "NewVote",
  "TeamVoted",
  "TeamRetractedVote",
  "VoteFinishedYes",
  "VoteFinishedNo",
  
  "Invalid",
  "City",
  "Silo",
  "RadarStation",
  "Nuke",
  "Explosion",
  "Sub",
  "BattleShip",
  "AirBase",
  "Fighter",
  "Bomber",
  "Carrier",
  "Tornado",
  "Saucer",
  "Fleet",
  "Gunshot",
  "QueueItem",

  "NorthAmerica",
  "SouthAmerica",
  "Europe",
  "Russia",
  "SouthAsia",
  "Africa",

  NULL
};

static int lbot_get_option_value(lua_State *L)
{
  lbot_pushnumber(L, g_pDefconInterface->GetOptionValue(const_cast<char*>(luaL_optstring(L, 1, ""))));
  return 1;
}

static const char * lbot_chat_channels[] = {
  "public",
  "alliance",
  "spectators",
  NULL,
};

static int lbot_send_chat(lua_State *L)
{
  size_t iStrLen;
  const char* sStr = luaL_checklstring(L, 1, &iStrLen);
  int iChannel = luaL_checkoption(L, 2, lbot_chat_channels[0], lbot_chat_channels) + CHATCHANNEL_PUBLIC;
  if(lua_toboolean(L, 3) != 0)
  {
    g_pDefconInterface->SendChatMessage(std::string(sStr, iStrLen), iChannel);
  }
  else
  {
    std::string sMsg(sStr, iStrLen);
    std::replace(sMsg.begin(), sMsg.end(), '\t', ' ');

    std::string::iterator itrBegin, itrNewline, itrEnd;
    itrBegin = sMsg.begin();
    itrEnd = sMsg.end();
    while(1)
    {
      itrNewline = std::find(itrBegin, itrEnd, '\n');
      g_pDefconInterface->SendChatMessage(std::string(itrBegin, itrNewline), iChannel);
      if(itrNewline == itrEnd)
        break;
      else
        itrBegin = itrNewline, ++itrBegin;
    }
  }
  return 0;
}

template <bool BTestSea>
static int lbot_is_sea(lua_State *L)
{
  float fLng = static_cast<float>(luaL_checknumber(L, 1));
  float fLat = static_cast<float>(luaL_checknumber(L, 2));
  lua_pushboolean(L, g_pDefconInterface->IsValidTerritory(-1, fLng, fLat, BTestSea) ? 1 : 0);
  return 1;
}

static int lbot_is_valid_territory(lua_State *L)
{
  int iTeamID = lbot_checkID(L, 1);
  float fLng = static_cast<float>(luaL_checknumber(L, 2));
  float fLat = static_cast<float>(luaL_checknumber(L, 3));
  bool bSea = lua_toboolean(L, 4) != 0;
  lua_pushboolean(L, g_pDefconInterface->IsValidTerritory(iTeamID, fLng, fLat, bSea) ? 1 : 0);
  return 1;
}

static int lbot_request_game_speed(lua_State *L)
{
  g_pDefconInterface->RequestGameSpeed(luaL_checkint(L, 1));
  return 0;
}

int lbot_optTypeName(lua_State *L, int idx, int def)
{
  if(lua_isnoneornil(L, idx))
    return def;
  luaL_checkstring(L, idx);
  lua_rawget(L, LUA_ENVIRONINDEX);
  if(lua_isnil(L, -1))
  {
    return luaL_argerror(L, idx, "Expected type name");
  }
  lua_replace(L, idx);
  return static_cast<int>(lua_tointeger(L, idx));
}

int lbot_checkTypeName(lua_State *L, int idx)
{
  const char *sStr = luaL_checkstring(L, idx);
  lua_pushvalue(L, idx);
  lua_rawget(L, LUA_ENVIRONINDEX);
  if(lua_isnil(L, -1))
  {
    sStr = lua_pushfstring(L, "Expected type name, got \"%s\"", sStr);
    return luaL_argerror(L, idx, sStr);
  }
  lua_replace(L, idx);
  return static_cast<int>(lua_tointeger(L, idx));
}

static int lbot_is_valid_placement_location(lua_State *L)
{
  float fLng = static_cast<float>(luaL_checknumber(L, 1));
  float fLat = static_cast<float>(luaL_checknumber(L, 2));
  int iTypeID = lbot_checkTypeName(L, 3);
  lua_pushboolean(L, g_pDefconInterface->IsValidPlacementLocation(fLng, fLat, iTypeID) ? 1 : 0);
  return 1;
}

static int lbot_get_remaining_units(lua_State *L)
{
  int iTypeID = lbot_checkTypeName(L, 1);
  lua_pushinteger(L, static_cast<lua_Integer>(g_pDefconInterface->GetRemainingUnits(iTypeID)));
  return 1;
}

static int lbot_place_structure(lua_State *L)
{
  float fLng = static_cast<float>(luaL_checknumber(L, 1));
  float fLat = static_cast<float>(luaL_checknumber(L, 2));
  int iTypeID = lbot_checkTypeName(L, 3);
  g_pDefconInterface->PlaceStructure(iTypeID, fLng, fLat);
  return 0;
}

static int lbot_place_fleet(lua_State *L)
{
  float fLng = static_cast<float>(luaL_checknumber(L, 1));
  float fLat = static_cast<float>(luaL_checknumber(L, 2));
  g_pDefconInterface->PlaceFleet(fLng, fLat, lbot_checkTypeName(L, 3), lbot_optTypeName(L, 4, -1),
    lbot_optTypeName(L, 5, -1), lbot_optTypeName(L, 6, -1), lbot_optTypeName(L, 7, -1), lbot_optTypeName(L, 8, -1));
  return 0;
}

static int lbot_get_unit_value(lua_State *L)
{
  lua_pushinteger(L, static_cast<lua_Integer>(g_pDefconInterface->GetUnitValue(lbot_checkTypeName(L, 1))));
  return 1;
}

static int lbot_whiteboard_draw(lua_State *L)
{
  g_pDefconInterface->WhiteboardDraw(static_cast<float>(luaL_checknumber(L, 1)), static_cast<float>(luaL_checknumber(L, 2)),
    static_cast<float>(luaL_checknumber(L, 3)), static_cast<float>(luaL_checknumber(L, 4)));
  return 0;
}

static int lbot_whiteboard_clear(lua_State *L)
{
  g_pDefconInterface->WhiteboardClear();
  return 0;
}

static int lbot_get_state_count(lua_State *L)
{
  lua_pushinteger(L, static_cast<lua_Integer>(g_pDefconInterface->GetStateCount(lbot_checkID(L, 1), luaL_checkint(L, 2))));
  return 1;
}

static int lbot_set_state(lua_State *L)
{
  lua_pushinteger(L, static_cast<lua_Integer>(g_pDefconInterface->SetState(lbot_checkID(L, 1), luaL_checkint(L, 2))));
  return 1;
}

static int lbot_set_movement_target(lua_State *L)
{
  g_pDefconInterface->SetMovementTarget(lbot_checkID(L, 1), static_cast<float>(luaL_checknumber(L, 2)), static_cast<float>(luaL_checknumber(L, 3)));
  return 0;
}

static int lbot_set_action_target(lua_State *L)
{
  g_pDefconInterface->SetActionTarget(lbot_checkID(L, 1), lbot_optID(L, 2, -1),
    static_cast<float>(luaL_optnumber(L, 3, 0.0)), static_cast<float>(luaL_optnumber(L, 4, 0.0)));
  return 0;
}

static int lbot_set_landing_target(lua_State *L)
{
  g_pDefconInterface->SetLandingTarget(lbot_checkID(L, 1), lbot_checkID(L, 2));
  return 0;
}

static int lbot_get_fleet_member_offset(lua_State *L)
{
  return thunk<Vector2<float> >::push(L, g_pDefconInterface->GetFleetMemberOffset(luaL_checkint(L, 1), luaL_checkint(L, 2) - 1));
}

static int lbot_send_vote(lua_State *L)
{
  g_pDefconInterface->SendVote(lbot_checkID(L, 1), lua_toboolean(L, 2));
  return 0;
}

static int lbot_debug_log(lua_State *L)
{
  size_t iMsgLength;
  const char* sMsg = luaL_checklstring(L, 1, &iMsgLength);
  g_pDefconInterface->DebugLog(std::string(sMsg, iMsgLength), lbot_optID(L, 2, -1), luaL_optstring(L, 3, ""), static_cast<unsigned char>(luaL_optint(L, 4, 255)),
    static_cast<unsigned char>(luaL_optint(L, 5, 255)), static_cast<unsigned char>(luaL_optint(L, 6, 255)), static_cast<unsigned char>(luaL_optint(L, 7, 255)));
  return 0;
}

static int lbot_get_all_unit_data(lua_State *L)
{
  std::vector<Funct::UnitData*> vData(g_pDefconInterface->GetAllUnitData());
  size_t iSize = vData.size();
  switch(lua_type(L, 1))
  {
  case LUA_TNIL:
    lua_settop(L, 0);
    // no break

  case LUA_TNONE:
    lua_createtable(L, 0, static_cast<int>(iSize));
    break;

  case LUA_TTABLE:
    lua_settop(L, 1);
    break;

  default:
    luaL_checktype(L, 1, LUA_TTABLE); // never returns
  }
  lua_Number fTime = static_cast<lua_Number>(g_pDefconInterface->GetGameTime());
  for(size_t i = 0; i < iSize; ++i)
  {
    Funct::UnitData *pData = vData[i];
    void *pKey = reinterpret_cast<void*>(pData->m_objectId);
    lua_pushlightuserdata(L, pKey);
    lua_rawget(L, 1);
    if(lua_type(L, 2) != LUA_TTABLE)
    {
      lua_settop(L, 1);
      lua_createtable(L, 0, 8);
      lua_pushlightuserdata(L, pKey);
      lua_pushvalue(L, 2);
      lua_rawset(L, 1);
    }
    lua_pushvalue(L, lua_upvalueindex(1)); lua_pushnumber(L, fTime); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(2)); lua_rawgeti(L, LUA_ENVIRONINDEX, TYPE_ENUM_NAMES + pData->m_type); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(3)); lbot_pushint(L, pData->m_teamId); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(4)); lua_pushinteger(L, static_cast<lua_Integer>(pData->m_currentState)); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(5)); lua_pushboolean(L, pData->m_visible ? 1 : 0); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(6)); lua_pushnumber(L, static_cast<lua_Number>(pData->m_longitude)); lua_rawset(L, 2);
    lua_pushvalue(L, lua_upvalueindex(7)); lua_pushnumber(L, static_cast<lua_Number>(pData->m_latitude)); lua_rawset(L, 2);
    lua_settop(L, 1);
  }
  return 1;
}

static int lbot_get_command_line_arguments(lua_State *L)
{
  if(lua_isnoneornil(L, 1))
  {
    lua_pushvalue(L, lua_upvalueindex(1));
  }
  else
  {
    lua_settop(L, 1);
    lua_pushvalue(L, lua_upvalueindex(1));
    lua_insert(L, 1);
    lua_rawget(L, 1);
  }
  return 1;
}

const luaL_Reg lbot_global_functions[] = {
  {"GetDefconLevel",            thunk_GetSimpleValue<int, &Funct::GetDefcon>},
  {"GetGameTime",               thunk_GetSimpleValue<float, &Funct::GetGameTime>},
  {"GetGameTick",               thunk_GetSimpleValue<int, &Funct::GetGameTick>},
  {"GetGameSpeed",              thunk_GetSimpleValue<int, &Funct::GetGameSpeed>},
  {"GetVictoryTimer",           thunk_GetSimpleValue<float, &Funct::GetVictoryTimer>},
  {"IsVictoryTimerActive",      thunk_GetSimpleValue<bool, &Funct::IsVictoryTimerActive>},
  {"GetOptionValue",            lbot_get_option_value},
  {"GetCityIDs",                thunk_GetSimpleValue<std::vector<void*>, &Funct::GetCityIds>},
  {"GetCityPopulation",         thunk_GetValueFromID<int, &Funct::GetCityPopulation>},
  {"GetRemainingPopulation",    thunk_GetValueFromID<int, &Funct::GetRemainingPopulation>},
  {"IsLand",                    lbot_is_sea<false>},
  {"IsSea",                     lbot_is_sea<true>},
  {"IsValidTerritory",          lbot_is_valid_territory},
  {"IsBorder",                  thunk_GetValueLngLat<bool, &Funct::IsBorder>},
  {"GetTerritoryName",          thunk_GetValueLngLat<EnvEnum<TERRITORY_ENUM_NAMES>, &Funct::GetTerritoryId>},
  {"GetOwnTeamID",              thunk_GetSimpleValue<void*, &Funct::GetOwnTeamId>},
  {"GetAllTeamIDs",             thunk_GetSimpleValue<std::vector<void*>, &Funct::GetTeamIds>},
  {"GetTeamTerritories",        thunk_GetValueFromID<std::vector<EnvEnum<TERRITORY_ENUM_NAMES> >, &Funct::GetTeamTerritories>},
  {"GetAllianceID",             thunk_GetValueFromID<void*, &Funct::GetAllianceId>},
  {"GetDesiredGameSpeed",       thunk_GetValueFromID<int, &Funct::GetDesiredGameSpeed>},
  {"GetEnemyKills",             thunk_GetValueFromID<int, &Funct::GetEnemyKills>},
  {"GetFriendlyDeaths",         thunk_GetValueFromID<int, &Funct::GetFriendlyDeaths>},
  {"GetCollateralDamage",       thunk_GetValueFromID<int, &Funct::GetCollateralDamage>},
  {"GetTeamName",               thunk_GetValueFromID<char*, &Funct::GetTeamName>},
  {"IsSharingRadar",            thunk_GetValueDualID<bool, &Funct::IsSharingRadar>},
  {"IsCeaseFire",               thunk_GetValueDualID<bool, &Funct::IsCeaseFire>},
  {"RequestAlliance",           thunk_RequestUsingID<&Funct::RequestAlliance>},
  {"RequestCeaseFire",          thunk_RequestUsingID<&Funct::RequestCeaseFire>},
  {"RequestShareRadar",         thunk_RequestUsingID<&Funct::RequestShareRadar>},
  {"RequestGameSpeed",          lbot_request_game_speed},
  {"GetOwnUnits",               thunk_GetSimpleValue<std::vector<void*>, &Funct::GetOwnUnits>},
  {"GetAllUnits",               thunk_GetSimpleValue<std::vector<void*>, &Funct::GetAllUnits>},
  {"GetTeamUnits",              thunk_GetValueFromID<std::vector<void*>, &Funct::GetTeamUnits>},
/*{"GetAllUnitData",            lbot_get_all_unit_data}, */ // requires upvalues
/*{"GetCommandLineArguments",   lbot_get_command_line_arguments}, */ // requires upvalue
  {"GetUnitType",               thunk_GetValueFromID<EnvEnum<TYPE_ENUM_NAMES>, &Funct::GetType>},
  {"GetEventType",              thunk_GetValueFromID<EnvEnum<EVENT_ENUM_NAMES>, &Funct::GetType>},
  {"GetTeamID",                 thunk_GetValueFromID<void*, &Funct::GetTeamId>},
  {"GetOwnFleets",              thunk_GetSimpleValue<std::vector<void*>, &Funct::GetOwnFleets>},
  {"GetTeamFleets",             thunk_GetValueFromID<std::vector<void*>, &Funct::GetFleets>},
  {"GetFleetUnits",             thunk_GetValueFromID<std::vector<void*>, &Funct::GetFleetMembers>},
  {"GetFleetID",                thunk_GetValueFromID<void*, &Funct::GetFleetId>},
  {"GetCurrentState",           thunk_GetValueFromID<int, &Funct::GetCurrentState>},
  {"GetStateCount",             lbot_get_state_count},
  {"GetActionQueue",            thunk_GetValueFromID<std::vector<void*>, &Funct::GetActionQueue>},
  {"GetStateTimer",             thunk_GetValueFromID<float, &Funct::GetStateTimer>},
  {"GetCurrentTargetID",        thunk_GetValueFromID<void*, &Funct::GetCurrentTargetId>},
  {"GetMovementTargetLocation", thunk_GetValueFromID<Vector2<float>, &Funct::GetMovementTargetLocation>},
  {"GetNukeCount",              thunk_GetValueFromID<int, &Funct::GetNukeSupply>},
  {"GetBomberNukeTarget",       thunk_GetValueFromID<Vector2<float>, &Funct::GetBomberNukeTarget>},
  {"IsRetaliating",             thunk_GetValueFromID<bool, &Funct::IsRetaliating>},
  {"IsVisible",                 thunk_GetValueDualID<bool, &Funct::IsVisible>},
  {"SetState",                  lbot_set_state},
  {"SetMovementTarget",         lbot_set_movement_target},
  {"SetActionTarget",           lbot_set_action_target},
  {"SetLandingTarget",          lbot_set_landing_target},
  {"GetLongitude",              thunk_GetValueFromID<float, &Funct::GetLongitude>},
  {"GetLatitude",               thunk_GetValueFromID<float, &Funct::GetLatitude>},
  {"GetVelocity",               thunk_GetValueFromID<Vector2<float>, &Funct::GetVelocity>},
  {"GetRange",                  thunk_GetValueFromID<float, &Funct::GetRange>},
  {"GetRemainingUnits",         lbot_get_remaining_units},
  {"IsValidPlacementLocation",  lbot_is_valid_placement_location},
  {"GetFleetMemberOffset",      lbot_get_fleet_member_offset},
  {"PlaceStructure",            lbot_place_structure},
  {"PlaceFleet",                lbot_place_fleet},
  {"GetUnitCreditsRemaining",   thunk_GetSimpleValue<int, &Funct::GetUnitCredits>},
  {"GetTypeCreditCost",         lbot_get_unit_value},
  {"SendVote",                  lbot_send_vote},
  {"SendChat",                  lbot_send_chat},
  {"GetDistance",               thunk_GetMapDistance<&Funct::GetDistance>},
  {"GetSailDistance",           thunk_GetMapDistance<&Funct::GetSailDistance>},
  {"DebugLog",                  lbot_debug_log},
  {"DebugIsReplayingGame",      thunk_GetSimpleValue<bool, &Funct::DebugIsReplayingGame>},
  {"WhiteboardDraw",            lbot_whiteboard_draw},
  {"WhiteboardClear",           lbot_whiteboard_clear},
  {"GetSuccessfulCommands",     thunk_GetSimpleValue<std::vector<void*>, &Funct::GetSuccessfulCommands>},
  {NULL, NULL}
};

static int lbot_index__tostring(lua_State *L)
{
  lua_pushfstring(L, "<%d>", lbot_checkID(L, 1));
  return 1;
}

static int lbot_openlibs_actual(lua_State *L)
{
  std::vector< std::vector<std::string> > *pvvCommandLineArguments = reinterpret_cast<std::vector< std::vector<std::string> >*>(lua_touserdata(L, 1));

  lua_createtable(L, 64, NumObjectTypes);
  for(int i = 0; lbot_enum_names[i]; )
  {
    lua_pushstring(L, lbot_enum_names[i]);
    lua_rawseti(L, -2, ++i);
  }
  for(int i = 0; i < NumObjectTypes; ++i)
  {
    lua_rawgeti(L, -1, TYPE_ENUM_NAMES + i);
    lua_pushinteger(L, static_cast<lua_Integer>(i));
    lua_rawset(L, -3);
  }
  lua_replace(L, LUA_ENVIRONINDEX);
  lua_pushvalue(L, LUA_GLOBALSINDEX);
  luaL_register(L, NULL, lbot_global_functions);
  lua_pushliteral(L, "time");
  lua_pushliteral(L, "type");
  lua_pushliteral(L, "team");
  lua_pushliteral(L, "state");
  lua_pushliteral(L, "visible");
  lua_pushliteral(L, "longitude");
  lua_pushliteral(L, "latitude");
  lua_pushcclosure(L, lbot_get_all_unit_data, 7);
  lua_setglobal(L, "GetAllUnitData");

  {
    size_t iNumCmdArgs = pvvCommandLineArguments->size();
    lua_createtable(L, static_cast<int>(iNumCmdArgs), static_cast<int>(iNumCmdArgs));
    for(size_t iArg = 0; iArg < iNumCmdArgs; ++iArg)
    {
      const std::string& sKey   = pvvCommandLineArguments->at(iArg)[0];
      const std::string& sValue = pvvCommandLineArguments->at(iArg)[1];

      lbot_pushstdstring(L, sKey);
      lbot_pushstdstring(L, sValue);
      lua_createtable(L, 2, 0);
      lua_pushvalue(L, -3);
      lua_rawseti(L, -2, 1);
      lua_pushvalue(L, -2);
      lua_rawseti(L, -2, 2);
      lua_rawseti(L, -4, static_cast<int>(iArg) + 1);
      lua_rawset(L, -3);
    }
    lua_pushcclosure(L, lbot_get_command_line_arguments, 1);
    lua_setglobal(L, "GetCommandLineArguments");
  }


  lbot_pushint(L, 0);
  lua_createtable(L, 0, 2);
  lua_pushvalue(L, LUA_GLOBALSINDEX);
  lua_setfield(L, -2, "__index");
  lua_pushcfunction(L, lbot_index__tostring);
  lua_setfield(L, -2, "__tostring");
  lua_setmetatable(L, -2);

  return 0;
}

void lbot_openlibs(lua_State *L, Funct* pDefconInterface, std::vector< std::vector<std::string> > &vvCommandLineOptions)
{
  g_pDefconInterface = pDefconInterface;
  lua_cpcall(L, lbot_openlibs_actual, reinterpret_cast<void*>(&vvCommandLineOptions));
}

static void lbot_report(lua_State *L, int iStatus, const char* sContext)
{
  const char *type = "unknown";
  switch(iStatus)
  {
  case LUA_ERRFILE:
    type = "file"; break;
  case LUA_ERRERR:
    type = "error-handling"; break;
  case LUA_ERRMEM:
    type = "memory"; break;
  case LUA_ERRRUN:
    type = "runtime"; break;
  case LUA_ERRSYNTAX:
    type = "syntax"; break;
  };
  const char *msg = lua_tostring(L, -1);
  if(msg == NULL)
    msg = "(error object is not a string)";
  lua_pushfstring(L, "Lua %s error in %s:\n%s", type, sContext, msg);
  std::string s(lua_tostring(L, -1));
  std::replace(s.begin(), s.end(), '\t', ' ');
  std::string::iterator itrBegin, itrNewline, itrEnd;
  itrBegin = s.begin();
  itrEnd = s.end();
  while(1)
  {
    itrNewline = std::find(itrBegin, itrEnd, '\n');
    g_pDefconInterface->SendChatMessage(std::string(itrBegin, itrNewline), CHATCHANNEL_ALLIANCE);
    if(itrNewline == itrEnd)
      break;
    else
      itrBegin = itrNewline, ++itrBegin;
  }
  lua_pop(L, 2);
}

void lbot_loadfile(lua_State *L, const char* sFilename)
{
  int iStatus = luaL_loadfile(L, sFilename);
  if(iStatus != 0)
  {
    lbot_report(L, iStatus, "load file");
  }
}

void lbot_pcall(lua_State *L, int nArgs, int nRes, const char* sContext)
{
  int iStatus = lua_pcall(L, nArgs, nRes, FUNCTION_NAMES + 2);
  if(iStatus != 0)
  {
    lbot_report(L, iStatus, sContext);
  }
}

static int lbot_error_handler_add_context(lua_State *L)
{
  if (!lua_isstring(L, 1))  /* 'message' not a string? */
  {
    lua_getfield(L, LUA_GLOBALSINDEX, "tostring");
    if (!lua_isfunction(L, -1))
    {
      lua_pop(L, 1);
      return 1;
    }
    lua_pushvalue(L, 1);
    lua_call(L, 1, 1);
    lua_replace(L, 1);
  }
  lua_getfield(L, LUA_GLOBALSINDEX, "debug");
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
    return 1;
  }
  lua_getfield(L, -1, "traceback");
  if (!lua_isfunction(L, -1)) {
    lua_pop(L, 2);
    return 1;
  }
  lua_pushvalue(L, 1);  /* pass error message */
  lua_pushinteger(L, 2);  /* skip this function and traceback */
  lua_call(L, 2, 1);  /* call debug.traceback */
  return 1;
}

void lbot_pusherrorhandler(lua_State *L)
{
  lua_pushcfunction(L, lbot_error_handler_add_context);
}

int lbot_checkID(lua_State *L, int idx)
{
  luaL_checktype(L, idx, LUA_TLIGHTUSERDATA);
  return reinterpret_cast<int>(lua_touserdata(L, idx));
}

int lbot_optID(lua_State *L, int idx, int def)
{
  if(lua_isnoneornil(L, idx))
    return def;
  luaL_checktype(L, idx, LUA_TLIGHTUSERDATA);
  return reinterpret_cast<int>(lua_touserdata(L, idx));
}

void lbot_pushstdstring(lua_State *L, const std::string& s)
{
  lua_pushlstring(L, s.c_str(), s.length());
}
