class EvilAIReactConditionConduit extends EvilAIReactCondition within EvilAIController;

var name OutputChannelName;
var float MinTimeBetweenActivations;
var float LastActivationTime;
//var delegate<OutputFunction> __OutputFunction__Delegate;

delegate OutputFunction(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    //return;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x23
    if(!super.ShouldActivate(InInstigator, OriginatingChannel))
    {
        return false;
    }
    // End:0x9B
    if(((MinTimeBetweenActivations > 0.0000000) && LastActivationTime > 0.0000000) && (Outer.WorldInfo.TimeSeconds - LastActivationTime) < MinTimeBetweenActivations)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function UnblockReaction(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super.UnblockReaction(InInstigator, OriginatingChannel);
    LastActivationTime = Outer.WorldInfo.TimeSeconds;
    //return;    
}

function Activate(Actor EventInstigator, EvilAIReactChannel OriginatingChannel)
{
    super.Activate(EventInstigator, OriginatingChannel);
    LastActivationTime = Outer.WorldInfo.TimeSeconds;
    Output(EventInstigator, OriginatingChannel);
    //return;    
}

function Output(Actor InInstigator, EvilAIReactChannel InOriginatingChannel)
{
    OutputFunction(InInstigator, InOriginatingChannel);
    Outer.ReactionManager.NudgeChannel(InInstigator, OutputChannelName);
    //return;    
}

defaultproperties
{
    MinTimeBetweenActivations=-1.0000000
}