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
    // End:0x7A
    if((int(PawnOwner.CurrentMoveMode) == int(2)) || !PawnOwner.bThrowingGrenade && PawnOwner.AST_GetAnimCount(36) < 1)
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
    local float FullBodyAnimRate;
    local AnimNodeSlot TopHalfAnimSlot;

    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xA2
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    TopHalfAnimSlot = PawnOwner.GetTopHalfAnimSlot();
    // End:0x137
    if(TopHalfAnimSlot != none)
    {
        TopHalfAnimSlot.PlayCustomAnim(AnimName, SpeedModifier, BlendInTime / SpeedModifier, BlendOutTime / SpeedModifier, false);
    }
    // End:0x260
    if(PawnOwner.bThrowingGrenade && !PawnOwner.bThrowedGrenade)
    {
        FullBodyAnimRate = PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().Rate;
        // End:0x241
        if(FullBodyAnimRate > 0.0000000)
        {
            PawnOwner.FullBodyAnimSlot.GetCustomAnimNodeSeq().Rate = -FullBodyAnimRate * 1.2000000;
        }
        PawnOwner.OnStartThrow();
    }
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