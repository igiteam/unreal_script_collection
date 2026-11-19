class RB_Spring extends ActorComponent
    native;

var const export editinline PrimitiveComponent Component1;
var const name BoneName1;
var const export editinline PrimitiveComponent Component2;
var const name BoneName2;
var native const int SceneIndex;
var native const Pointer SpringData;
var native const float TimeSinceActivation;
var const float MinBodyMass;
var() float SpringSaturateDist;
var() float SpringMaxForce;
var() float MaxForceMassRatio;
var() bool bEnableForceMassRatio;
var() InterpCurveFloat SpringMaxForceTimeScale;
var() float DampSaturateVel;
var() float DampMaxForce;

// Export URB_Spring::execSetComponents(FFrame&, void* const)
native function SetComponents(PrimitiveComponent InComponent1, name InBoneName1, Vector Position1, PrimitiveComponent InComponent2, name InBoneName2, Vector Position2);

// Export URB_Spring::execClear(FFrame&, void* const)
native function Clear();
