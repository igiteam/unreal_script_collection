class SkySkelControl_FootPlacement extends SkelControlFootPlacement
    native;

var() Vector FootBone;
var() float NormalBlendToeHeight;
var() float ToeAdjustment;
var() bool bEnableToePlacement;
var() bool bEnableFixing;
var() bool bLogFootMeasurements;
var transient bool bFixed;
var() float MaxCorrectionHeight;
var() float TraceCorrectionHeight;
var() float HyperExtendLen;
var() float UnfixAdjust;
var transient Quat TargetOrient;
var() transient float InterpTime;
var transient float InterpTimer;
var transient Quat FixedOrient;
var transient Vector FixedEffector;
var() Vector Floor;
var() float FloorHeight;
var() float FootVelThreshold;
var transient float FootAnimHeight;
var editoronly transient Vector debugLinePos;
var editoronly transient Vector debugLineDir;
