class APA_AttackedByCreature extends EvilPawnAction;

var float AnimRate;
var float BlendInTime;
var float BlendOutTime;

function bool CanOverrideAction(byte inAction)
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte inAction)
{
    return false;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    super.PawnActionStarted(bForced, PrevAction);
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(name("Throw_Grenade"), AnimRate, BlendInTime, BlendOutTime, false, true);
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
}