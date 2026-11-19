class MOHAAnimPlayDeathByLocomoting extends MOHAAnimPlayByBase
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

var() float LocomotionThresholdSpeed;

event int GetChildIndexToPlay()
{
    local int Index;
    local MOHAPawn aPawn;

    Index = 0;
    aPawn = MOHAPawn(SkelComponent.Owner);
    // End:0x63
    if(aPawn != none)
    {
        // End:0x63
        if((aPawn.VelocityMagAtDeath >= LocomotionThresholdSpeed) && Children[1].Anim != none)
        {
            Index = 1;
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    LocomotionThresholdSpeed=150.0000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}