class SPHeavySoldierRocketLauncherAIController extends SPHeavySoldierAIController
    native;

// Export USPHeavySoldierRocketLauncherAIController::execCanClassMoveAndAttack(FFrame&, void* const)
native function bool CanClassMoveAndAttack();

// Export USPHeavySoldierRocketLauncherAIController::execCanClassUseCoverType(FFrame&, void* const)
native function bool CanClassUseCoverType(CoverLink.ECoverType CoverType, bool bAttacking);

event bool WantsToLookForCover()
{
    return true;
    //return ReturnValue;    
}

state MoveToGoalWhileAttacking
{
    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state MoveToCover
{
    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}
