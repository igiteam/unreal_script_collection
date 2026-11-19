class SkyWeap_WatcherMelee extends SkyWeapon
    native
    config(Pawn);

var() config float SwipeDamage;
var() config float PounceDamage;

// Export USkyWeap_WatcherMelee::execHasAnyAmmo(FFrame&, void* const)
native simulated function bool HasAnyAmmo();

function bool IsMeleeWeapon()
{
    return true;
    //return ReturnValue;    
}

simulated function DrawAmmoCount(HUD H)
{
    //return;    
}

function DoSwipeDamage(Actor Target, Vector HitLocation, float DamageScale)
{
    local Vector DamageMomentum;

    DamageMomentum = Normal(Target.Location - Instigator.Location);
    Target.TakeDamage(int(SwipeDamage * DamageScale), Instigator.Controller, HitLocation, DamageMomentum, Class'SkyDmgType_WatcherMelee',, self);
    //return;    
}

function DoPounceDamage(Actor Target, Vector HitLocation, float DamageScale)
{
    local Vector DamageMomentum;

    DamageMomentum = Normal(Target.Location - Instigator.Location);
    Target.TakeDamage(int(PounceDamage * DamageScale), Instigator.Controller, HitLocation, DamageMomentum, Class'SkyDmgType_WatcherMelee',, self);
    //return;    
}
