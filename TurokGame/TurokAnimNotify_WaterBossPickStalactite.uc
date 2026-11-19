class TurokAnimNotify_WaterBossPickStalactite extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var @NULL pickSoundCue;

simulated event PlaySound(@NULL Owner, @NULL SkelComponent)
{
    local @NULL waterBoss;

    // End:0x55
    if(pickSoundCue != none)
    {
        // End:0x52
        if(TurokPawnBossWaterNative(Owner) != none)
        {
            waterBoss = TurokPawnBossWaterNative(Owner);
            waterBoss.mSoundController.TryPlayLocalSound(pickSoundCue);            
        }        
    }
    //return;    
}

defaultproperties
{
    pickSoundCue=SoundCue'SndCreatureDinosaurWaterBossNew.WaterBossRockBreakSndCue'
}