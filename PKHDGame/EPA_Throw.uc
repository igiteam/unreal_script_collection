class EPA_Throw extends EvilPawnAction;

function bool CanOverrideActionWith(byte NewAction)
{
    return (int(NewAction) == 3) || int(NewAction) == 1;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return int(inAction) == 10;
    //return ReturnValue;    
}

function bool AimOffsetOverride(out Rotator DeltaRot)
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AnimInfo;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0x189
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        Anim = AnimInfo.AnimName;
        PawnOwner.FullBodyAnimSlot.PlayCustomAnim(Anim, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false, true, 0.0000000);
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.StopCustomAnim(0.2000000);
    PawnOwner.OnStopThrow();
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}

defaultproperties
{
    bLockPawnRotation=true
}