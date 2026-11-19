class R6HostageManager extends R6TeamManager
    native
    notplaceable
    hidecategories(lighting);

var array<R6Pawn> m_arrHostagePawn;
var int m_iNumHostages;

// Export UR6HostageManager::execInitHostageManager(FFrame&, void* const)
native final function InitHostageManager();

// Export UR6HostageManager::execRegisterHostage(FFrame&, void* const)
native final function bool RegisterHostage(R6Pawn Pawn);

// Export UR6HostageManager::execUnRegisterHostage(FFrame&, void* const)
native final function bool UnRegisterHostage(R6Pawn Pawn);

// Export UR6HostageManager::execFreeHostagesInZone(FFrame&, void* const)
native final function FreeHostagesInZone(int a_iZoneID);

// Export UR6HostageManager::execChangeTacticFor(FFrame&, void* const)
native final function ChangeTacticFor(R6HostagePawn pHostage, Actor.ETacticType eNewTactic, R6Pawn pLeader, optional bool bSwitchOnPlayerCommand);

// Export UR6HostageManager::execGetCurrentTacticFor(FFrame&, void* const)
native final function Actor.ETacticType GetCurrentTacticFor(R6HostagePawn pHostage);

// Export UR6HostageManager::execGetCurrentTacticLeaderFor(FFrame&, void* const)
native final function R6Pawn GetCurrentTacticLeaderFor(R6HostagePawn pHostage);

defaultproperties
{
    m_eTypeClass=Class'R6HostagePawn'
}