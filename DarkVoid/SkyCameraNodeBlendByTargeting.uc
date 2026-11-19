class SkyCameraNodeBlendByTargeting extends SkyCameraNodeBlendList
    native;

enum ECamBlendByTargeting
{
    CamTargeting_NoTargeting,       // 0
    CamTargeting_Targeting,         // 1
    CamTargeting_Zooming,           // 2
    CamTargeting_MAX                // 3
};

var bool bTargetingOnRequest;
