class SeqAct_PlayCustomAnim extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() name AnimName;
var() float Rate;
var() float Duration;
var() float BlendInTime;
var() float BlendOutTime;
var() bool bLooping;
var() bool bOverride;
var() float StartTime;
var() float EndTime;
var int actionCase;

simulated event Activated()
{
    local AdvPlayerController APC;
    local AdvPlayerPawn APP;
    local int I;
    local float PlayBackLength;

    I = 0;
    J0x0B:

    // End:0x5EB [Loop If]
    if(I < Targets.Length)
    {
        APC = AdvPlayerController(Targets[I]);
        // End:0x8C
        if(APC != none)
        {
            APP = AdvPlayerPawn(APC.Pawn);            
        }
        else
        {
            APP = AdvPlayerPawn(Targets[I]);
        }
        // End:0x143
        if(APP == none)
        {
            ScriptLog((((("WARNING: Player expected in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));
            ActivateOutputLink(1);
            return;            
        }
        else
        {
            // End:0x1FE
            if(APP.FullBodyAnimSlot == none)
            {
                ScriptLog((((("WARNING: There is no FullBodyAnimSlot for Player in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));
                ActivateOutputLink(1);
                return;
            }
        }
        // End:0x433
        if(InputLinks[0].bHasImpulse)
        {
            actionCase = 0;
            // End:0x2DE
            if((StartTime >= 0.0000000) && EndTime >= 0.0000000)
            {
                PlayBackLength = APP.FullBodyAnimSlot.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime, EndTime);                
            }
            else
            {
                PlayBackLength = APP.FullBodyAnimSlot.PlayCustomAnim(AnimName, Rate, BlendInTime, BlendOutTime, bLooping, bOverride);
            }
            // End:0x430
            if(PlayBackLength <= float(0))
            {
                ScriptLog((((((("WARNING: PlayCustomAnim has PlayBackLength equal " $ string(PlayBackLength)) $ " for FullBodyAnimSlot for Player in Targets for") @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));
                ActivateOutputLink(1);
                return;
            }            
        }
        else
        {
            // End:0x587
            if(InputLinks[1].bHasImpulse)
            {
                actionCase = 1;
                // End:0x584
                if(!APP.FullBodyAnimSlot.PlayCustomAnimByDuration(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride))
                {
                    ScriptLog((((("WARNING: PlayCustomAnimByDuration has failed for FullBodyAnimSlot for Player in Targets for" @ string(self)) @ ". Target[") $ string(I)) $ "] : ") $ string(Targets[I]));
                    ActivateOutputLink(1);
                    return;
                }                
            }
            else
            {
                APP.FullBodyAnimSlot.StopCustomAnim(BlendOutTime);
                ActivateOutputLink(2);
                return;
            }
        }
        ActivateOutputLink(0);
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

defaultproperties
{
    Rate=1.0000000
    Duration=1.0000000
    BlendInTime=0.2000000
    BlendOutTime=0.2000000
    bOverride=true
    StartTime=-1.0000000
    EndTime=-1.0000000
    bAutoActivateOutputLinks=false
    InputLinks[0]=(LinkDesc="Play Custom Anim",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[1]=(LinkDesc="Play Custom Anim By Duration",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    InputLinks[2]=(LinkDesc="Force Stop",bHasImpulse=false,QueuedActivations=0,bDisabled=false,bDisabledPIE=false,LinkedOp=none,DrawY=0,bHidden=false,ActivateDelay=0.0000000,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0)
    OutputLinks[0]=(Links=none,LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[1]=(Links=none,LinkDesc="Error",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    OutputLinks[2]=(Links=none,LinkDesc="Stop",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false,bMoving=false,bClampedMax=false,bClampedMin=false,OverrideDelta=0,PIEActivationTime=0.0000000,bIsActivated=false)
    ObjName="Play Custom Anim"
}