class EPA_BasePlaySingleAnim extends EvilPawnAction
    abstract;

var() name AnimName;
var float BlendInTime;
var float BlendOutTime;
var() bool bUseHalfBodySlot;

function PawnActionStarted(bool bForced, byte PrevMove)
{
    super.PawnActionStarted(bForced, PrevMove);
    PlayAnimation();
    //return;    
}

function SetActionParamsFromAniminfo(const out EvilAnimInfo InAnimInfo)
{
    SpeedModifier = default.SpeedModifier;
    AnimName = InAnimInfo.AnimName;
    SpeedModifier *= InAnimInfo.AnimSpeed;
    BlendInTime = InAnimInfo.BlendInTime;
    BlendOutTime = InAnimInfo.BlendOutTime;
    //return;    
}

function PlayAnimation()
{
    GetAnimNodeSlot().PlayCustomAnim(AnimName, SpeedModifier, BlendInTime / SpeedModifier, BlendOutTime / SpeedModifier, false);
    GetAnimNodeSlot().SetActorAnimEndNotification(true);
    //return;    
}

function AnimNodeSlot GetAnimNodeSlot()
{
    return ((bUseHalfBodySlot) ? PawnOwner.TopHalfAnimSlot : PawnOwner.FullBodyAnimSlot);
    //return ReturnValue;    
}

defaultproperties
{
    BlendInTime=0.2000000
    BlendOutTime=0.2000000
}