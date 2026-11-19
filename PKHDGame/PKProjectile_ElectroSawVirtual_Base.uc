class PKProjectile_ElectroSawVirtual_Base extends PKProjectile_ElectroSaw_Base
    abstract
    hidecategories(Navigation);

singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
    super(Actor).HitWall(HitNormal, Wall, WallComp);
    //return;    
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__PKProjectile_ElectroSawVirtual_Base.StaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMesh'
    // Archetype: StaticMeshComponent'Default__PKProjectile_ElectroSaw_Base.StaticMesh'
    begin object name="StaticMesh"
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    TimeToExplode=0.0000000
    Speed=0.0000000
    MaxSpeed=0.0000000
    // Reference: CylinderComponent'Default__PKProjectile_ElectroSawVirtual_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKProjectile_ElectroSaw_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    LifeSpan=0.0000000
    CollisionComponent=CollisionCylinder
}