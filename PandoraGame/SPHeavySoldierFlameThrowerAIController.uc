class SPHeavySoldierFlameThrowerAIController extends SPHeavySoldierAIController
    native;

// Export USPHeavySoldierFlameThrowerAIController::execGetAdjustedAimForEnemy(FFrame&, void* const)
native function Rotator GetAdjustedAimForEnemy(Weapon W, const out Vector StartFireLoc);

// Export USPHeavySoldierFlameThrowerAIController::execGetDefaultCanFireAtStartLocation(FFrame&, void* const)
native function Vector GetDefaultCanFireAtStartLocation();

// Export USPHeavySoldierFlameThrowerAIController::execHasLimitedRangeWeapon(FFrame&, void* const)
native function bool HasLimitedRangeWeapon();

// Export USPHeavySoldierFlameThrowerAIController::execGetMaximumAttackDistance(FFrame&, void* const)
native function float GetMaximumAttackDistance();

// Export USPHeavySoldierFlameThrowerAIController::execCanFireAtIsBlocked(FFrame&, void* const)
native function CanFireAtIsBlocked(Pawn theTarget);

// Export USPHeavySoldierFlameThrowerAIController::execDoWePreferFullVisibilityToAttack(FFrame&, void* const)
native function bool DoWePreferFullVisibilityToAttack();

function bool AllowOnlyCheckDynamicActorsInCanFireAt()
{
    return false;
    //return ReturnValue;    
}
