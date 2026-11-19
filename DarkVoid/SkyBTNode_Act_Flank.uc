class SkyBTNode_Act_Flank extends SkyBTNode_Leaf_Action
    native;

var(Flank) float StayAwayRange;
var(Flank) float MaxFlankRange;
var(Flank) float GetBehindAngle;
var(Flank) SkyBTNode.E_MeOrEnemy FlankTarget;
var transient NavigationPoint CurrentFlankPosition;
