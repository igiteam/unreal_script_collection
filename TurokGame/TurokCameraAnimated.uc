class TurokCameraAnimated extends TurokCameraBase
    native;

var transient bool mbUseAnimCam;
var transient @NULL mPawnAttachedTo;
var private transient @NULL mCamera;
var private export editinline transient @NULL mAnimCamMesh;
var private transient @NULL mCameraMeshTree;
var private transient @NULL mAnimController;
var bool mUpdateControllerRotation;

// Export UTurokCameraAnimated::execInit(FFrame&, void* const)
native function Init();

// Export UTurokCameraAnimated::execPlayTransitionGraph(FFrame&, void* const)
native function PlayTransitionGraph(@NULL TurokCam, @NULL graph, @NULL attachTo, @NULL camAttachment, @NULL aiInterface);

// Export UTurokCameraAnimated::execTickCameraAnim(FFrame&, void* const)
native function TickCameraAnim();

// Export UTurokCameraAnimated::execFinishCamera(FFrame&, void* const)
native function FinishCamera();

// Export UTurokCameraAnimated::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__TurokCameraAnimated.MeshComponent'
    begin object name=MeshComponent class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'CinematicCameraMesh.CameraBox'
        bUpdateSkelWhenNotRendered=true
        HiddenGame=true
        CastShadow=false
    end object
    mAnimCamMesh=MeshComponent
    mUpdateControllerRotation=true
}