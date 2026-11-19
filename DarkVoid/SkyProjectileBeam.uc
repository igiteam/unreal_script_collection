class SkyProjectileBeam extends SkyProjectile
    native;

var Vector ColorLevel;
var Vector ExplosionColor;

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    // End:0x87
    if(Other != Instigator)
    {
        // End:0x87
        if(!Other.IsA('Projectile') || Other.bProjTarget)
        {
            Other.TakeDamage(int(Damage), InstigatorController, HitLocation, Normal(Velocity), MyDamageType,, self);
            Explode(HitLocation, HitNormal);
        }
    }
    //return;    
}

// Export USkyProjectileBeam::execHitWall(FFrame&, void* const)
native simulated function HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp, optional int Item);

simulated function SpawnFlightEffects()
{
    super.SpawnFlightEffects();
    //return;    
}

simulated function SetExplosionEffectParameters(ParticleSystemComponent ProjExpl)
{
    ProjExpl.SetVectorParameter('LinkImpactColor', ExplosionColor);
    //return;    
}
