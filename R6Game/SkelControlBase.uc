class SkelControlBase extends Object
    abstract
    native
    hidecategories(Object);

enum EBoneControlSpace
{
    BCS_WorldSpace,                 // 0
    BCS_ActorSpace,                 // 1
    BCS_ComponentSpace,             // 2
    BCS_ParentBoneSpace,            // 3
    BCS_BoneSpace,                  // 4
    BCS_OtherBoneSpace,             // 5
    BCS_MAX                         // 6
};

var(Controller) name ControlName;
var transient float ControlStrength;
var(Controller) float m_fMaxControlStrength;
var(Controller) float BlendInTime;
var(Controller) float BlendOutTime;
var transient float StrengthTarget;
var transient float BlendTimeToGo;
var transient bool bActive;
var transient bool bInitalized;
var transient bool bInitializedCachedNodeList;
var(Controller) bool bSetStrengthFromAnimNode;
var(Controller) bool bPropagateSetActive;
var() bool m_bEvaluateSecondPass;
var(Controller) array<name> StrengthAnimNodeNameList;
var array<AnimNode> CachedNodeList;
var(Controller) float BoneScale;
var int m_iControlTickStatus;
var SkelControlBase NextControl;
var int ControlPosX;
var int ControlPosY;
var int DrawWidth;
var() int m_iDisableLOD;

// Export USkelControlBase::execSetSkelControlActive(FFrame&, void* const)
native final function SetSkelControlActive(bool bInActive);

defaultproperties
{
    ControlStrength=1.0000000
    m_fMaxControlStrength=1.0000000
    BlendInTime=0.2000000
    BlendOutTime=0.2000000
    StrengthTarget=1.0000000
    bActive=true
    BoneScale=1.0000000
}