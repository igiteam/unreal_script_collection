class SPWeakWerewolfPawnPersistent extends WerewolfPawnPersistent
    native
    config(Game);

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.static.GetTuneDataWeakWerewolf();
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.static.GetGameDifficultyTuneWeakWerewolf();
    //return ReturnValue;    
}

simulated state Unconscious
{
    simulated function CleanUpUnconscious(bool bDying)
    {
        local PandoraGameInfo PGI;

        super.CleanUpUnconscious(bDying);
        // End:0x64
        if(!bDying)
        {
            PGI = PandoraGameInfo(WorldInfo.Game);
            // End:0x64
            if(PGI != none)
            {
                PGI.UnlockPDAMessage(2, "PDA_CRE_LIMOS_02");
            }
        }
        //return;        
    }
    stop;    
}
