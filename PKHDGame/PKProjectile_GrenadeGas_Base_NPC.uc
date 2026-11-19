class PKProjectile_GrenadeGas_Base_NPC extends PKProjectile_Grenade_Base
    abstract
    hidecategories(Navigation);

var() float GasLifeTime;
var() float GasDamage;
var() float GasDamageInterval;
var Vector InitDirection;

function Init(Vector Direction)
{
    super(EvilProjectile_Bouncing_Base).Init(Direction);
    InitDirection = Direction;
    SetTimer(GasDamageInterval, true, 'DoGasDamage');
    //return;    
}

simulated event Landed(Vector HitNormal, Actor FloorActor)
{
    super(EvilProjectile_Base).Landed(HitNormal, FloorActor);
    //return;    
}

simulated function ShutDown()
{
    //return;    
}

simulated function Explode(Vector HitLocation, Vector HitNormal)
{
    //return;    
}

simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal)
{
    //return;    
}

simulated function DoGasDamage()
{
    local PKPawn Other;

    // End:0x11
    if(ProjEffects == none)
    {
        return;
    }
    // End:0x10F
    foreach OverlappingActors(Class'PKPawn', Other, ExplosionArchetype.DamageRadius,, true)
    {
        // End:0x10E
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

simulated function Tick(float DeltaTime)
{
    super(EvilProjectile_Bouncing_Base).Tick(DeltaTime);
    // End:0x91
    if(int(Physics) == int(6))
    {
        Mesh.SetRotation(Mesh.Rotation + MakeRotator(int((182.0444000 * float(270)) * DeltaTime), 0, 0));        
    }
    else
    {
        // End:0x13F
        if(int(Physics) == int(0))
        {
            SetPhysics(6);
            Mesh.SetRotation(Mesh.Rotation + MakeRotator(0, 0, int(182.0444000 * float(20))));
            Velocity = InitDirection * 16.0000000;
            Velocity.Z = 0.0000000;
        }
    }
    //return;    
}

defaultproperties
{
    GasLifeTime=5.0000000
    GasDamage=2.0000000
    GasDamageInterval=1.0000000
    // Reference: StaticMeshComponent'Default__PKProjectile_GrenadeGas_Base_NPC.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'Default__PKProjectile_Grenade_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    TimeToExplode=10.0000000
    MyDamageType=Class'PKDmgType_Gas'
    // Reference: CylinderComponent'Default__PKProjectile_GrenadeGas_Base_NPC.CollisionCylinder'
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