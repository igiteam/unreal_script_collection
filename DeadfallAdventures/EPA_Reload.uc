class EPA_Reload extends EvilPawnAction;

var AnimNodeSlot TopHalfAnimSlot;

function bool CanOverrideActionWith(byte NewAction)
{
    return (int(NewAction) == 3) || int(NewAction) == 1;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return ((int(inAction) != 3) && int(inAction) != 13) && int(inAction) != 14;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AnimInfo;

    super.PawnActionStarted(bForced, PrevAction);
    TopHalfAnimSlot = PawnOwner.GetActiveHalfBodySlot();
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0x19C
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        Anim = AnimInfo.AnimName;
        TopHalfAnimSlot.PlayCustomAnim(Anim, AnimInfo.AnimSpeed * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    TopHalfAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    TopHalfAnimSlot.SetActorAnimEndNotification(false);
    TopHalfAnimSlot.StopCustomAnim(0.2000000);
    TopHalfAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    //return;    
}
