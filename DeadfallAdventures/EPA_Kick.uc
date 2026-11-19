class EPA_Kick extends EvilPawnAction;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilAnimInfo AnimInfo;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xAB
    if(!PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
    }
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.StopCustomAnim(0.2000000);
    //return;    
}
