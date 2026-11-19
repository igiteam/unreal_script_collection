class SkyBTNode_Act_SeekLandingZone extends SkyBTNode_Leaf_Action
    native;

var() bool bIgnoreLastLZ;
var() bool bLeaveVehicleOnLZEntry;
var() float MaxDistFromTarget;
var() SkyBTNode.E_MeOrEnemy SeekTarget;
