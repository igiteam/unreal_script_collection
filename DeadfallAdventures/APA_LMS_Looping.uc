class APA_LMS_Looping extends EPA_BasePlaySingleAnim;

var array<name> AnimNames;

static simulated function int EncodeAnimationInfo(int AnimIndex)
{
    local int ret;

    ret = AnimIndex & 255;
    return ret;
    //return ReturnValue;    
}

static simulated function DecodeAnimationInfo(int AnimationInfo, out int AnimIndex)
{
    AnimIndex = AnimationInfo & 255;
    //return;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local int AnimIndex;

    PawnOwner.ZeroMovementVariables();
    DecodeAnimationInfo(PawnOwner.PawnActionFlags, AnimIndex);
    AnimName = AnimNames[AnimIndex % AnimNames.Length];
    super.PawnActionStarted(bForced, PrevAction);
    //return;    
}

function PlayAnimation()
{
    PawnOwner.FullBodyAnimSlot.PlayCustomAnim(AnimName, SpeedModifier, BlendInTime / SpeedModifier, BlendOutTime / SpeedModifier, true);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    //return;    
}

function bool ShouldReplicate()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    AnimNames[0]="LMS_Wounded_Loop1"
    AnimNames[1]="LMS_Wounded_Loop2"
    AnimNames[2]="LMS_Wounded_Loop3"
}