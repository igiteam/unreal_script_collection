class EvilAI_ZombieTest extends EvilAIController
    config(AI)
    hidecategories(Navigation);

var int TickCount;

auto state Idle
{Begin:

    Sleep(0.1000000);
    // End:0x5C
    if((MyEvilPawn != none) && int(MyEvilPawn.Physics) == int(0))
    {
        MyEvilPawn.SetPhysics(1);
    }
    // End:0x8F
    if((Enemy != none) && Focus == none)
    {
        Focus = Enemy;
    }
    goto 'Begin';
    stop;            
}

defaultproperties
{
    // Reference: EvilAIReactManager'Default__EvilAI_ZombieTest.ReactionManager0'
    // Archetype: EvilAIReactManager'Default__EvilAIController.ReactionManager0'
    begin object name="ReactionManager0"
    end object
    ReactionManager=ReactionManager0
    // Reference: EvilAIReactCond_EnemyCanBeMeleed'Default__EvilAI_ZombieTest.EnemyCanBeMeleed0'
    // Archetype: EvilAIReactCond_EnemyCanBeMeleed'Default__EvilAIController.EnemyCanBeMeleed0'
    begin object name="EnemyCanBeMeleed0"
    end object
    DefaultReactConditions[0]=EnemyCanBeMeleed0
    // Reference: EvilAIReactCond_EnemyCloseAndVisible'Default__EvilAI_ZombieTest.EnemyCloseAndVisible0'
    // Archetype: EvilAIReactCond_EnemyCloseAndVisible'Default__EvilAIController.EnemyCloseAndVisible0'
    begin object name="EnemyCloseAndVisible0"
    end object
    DefaultReactConditions[1]=EnemyCloseAndVisible0
    // Reference: EvilAIReactCond_CanLongDistanceCharge'Default__EvilAI_ZombieTest.LongDistanceCharge0'
    // Archetype: EvilAIReactCond_CanLongDistanceCharge'Default__EvilAIController.LongDistanceCharge0'
    begin object name="LongDistanceCharge0"
    end object
    DefaultReactConditions[2]=LongDistanceCharge0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAI_ZombieTest.BehaviorAttack0'
    // Archetype: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.BehaviorAttack0'
    begin object name="BehaviorAttack0"
    end object
    DefaultReactConditions[3]=BehaviorAttack0
    // Reference: EvilAIReactCond_Stumble'Default__EvilAI_ZombieTest.RunFail0'
    // Archetype: EvilAIReactCond_Stumble'Default__EvilAIController.RunFail0'
    begin object name="RunFail0"
    end object
    DefaultReactConditions[4]=RunFail0
    // Reference: EvilAIReactCond_CanAimEnemy'Default__EvilAI_ZombieTest.ReadyToFire0'
    // Archetype: EvilAIReactCond_CanAimEnemy'Default__EvilAIController.ReadyToFire0'
    begin object name="ReadyToFire0"
    end object
    DefaultReactConditions[5]=ReadyToFire0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAI_ZombieTest.AbortMovingOnEnemyCloseAndVisible0'
    // Archetype: EvilAIReactCond_GenericCallDelegate'Default__EvilAIController.AbortMovingOnEnemyCloseAndVisible0'
    begin object name="AbortMovingOnEnemyCloseAndVisible0"
    end object
    DefaultReactConditions[6]=AbortMovingOnEnemyCloseAndVisible0
}