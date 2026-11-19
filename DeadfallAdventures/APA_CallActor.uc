class APA_CallActor extends EvilPawnAction;

var name AnimName;
var float AnimRate;
var float BlendInTime;
var float BlendOutTime;
var float ActionFinishTime;
var bool IsIdleAnimationPlaying;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim('Zimmerman_Idle_Come1', AnimRate, BlendInTime, BlendOutTime, false, true);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.StopCustomAnim(0.2000000);
    //return;    
}

defaultproperties
{
    AnimRate=1.0000000
    BlendInTime=0.4000000
    BlendOutTime=0.4000000
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}