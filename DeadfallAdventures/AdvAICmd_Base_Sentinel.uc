class AdvAICmd_Base_Sentinel extends EvilAICmd_Base_Combat within EvilAIController;

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
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee * 0.8000000, true);
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;                
}
