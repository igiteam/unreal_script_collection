class TurokStealthVolume extends Volume
    hidecategories(Navigation,Object,Movement,Display);

enum StealthVisibilityPreset
{
    STEALTH_VISIBILITY_PRESET_Low,  // 0
    STEALTH_VISIBILITY_PRESET_Medium,// 1
    STEALTH_VISIBILITY_PRESET_High, // 2
    STEALTH_VISIBILITY_PRESET_Manual,// 3
    STEALTH_VISIBILITY_PRESET_MAX   // 4
};

var(Stealth) float mStealthFactor;
var(Stealth) byte mStealthVisibilityPreset;
var float mStealthPresets[3];

simulated function float GetStealthFactor()
{
    return mStealthFactor;
    //return ReturnValue;    
}

simulated event Touch(@NULL Other, @NULL HitLocation, @NULL HitNormal)
{
    local @NULL TP;

    TP = TurokPawn(Other);
    // End:0x7A
    if(TP != none)
    {
        // End:0x46
        if(int(mStealthVisibilityPreset) == int(3))
        {
            TP.StealthVisibility(mStealthFactor);            
        }
        else
        {
            TP.StealthVisibility(mStealthPresets[int(mStealthVisibilityPreset)]);
        }
        TP.SetIsStealthPocket(true);
    }
    //return;    
}

simulated event UnTouch(@NULL Other)
{
    local @NULL TP;

    TP = TurokPawn(Other);
    // End:0x5B
    if(TP != none)
    {
        // End:0x5B
        if(TP.Health > 0)
        {
            TP.StealthVisibility(1.0000000);
            TP.SetIsStealthPocket(false);
        }
    }
    //return;    
}

defaultproperties
{
    mStealthFactor=0.2500000
    mStealthVisibilityPreset=1
    mStealthPresets[0]=0.1500000
    mStealthPresets[1]=0.2500000
    mStealthPresets[2]=0.3500000
    mSetVolumeFlags=4
    // Reference: BrushComponent'Default__TurokStealthVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}