class EvilProjectile_Tracer_Base extends EvilProjectile_Base
    hidecategories(Navigation);

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    //return;    
}

function Init(Vector Direction)
{
    SetHidden(false);
    super.Init(Direction);
    Enable('Tick');
    Tick(0.0000000);
    //return;    
}

function Recycle()
{
    SetHidden(true);
    SetPhysics(0);
    ClearTimer('WakeProjectile');
    Disable('Tick');
    //return;    
}

defaultproperties
{
    CustomGravityScaling=0.2000000
    Speed=8000.0000000
    MaxSpeed=8000.0000000
    MyDamageType=none
    // Reference: CylinderComponent'Default__EvilProjectile_Tracer_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilProjectile_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Physics=EPhysics.PHYS_Falling
    RemoteRole=ENetRole.ROLE_None
    LifeSpan=1.0000000
    CollisionComponent=CollisionCylinder
}