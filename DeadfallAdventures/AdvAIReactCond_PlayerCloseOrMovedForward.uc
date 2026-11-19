class AdvAIReactCond_PlayerCloseOrMovedForward extends EvilAIReactConditionConduit within EvilAIController;

var() float DistanceThreshold;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local bool bIsClose, bMovedForward;

    bIsClose = ((OriginatingChannel.ChannelName == 'HearingPlayer') || OriginatingChannel.ChannelName == 'SightPlayer') && VSizeSq(InInstigator.Location - Outer.Pawn.Location) < (DistanceThreshold ** float(2));
    bMovedForward = OriginatingChannel.ChannelName == 'PlayerMovedForward';
    return super.ShouldActivate(InInstigator, OriginatingChannel) && bIsClose || bMovedForward;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="PlayerCloseAndVisible"
    AutoSubscribedChannels=/* Array type was not detected. */
}