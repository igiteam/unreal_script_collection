class EvilAIReactCond_GenericPushCommand extends EvilAIReactCondition within EvilAIController;

var class<EvilAICommand> CommandClass;
var float MinTimeBetweenOutputsSeconds;
var float LastOutputTime;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0x86
    if(!super.ShouldActivate(InInstigator, OriginatingChannel) || (LastOutputTime != 0.0000000) && (Outer.WorldInfo.TimeSeconds - LastOutputTime) < MinTimeBetweenOutputsSeconds)
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

function Activate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    super.Activate(InInstigator, OriginatingChannel);
    // End:0x8D
    if(CommandClass.static.InitCommandUserActor(Outer, InInstigator))
    {
        LastOutputTime = Outer.WorldInfo.TimeSeconds;
    }
    //return;    
}

defaultproperties
{
    MinTimeBetweenOutputsSeconds=3.0000000
}