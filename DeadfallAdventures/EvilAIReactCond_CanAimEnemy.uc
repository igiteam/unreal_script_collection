class EvilAIReactCond_CanAimEnemy extends EvilAIReactCond_CanShootEnemy within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local bool bActCond, bResult;

    bActCond = Outer.MyEvilPawn.HasRangedAttack();
    switch(OriginatingChannel.ChannelName)
    {
        // End:0xF7
        case 'EnemyCloseToThrowLine':
            bActCond = (bActCond && Outer.CanThrowGrenade()) || Outer.CanThrowAttack() && Outer.bShouldThrowWeapon;
            // End:0x10C
            break;
        // End:0x106
        case 'EnemyCloseToFireLine':
            // End:0x10C
            break;
        // End:0xFFFF
        default:
            // End:0x10C
            break;
            break;
    }
    bResult = bActCond && super.ShouldActivate(InInstigator, OriginatingChannel);
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bCheckSouldStartShootAttack=false
}