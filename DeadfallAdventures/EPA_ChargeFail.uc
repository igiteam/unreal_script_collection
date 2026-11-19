class EPA_ChargeFail extends EvilPawnAction;

protected function bool InternalCanDoPawnAction()
{
    local Vector HitLocation, HitNormal;
    local Actor HitActor;

    HitActor = PawnOwner.Trace(HitLocation, HitNormal, PawnOwner.Location + (Vector(PawnOwner.Rotation) * float(150)),, true, vect(30.0000000, 30.0000000, 30.0000000));
    return HitActor == none;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilAnimInfo AnimInfo;

    super.PawnActionStarted(bForced, PrevAction);
    // End:0x6E
    if(!PawnOwner.AST_GetAnimInfo(42, PawnOwner.PawnActionFlags & 255, AnimInfo))
    {
    }
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    // End:0x21A
    if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
    {
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}
