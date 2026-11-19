class UTScout extends UDKScout
    transient
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    MaxDoubleJumpHeight=85.0000000
    PrototypePawnClass=Class'UTPawn'
    SizePersonFindName="Human"
    PathSizes=/* Array type was not detected. */
    TestJumpZ=322.0000000
    TestGroundSpeed=440.0000000
    NavMeshGen_EntityHalfHeight=44.0000000
    NavMeshGen_StartingHeightOffset=44.0000000
    MaxStepHeight=26.0000000
    MaxJumpHeight=49.0000000
    WalkableFloorZ=0.7800000
    // Reference: CylinderComponent'Default__UTScout.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}