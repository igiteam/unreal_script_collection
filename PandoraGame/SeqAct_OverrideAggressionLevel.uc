class SeqAct_OverrideAggressionLevel extends SequenceAction;

enum EOverrideAggressionLevel
{
    oalForcedLow,                   // 0
    oalDefault,                     // 1
    oalForcedHigh,                  // 2
    EOverrideAggressionLevel_MAX    // 3
};

/** Force Low will prevent high aggression, default allows AI to determine aggression, ForceHigh forces high aggression */
var() SeqAct_OverrideAggressionLevel.EOverrideAggressionLevel AggressionLevel;
