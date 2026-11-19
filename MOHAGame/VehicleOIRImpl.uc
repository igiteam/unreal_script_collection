class VehicleOIRImpl extends SpawnInOIRImpl
    hidecategories(Object);

var Pawn TargetPawn;
var name AttachmentSocket;
var export editinline SkeletalMeshComponent AttachmentMesh;

function OIRData GetOIRData()
{
    AttachmentMesh.GetSocketWorldLocationAndRotation(AttachmentSocket, oir.OIRPosition, oir.OIRRotation);
    return oir;
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    out_Actor = Actor(OwningObject);
    out_SkelMesh = AttachmentMesh;
    out_AttachName = AttachmentSocket;
    //return;    
}

function SetupVehicleOIR(AnimSet OIRAnimSet, AnimTree OIRAnimTree, name AttachSocket, SkeletalMeshComponent AttachMesh)
{
    oir.OIRAnimSet = OIRAnimSet;
    oir.OIRAnimTree = OIRAnimTree;
    AttachmentSocket = AttachSocket;
    AttachmentMesh = AttachMesh;
    AttachmentMesh.GetSocketWorldLocationAndRotation(AttachmentSocket, oir.OIRPosition, oir.OIRRotation);
    //return;    
}

function InvokeAnimation(name activity, optional Pawn Target)
{
    super.InvokeAnimation(activity, TargetPawn);
    //return;    
}

function InitBrainState(AxonBrainState Abs)
{
    // End:0x3E
    if(OIRBrainState(Abs) != none)
    {
        OIRBrainState(Abs).OIROwningObject = OwningObject;
        OIRBrainState(Abs).SImpl = self;
    }
    //return;    
}
