class AdvAICmd_Base_Conquistador extends EvilAICmd_Base_Combat within AdvAI_Conquistador;

var float LastBeginInCombatTime;

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

    LastBeginInCombatTime = Outer.WorldInfo.TimeSeconds;
    // End:0x88
    if(!Outer.HasValidEnemy())
    {
        Outer.Sleep(0.5000000);
        goto 'Begin';
    }
    // End:0xFE
    if(!Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode)
    {
        Outer.Focus = Outer.Enemy;
    }
    // End:0x3BC
    if(Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode || Outer.DoStrafeByDirections(Outer.OnRateStrafeByFlankEnemy, Outer.Enemy))
    {
        // End:0x3B9
        if(Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode || !Outer.CanSeeByPoints(Outer.MyEvilPawn.GetPawnViewLocation(), Outer.Enemy.Location, Rotator(Normal(Outer.Enemy.Location - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee * ((Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode) ? 0.6000000 : 2.0000000), true,,,, !Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode, !Outer.MyAdvPawn_Conquistador_Base.bBerserkerMode);
        }        
    }
    else
    {
        // End:0x4F5
        if(!Outer.CanSeeByPoints(Outer.MyEvilPawn.GetPawnViewLocation(), Outer.Enemy.Location, Rotator(Normal(Outer.Enemy.Location - Outer.MyEvilPawn.Location))))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * float(2), true,,,, true, true);
        }
    }
    J0x4F5:

    // End:0x52E
    if(!Outer.MyEvilPawn.IsInBerserkerMode())
    {
    }
    // End:0x593
    if((Outer.WorldInfo.TimeSeconds - LastBeginInCombatTime) < 0.1000000)
    {
        Outer.Sleep(0.1000000);
    }
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
