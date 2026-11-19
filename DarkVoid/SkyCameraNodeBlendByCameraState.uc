class SkyCameraNodeBlendByCameraState extends SkyCameraNodeBlendList
    native;

enum EBlendByCameraState
{
    CamBlendByCameraState_Pawn,     // 0
    CamBlendByCameraState_Vehicle,  // 1
    CamBlendByCameraState_Hijack,   // 2
    CamBlendByCameraState_MAX       // 3
};

var SkyCameraNodeBlendByCameraState.EBlendByCameraState CamBlendByCameraState_Pawn;
