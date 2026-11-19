class SecretPickup extends SkyBonusPickupFactory;

var(Bonus) int secretId;

event bool BonusIsVaid(SkyPlayerControllerBase C)
{
    // End:0x25
    if(C != none)
    {
        return C.HasSecret(secretId);
    }
    return true;
    //return ReturnValue;    
}

event OnPickupBonus(SkyPlayerControllerBase C)
{
    // End:0x44
    if((C != none) && !C.HasSecret(secretId))
    {
        C.ToggleSecret(secretId);
    }
    //return;    
}
