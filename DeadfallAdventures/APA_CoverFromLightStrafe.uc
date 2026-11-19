class APA_CoverFromLightStrafe extends EvilPawnAction;

var EvilAnimInfo AnimInfo;
var EvilTypesNative.EAnimationSetType AST;
var int Index;

function bool CanOverrideActionWith(byte NewAction)
{
    return (int(NewAction) == 54) || int(NewAction) == 57;
    //return ReturnValue;    
}

function bool CanOverrideWithCurrentAction()
{
    return true;
    //return ReturnValue;    
}

function int GetCoverFromLightAnimPackedIndex()
{
    return PawnOwner.PawnActionFlags;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilGame.EvilPawn'.static.UnpackAnimInfo(GetCoverFromLightAnimPackedIndex(), AST, Index);
    PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
    // End:0xDF
    if(AnimInfo.AnimName == 'None')
    {
        PawnOwner.EndPawnAction();        
    }
    else
    {
        PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimInfo.AnimName, AnimInfo.AnimSpeed * PawnOwner.PawnActionAnimRateModifier, AnimInfo.BlendInTime, AnimInfo.BlendOutTime, false, true);
        PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 2);
        PawnOwner.Mesh.RootMotionMode = 3;
        // End:0x27C
        if(PawnOwner.FullBodyAnimSlot.GetPlayedAnimation() == 'None')
        {
            PawnOwner.EndPawnAction();            
        }
        else
        {
            PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
        }
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.Mesh.RootMotionMode = 1;
    //return;    
}

defaultproperties
{
    AnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
}