class EvilAIReactCond_EmergeEnemyCloseAndVisible extends EvilAIReactCond_EmergeEnemy within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    // End:0xA3
    if(super.ShouldActivate(InInstigator, OriginatingChannel))
    {
        // End:0x3C
        if(EvilAIReactChan_Damage(OriginatingChannel) != none)
        {
            return true;            
        }
        else
        {
            return VSizeSq(InInstigator.Location - Outer.Pawn.Location) < (DistanceThreshold ** float(2));
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    DistanceThreshold=500.0000000
    AutoSubscribedChannels[0]="SightPlayer"
    AutoSubscribedChannels[1]="Hearing"
    AutoSubscribedChannels[2]="Damage"
}