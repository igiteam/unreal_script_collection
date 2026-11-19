class TurokInventoryAttachment extends ActorComponent
    abstract
    native;

var protected export editinline @NULL mAttachmentMesh;
var private name mAttachmentBone;
var private name mFlareAttachmentSocket;
var private export editinline @NULL mFlareParticleComponent;

// Export UTurokInventoryAttachment::execAttach(FFrame&, void* const)
native function Attach(@NULL OwnerMesh);

// Export UTurokInventoryAttachment::execDetach(FFrame&, void* const)
native function Detach(@NULL OwnerMesh);

// Export UTurokInventoryAttachment::execSetAttachmentMeshVisibility(FFrame&, void* const)
native function SetAttachmentMeshVisibility(bool bVisible);

event SetAttachmentColor()
{
    //return;    
}
