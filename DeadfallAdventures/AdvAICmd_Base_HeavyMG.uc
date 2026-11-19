class AdvAICmd_Base_HeavyMG extends EvilAICmd_Base_Combat within EvilAIController;

function AgrressionLevelChanged(EvilTypes.EAggressionLevel InNewLevel, EvilTypes.EAggressionLevel InOldLevel)
{
    // End:0x5F
    if((int(InNewLevel) == int(4)) && !IsInState('InCombat', true))
    {
        Outer.AbortCommand(none, Class'EvilGame.EvilAICmd_MoveToGoal');
        GotoState('InCombat');
    }
    //return;    
}

function Pushed()
{
    super.Pushed();
    GotoState('InCombat');
    //return;    
}

auto state InCombat
{Begin:

    // End:0x4B
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.5000000);
        goto 'Begin';
    }
    Outer.Focus = Outer.Enemy;
    // End:0x2A4
    if(Outer.DoStrafeByDirections())
    {
        Outer.Focus = Outer.Enemy;
        // End:0x2A1
        if((!Outer.HasCombatZones() || Outer.IsLocationInCombatZones(Outer.Enemy.Location)) && !Outer.CanSeeByPoints(Outer.MyEvilPawn.GetPawnViewLocation(), Outer.Enemy.Location, Rotator(Normal(Outer.Enemy.Location - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * float(2), true,,,, true, true);
        }        
    }
    else
    {
        // End:0x45B
        if((!Outer.HasCombatZones() || Outer.IsLocationInCombatZones(Outer.Enemy.Location)) && !Outer.CanSeeByPoints(Outer.MyEvilPawn.GetPawnViewLocation(), Outer.Enemy.Location, Rotator(Normal(Outer.Enemy.Location - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * float(2), true,,,, true, true);
        }
    }
    J0x45B:

    Outer.Sleep(RandRange(1.0000000, 2.0000000));
    goto 'Begin';
    stop;            
}

state MoveToEnemy
{Begin:

    // End:0x43
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
Loop:


    // End:0x86
    if(!Outer.HasValidEnemy())
    {
        Outer.ReturnToIdle();
    }
    Outer.SetMoveGoal(Outer.Enemy, RandRange(100.0000000, 200.0000000), false, false);
    // End:0x13A
    if(Outer.CommandList.ChildStatus == 'Failure')
    {
        Outer.Sleep(0.1000000);
    }
    goto 'Loop';
    stop;                
}
