class EPA_PlayerEquipWeapon extends EvilPawnAction;

function bool CanChainAction(byte NextAction)
{
    return true;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
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
    // End:0x1F8
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo) && PawnOwner.TopHalfAnimSlot != none)
    {
        Anim = AnimInfo.AnimName;
        // End:0x1F5
        if(PawnOwner.TopHalfAnimSlot.PlayCustomAnim(Anim, (AnimInfo.AnimSpeed * SpeedModifier) * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false) == 0.0000000)
        {
            PawnOwner.EndPawnAction();
        }        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.TopHalfAnimSlot.StopCustomAnim(0.2000000);
    PawnOwner.TopHalfAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    //return;    
}
