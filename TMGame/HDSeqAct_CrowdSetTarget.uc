//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HDSeqAct_CrowdSetTarget extends SequenceAction;

var() Actor    FireTarget;
var() float    InaccuracyDegrees;
var() float    NewDamage;
var() vector2d ShotsInternal;
var() int      ShotsToFire;

