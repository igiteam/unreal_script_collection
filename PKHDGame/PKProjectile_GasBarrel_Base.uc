class PKProjectile_GasBarrel_Base extends EvilProjectile_Bouncing_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_GasBarrel_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    VelocityDampingFactor=0.4000000
    Bounciness=0.3000000
    InitialRotationRate=(Pitch=7000,Yaw=5000,Roll=20000)
    bCanBeDetonatedByDamage=true
    TimeToExplode=3.0000000
    TossZ=400.0000000
    CustomGravityScaling=1.3000000
    MyDamageType=Class'PKDmgType_GasBarrel'
    // Reference: CylinderComponent'Default__PKProjectile_GasBarrel_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'EvilGame.Default__EvilProjectile_Bouncing_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    bProjTarget=true
    CollisionComponent=StaticMesh
}