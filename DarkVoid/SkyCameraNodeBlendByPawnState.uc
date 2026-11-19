class SkyCameraNodeBlendByPawnState extends SkyCameraNodeBlendList
    native;

enum EBlendByPawnState
{
    SCPS_None,                      // 0
    SCPS_Default,                   // 1
    SCPS_PreIntervehic,             // 2
    SCPS_Melee,                     // 3
    SCPS_FreeFall,                  // 4
    SCPS_MAX                        // 5
};

var SkyCameraNodeBlendByPawnState.EBlendByPawnState CurrentState;
