class EPA_FullBodyHitReaction extends EPA_BasePlaySingleAnim;

var EvilTypesNative.EAnimationSetType CurrentAST;

function bool CanOverrideWithCurrentAction()
{
    return true;
    //return ReturnValue;    
}

protected function bool InternalCanDoPawnAction()
{
    // End:0x7A
    if(((int(PawnOwner.CurrentMoveMode) == int(2)) && !PawnOwner.bMovingToCover) && PawnOwner.AST_GetAnimCount(187) > 0)
    {
        return true;
    }
    // End:0xA3
    if(PawnOwner.AST_GetAnimCount(22) < 1)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte NewAction)
{
    local bool Result;

    Result = ((int(NewAction) == 3) || int(NewAction) == 1) && int(CurrentAST) != int(105);
    return Result;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return (((((((int(inAction) != 3) && int(inAction) != 31) && int(inAction) != 13) && int(inAction) != 32) && int(CurrentAST) != int(105)) && int(inAction) != 16) && int(inAction) != 19) && int(inAction) != 4;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    // End:0x60
    if((int(PawnOwner.CurrentMoveMode) == int(2)) && PawnOwner.AST_GetAnimCount(187) > 0)
    {
        DefaultAICommand = none;        
    }
    else
    {
        DefaultAICommand = default.DefaultAICommand;
    }
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.SetCoverAction(0);
    // End:0x10F
    if(!PawnOwner.IsRidingRailCar())
    {
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    }
    // End:0x1A9
    if((int(PawnOwner.WorldInfo.NetMode) < int(NM_Client)) && !PawnOwner.IsRidingRailCar())
    {
        PawnOwner.Mesh.RootMotionMode = 3;
    }
    PawnOwner.NotifyStartFullBodyHit();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.DISABLEHITPLAYRAGDOLL();
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.RecomputeNextHitTime();
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.NotifyEndFullBodyHit();
    //return;    
}

simulated function PlayAnimation()
{
    local EvilTypesNative.EAnimationSetType AST;
    local EvilAnimInfo AnimInfo;
    local int Index;

    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    CurrentAST = AST;
    // End:0xB5
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        SetActionParamsFromAniminfo(AnimInfo);        
    }
    super.PlayAnimation();
    //return;    
}

defaultproperties
{
    DefaultAICommand=Class'EvilAICmd_Base_PushedByPawnAction'
    bLockPawnRotation=true
    bDisableMovement=true
}