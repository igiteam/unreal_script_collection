class PKAI_KrustyClown extends PKAIController
    config(AI)
    hidecategories(Navigation);

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    super(EvilAIController).BeginFireFromOpenWrapper(EventInstigator, OrigChannel);
    //return;    
}

function NotifyEndOfPawnAction(byte LastMove)
{
    // End:0x31
    if(int(LastMove) == 5)
    {
        MyPKPawn.OnStopFireAlt();
    }
    //return;    
}

function float GetMaxAimAngle()
{
    switch(MyEvilPawn.CurrentMoveMode)
    {
        // End:0x2D
        case 0:
        // End:0x3B
        case 4:
            return 90.0000000;
            // End:0x3E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return 20.0000000;
    //return ReturnValue;    
}

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    AutoAcquireEnemy();
    SetAttackBehavior();
    //return;    
}

function float OnRateStrafe(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local float Rating;

    // End:0x2AB
    if((StrafeData.bValidMoveToStrafePoint && !StrafeData.bDisabled) && (StrafeData.StrafeDelay <= 0.0000000) || WorldInfo.TimeSeconds > (StrafeData.LastStrafeTime + StrafeData.StrafeDelay))
    {
        Rating = StrafeData.DefaultRating;
        Rating *= ((StrafeData.bEnemyReachable) ? 1.0000000 : 0.9000000);
        // End:0x1CB
        if(int(CurrentAggressionLevel) <= int(3))
        {
            Rating *= (1.0000000 - FMin(1.0000000, ((Enemy != none) ? ((EnemyDistance_MeleeCharge ** float(2)) / (VSizeSq(Enemy.Location - StrafeData.StrafePoint) + 1.0000000)) + 0.1000000 : 0.0000000)));            
        }
        else
        {
            Rating *= FMin(1.0000000, ((Enemy != none) ? ((EnemyDistance_MeleeCharge ** float(2)) / (VSizeSq(Enemy.Location - StrafeData.StrafePoint) + 1.0000000)) + 0.1000000 : 0.0000000));
        }
        Rating *= ((StrafeData.bClearFireLine && MyEvilPawn.HasRangedAttack()) ? 1.0000000 : 0.1000000);
    }
    return Rating;
    //return ReturnValue;    
}

defaultproperties
{
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    TargettedAimEpsilon=1.0000000
    DefaultCommand=Class'PKAICmd_Base_KrustyClown'
    MeleeCommand=none
    // Reference: EvilAIReactManager'Default__PKAI_KrustyClown.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
}