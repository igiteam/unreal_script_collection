class PKAIcmd_Action_ChargeAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

var bool bSavedSlowDown;

function Pushed()
{
    super.Pushed();
    bSavedSlowDown = Outer.MyPKPawn.bCanSlowDown;
    Outer.MyPKPawn.bCanSlowDown = false;
    // End:0xCB
    if(Outer.DefaultNearAttackPriority > 0.0000000)
    {
        Outer.FarAttackPriority = 0.0000000;
    }
    // End:0xFE
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

function Popped()
{
    super.Popped();
    Outer.MyPKPawn.bCanSlowDown = bSavedSlowDown;
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x23A
    if((AI.CanEngageCharge() && (AI.LastFailedChargeTime + AI.TimeBetweenFailedCharges) < AI.WorldInfo.TimeSeconds) && (AI.HasValidEnemy() || AI.DelayBeforeHunt > 0.0000000) || AI.IsAttacking() && ActivationData.bActive)
    {
        // End:0x1D7
        if((AI.GetEnemyInfo().DistanceToEnemy > AI.EnemyDistance_MeleeCharge) || AI.IsAttacking() && ActivationData.bActive)
        {
            return 0.5200000;            
        }
        else
        {
            // End:0x23A
            if(AI.GetEnemyInfo().DistanceToEnemy > (AI.EnemyDistance_Melee * 1.5000000))
            {
                return 0.5100000;
            }
        }
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

    Outer.SelectTarget();
    // End:0x194
    if(Outer.HasValidEnemy())
    {
        // End:0x158
        if(Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_MeleeCharge)
        {
            // End:0x147
            if(Outer.IsTimerActive('AttackDelay', self))
            {
                // End:0x147
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
            // End:0x194
            if(!Outer.IsTimerActive('AttackDelay', self))
            {
                GotoState('Attack');
            }
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
DelayBetweenAttacks:


    // End:0x236
    if(!Outer.bConfused)
    {
        Outer.SetTimer(Outer.DelayBetweenAttacks * RandRange(0.6000000, 1.0000000), false, 'AttackDelay', self);
    }
    goto 'Begin';
    stop;                
}

state Attack
{Begin:

    // End:0x493
    if(Outer.HasValidEnemy())
    {
        // End:0x433
        if((Outer.IsAimingAt(Outer.Enemy, Outer.EnemyAngleEpsilon_Melee) || Outer.bConfused) && Outer.NavigationHandle.ActorReachable(Outer.Enemy))
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
            Outer.StartChargeAttack();
            J0x16D:

            Outer.Sleep(0.1000000);
            // End:0x23A
            if(Outer.ContinousAttack && Outer.EnemyDistance_Melee < Outer.GetEnemyInfo().DistanceToEnemy)
            {
                Outer.MyPKPawn.EndPawnAction(7);
            }
            // End:0x16D
            if(!(int(Outer.MyPKPawn.PawnAction) != 7))
                goto J0x16D;
            // End:0x33F
            if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyMinDistance_Melee)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTimeWhenTooCloseToPlayer * 0.9000000, Outer.EscapeTimeWhenTooCloseToPlayer * 1.2000000);
            }
            // End:0x41A
            if((Outer.LastMeleeMissedTime > Outer.LastMeleeHitTime) && FRand() < Outer.ChanceOfEscapeAfterFire)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTime * 0.7000000, Outer.EscapeTime * 1.2000000);
            }
            GotoState('Idle', 'DelayBetweenAttacks');            
        }
        else
        {
            Outer.LastFailedChargeTime = Outer.WorldInfo.TimeSeconds;
            GotoState('MoveToEnemy');
        }
    }
    GotoState('Idle');
    stop;            
}

state MoveToEnemy
{Begin:

    // End:0x116
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_MeleeCharge * 0.8000000, false);
        // End:0xC9
        if(Outer.bResetFocusAfterMove)
        {
            Outer.Focus = none;
        }
        // End:0x116
        if((ChildStatus != 'Success') && ChildStatus != 'Aborted')
        {
            Outer.Sleep(2.0000000);
        }
    }
    GotoState('Idle');
    stop;                
}
