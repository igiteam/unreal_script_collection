class SeqAct_HodSetFireRate extends SequenceAction
native(HDSequence);

enum EFireMood
{
  FRM_Custom,
  FRM_Passive,
  FRM_Normal,
  FRM_Aggressive,
  FRM_ShootToKill,
};

var() EFireMood    Mood;
var   editoronly array<float> DefaultValue;

var() int FireNumShots[5];
var() bool UseFireNumShots;

var() float BurstDelayMin;
var() float BurstDelayMax;
var() bool UseBurstDelayRange;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


