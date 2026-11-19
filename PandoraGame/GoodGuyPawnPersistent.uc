class GoodGuyPawnPersistent extends SoldierPawn
    config(Game);

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoAlly.eSPSquad_Allies SquadAssignment;

function bool CanClassStepAside()
{
    return true;
    //return ReturnValue;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Council;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.CouncilGD;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}
