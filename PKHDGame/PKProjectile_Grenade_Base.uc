class PKProjectile_Grenade_Base extends EvilProjectile_Bouncing_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_Grenade_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.9000000
    Bounciness=0.3000000
    StopSimulatingVelocityThreshhold=200.0000000
    InitialRotationRate=(Pitch=7000,Yaw=5000,Roll=20000)
    bAddVelocityFromInstigator=true
    bAddOnlyForwardVelocityFromInstigator=true
    TimeToExplode=2.5000000
    TossZ=300.0000000
    CustomGravityScaling=0.8000000
    Speed=900.0000000
    MaxSpeed=900.0000000
    MyDamageType=Class'PKDmgType_Grenade'
    // Reference: CylinderComponent'Default__PKProjectile_Grenade_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}