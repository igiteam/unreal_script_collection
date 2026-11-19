class RB_Handle extends ActorComponent
    native
    collapsecategories
    hidecategories(Object);

var export editinline PrimitiveComponent GrabbedComponent;
var name GrabbedBoneName;
var native const int SceneIndex;
var native const Pointer HandleData;
var native const Pointer KinActorData;
var native const bool bRotationConstrained;
var bool bInterpolating;
var() float LinearDamping;
var() float LinearStiffness;
var() float AngularDamping;
var() float AngularStiffness;
var Vector Destination;
var Vector StepSize;
var Vector Location;

// Export URB_Handle::execGrabComponent(FFrame&, void* const)
native function GrabComponent(PrimitiveComponent Component, name InBoneName, Vector GrabLocation, bool bConstrainRotation);

// Export URB_Handle::execReleaseComponent(FFrame&, void* const)
native function ReleaseComponent();

// Export URB_Handle::execSetLocation(FFrame&, void* const)
native function SetLocation(Vector NewLocation);

// Export URB_Handle::execSetSmoothLocation(FFrame&, void* const)
native function SetSmoothLocation(Vector NewLocation, float MoveTime);

// Export URB_Handle::execSetOrientation(FFrame&, void* const)
native function SetOrientation(Quat NewOrientation);
