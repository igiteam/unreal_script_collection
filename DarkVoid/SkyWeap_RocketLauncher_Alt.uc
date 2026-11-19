class SkyWeap_RocketLauncher_Alt extends SkyWeapon
    config(Game);

var(Projectiles) SkyProjectile StageOneProjectile;
var(Projectiles) SkyProjectile StageTwoProjectile;

simulated function SkyProjectile GetProjectileArchetype()
{
    // End:0x14
    if(UpgradeStage == 1)
    {
        return StageOneProjectile;        
    }
    else
    {
        // End:0x26
        if(UpgradeStage == 2)
        {
            return StageTwoProjectile;
        }
    }
    return super.GetProjectileArchetype();
    //return ReturnValue;    
}
