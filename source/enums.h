#pragma once

const int STATE_AIRBASEFIGHTERLAUNCH = 0;
const int STATE_AIRBASEBOMBERLAUNCH = 1;

const int STATE_BATTLESHIPATTACK = 0;

const int STATE_BOMBERATTACK = 0;    
const int STATE_BOMBERNUKE = 1;      
const int STATE_BOMBERINQUEUE = 2;   

const int STATE_CARRIERFIGHTERLAUNCH = 0;
const int STATE_CARRIERBOMBERLAUNCH = 1;
const int STATE_CARRIERANTISUB = 2;  

const int STATE_FIGHTERATTACK = 0;   
const int STATE_FIGHTERINQUEUE = 2;    //2 instead of 1 makes handling easier when looking for STATE_s of items in queues

const int STATE_NUKEONTARGET = 0;    
const int STATE_NUKEDISARM = 1;      

const int STATE_RADARACTIVE = 0;     

const int STATE_SILONUKE = 0;        
const int STATE_SILOAIRDEFENSE = 1;  

const int STATE_SUBPASSIVESONAR = 0; 
const int STATE_SUBACTIVESONAR = 1;  
const int STATE_SUBNUKE = 2;         

const int CHATCHANNEL_PUBLIC      = 100;
const int CHATCHANNEL_ALLIANCE    = 101;
const int CHATCHANNEL_SPECTATORS  = 102;



enum
{
    TerritoryNorthAmerica,
    TerritorySouthAmerica,
    TerritoryEurope,
    TerritoryRussia,
    TerritorySouthAsia,
    TerritoryAfrica,
    NumTerritories
};

enum
{
    EventPingSub = 0,
    EventPingCarrier,
    EventNukeLaunchSilo,
    EventNukeLaunchSub,
    EventHit,
    EventDestroyed,
    EventPingDetection,
    EventCeasedFire,
    EventUnceasedFire,
    EventSharedRadar,
    EventUnsharedRadar,
    EventNewVote,
    EventTeamVoted,
    EventTeamRetractedVote,
    EventVoteFinishedYes,
    EventVoteFinishedNo
};

enum
{
    TypeInvalid,
    TypeCity,
    TypeSilo,
    TypeRadarStation,        
    TypeNuke,
    TypeExplosion,
    TypeSub,
    TypeBattleShip,
    TypeAirBase,
    TypeFighter,
    TypeBomber,
    TypeCarrier,
    TypeTornado,
    TypeSaucer,
    TypeFleet, 
    TypeGunshot,
    TypeQueueItem,
    NumObjectTypes
};

enum
{
    VoteTypeInvalid,
    VoteTypeJoinAlliance,
    VoteTypeKickPlayer,
    VoteTypeLeaveAlliance
};

enum
{
    VoteUnknown,
    VoteYes,
    VoteNo,
    VoteAbstain
};
