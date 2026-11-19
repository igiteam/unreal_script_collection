class EPA_PlayerPreThrow extends EvilPawnAction;

var EvilTypesNative.EAnimationSetType AST;
var int Index;

function bool CanOverrideActionWith(byte NewAction)
{
    return (((int(NewAction) == 3) || int(NewAction) == 1) || int(NewAction) == 2) || int(NewAction) == 9;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return int(inAction) == 10;
    //return ReturnValue;    
}

function bool AimOffsetOverride(out Rotator DeltaRot)
{
    return true;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local EvilAnimInfo AnimInfo;
    local float FPPAnimTime, AnimTime, AnimRate;

    super.PawnActionStarted(bForced, PrevAction);
    FPPAnimTime = float(PawnOwner.PawnActionFlags) / 100.0000000;
    // End:0x1C6
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        Anim = AnimInfo.AnimName;
        AnimTime = PawnOwner.Mesh.GetAnimLength(Anim);
        // End:0x1C3
        if((AnimTime > 0.0000000) && FPPAnimTime > 0.0000000)
        {
            AnimRate = AnimTime / FPPAnimTime;
            PawnOwner.TopHalfAnimSlot.PlayCustomAnim(Anim, AnimRate * SpeedModifier, AnimInfo.BlendInTime / SpeedModifier, 0.0000000, false, true, 0.0000000);
        }        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.TopHalfAnimSlot.SetRootBoneAxisOption(0, 0, 0);
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    local name Anim;
    local EvilAnimInfo AnimInfo;
    local float AnimTime;

    PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
    // End:0x13E
    if(PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo))
    {
        Anim = AnimInfo.AnimName;
        AnimTime = PawnOwner.Mesh.GetAnimLength(Anim);
        PawnOwner.TopHalfAnimSlot.PlayCustomAnim(Anim, 0.0010000, 0.0000000, 0.0000000, false, true, AnimTime - 0.0100000);
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    // End:0x170
    if((int(NextMove) != 2) && int(NextMove) != 9)
    {
        PawnOwner.TopHalfAnimSlot.SetActorAnimEndNotification(false);
        PawnOwner.TopHalfAnimSlot.StopCustomAnim(0.2000000);
        PawnOwner.OnStopThrow();
        PawnOwner.TopHalfAnimSlot.SetRootBoneAxisOption(1, 1, 1);
        PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    }
    //return;    
}

defaultproperties
{
    AST=EAnimationSetType.AST_Throw
    bLockPawnRotation=true
}