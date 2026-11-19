class BlueprintPickup extends SkyBonusPickupFactory;

var(Bonus) name WeaponType;
var(Bonus) int BlueprintId;

event bool BonusIsVaid(SkyPlayerControllerBase C)
{
    // End:0x2A
    if(C != none)
    {
        return C.HasBlueprint(BlueprintId, WeaponType);
    }
    return true;
    //return ReturnValue;    
}

event OnPickupBonus(SkyPlayerControllerBase C)
{
    // End:0x29
    if(C != none)
    {
        C.FoundBlueprint(BlueprintId, WeaponType);
    }
    //return;    
}
