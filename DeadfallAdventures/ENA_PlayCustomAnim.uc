class ENA_PlayCustomAnim extends EvilNavPointAction
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() name AnimName;
var() float AnimStartTime;
var() float AnimEndTime;
var() float AnimRate;
var() float BlendInTime;
var() float BlendOutTime;
var bool bLoop;
var() bool bTopHalfBodySlot;
var() bool bUseMotionDelta;
var float ActionEndTime;
var AnimNodeSlot CurrentAnimNodeSlot;

function bool InitNavAction(EvilPawn InMyEvilPawn)
{
    // End:0x80
    if(super.InitNavAction(InMyEvilPawn))
    {
        CurrentAnimNodeSlot = GetAnimNodeSlot();
        return (CurrentAnimNodeSlot != none) && MyEvilPawn.Mesh.GetAnimLength(AnimName) > 0.0000000;
    }
    return false;
    //return ReturnValue;    
}

function StartNavAction()
{
    // End:0x5D
    if(AnimEndTime == 0.0000000)
    {
        AnimEndTime = MyEvilPawn.Mesh.GetAnimLength(AnimName);        
    }
    else
    {
        // End:0xC9
        if((AnimEndTime < 0.0000000) || AnimEndTime > MyEvilPawn.Mesh.GetAnimLength(AnimName))
        {
            bLoop = true;
        }
    }
    // End:0xFD
    if(AnimEndTime < 0.0000000)
    {
        AnimEndTime = 0.0000000;
        ActionEndTime = -1.0000000;        
    }
    else
    {
        ActionEndTime = MyEvilPawn.WorldInfo.TimeSeconds + AnimEndTime;
    }
    // End:0x21E
    if(CurrentAnimNodeSlot.PlayCustomAnim(AnimName, AnimRate, BlendInTime, BlendOutTime, bLoop, true, AnimStartTime, ((AnimEndTime > MyEvilPawn.Mesh.GetAnimLength(AnimName)) ? 0.0000000 : AnimEndTime)) <= 0.0000000)
    {
        ExitWithFailure("AnimPlayFailed");        
    }
    else
    {
        // End:0x2AD
        if(bUseMotionDelta && !bTopHalfBodySlot)
        {
            MyEvilPawn.Mesh.RootMotionMode = 3;
            CurrentAnimNodeSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(2, 2, 2);
        }
    }
    super.StartNavAction();
    //return;    
}

function bool IsNavActionActive()
{
    return ((super.IsNavActionActive() && CurrentAnimNodeSlot.GetPlayedAnimation() == AnimName) && CurrentAnimNodeSlot.bIsPlayingCustomAnim) && (ActionEndTime < 0.0000000) || MyEvilPawn.WorldInfo.TimeSeconds < ActionEndTime;
    //return ReturnValue;    
}

function OnNavActionFinish()
{
    FinishAnim();
    super.OnNavActionFinish();
    //return;    
}

function OnNavActionAbort()
{
    FinishAnim();
    super.OnNavActionAbort();
    //return;    
}

function Cleanup()
{
    super.Cleanup();
    CurrentAnimNodeSlot = none;
    //return;    
}

function FinishAnim()
{
    // End:0xE3
    if(((CurrentAnimNodeSlot != none) && CurrentAnimNodeSlot.bIsPlayingCustomAnim) && CurrentAnimNodeSlot.GetPlayedAnimation() == AnimName)
    {
        CurrentAnimNodeSlot.StopCustomAnim(BlendOutTime);
        // End:0xE3
        if(bUseMotionDelta && !bTopHalfBodySlot)
        {
            CurrentAnimNodeSlot.GetCustomAnimNodeSeq().SetRootBoneAxisOption(1, 1, 1);
        }
    }
    //return;    
}

function AnimNodeSlot GetAnimNodeSlot()
{
    // End:0x2F
    if(bTopHalfBodySlot)
    {
        return MyEvilPawn.TopHalfAnimSlot;        
    }
    else
    {
        return MyEvilPawn.FullBodyAnimSlot;
    }
    //return ReturnValue;    
}

defaultproperties
{
    AnimRate=1.0000000
    BlendInTime=0.4000000
    BlendOutTime=0.4000000
    bUseMotionDelta=true
}