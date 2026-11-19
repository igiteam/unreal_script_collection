class SkyBTNode_Decorator_PawnIterator extends SkyBTNode_Decorator
    native;

enum E_PAWN_ITER_CRITERIA
{
    PIC_CLOSEST,                    // 0
    PIC_MAX                         // 1
};

var() class<Pawn> TestTargetClass;
var() SkyBTNode_Decorator_PawnIterator.E_PAWN_ITER_CRITERIA BestCriteria;
var() bool bPawnsMustBeVisible;
var() bool bMustBeWithinPeripheralVision;
var() bool bSetBestAsEnemy;
var(Scripted) bool bIncludeScriptedTarget;
var(Scripted) bool bIncludeScriptedFireTarget;
var() bool bIncludeGrippers;
var transient array<Actor> TestTargetList;
var int CurrentIndex;
