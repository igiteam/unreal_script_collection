class EvilScout extends UDKScout
    transient
    native
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    MaxDoubleJumpHeight=85.0000000
    PrototypePawnClass=Class'EvilPawn'
    SizePersonFindName="Human"
    PathSizes=/* Array type was not detected. */
    TestJumpZ=0.0000000
    TestGroundSpeed=440.0000000
    NavMeshGen_EntityHalfHeight=44.0000000
    NavMeshGen_StartingHeightOffset=44.0000000
    NavMeshGen_MaxDropHeight=80.0000000
    NavMeshGen_MaxPolyHeight=600.0000000
    NavMeshGen_ExpansionDoObstacleMeshSimplification=false
    MaxStepHeight=20.0000000
    MaxJumpHeight=30.0000000
    WalkableFloorZ=0.7400000
    // Reference: CylinderComponent'Default__EvilScout.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UDKBase.Default__UDKScout.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionRadius=30.0000000
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}