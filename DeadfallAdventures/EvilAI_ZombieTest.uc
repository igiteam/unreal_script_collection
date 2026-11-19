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
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    // Reference: EvilAIReactCond_EnemyCanBeMeleed'Default__EvilAI_ZombieTest.EnemyCanBeMeleed0'
    begin object name=EnemyCanBeMeleed0
    end object
    DefaultReactConditions[0]=EnemyCanBeMeleed0
    // Reference: EvilAIReactCond_EnemyCloseAndVisible'Default__EvilAI_ZombieTest.EnemyCloseAndVisible0'
    begin object name=EnemyCloseAndVisible0
    end object
    DefaultReactConditions[1]=EnemyCloseAndVisible0
    // Reference: EvilAIReactCond_EnemyCloseToThrowLine'Default__EvilAI_ZombieTest.EnemyCloseToThrowLine0'
    begin object name=EnemyCloseToThrowLine0
    end object
    DefaultReactConditions[2]=EnemyCloseToThrowLine0
    // Reference: EvilAIReactCond_CanLongDistanceCharge'Default__EvilAI_ZombieTest.LongDistanceCharge0'
    begin object name=LongDistanceCharge0
    end object
    DefaultReactConditions[3]=LongDistanceCharge0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAI_ZombieTest.BehaviorAttack0'
    begin object name=BehaviorAttack0
    end object
    DefaultReactConditions[4]=BehaviorAttack0
    // Reference: EvilAIReactCond_Stumble'Default__EvilAI_ZombieTest.RunFail0'
    begin object name=RunFail0
    end object
    DefaultReactConditions[5]=RunFail0
    // Reference: EvilAIReactCond_CanAimEnemy'Default__EvilAI_ZombieTest.ReadyToFire0'
    begin object name=ReadyToFire0
    end object
    DefaultReactConditions[6]=ReadyToFire0
    // Reference: EvilAIReactCond_GenericCallDelegate'Default__EvilAI_ZombieTest.AbortMovingOnEnemyCloseAndVisible0'
    begin object name=AbortMovingOnEnemyCloseAndVisible0
    end object
    DefaultReactConditions[7]=AbortMovingOnEnemyCloseAndVisible0
    // Reference: EvilAIReactCond_CanThrowAtEnemy'Default__EvilAI_ZombieTest.Throw0'
    begin object name=Throw0
    end object
    DefaultReactConditions[8]=Throw0
}