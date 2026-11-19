class EPA_BasePlaySingleAnim extends EvilPawnAction
    abstract;

var() name AnimName;
var float BlendInTime;
var float BlendOutTime;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PlayAnimation();
    //return;    
}

function SetActionParamsFromAniminfo(const out EvilAnimInfo InAnimInfo)
{
    AnimName = InAnimInfo.AnimName;
    SpeedModifier *= InAnimInfo.AnimSpeed;
    BlendInTime = InAnimInfo.BlendInTime;
    BlendOutTime = InAnimInfo.BlendOutTime;
    //return;    
}

function PlayAnimation()
{
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimName, SpeedModifier, BlendInTime / SpeedModifier, BlendOutTime / SpeedModifier, false);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

defaultproperties
{
    BlendInTime=0.2000000
    BlendOutTime=0.2000000
}