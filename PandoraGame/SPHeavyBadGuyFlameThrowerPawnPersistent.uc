class SPHeavyBadGuyFlameThrowerPawnPersistent extends SoldierPawn
    native
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
    return Class'SPTuneManager'.default.Difficulty.BlackOrderHeavyFlameThrowerGD;
    //return ReturnValue;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}

simulated function float GetFlameThrowerAmmoConsumedPerSecond()
{
    return m_SoldierGDData.AmmoConsumedPerSecond;
    //return ReturnValue;    
}
