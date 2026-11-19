class EvilAIReactCond_StopGuarding extends EvilAIReactConditionConduit within EvilAIController;

var float GuardAttackThreshold;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local float RangeToEnemy;
    local int Index;

    // End:0x6C
    if((!super.ShouldActivate(InInstigator, OriginatingChannel) || EvilAICmd_Base_Guard(Outer.CommandList) == none) || Pawn(InInstigator) == none)
    {
        return false;
    }
    Index = Outer.GetAIEnemyInfoIdx(Pawn(InInstigator));
    // End:0x102
    if(Index > -1)
    {
        RangeToEnemy = Outer.EnemyInfoList[Index].DistanceToEnemy;        
    }
    else
    {
        RangeToEnemy = VSize(InInstigator.Location - Outer.Pawn.Location);
    }
    // End:0x1BC
    if((RangeToEnemy < GuardAttackThreshold) && Outer.NavigationHandle.ActorReachable(InInstigator))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="StopGuarding"
    bOneTimeOnly=true
    AutoSubscribedChannels[0]="Sight"
    AutoSubscribedChannels[1]="StopGuarding"
}