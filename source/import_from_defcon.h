// import_from_defcon.h
// Contains the imported functions from DEFCON

#pragma once

#include <vector>
#include <string>

#define INTERFACE_VERSION 1                 // Indicates the version of the interface.

class Funct {
public:
    struct UnitData;
    virtual int GetDefcon() = 0;
    virtual float GetGameTime() = 0;
    virtual int GetGameTick() = 0;
    virtual int GetGameSpeed() = 0;
    virtual float GetVictoryTimer() = 0;
    virtual bool IsVictoryTimerActive() = 0;
    virtual int GetOptionValue( char* name ) = 0;
    virtual std::vector<int> GetCityIds() = 0;
    virtual int GetCityPopulation( int cityId ) = 0;
    virtual int GetRemainingPopulation( int teamId ) = 0;
    virtual bool IsValidTerritory( int teamId, float longitude, float latitude, bool seaArea ) = 0;
    virtual bool IsBorder( float longitude, float latitude ) = 0;
    virtual int GetTerritoryId( float longitude, float latitude ) = 0;
    virtual int GetOwnTeamId() = 0;
    virtual std::vector<int> GetTeamIds() = 0;
    virtual std::vector<int> GetTeamTerritories( int teamId ) = 0;  
    virtual int GetAllianceId( int teamId ) = 0;
    virtual int GetDesiredGameSpeed( int teamId ) = 0;
    virtual int GetEnemyKills( int teamId ) = 0;
    virtual int GetFriendlyDeaths( int teamId ) = 0;
    virtual int GetCollateralDamage( int teamId ) = 0;
    virtual char* GetTeamName( int teamId ) = 0;
    virtual bool IsSharingRadar( int teamId1, int teamId2 ) = 0;
    virtual bool IsCeaseFire( int teamId1, int teamId2 ) = 0;
    //virtual void setTeamName( char* String ) = 0;
    virtual void RequestAlliance( int allianceId ) = 0;
    virtual void RequestCeaseFire( int teamId ) = 0;
    virtual void RequestShareRadar( int teamId ) = 0;
    virtual void RequestGameSpeed( int requestedSpeedIdentifier ) = 0;
    virtual std::vector<int> GetAllUnits() = 0;
    virtual std::vector<int> GetOwnUnits() = 0;
    virtual std::vector<int> GetTeamUnits( int teamId ) = 0;
    virtual std::vector<UnitData*> GetAllUnitData() = 0;
    virtual int GetType( int id ) = 0;
    virtual int GetTeamId( int id ) = 0;
    virtual std::vector<int> GetOwnFleets() = 0;
    virtual std::vector<int> GetFleets( int teamId ) = 0;
    virtual std::vector<int> GetFleetMembers( int _fleetId ) = 0;
    virtual int GetFleetId( int unitId ) = 0;
    virtual int GetCurrentState( int unitId ) = 0;
    //virtual int getCurrentStateCount( int unitId ) = 0;
    virtual int GetStateCount( int unitId, int stateId ) = 0;
    virtual std::vector<int> GetActionQueue( int unitId ) = 0;
    virtual float GetStateTimer( int unitId ) = 0;
    virtual int GetCurrentTargetId( int unitId ) = 0;
    virtual std::vector<float> GetMovementTargetLocation( int unitId ) = 0;
    virtual int GetNukeSupply( int _unitId ) = 0;
    virtual std::vector<float> GetBomberNukeTarget( int _unitId ) = 0;
    virtual bool IsRetaliating( int _unitId ) = 0;
    virtual bool IsVisible( int _unitId, int _byTeamId ) = 0;
    virtual int SetState( int unitId, int stateId ) = 0;
    virtual void SetMovementTarget( int unitId, float longitude, float latitude ) = 0;
    virtual void SetActionTarget( int _unitId, int _targetUnitId, float _longitude, float _latitude ) = 0;
    virtual void SetLandingTarget( int _unitId, int _targetUnitId ) = 0;
    virtual float GetLongitude( int id ) = 0;
    virtual float GetLatitude( int id ) = 0;
    virtual std::vector<float> GetVelocity( int unitId ) = 0;
    virtual float GetRange( int unitId ) = 0;
    virtual int GetRemainingUnits( int typeId ) = 0;
    virtual bool IsValidPlacementLocation( float longitude, float latitude, int typeId ) = 0;
    virtual std::vector<float> GetFleetMemberOffset( int memberCount, int memberId ) = 0;
    virtual void PlaceStructure( int typeId, float longitude, float latitude ) = 0;
    virtual void PlaceFleet( float longitude, float latitude, int typeShip1, int typeShip2 = -1, int typeShip3 = -1, int typeShip4 = -1, int typeShip5 = -1, int typeShip6 = -1 ) = 0;
    virtual int GetUnitCredits() = 0;
    virtual int GetUnitValue( int _typeId ) = 0;
    virtual void SendVote( int _voteId, int _vote ) = 0;
    virtual void SendChatMessage( std::string chatMessage, int receiverId ) = 0;
    virtual float GetDistance( float longitude1, float latitude1, float longitude2, float latitude2 ) = 0;
    virtual float GetSailDistance( float longitude1, float latitude1, float longitude2, float latitude2 ) = 0;
    virtual void DebugLog(std::string entry, int objectId = -1, std::string tags = "", 
    unsigned char colorR = 255, unsigned char colorG = 255, unsigned char colorB = 255, unsigned char colorAlpha = 255) = 0;
    virtual bool DebugIsReplayingGame() = 0;
    virtual void WhiteboardDraw(float longitude1, float latitude1, float longitude2, float latitude2) = 0;
    virtual void WhiteboardClear() = 0;
    virtual std::vector<int> GetSuccessfulCommands() = 0;

    virtual ~Funct() = 0;

    struct UnitData
    {
        int m_objectId;
        int m_type;
        int m_teamId;
        int m_currentState;
        bool m_visible;
        float m_longitude;
        float m_latitude;
    };

};

inline Funct::~Funct() { } 

