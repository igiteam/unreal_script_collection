class WerewolfPawnPersistent extends SPBaseWerewolfPawnPersistent
    native
    config(Game);

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.static.GetTuneDataWerewolf();
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTuneWerewolf();
    //return ReturnValue;    
}
