class SkyCameraNodeFlightTakeOff extends SkyCameraNodeBlendList
    native;

enum EBlendByFlightTakeOff
{
    SCTO_None,                      // 0
    SCTO_Landed,                    // 1
    SCTO_Flying,                    // 2
    SCTO_MAX                        // 3
};

var SkyCameraNodeFlightTakeOff.EBlendByFlightTakeOff CurrentState;
