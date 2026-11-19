class EPA_TopBodyHalfHitReaction extends EPA_FullBodyHitReaction;

function bool CanOverrideActionWith(byte NewAction)
{
    return super.CanOverrideActionWith(NewAction) || int(NewAction) == 1;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return super.CanOverrideAction(inAction) && int(inAction) != 1;
    //return ReturnValue;    
}

protected function bool InternalCanDoPawnAction()
{
    // End:0x29
    if(PawnOwner.AST_GetAnimCount(36) < 1)
    {
        return false;
    }
    return super.InternalCanDoPawnAction();
    //return ReturnValue;    
}

simulated function PlayAnimation()
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xA2
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    PawnOwner.TopHalfAnimSlot.PlayCustomAnim(AnimName, SpeedModifier, BlendInTime / SpeedModifier, BlendOutTime / SpeedModifier, false);
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

defaultproperties
{
    DefaultAICommand=none
    bLockPawnRotation=false
    bDisableMovement=false
    bDisableIK=false
}