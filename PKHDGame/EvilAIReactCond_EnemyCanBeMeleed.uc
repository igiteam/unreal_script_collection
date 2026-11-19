class EvilAIReactCond_EnemyCanBeMeleed extends EvilAIReactConditionConduit within EvilAIController;

function bool ShouldMeleeCharge(Actor EventInstigator, float RangeToEnemy)
{
    return Outer.CanEngageCharge();
    //return ReturnValue;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local float RangeToEnemy;

    // End:0x49
    if(!super.ShouldActivate(InInstigator, OriginatingChannel) || !Outer.CanMeleeAttack())
    {
        return false;
    }
    RangeToEnemy = VSize(InInstigator.Location - Outer.Pawn.Location);
    // End:0xD9
    if(RangeToEnemy < Outer.EnemyDistance_Melee)
    {
        return true;        
    }
    else
    {
        // End:0x128
        if((RangeToEnemy < Outer.EnemyDistance_MeleeCharge) && ShouldMeleeCharge(InInstigator, RangeToEnemy))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="EnemyCanBeMeleed"
    AutoSubscribedChannels[0]="EnemyWithinMeleeChargeDistance"
}