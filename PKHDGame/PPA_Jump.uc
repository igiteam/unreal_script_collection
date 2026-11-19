class PPA_Jump extends EPA_BasePlaySingleASTAnim;

var EvilAnimInfo AnimInfo;

function bool CanOverrideActionWith(byte NewAction)
{
    return int(NewAction) == 3;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    AnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    DefaultAICommand=none
    bLockPawnRotation=false
    bDisableMovement=false
    bDisableIK=false
}