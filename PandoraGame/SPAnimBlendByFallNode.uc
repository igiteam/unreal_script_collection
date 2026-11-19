class SPAnimBlendByFallNode extends SPAnimBaseNode
    native;

enum EBlendFallTypes
{
    FBT_Up,                         // 0
    FBT_Down,                       // 1
    FBT_PreLand,                    // 2
    FBT_Land,                       // 3
    FBT_None,                       // 4
    FBT_MAX                         // 5
};

var bool bDodgeFall;
var const SPAnimBlendByFallNode.EBlendFallTypes FallState;
var const float LastFallingVelocity;
var() transient int m_editorChildSelect;
