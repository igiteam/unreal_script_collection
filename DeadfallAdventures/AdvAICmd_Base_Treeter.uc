class AdvAICmd_Base_Treeter extends EvilAICmd_Base_Combat within EvilAIController;

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
    Outer.SetMovePoint(Outer.GetShootLocation(FMin(Outer.EnemyDistance_Shoot, Outer.GetEnemyInfo().DistanceToEnemy + (Outer.MyEvilPawn.GetCollisionRadius() * float(2))), Outer.Enemy, Outer.EnemyDistance_Melee));
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.FinishRotation();
    Outer.StartShootAttack();
    J0x1D9:

    Outer.Sleep(0.1000000);
    // End:0x1D9
    if(!(int(Outer.MyEvilPawn.PawnAction) != 11))
        goto J0x1D9;
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;            
}
