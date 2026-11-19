class SkyCameraNodeBlendByParachute extends SkyCameraNodeBlendList
    native;

enum EBlendByParachute
{
    SCP_None,                       // 0
    SCP_NoParachute,                // 1
    SCP_Parachute,                  // 2
    SCP_MAX                         // 3
};

var SkyCameraNodeBlendByParachute.EBlendByParachute CurrentState;
