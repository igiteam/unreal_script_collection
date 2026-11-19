class EPA_Aim extends EvilPawnAction;

var EvilAnimInfo AnimInfo;
var bool bStartFireFromAnim;

function bool CanChainAction(byte NextAction)
{
    // End:0x14
    if(int(NextAction) == 11)
    {
        return true;
    }
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
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;

    super.PawnActionStarted(bForced, PrevAction);
    Class'EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    PawnOwner.AST_GetAnimInfo(AST, Index, AnimInfo);
    PawnOwner.ToggleAimingAnimMode();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    // End:0x5D
    if((int(NextMove) != 11) && int(PawnOwner.CurrentAimZone) == int(0))
    {
        PawnOwner.ToggleAimingAnimMode(true);
    }
    super.PawnActionEnded(PrevMove, NextMove);
    //return;    
}

defaultproperties
{
    AnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    bDisableIK=false
}