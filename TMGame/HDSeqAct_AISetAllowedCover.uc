//-----------------------------------------------------------
//    ???????????1??Cover????(?CombatZone?????)
//-----------------------------------------------------------
class HDSeqAct_AISetAllowedCover extends SequenceAction;

var() bool bClearOld;

/** List of actual move targets to pick from */
var() array<Actor> CoverLink;

