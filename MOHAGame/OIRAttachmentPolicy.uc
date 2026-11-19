interface OIRAttachmentPolicy extends Interface
    abstract;

function bool ShouldAttach()
{
    //return ReturnValue;    
}

function bool ShouldCollideWorld()
{
    //return ReturnValue;    
}

function GetAttachData(out Actor out_Actor, optional out SkeletalMeshComponent out_SkelMesh, optional out name out_AttachName)
{
    //return;    
}

function SkeletalMeshComponent.ERootMotionMode GetRootMotionMode()
{
    //return ReturnValue;    
}

function bool UseOIRPhysics()
{
    //return ReturnValue;    
}
