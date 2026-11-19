class SkyCameraNodeBlendByYaw extends SkyCameraNodeBlendList
    native;

enum EBlendByYaw
{
    BBY_RelativeToPawn,             // 0
    BBY_RelativeToWorld,            // 1
    BBY_RelativeToCover,            // 2
    BBY_MAX                         // 3
};

var() SkyCameraNodeBlendByYaw.EBlendByYaw eRelativeTo;
var editoronly bool bForceModifyChildren;
