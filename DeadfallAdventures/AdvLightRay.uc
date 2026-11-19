class AdvLightRay extends Actor
    notplaceable
    hidecategories(Navigation);

var() private const export editinline StaticMeshComponent RayMesh;

function SetRayDirection(Vector Dir)
{
    SetRotation(Rotator(Dir));
    //return;    
}

defaultproperties
{
    // Reference: StaticMeshComponent'Default__AdvLightRay.Mesh'
    begin object name=Mesh class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        Scale3D=(X=12.0000000,Y=1.5000000,Z=1.5000000)
    end object
    RayMesh=Mesh
    Components[0]=Mesh
    CollisionComponent=Mesh
}