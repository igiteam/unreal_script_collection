class EPA_FastSpinUp extends EvilPawnAction;

var float MinTimeBetweenScereams;
var float LastScreamTime;

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
    // End:0x1A8
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        Anim = AnimInfo.AnimName;
        PawnOwner.TopHalfAnimSlot.PlayCustomAnim(Anim, (AnimInfo.AnimSpeed * SpeedModifier) * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime / SpeedModifier, AnimInfo.BlendOutTime / SpeedModifier, false);        
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

protected function bool InternalCanDoPawnAction()
{
    // End:0x4E
    if((PawnOwner.WorldInfo.TimeSeconds - LastScreamTime) > MinTimeBetweenScereams)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    MinTimeBetweenScereams=22.0000000
    LastScreamTime=-999.0000000
}