class EvilAIReactCond_EnemyCanBeMeleed extends EvilAIReactConditionConduit within EvilAIController;

function bool ShouldMeleeCharge(Actor EventInstigator, float RangeToEnemy)
{
    return Outer.CanEngageCharge();
    //return ReturnValue;    
}

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local float RangeToEnemy;
    local bool bResult, bCanEngageMelee;

    RangeToEnemy = VSize(InInstigator.Location - Outer.Pawn.Location);
    // End:0x9A
    if(RangeToEnemy < Outer.EnemyDistance_Melee)
    {
        bResult = true;        
    }
    else
    {
        // End:0xF3
        if((RangeToEnemy < Outer.EnemyDistance_MeleeCharge) && ShouldMeleeCharge(InInstigator, RangeToEnemy))
        {
            bResult = true;
        }
    }
    bCanEngageMelee = Outer.CanEngageMelee();
    // End:0x17C
    if((bResult && bCanEngageMelee) && Outer.IsFiring())
    {
        Outer.OnStopFire();
    }
    // End:0x1CF
    if(!super.ShouldActivate(InInstigator, OriginatingChannel) || !Outer.CanMeleeAttack())
    {
        bResult = false;
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    OutputChannelName="EnemyCanBeMeleed"
    AutoSubscribedChannels[0]="EnemyWithinMeleeChargeDistance"
}