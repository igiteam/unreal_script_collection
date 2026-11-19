class EvilNavMeshGoal extends StaticMeshActor
    hidecategories(Navigation);

var bool DisableAutoDestory;

function DelayedDestroy()
{
    Destroy();
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__EvilNavMeshGoal.StaticMeshComponent0'
    begin object name=StaticMeshComponent0
        StaticMesh=none
        ReplacementPrimitive=none
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
        BlockRigidBody=false
        Scale3D=(X=0.2000000,Y=0.2000000,Z=0.2000000)
    end object
    StaticMeshComponent=StaticMeshComponent0
    Components[0]=StaticMeshComponent0
    bStatic=false
    bWorldGeometry=false
    bMovable=true
    bCollideActors=false
    bBlockActors=false
    CollisionComponent=StaticMeshComponent0
}