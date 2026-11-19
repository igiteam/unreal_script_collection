//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSkeletalMeshCinematicActor extends SkeletalMeshCinematicActor
placeable;

var() SkeletalMesh          AttachMesh;
var   SkeletalMeshComponent AttachComp;
var() name SocketName;

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();

    if(AttachMesh != none && SocketName != '')
    {
        AttachComp.SetSkeletalMesh(AttachMesh);
        SkeletalMeshComponent.AttachComponentToSocket(AttachComp, SocketName);
        AttachComp.SetShadowParent(SkeletalMeshComponent);
    }
}

