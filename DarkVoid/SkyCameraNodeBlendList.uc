class SkyCameraNodeBlendList extends SkyCameraNodeBlendListBase
    abstract
    native;

struct native s_SkyBlendAtom
{
    var() SkyCameraTreeObject.BlendFunctions BlendType;
    var() float BlendExponent;
    var() float BlendTimeRatio;
    var() SkyCameraTreeObject.SKYCAMERA_MOVEMENT_TYPE LerpType;

    structdefaultproperties
    {
        BlendType=SCBLEND_Linear
        BlendExponent=0.0000000
        BlendTimeRatio=0.0000000
        LerpType=SKYCAMERA_MOVEMENT_TYPE_LERP
    }
};

struct native SCustomBlends
{
    var() int FromChild;
    var() float BlendTime;

    structdefaultproperties
    {
        FromChild=0
        BlendTime=0.2000000
    }
};

struct native SkyCameraBlendInfo
{
    var() float BlendUpTime;
    var() float BlendDownTime;
    var() array<SCustomBlends> CustomBlendTimes;

    structdefaultproperties
    {
        BlendUpTime=0.2000000
        BlendDownTime=0.2000000
        CustomBlendTimes=none
    }
};

var() s_SkyBlendAtom MovementBlend;
var() s_SkyBlendAtom ConstraintBlend;
var() s_SkyBlendAtom FocusBlend;
var() s_SkyBlendAtom FocusConstraintBlend;
var() s_SkyBlendAtom UpBlend;
var() s_SkyBlendAtom PivotBlend;
var() s_SkyBlendAtom PivotConstraintBlend;
var deprecated s_SkyBlendAtom SafeLocBlend;
var deprecated s_SkyBlendAtom SafeLocConstraintBlend;
var(BlendInfo) array<SkyCameraBlendInfo> BlendInfo;

// Export USkyCameraNodeBlendList::execSetActiveChild(FFrame&, void* const)
native function SetActiveChild(int ChildIndex, float BlendTime);
