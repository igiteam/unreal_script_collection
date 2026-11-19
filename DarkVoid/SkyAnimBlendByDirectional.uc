class SkyAnimBlendByDirectional extends SkyAnimBlendBase
    native;

enum EAnimBBDVectorType
{
    BBDVectorType_Pawn,             // 0
    BBDVectorType_FloorUp,          // 1
    BBDVectorType_Velocity,         // 2
    BBDVectorType_Camera,           // 3
    BBDVectorType_WorldUp,          // 4
    BBDVectorType_HitDirection,     // 5
    BBDVectorType_MAX               // 6
};

struct native AnimBDDDef
{
    var() name Name;
    var() float Degrees;
    var() float Bias;

    structdefaultproperties
    {
        Name="None"
        Degrees=0.0000000
        Bias=0.0000000
    }
};

var() editfixedsize array<AnimBDDDef> Directions;
var() SkyAnimBlendByDirectional.EAnimBBDVectorType DirectionalVectorType;
var() SkyAnimBlendByDirectional.EAnimBBDVectorType ReferenceVectorType;
var() SkyAnimBlendByDirectional.EAnimBBDVectorType UpVectorType;
var() float DirDegreesPerSecond;
var() bool bSkipUpdateDuringTransition;
var() bool bSkipUpdateForZeroDirection;
var() bool bSnapOnBecomeRelevant;
var() bool bFlattenVectors;
var() bool bUsePawnDirAngle;
var() float MaxBlendRate;
var transient float DirAngle;
var transient int TargetChild0;
var transient int TargetChild1;
var transient float TargetWeight0;
var transient float TargetWeight1;
