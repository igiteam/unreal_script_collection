class SkyBTNode_Act_FindTurret extends SkyBTNode_Leaf_Action
    native;

enum FindTurretOperation
{
    FTO_FindTurretOnly,             // 0
    FTO_FindTurretThenMoveTo,       // 1
    FTO_FindTurretMoveToAndEnter,   // 2
    FTO_MAX                         // 3
};

var(TurretSearch) float MinDistanceFromTarget;
var(TurretSearch) float MaxDistanceFromTarget;
var(TurretSearch) float MinDistanceFromBot;
var(TurretSearch) float MaxDistanceFromBot;
var(TurretSearch) SkyBTNode.E_MeOrEnemy TargetType;
var(TurretUsage) SkyBTNode_Act_FindTurret.FindTurretOperation FindTurretOp;
var(TurretUsage) SkyAITurret TurretAIArchetype;
var transient SkyVehicleFactory FoundTurretFactory;
