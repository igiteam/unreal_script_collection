class APA_IdleBehavior extends EvilPawnAction;

var name AnimName;
var float AnimRate;
var float BlendInTime;
var float BlendOutTime;
var array<string> AnimationNames;

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local int AnimationNameIndex;

    super.PawnActionStarted(bForced, PrevAction);
    AnimationNameIndex = Rand(AnimationNames.Length);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(name(AnimationNames[AnimationNameIndex]), AnimRate, BlendInTime, BlendOutTime, false, true);
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
    AnimationNames[0]="Zimmerman_Idle_Come1"
    AnimationNames[1]="Zimmerman_Idle1_Crouch"
    DefaultAICommand=Class'EvilGame.EvilAICmd_Base_PushedByPawnAction'
}