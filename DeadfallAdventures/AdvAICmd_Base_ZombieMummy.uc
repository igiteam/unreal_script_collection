class AdvAICmd_Base_ZombieMummy extends EvilAICmd_Base_Combat within EvilAIController;

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
    // End:0x100
    if(!Outer.MyEvilPawn.bOnLightInfluenceFromFlashLight && int(Outer.MyEvilPawn.PawnAction) != 55)
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, true);        
    }
    else
    {
        Outer.Sleep(0.1000000);
    }
    Outer.Focus = Outer.Enemy;
    goto 'Begin';
    stop;                
}
