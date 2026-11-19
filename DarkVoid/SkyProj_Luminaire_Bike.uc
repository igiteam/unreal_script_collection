class SkyProj_Luminaire_Bike extends SkyProjectile;

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal, optional Actor Other)
{
    local Vector X;

    // End:0xA3
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && EffectIsRelevant(Location, false, MaxEffectDistance))
    {
        X = Normal(Velocity Cross HitNormal);
        X = Normal(HitNormal Cross X);
        ProjExplosion = Spawn(Class'SkyEmitter', self,, HitLocation, Rotator(X));
        // End:0xA3
        if(ProjExplosion != none)
        {
            ProjExplosion.SetTemplate(ProjExplosionTemplate, true);
        }
    }
    // End:0xBE
    if(ExplosionSound != none)
    {
        PlaySound(ExplosionSound);
    }
    //return;    
}
