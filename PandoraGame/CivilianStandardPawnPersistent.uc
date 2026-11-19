class CivilianStandardPawnPersistent extends SoldierPawn
    native
    config(Game);

/** MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCivilian.eSPSquad_Civilian SquadAssignment;

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Civilian;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.CivilianGD;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}
