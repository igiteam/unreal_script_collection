class AnimusHealthPack extends SPLifeForceHolder
    placeable;

simulated function PostBeginPlay()
{
    m_GameplayGDTuneData = Class'SPTuneManager'.default.Difficulty.GameplayGD;
    LifeForceAmount = m_GameplayGDTuneData.GetValue(m_GameplayGDTuneData.AnimusPackHealth);
    super.PostBeginPlay();
    //return;    
}

simulated state Activated
{
    function float GiveLifeForce(float DeltaTime)
    {
        local float lifeForceGiven;
        local PandoraGameInfo theGameInfo;
        local SPPointEventAnimusCollectedPlayer collected;

        lifeForceGiven = super(SPLifeForceHolder).GiveLifeForce(DeltaTime);
        collected = Class'SPPointEventAnimusCollectedPlayer'.static.CreateSPPointEventAnimusCollectedPlayer(GetTargetPawn().Controller, lifeForceGiven);
        // End:0x8E
        if(collected != none)
        {
            theGameInfo = PandoraGameInfo(GetWorldInfo().Game);
            // End:0x8E
            if(theGameInfo != none)
            {
                theGameInfo.RegisterPointEvent(collected);
            }
        }
        return lifeForceGiven;
        //return ReturnValue;        
    }
    stop;    
}
