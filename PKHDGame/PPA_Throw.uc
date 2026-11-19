class PPA_Throw extends EPA_BasePlaySingleASTAnim;

var EvilAnimInfo AnimInfo;

function bool CanOverrideActionWith(byte NewAction)
{
    return (((int(NewAction) == 3) || int(NewAction) == 1) || int(NewAction) == 7) || int(NewAction) == 5;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local PKAIController MyPKAI;

    super.PawnActionStarted(bForced, PrevAction);
    MyPKAI = PKAIController(PawnOwner.MyEvilAI);
    // End:0xAF
    if(MyPKAI != none)
    {
        MyPKAI.ActualThrowLocation = MyPKAI.GetEnemyInfo().KnownLocation;
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local PKAIController MyPKAI;

    MyPKAI = PKAIController(PawnOwner.MyEvilAI);
    // End:0xFC
    if((MyPKAI != none) && !PawnOwner.bEndingPawnAction)
    {
        // End:0xF1
        if(MyPKAI.HasValidEnemy())
        {
            SetLockPawnRotation(default.bLockPawnRotation);
            MyPKAI.ActualThrowLocation = MyPKAI.GetEnemyInfo().KnownLocation;            
        }
        else
        {
            SetLockPawnRotation(true);
        }
    }
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.OnStopThrow();
    //return;    
}

defaultproperties
{
    AnimInfo=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
    DefaultAICommand=none
    bLockPawnRotation=false
    bDisableMovement=false
    bDisableAI=true
    bDisableIK=false
}