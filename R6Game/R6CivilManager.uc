class R6CivilManager extends R6TeamManager
    native
    notplaceable
    hidecategories(lighting);

const NBMAX_EMOTIONS = 3;

var float m_fCurentTime;

// Export UR6CivilManager::execInitCivilManager(FFrame&, void* const)
native final function InitCivilManager();

// Export UR6CivilManager::execRegisterCivil(FFrame&, void* const)
native final function bool RegisterCivil(R6Pawn Pawn);

// Export UR6CivilManager::execUnRegisterCivil(FFrame&, void* const)
native final function bool UnRegisterCivil(R6Pawn Pawn);

// Export UR6CivilManager::execFreeCiviliansInZone(FFrame&, void* const)
native final function FreeCiviliansInZone(int a_iCivilZoneID);

function PreBeginPlay()
{
    PreBeginPlay();
    m_fCurentTime = 0.0000000;
    return;
}

defaultproperties
{
    m_eTypeClass=Class'R6CivilPawn'
}