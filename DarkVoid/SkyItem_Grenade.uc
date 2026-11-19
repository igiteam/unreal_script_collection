class SkyItem_Grenade extends SkyItem_Dynamite
    native
    config(Game);

// Export USkyItem_Grenade::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

simulated function Release()
{
    local SkyProj_Grenade Grenade;
    local bool bOwnerIsAnNPC;

    Grenade = SkyProj_Grenade(HeldItem);
    bOwnerIsAnNPC = Instigator.Controller.IsA('SkyBot') || Instigator.IsA('SkyNPC');
    // End:0x7C
    if((Grenade != none) && !bOwnerIsAnNPC)
    {
        Grenade.StartDetonateTimer();
    }
    super.Release();
    //return;    
}
