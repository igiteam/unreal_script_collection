class EvilAIReactCond_EnemyCloseAndVisible extends EvilAIReactConditionConduit within EvilAIController;

var() float DistanceThreshold;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local bool bResult;

    bResult = super.ShouldActivate(InInstigator, OriginatingChannel) && VSizeSq(InInstigator.Location - Outer.Pawn.Location) < (DistanceThreshold ** float(2));
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="EnemyCloseAndVisible"
    AutoSubscribedChannels[0]="Sight"
    AutoSubscribedChannels[1]="SightPlayer"
}