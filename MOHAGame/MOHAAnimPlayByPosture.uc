class MOHAAnimPlayByPosture extends MOHAAnimPlayByBase
    native
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

var() float CrouchMaxDistance;
var() name HighBoneName;
var() name LowBoneName;

event int GetChildIndexToPlay()
{
    local int Index;
    local Vector HiLoc, LowLoc;
    local MOHAPawn Pawn;

    // End:0x3D
    if((SkelComponent != none) && SkelComponent.Owner != none)
    {
        Pawn = MOHAPawn(SkelComponent.Owner);        
    }
    else
    {
        Pawn = none;
    }
    Index = 0;
    // End:0x9F
    if((Pawn != none) && Pawn.PlayByPostureOverride > 0)
    {
        // End:0x9C
        if(Pawn.PlayByPostureOverride <= Children.Length)
        {
            Index = Pawn.PlayByPostureOverride - 1;
        }        
    }
    else
    {
        HiLoc = SkelComponent.GetBoneLocation(HighBoneName, 1);
        LowLoc = SkelComponent.GetBoneLocation(LowBoneName, 1);
        // End:0xF4
        if(VSize(HiLoc - LowLoc) <= CrouchMaxDistance)
        {
            Index = 1;
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    CrouchMaxDistance=80.0000000
    HighBoneName="Hips"
    LowBoneName="Root"
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}