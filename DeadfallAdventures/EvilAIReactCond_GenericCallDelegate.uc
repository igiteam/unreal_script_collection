class EvilAIReactCond_GenericCallDelegate extends EvilAIReactCondition within EvilAIController;

var float MinTimeBetweenOutputsSeconds;
var float LastOutputTime;
var float ActivationDelay;
var Actor DelayedEventInstigator;
var EvilAIReactChannel DelayedOriginatingChannel;
var bool EventInstigatorValid;
var bool OriginatingChannelValid;
//var delegate<OutputFunction> __OutputFunction__Delegate;

delegate OutputFunction(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x2E
    if(Outer.IsTimerActive('DelayedActivateTimer', self))
    {
        return false;
    }
    // End:0x51
    if(!super.ShouldActivate(InInstigator, OriginatingChannel))
    {
        return false;
    }
    // End:0xC9
    if(((MinTimeBetweenOutputsSeconds > 0.0000000) && LastOutputTime > 0.0000000) && (Outer.WorldInfo.TimeSeconds - LastOutputTime) < MinTimeBetweenOutputsSeconds)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function UnblockReaction(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super.UnblockReaction(InInstigator, OriginatingChannel);
    LastOutputTime = Outer.WorldInfo.TimeSeconds;
    //return;    
}

function Activate(Actor EventInstigator, EvilAIReactChannel OriginatingChannel)
{
    EventInstigatorValid = EventInstigator != none;
    OriginatingChannelValid = OriginatingChannel != none;
    // End:0x5E
    if(ActivationDelay <= float(0))
    {
        Activate_internal(EventInstigator, OriginatingChannel);        
    }
    else
    {
        DelayedEventInstigator = EventInstigator;
        DelayedOriginatingChannel = OriginatingChannel;
        Outer.SetTimer(ActivationDelay, false, 'DelayedActivateTimer', self);
    }
    //return;    
}

function DelayedActivateTimer()
{
    // End:0x20
    if(EventInstigatorValid && DelayedEventInstigator == none)
    {
        return;
    }
    // End:0x40
    if(OriginatingChannelValid && DelayedOriginatingChannel == none)
    {
        return;
    }
    Activate_internal(DelayedEventInstigator, DelayedOriginatingChannel);
    //return;    
}

function Activate_internal(Actor EventInstigator, EvilAIReactChannel OriginatingChannel)
{
    Activate(EventInstigator, OriginatingChannel);
    LastOutputTime = Outer.WorldInfo.TimeSeconds;
    OutputFunction(EventInstigator, OriginatingChannel);
    //return;    
}

defaultproperties
{
    MinTimeBetweenOutputsSeconds=0.5000000
    ActivationDelay=-1.0000000
}