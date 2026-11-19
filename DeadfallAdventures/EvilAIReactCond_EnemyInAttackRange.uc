class EvilAIReactCond_EnemyInAttackRange extends EvilAIReactConditionConduit within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local AICharacterInfo EnemyInfo;

    // End:0x49
    if(!super.ShouldActivate(InInstigator, OriginatingChannel) || !Outer.HasValidEnemy())
    {
        return false;
    }
    // End:0xB7
    if(Outer.GetCurrentEnemyInfo(EnemyInfo) && EnemyInfo.DistanceToEnemy < Outer.BeginAttackDistance)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="EnemyInAttackRange"
    bOneTimeOnly=true
    AutoSubscribedChannels[0]="Sight"
    AutoSubscribedChannels[1]="Hear"
}