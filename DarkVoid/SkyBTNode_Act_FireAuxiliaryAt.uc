class SkyBTNode_Act_FireAuxiliaryAt extends SkyBTNode_Leaf_Action
    native;

var() int AuxWeaponsIndex;
var() float Duration;
var() SkyBTNode.E_MeOrEnemy Target;
var transient float CurrentFiringTime;
