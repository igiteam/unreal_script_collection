class PlayerPawnMPPersistent extends PlayerPawn
    native
    config(Game);

var PlayerPawnMPPersistent MasterPawn;
var PlayerPawnMPPersistent SlavePawn;

// Export UPlayerPawnMPPersistent::execSetMasterPawn(FFrame&, void* const)
native function SetMasterPawn(PlayerPawnMPPersistent Master);

k2override function ServerOnlyTakeDamageFromSlave(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

simulated function TakeRadiusDamageFromSlave(Controller instigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser)
{
    //return;    
}

event bool ActorCannotHitMe(const Actor Other)
{
    local Projectile theProjectile;

    // End:0x26
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        return super.ActorCannotHitMe(Other);
    }
    theProjectile = Projectile(Other);
    // End:0x43
    if(theProjectile == none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}
