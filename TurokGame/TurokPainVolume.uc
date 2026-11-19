class TurokPainVolume extends PhysicsVolume
    native
    hidecategories(Navigation,Object,Movement,Display);

simulated function PostBeginPlay()
{
    local bool bSavedPawnCausing;

    bSavedPawnCausing = bPainCausing;
    bPainCausing = false;
    super.PostBeginPlay();
    bPainCausing = bSavedPawnCausing;
    //return;    
}

function Reset()
{
    //return;    
}

function TouchedPainVolume(@NULL Other)
{
    local @NULL TP;

    // End:0x3F
    if(int(Role) == int(ROLE_Authority))
    {
        TP = TurokPawn(Other);
        // End:0x3F
        if(TP != none)
        {
            TP.TouchPainVolume(self);
        }
    }
    //return;    
}

simulated event UnTouch(@NULL Other)
{
    local @NULL TP;

    // End:0x3F
    if(int(Role) == int(ROLE_Authority))
    {
        TP = TurokPawn(Other);
        // End:0x3F
        if(TP != none)
        {
            TP.UnTouchPainVolume(self);
        }
    }
    super(Actor).UnTouch(Other);
    //return;    
}

defaultproperties
{
    DamageType=Class'TurokDamageTypeFoot'
    bPainCausing=true
    // Reference: BrushComponent'Default__TurokPainVolume.BrushComponent0'
    begin object name=BrushComponent0
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    CollisionComponent=BrushComponent0
}