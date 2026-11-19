class EPA_Run2Cover extends EvilPawnAction;

var Vector PreciseDestination;
var bool bExitOnAnimEnd;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local EvilAnimInfo AnimInfo;
    local int Index;
    local EvilTypesNative.EAnimationSetType AST;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    // End:0xAD
    if(PawnOwner.IsAiming())
    {
        PawnOwner.StopAim();
    }
    PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime, AnimInfo.BlendOutTime, false, true);
    PawnOwner.Mesh.RootMotionMode = 2;
    // End:0x2C7
    if(PawnOwner.Controller != none)
    {
        PawnOwner.Controller.SetDestinationPosition(PawnOwner.CurrentLink.GetSlotLocation(PawnOwner.CurrentSlotIdx));
        PawnOwner.Controller.bPreciseDestination = true;
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local EvilAnimInfo AnimInfo;
    local int Index;
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x199
    if(!bExitOnAnimEnd)
    {
        Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.GetRun2CoverLoopAnimPackedIndex(), AST, Index);
        PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
        PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime, AnimInfo.BlendOutTime, true, true);
        PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);        
    }
    else
    {
        super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
    }
    //return;    
}

function PlayStopAnim()
{
    local EvilAnimInfo AnimInfo;
    local int Index;
    local EvilTypesNative.EAnimationSetType AST;

    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.GetRun2CoverStopAnimPackedIndex(), AST, Index);
    PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime, AnimInfo.BlendOutTime, false, true);
    PawnOwner.EndPawnAction();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.Mesh.RootMotionMode = 1;
    //return;    
}
