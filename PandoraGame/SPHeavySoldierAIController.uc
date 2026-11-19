class SPHeavySoldierAIController extends SPSoldierAIController
    native;

/** MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONS */
var(AI) float m_minRange;
var(AI) float m_maxRange;

// Export USPHeavySoldierAIController::execFindBestDestination(FFrame&, void* const)
native function bool FindBestDestination(out DestinationInfo Info);

// Export USPHeavySoldierAIController::execCanClassUseCoverType(FFrame&, void* const)
native function bool CanClassUseCoverType(CoverLink.ECoverType CoverType, bool bAttacking);

// Export USPHeavySoldierAIController::execGetDefaultCanFireAtStartLocation(FFrame&, void* const)
native function Vector GetDefaultCanFireAtStartLocation();

// Export USPHeavySoldierAIController::execShouldThrowGrenadeAtEnemy(FFrame&, void* const)
native function bool ShouldThrowGrenadeAtEnemy();

// Export USPHeavySoldierAIController::execCanFireAtIsBlocked(FFrame&, void* const)
native function CanFireAtIsBlocked(Pawn theTarget);

event bool WantsToLookForCover()
{
    return (GetEnemy()) == none;
    //return ReturnValue;    
}

function bool IsLookingForAttackDestination()
{
    return super.IsLookingForAttackDestination();
    //return ReturnValue;    
}

function InitRangeToUsPartOfDestinationInfo(out DestinationInfo theInfo)
{
    super.InitRangeToUsPartOfDestinationInfo(theInfo);
    theInfo.bExcludeCoverOutOfRangeToUs = (GetEnemy()) != none;
    //return;    
}

function bool AllowOnlyCheckDynamicActorsInCanFireAt()
{
    return false;
    //return ReturnValue;    
}
