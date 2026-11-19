class R6PresenceMgr extends Object
    native;

var int m_iLastPresence[4];

// Export UR6PresenceMgr::execUpdatePresenceController(FFrame&, void* const)
native function UpdatePresenceController(PlayerController pController);

// Export UR6PresenceMgr::execUpdatePresencePlayerID(FFrame&, void* const)
native function UpdatePresencePlayerID(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceCreateChar(FFrame&, void* const)
native function PushPresenceCreateChar(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceFaceScan(FFrame&, void* const)
native function PushPresenceFaceScan(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceTrophy(FFrame&, void* const)
native function PushPresenceTrophy(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceOutfitting(FFrame&, void* const)
native function PushPresenceOutfitting(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceFindMatch(FFrame&, void* const)
native function PushPresenceFindMatch(int iPlayerID);

// Export UR6PresenceMgr::execPushPresenceCreateMatch(FFrame&, void* const)
native function PushPresenceCreateMatch(int iPlayerID);

// Export UR6PresenceMgr::execSetPresencePlayerID(FFrame&, void* const)
native function SetPresencePlayerID(int iPresence, int iPlayerID);

// Export UR6PresenceMgr::execSetPresenceControllerID(FFrame&, void* const)
native function SetPresenceControllerID(int iPresence, int iControllerId);

// Export UR6PresenceMgr::execUpdatePresenceAll(FFrame&, void* const)
native function UpdatePresenceAll();

// Export UR6PresenceMgr::execUpdateMapName(FFrame&, void* const)
native function UpdateMapName();

// Export UR6PresenceMgr::execUpdateGameMode(FFrame&, void* const)
native function UpdateGameMode();

// Export UR6PresenceMgr::execPopPresence(FFrame&, void* const)
native function PopPresence(int iPlayerID);

defaultproperties
{
    m_iLastPresence[0]=-1
    m_iLastPresence[1]=-1
    m_iLastPresence[2]=-1
    m_iLastPresence[3]=-1
}