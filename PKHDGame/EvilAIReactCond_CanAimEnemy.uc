class EvilAIReactCond_CanAimEnemy extends EvilAIReactCond_CanShootEnemy within EvilAIController;

function bool ShouldActivate(Actor InInstigator, EvilAIReactChannel OriginatingChannel)
{
    local bool bActCond;

    bActCond = Outer.MyEvilPawn.HasRangedAttack() && !Outer.IsAiming();
    switch(OriginatingChannel.ChannelName)
    {
        // End:0x11D
        case 'EnemyCloseToThrowLine':
            bActCond = (bActCond && Outer.CanThrowGrenade()) || Outer.CanThrowAttack() && Outer.bShouldThrowWeapon;
            // End:0x132
            break;
        // End:0x12C
        case 'EnemyCloseToFireLine':
            // End:0x132
            break;
        // End:0xFFFF
        default:
            // End:0x132
            break;
            break;
    }
    return bActCond && super.ShouldActivate(InInstigator, OriginatingChannel);
    //return ReturnValue;    
}
