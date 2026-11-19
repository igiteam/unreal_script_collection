class TurokDuckerVolume extends Volume
    nativereplication
    hidecategories(Navigation,Object,Movement,Display);

var(Sound) name mDuckerName;
var(Sound) float mFadeTime;
var(Sound) array mDuckerCommands;

simulated event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    local @NULL TP, TPC;
    local int I;
    local @NULL ducker;

    TP = TurokPawnPlayer(Other);
    // End:0x1D
    if(TP == none)
    {
        return;
    }
    // End:0x33
    if(!TP.IsLocallyControlled())
    {
        return;
    }
    TPC = TurokPlayerController(TP.Controller);
    // End:0x5C
    if(TPC == none)
    {
        return;        
    }
    else
    {
        ducker = TPC.GetAudioDucker();
    }
    // End:0x109
    if(ducker != none)
    {
        ducker.SetAudioDuckerItem(mDuckerName, false, mFadeTime);
        I = 0;
        J0x9D:

        // End:0xF5 [Loop If]
        if(I < mDuckerCommands.Length)
        {
            ducker.AddDuckerCommand(mDuckerName, mDuckerCommands[I].mSoundGroupName, mDuckerCommands[I].mTargetVolume);
            I++;
            // [Loop Continue]
            goto J0x9D;
        }
        ducker.ActivateAudioDuckerItem(mDuckerName);
    }
    //return;    
}

simulated event UnTouch(@NULL Other)
{
    local @NULL TP, TPC, ducker;

    TP = TurokPawnPlayer(Other);
    // End:0x1D
    if(TP == none)
    {
        return;
    }
    // End:0x33
    if(!TP.IsLocallyControlled())
    {
        return;
    }
    TPC = TurokPlayerController(TP.Controller);
    // End:0x5C
    if(TPC == none)
    {
        return;        
    }
    else
    {
        ducker = TPC.GetAudioDucker();
    }
    // End:0x96
    if(ducker != none)
    {
        ducker.SetAudioDuckerItem(mDuckerName, true, mFadeTime);
    }
    //return;    
}

defaultproperties
{
    mFadeTime=0.1000000
    // Reference: BrushComponent'Default__TurokDuckerVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}