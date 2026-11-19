class PKAIcmd_Action_BlackDemonBigAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAI_BlackDemonBig;

var Vector TempDest;

function Pushed()
{
    super.Pushed();
    // End:0x56
    if(Outer.DefaultNearAttackPriority > 0.0000000)
    {
        Outer.FarAttackPriority = 0.0000000;
    }
    // End:0x89
    if(Outer.bFirstTimeSee)
    {
        GotoState('FirstSeeEnemy');        
    }
    else
    {
        GotoState('Idle');
    }
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x52
    if(AI.HasValidEnemy() || AI.DelayBeforeHunt > 0.0000000)
    {
        return 0.5000000;
    }
    return 0.0000000;
    //return ReturnValue;    
}

function UpdateFarAttackPrio()
{
    // End:0x111
    if(Outer.HasValidEnemy())
    {
        Outer.DelayBeforeHunt = 0.5000000;
        // End:0x10E
        if(Outer.DefaultFarAttackPriority > 0.0000000)
        {
            Outer.FarAttackPriority += (Outer.DefaultFarAttackPriority * RandRange(0.0100000, 0.0500000));
            // End:0x10E
            if(Outer.FarAttackPriority > 1.0000000)
            {
                Outer.FarAttackPriority = 1.0000000;
            }
        }        
    }
    else
    {
        // End:0x182
        if(Outer.DelayBeforeHunt > 0.0000000)
        {
            Outer.DelayBeforeHunt -= Outer.GetTimerRate('UpdateFarAttackPrio', self);
        }
    }
    //return;    
}

function AttackDelay()
{
    //return;    
}

state Idle
{Begin:

    // End:0x1B0
    if(Outer.HasValidEnemy())
    {
        // End:0x174
        if((Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_Melee) && !Outer.MyPKPawn_BlackDemon.bShouldEarthQuakeAttack)
        {
            // End:0x163
            if(Outer.IsTimerActive('AttackDelay', self))
            {
                // End:0x163
                if(Outer.GetRemainingTimeForTimer('AttackDelay') >= 1.0000000)
                {
                    Outer.ClearTimer('AttackDelay', self);
                    Outer.SetTimer(1.0000000, false, 'AttackDelay', self);
                }
            }
            GotoState('MoveToEnemy');            
        }
        else
        {
            // End:0x1B0
            if(!Outer.IsTimerActive('AttackDelay', self))
            {
                GotoState('Attack');
            }
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
DelayBetweenAttacks:


    Outer.SetTimer(Outer.DelayBetweenAttacks * RandRange(0.8000000, 1.2000000), false, 'AttackDelay', self);
    goto 'Begin';
    stop;                
}

state Attack
{Begin:

    // End:0x44D
    if(Outer.HasValidEnemy())
    {
        // End:0x3EE
        if(Outer.IsAimingAt(Outer.Enemy, Outer.EnemyAngleEpsilon_Melee))
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
            Outer.StartMeleeAttack();
            J0xF2:

            Outer.Sleep(0.1000000);
            // End:0x1BF
            if(Outer.ContinousAttack && Outer.EnemyDistance_Melee < Outer.GetEnemyInfo().DistanceToEnemy)
            {
                Outer.MyPKPawn.EndPawnAction(5);
            }
            // End:0xF2
            if(!(int(Outer.MyPKPawn.PawnAction) != 5))
                goto J0xF2;
            Outer.MyPKPawn_BlackDemon.bShouldEarthQuakeAttack = false;
            // End:0x2FA
            if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyMinDistance_Melee)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTimeWhenTooCloseToPlayer * 0.9000000, Outer.EscapeTimeWhenTooCloseToPlayer * 1.2000000);
            }
            // End:0x3D5
            if((Outer.LastMeleeMissedTime > Outer.LastMeleeHitTime) && FRand() < Outer.ChanceOfEscapeAfterFire)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTime * 0.7000000, Outer.EscapeTime * 1.2000000);
            }
            GotoState('Idle', 'DelayBetweenAttacks');            
        }
        else
        {
            // End:0x44D
            if(FRand() < 0.2000000)
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }
        }
    }
    GotoState('Idle');
    stop;                    
}

state MoveToEnemy
{Begin:

    // End:0x43C
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * 0.8000000, false);
        // End:0x3C4
        if((ChildStatus != 'Success') && ChildStatus != 'Aborted')
        {
            Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * float(2), false);
            // End:0x38B
            if((ChildStatus != 'Success') && ChildStatus != 'Aborted')
            {
                // End:0x25D
                if((Outer.GetEnemyInfo().DistanceToEnemy < RandRange(1500.0000000, 2000.0000000)) && Outer.GetUnstuckLocation(3000.0000000, TempDest, Outer.MyPKPawn.Location, true, 2000.0000000))
                {
                    Outer.MoveTo(TempDest, none, Outer.Pawn.GetCollisionRadius());                    
                }
                else
                {
                    // End:0x327
                    if(Outer.GetUnstuckLocation(3000.0000000, TempDest, Outer.Enemy.Location, false, 2000.0000000))
                    {
                        Outer.SetMovePoint(TempDest, Outer.MyPKPawn.GetCollisionRadius());                        
                    }
                    else
                    {
                        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * float(3), false);
                    }
                }
            }
            Outer.MyPKPawn_BlackDemon.bShouldEarthQuakeAttack = true;            
        }
        else
        {
            Outer.MyPKPawn_BlackDemon.bShouldEarthQuakeAttack = false;
        }
        // End:0x43C
        if(Outer.bResetFocusAfterMove)
        {
            Outer.Focus = none;
        }
    }
    GotoState('Idle');
    stop;        
}
