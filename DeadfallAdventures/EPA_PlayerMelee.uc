class EPA_PlayerMelee extends EvilPawnAction;

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
    // End:0x19E
    if(PawnOwner.TopHalfAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false) == 0.0000000)
    {
        PawnOwner.EndPawnAction();
    }
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.TopHalfAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.StopCustomAnim(0.2000000);
    //return;    
}
