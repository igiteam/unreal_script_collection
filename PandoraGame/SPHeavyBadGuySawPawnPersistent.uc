class SPHeavyBadGuySawPawnPersistent extends SoldierPawn
    config(Game);

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoBadGuy.eSPSquad_BadGuy SquadAssignment;

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].BlackOrder;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.BlackOrderHeavySawGD;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}
