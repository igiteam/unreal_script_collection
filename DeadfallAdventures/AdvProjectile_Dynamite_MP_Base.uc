class AdvProjectile_Dynamite_MP_Base extends AdvProjectile_Dynamite_Base
    abstract
    hidecategories(Navigation);

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvProjectile_Dynamite_MP_Base.StaticMesh'
    begin object name=StaticMesh
        ReplacementPrimitive=none
    end object
    Mesh=StaticMesh
    // Reference: CylinderComponent'Default__AdvProjectile_Dynamite_MP_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=StaticMesh
    CollisionComponent=StaticMesh
}