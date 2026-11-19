class SkySkelControl_SocketIK extends SkelControlLimb
    native;

var name AttachedSocket;
var export editinline SkeletalMeshComponent AttachedMesh;
var Matrix AttachmentToBaseBoneTM;

// Export USkySkelControl_SocketIK::execSetAttached(FFrame&, void* const)
native function SetAttached(SkeletalMeshComponent Mesh, name Socket);

function Disconnect()
{
    AttachedMesh = none;
    AttachedSocket = 'None';
    //return;    
}
