class SPHeadTrackComponent extends HeadTrackComponent
    native;

enum LookAtMode
{
    LookAtModeDisabled,             // 0
    LookAtModeAIControlled,         // 1
    LookAtModeDesignerSpecified,    // 2
    LookAtMode_MAX                  // 3
};

enum LookAtPart
{
    LookAtPartDefault,              // 0
    LookAtPartBone,                 // 1
    LookAtPartSocket,               // 2
    LookAtPart_MAX                  // 3
};

struct native LookAtInfo
{
    var() SPHeadTrackComponent.LookAtMode Mode;
    var() SPHeadTrackComponent.LookAtPart Part;
    /** Only valid if Part is set to LookAtPartBone */
    var() name PartBone;
    /** Only valid if Part is set to LookAtPartSocket */
    var() name PartSocket;

    structdefaultproperties
    {
        Mode=LookAtModeDesignerSpecified
        Part=LookAtPartDefault
        PartBone="None"
        PartSocket="None"
    }
};

var const name HeadLookAtControlName;
var const name LeftEyeLookAtControlName;
var const name RightEyeLookAtControlName;
var const name CameraBoneName;
var const name HeadBoneName;
var const name HipBoneName;
var transient LookAtInfo LookInfo;
var transient Actor LookAtActor;
var transient bool LookAtEnabled;
var transient bool LookAtAnimEnabled;
var transient bool m_GlobalTurnOffHeadTracking;
var transient bool bInitizlized;
var bool bCanSwicthAnimTree;
var transient array<SPAnimNodeSequence> LookAtDisabledAnims;
var transient SPAIController Controller;
var transient SPPawn Pawn;
var export editinline transient SkeletalMeshComponent Mesh;
var AnimTree lastAnimTree;
var transient SkelControlLookAt HeadLookAt;
var transient SkelControlLookAt LeftEyeLookAt;
var transient SkelControlLookAt RightEyeLookAt;

// Export USPHeadTrackComponent::execLookAtConsoleEnabled(FFrame&, void* const)
native function bool LookAtConsoleEnabled();

// Export USPHeadTrackComponent::execShowingLookAt(FFrame&, void* const)
native function bool ShowingLookAt();

// Export USPHeadTrackComponent::execGetAdjustedHeadLookAtPos(FFrame&, void* const)
native function Vector GetAdjustedHeadLookAtPos(const out Vector lookAtPos);

// Export USPHeadTrackComponent::execGetSpecifiedLookAtSkelControl(FFrame&, void* const)
native function SkelControlLookAt GetSpecifiedLookAtSkelControl(name SkelControlName);

// Export USPHeadTrackComponent::execLookAtActorBone(FFrame&, void* const)
native function bool LookAtActorBone(Actor actorToLookAt, name BoneName, out Vector whereToLook);

// Export USPHeadTrackComponent::execLookAtActorSocket(FFrame&, void* const)
native function bool LookAtActorSocket(Actor actorToLookAt, name SocketName, out Vector whereToLook);

// Export USPHeadTrackComponent::execGetMesh(FFrame&, void* const)
native function SkeletalMeshComponent GetMesh(Actor actorToLookAt);

// Export USPHeadTrackComponent::execLookAtActorDefault(FFrame&, void* const)
native function bool LookAtActorDefault(Actor actorToLookAt, out Vector whereToLook);

// Export USPHeadTrackComponent::execDoDesignerSpecifiedLookAt(FFrame&, void* const)
native function bool DoDesignerSpecifiedLookAt(out Vector whereToLook);

// Export USPHeadTrackComponent::execEnableSpecifiedLookAt(FFrame&, void* const)
native function EnableSpecifiedLookAt(SkelControlLookAt Control, bool Enable);

// Export USPHeadTrackComponent::execEnableLookAt(FFrame&, void* const)
protected native function EnableLookAt(bool Enable);

// Export USPHeadTrackComponent::execSetLookAtPos(FFrame&, void* const)
native function SetLookAtPos(Vector lookAtPos);

// Export USPHeadTrackComponent::execIsHeadTrackingDisable(FFrame&, void* const)
native function bool IsHeadTrackingDisable();

// Export USPHeadTrackComponent::execDetermineWhatToLookAt(FFrame&, void* const)
protected native function DetermineWhatToLookAt();

// Export USPHeadTrackComponent::execDoTick(FFrame&, void* const)
native function DoTick(float DeltaTime);

event Init()
{
    // End:0x0B
    if(bInitizlized)
    {
        return;
    }
    Mesh = none;
    Pawn = SPPawn(Owner);
    // End:0x45
    if(Pawn != none)
    {
        Mesh = Pawn.Mesh;        
    }
    else
    {
        Mesh = Owner.GetSkeletalMeshComponent();
    }
    GetLookAtSkelControls(HeadLookAt, LeftEyeLookAt, RightEyeLookAt);
    EnableLookAt(true);
    lastAnimTree = none;
    bInitizlized = true;
    //return;    
}

protected function GetLookAtSkelControls(out SkelControlLookAt headControl, out SkelControlLookAt leftEyeControl, out SkelControlLookAt rightEyeControl)
{
    headControl = GetSpecifiedLookAtSkelControl(HeadLookAtControlName);
    leftEyeControl = GetSpecifiedLookAtSkelControl(LeftEyeLookAtControlName);
    rightEyeControl = GetSpecifiedLookAtSkelControl(RightEyeLookAtControlName);
    //return;    
}

event UpdateLookAtControls(float DeltaTime)
{
    // End:0x20
    if(HeadLookAt != none)
    {
        HeadLookAt.InterpolateTargetLocation(DeltaTime);
    }
    // End:0x40
    if(LeftEyeLookAt != none)
    {
        LeftEyeLookAt.InterpolateTargetLocation(DeltaTime);
    }
    // End:0x60
    if(RightEyeLookAt != none)
    {
        RightEyeLookAt.InterpolateTargetLocation(DeltaTime);
    }
    //return;    
}

defaultproperties
{
    HeadLookAtControlName="HeadLookAt"
    LeftEyeLookAtControlName="LeftEyeLookAt"
    RightEyeLookAtControlName="RightEyeLookAt"
    CameraBoneName="JO_camera"
    HeadBoneName="JO_head"
    HipBoneName="JO_Hip"
    LookInfo=(Mode=LookAtModeAIControlled,Part=LookAtPartDefault,PartBone="None",PartSocket="None")
    LookAtAnimEnabled=true
}