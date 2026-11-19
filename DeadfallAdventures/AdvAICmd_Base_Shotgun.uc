class AdvAICmd_Base_Shotgun extends EvilAICmd_Base_Combat within EvilAIController;

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
    // End:0x2E3
    if(Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
    {
        Outer.Focus = Outer.Enemy;
        // End:0x2E0
        if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * float(2), true, true,,, true, true);
        }        
    }
    else
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * float(2), true, true,,, true, true);
        // End:0x4BD
        if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetWeaponStartTraceLocation(), Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone), Rotator(Normal(Outer.GetAimLocation(Outer.Enemy, Outer.MyEvilPawn.RequestedAimZone) - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(,, true, true,,, true, true);
        }
        Outer.Sleep(0.0100000);
    }
    J0x4DA:

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
