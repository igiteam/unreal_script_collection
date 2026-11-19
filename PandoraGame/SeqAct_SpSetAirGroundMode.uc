class SeqAct_SpSetAirGroundMode extends SequenceAction
    native;

enum AirGroundMode
{
    AirGroundMode_Air,              // 0
    AirGroundMode_Ground,           // 1
    AirGroundMode_Both,             // 2
    AirGroundMode_MAX               // 3
};

/** VARIABLE DECLARATIONS */
var() SeqAct_SpSetAirGroundMode.AirGroundMode Mode;
