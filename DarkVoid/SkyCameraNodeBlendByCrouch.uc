class SkyCameraNodeBlendByCrouch extends SkyCameraNodeBlendList
    native;

enum ECamBlendByCrouch
{
    CamCrouch_NoCrouch,             // 0
    CamCrouch_Crouch,               // 1
    CamCrouch_MAX                   // 2
};

var deprecated SkyCameraNodeBlendByCrouch.ECamBlendByCrouch CurrentState;
