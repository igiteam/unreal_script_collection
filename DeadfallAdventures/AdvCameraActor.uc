class AdvCameraActor extends CameraActor
    native(Camera)
    hidecategories(Navigation);

struct native CameraLimits
{
    var() float MinYaw;
    var() float MaxYaw;
    var() float MinPitch;
    var() float maxPitch;

    structdefaultproperties
    {
        MinYaw=0.0000000
        MaxYaw=0.0000000
        MinPitch=0.0000000
        maxPitch=0.0000000
    }
};

var() interp CameraLimits Limits;
var export editinline transient SkeletalMeshComponent FakePlayerMesh;
var transient Vector BlendedViewLocation;
var transient Rotator BlendedViewRotation;
var transient Vector MatineeViewLocation;
var transient Rotator MatineeViewRotation;
var transient float InterpolationAlpha;
var transient bool bHasBlendedData;
var transient bool bAllowAutomaticVisibility;
var transient bool bAllowMeshAdjustment;
var transient bool bAdvancedBlend;

// Export UAdvCameraActor::execApplyLimits(FFrame&, void* const)
native final function ApplyLimits(out Rotator out_Rotation);

// Export UAdvCameraActor::execAdjustInterpolatedMeshes(FFrame&, void* const)
native final function AdjustInterpolatedMeshes(Vector NewViewLocation, Rotator NewViewRotation);

// Export UAdvCameraActor::execResetInterpolatedMeshes(FFrame&, void* const)
native final function ResetInterpolatedMeshes();

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    local SkeletalMeshActor SMA;

    // End:0x36
    if(bAdvancedBlend)
    {
        out_Location = MatineeViewLocation;
        out_Rotation = MatineeViewRotation;        
    }
    else
    {
        super(Actor).GetActorEyesViewPoint(out_Location, out_Rotation);
        SMA = SkeletalMeshActor(Base);
        // End:0x12A
        if((SMA != none) && bAllowMeshAdjustment)
        {
            out_Location -= (SMA.SkeletalMeshComponent.Translation >> SMA.Rotation);
            out_Rotation -= SMA.SkeletalMeshComponent.Rotation;
        }
    }
    //return;    
}

event BecomeViewTarget(PlayerController PC)
{
    super(Actor).BecomeViewTarget(PC);
    InterpolationAlpha = 1.0000000;
    //return;    
}

defaultproperties
{
    Limits=(MinYaw=-30.0000000,MaxYaw=30.0000000,MinPitch=-30.0000000,maxPitch=30.0000000)
    InterpolationAlpha=1.0000000
    TickGroup=ETickingGroup.TG_PostAsyncWork
}