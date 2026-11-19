class SkyCameraNodeBlendByCoverMovement extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByCoverMovement
{
    CameraBlendByCoverMovement_None,// 0
    CameraBlendByCoverMovement_LeftLast,// 1
    CameraBlendByCoverMovement_RightLast,// 2
    CameraBlendByCoverMovement_MovingLeft,// 3
    CameraBlendByCoverMovement_MovingRight,// 4
    CameraBlendByCoverMovement_MAX  // 5
};

var SkyCameraNodeBlendByCoverMovement.ECameraBlendByCoverMovement eLastMovement;
