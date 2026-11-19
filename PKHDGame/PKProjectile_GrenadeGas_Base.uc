class PKProjectile_GrenadeGas_Base extends PKProjectile_Grenade_Base
    abstract
    hidecategories(Navigation);

var() float GasLifeTime;
var() float GasDamage;
var() float GasDamageInterval;

simulated function ShutDown()
{
    super(EvilProjectile_Base).ShutDown();
    // End:0x66
    if((bWaitForEffects && !bNetTemporary) && !bInWater)
    {
        LifeSpan = GasLifeTime;
        SetTimer(GasDamageInterval, true, 'DoGasDamage');        
    }
    //return;    
}

simulated function DoGasDamage()
{
    local PKPawn Other;

    // End:0xFE
    foreach OverlappingActors(Class'PKPawn', Other, ExplosionArchetype.DamageRadius,, true)
    {
        // End:0xFD
        if(Other.IsAliveAndWell())
        {
            Other.TakeDamage(int(GasDamage), Instigator.Controller, Other.Location, Normal(Other.Location - Location), MyDamageType,, self);
        }        
    }    
    //return;    
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
    // End:0x72
    if(PSC == ProjEffects)
    {
        DetachComponent(ProjEffects);
        WorldInfo.MyEmitterPool.OnParticleSystemFinished(ProjEffects);
        ProjEffects = none;
    }
    //return;    
}

defaultproperties
{
    GasLifeTime=3.0000000
    GasDamage=8.0000000
    GasDamageInterval=0.0660000
    // Reference: StaticMeshComponent'Default__PKProjectile_GrenadeGas_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'Default__PKProjectile_Grenade_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    MyDamageType=Class'PKDmgType_GrenadeGas'
    // Reference: CylinderComponent'Default__PKProjectile_GrenadeGas_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKProjectile_Grenade_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}