class PKAI_Skull extends PKAIController
    config(AI)
    hidecategories(Navigation);

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    super(EvilAIController).BeginFireFromOpenWrapper(EventInstigator, OrigChannel);
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

defaultproperties
{
    DelayBetweenAttacks=0.5000000
    ChangePosAfterFireChance=0.9500000
    bMoveToGoalByNavMesh_TryToUnstuck=false
    bIgnoreStepAside=true
    TargettedAimEpsilon=1.0000000
    DefaultCommand=Class'PKAICmd_Base_Skull'
    MeleeCommand=none
    EnemyDistance_Shoot=2000.0000000
    EnemyDistance_Throw=1500.0000000
    EnemyDistance_MeleeCharge=200.0000000
    // Reference: EvilAIReactManager'Default__PKAI_Skull.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__PKAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=none
    DefaultReactConditionClasses=none
    MaxTimeBetweenFireBurst=0.2000000
    MinTimeBetweenFireBurst=0.1000000
    TimeBetweenThrows=8.0000000
    BurstFireTimeout=1.0000000
    BurstFireSpreadTime=0.5000000
    BurstFireLag=0.5000000
}