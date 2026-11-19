class AdvAIReactCond_PlayerMovedForward extends EvilAIReactConditionConduit within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    return super.ShouldActivate(InInstigator, OriginatingChannel) && OriginatingChannel.ChannelName == 'PlayerMovedForward';
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="PlayerCloseAndVisible"
    AutoSubscribedChannels=/* Array type was not detected. */
}