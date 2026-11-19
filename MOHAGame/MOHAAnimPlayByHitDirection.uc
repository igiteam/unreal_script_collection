class MOHAAnimPlayByHitDirection extends MOHAAnimPlayByBase
    hidecategories(Object,Object,Object,Object,AnimNodeBlendList);

event int GetChildIndexToPlay()
{
    local int Index;
    local Vector HorzHitVector;
    local Rotator HitRot;
    local int DeltaYaw, SliceSize;
    local MOHAPawn Pawn;

    Index = 0;
    Pawn = MOHAPawn(SkelComponent.Owner);
    // End:0x116
    if((Children.Length > 0) && VSizeSq2D(Pawn.LastHitDirection) > 0.0010000)
    {
        HorzHitVector = -Pawn.LastHitDirection;
        HorzHitVector.Z = 0.0000000;
        HitRot = Rotator(HorzHitVector);
        SliceSize = 65536 / Children.Length;
        DeltaYaw = HitRot.Yaw - Pawn.Rotation.Yaw;
        DeltaYaw += (SliceSize / 2);
        // End:0xED
        if(DeltaYaw < 0)
        {
            DeltaYaw += 65536;
        }
        Index = DeltaYaw / SliceSize;
        // End:0x116
        if(Index >= Children.Length)
        {
            Index = 0;
        }
    }
    return Index;
    //return ReturnValue;    
}

defaultproperties
{
    Children=/* Array type was not detected. */
}