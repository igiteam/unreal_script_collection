//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_AISetAutoSpeak extends SequenceAction;

var() SoundCue         Reload;
var() SoundCue         Kill;
var() array<SoundCue>  Random;
var() vector2d         RandLoopTime;
var() bool             bResetAll;

