class SkySeqAct_AIStartFireAt extends SequenceAction;

enum FiringCommand
{
    FC_ShootFromHip,                // 0
    FC_ShootFromFocusAim,           // 1
    FC_NoShootNoFocusAim,           // 2
    FC_NoShootFocusAim,             // 3
    FC_MAX                          // 4
};

var() SkySeqAct_AIStartFireAt.FiringCommand ForcedFireMode;
