class EvilAnim_TurnInPlace_Player extends AnimNodeSequenceBlendBase
    native(Anim)
    hidecategories(Object,Object,Object);

struct native TIP_Transition
{
    var() name TransName;
    var() name AnimName;
    var() bool bBottomHalfOnly;

    structdefaultproperties
    {
        TransName="None"
        AnimName="None"
        bBottomHalfOnly=false
    }
};

var() array<TIP_Transition> TIP_Transitions;
var() float TransitionBlendTime;
var transient int ActiveChildIndex;
var transient float BlendTimeToGo;
var AnimNodeBlendPerBone TurnInPlaceSlot;

defaultproperties
{
    TIP_Transitions[0]=(TransName="Rt_90",AnimName="AR_Idle_Ready_Turn_Rt_90",bBottomHalfOnly=false)
    TIP_Transitions[1]=(TransName="Rt_180",AnimName="AR_Idle_Ready_Turn_Rt_180",bBottomHalfOnly=false)
    TIP_Transitions[2]=(TransName="Lt_90",AnimName="AR_Idle_Ready_Turn_Lt_90",bBottomHalfOnly=false)
    TIP_Transitions[3]=(TransName="Lt_180",AnimName="AR_Idle_Ready_Turn_Lt_180",bBottomHalfOnly=false)
    TransitionBlendTime=0.3300000
    RootRotationOption[0]=ERootRotationOption.RRO_Discard
    RootRotationOption[1]=ERootRotationOption.RRO_Discard
    RootRotationOption[2]=ERootRotationOption.RRO_Discard
}