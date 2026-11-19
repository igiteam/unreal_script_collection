class EvilAICmd_Base_Skeleton extends EvilAICmd_Base_Combat within EvilAIController;

function Pushed()
{
    super.Pushed();
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    // End:0x43
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, true);
    goto 'Begin';
    stop;                    
}
