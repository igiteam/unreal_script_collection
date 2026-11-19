class EPA_Charge extends EvilPawnAction;

var const bool bShouldSetFocus;

function bool CanChainAction(byte NextAction)
{
    // End:0x14
    if(int(NextAction) == 8)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilAnimInfo AnimInfo;
    local int Index;
    local EvilTypesNative.EAnimationSetType AST;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    // End:0x252
    if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
    {
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    // End:0x2AD
    if((AIOwner != none) && bShouldSetFocus)
    {
        AIOwner.Focus = AIOwner.Enemy;
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

defaultproperties
{
    bForceRotation=true
}