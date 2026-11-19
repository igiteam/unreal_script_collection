class PPA_Shoot extends EPA_BasePlaySingleASTAnim;

var EvilAnimInfo AnimInfo;

function bool CanOverrideActionWith(byte NewAction)
{
    return (((int(NewAction) == 3) || int(NewAction) == 1) || int(NewAction) == 7) || int(NewAction) == 5;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return int(inAction) == 10;
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
    PawnOwner.OnStopFire();
    PawnOwner.OnStopFireAlt();
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