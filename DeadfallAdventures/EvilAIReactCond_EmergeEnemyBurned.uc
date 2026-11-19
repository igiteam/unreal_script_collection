class EvilAIReactCond_EmergeEnemyBurned extends EvilAIReactCond_EmergeEnemy within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local EvilAIReactChan_Damage DamageChan;
    local float FrozenAmount;

    // End:0xDC
    if(super.ShouldActivate(InInstigator, OriginatingChannel))
    {
        DamageChan = EvilAIReactChan_Damage(OriginatingChannel);
        // End:0xDC
        if((((DamageChan != none) && Outer.MyEvilPawn.IsFrozen(FrozenAmount)) && FrozenAmount < 0.9000000) && DamageChan.DamageType.default.bIsLightDmgType)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    AutoSubscribedChannels[0]="Damage"
}