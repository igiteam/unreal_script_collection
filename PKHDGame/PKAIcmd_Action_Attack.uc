class PKAIcmd_Action_Attack extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

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
    // End:0x9A
    if((AI.HasValidEnemy() || AI.DelayBeforeHunt > 0.0000000) || AI.IsAttacking() && ActivationData.bActive)
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

function bool ShouldInterruptActiveCommand()
{
    return super(EvilAICommand).ShouldInterruptActiveCommand() || Outer.HasValidEnemy() && Outer.GetEnemyInfo().DistanceToEnemy <= Outer.EnemyDistance_Melee;
    //return ReturnValue;    
}

function AttackDelay()
{
    //return;    
}

function bool CanAttackEnemy()
{
    local AICharacterInfo EnemyInfo;
    local Vector HitLocation, HitNormal;

    // End:0x1C3
    if(Outer.GetCurrentEnemyInfo(EnemyInfo))
    {
        // End:0x96
        if(PKPawn_Boss_Base(EnemyInfo.Pawn) == none)
        {
            return EnemyInfo.DistanceToEnemy <= Outer.EnemyDistance_Melee;            
        }
        else
        {
            return Outer.MyEvilPawn.Trace(HitLocation, HitNormal, Outer.MyEvilPawn.Location + (Normal(Vector(Outer.MyEvilPawn.Rotation)) * Outer.EnemyDistance_Melee), Outer.MyEvilPawn.Location, true, vect(1.0000000, 1.0000000, 1.0000000)) == EnemyInfo.Pawn;
        }
    }
    return false;
    //return ReturnValue;    
}

state Idle
{Begin:

    Outer.SelectTarget();
    // End:0x14D
    if(Outer.HasValidEnemy())
    {
        // End:0x111
        if(!CanAttackEnemy())
        {
            // End:0x100
            if(Outer.IsTimerActive('AttackDelay', self))
            {
                // End:0x100
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
            // End:0x14D
            if(!Outer.IsTimerActive('AttackDelay', self))
            {
                GotoState('Attack');
            }
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
DelayBetweenAttacks:


    // End:0x1EF
    if(!Outer.bConfused)
    {
        Outer.SetTimer(Outer.DelayBetweenAttacks * RandRange(0.8000000, 1.2000000), false, 'AttackDelay', self);
    }
    goto 'Begin';
    stop;            
}

state Attack
{Begin:

    // End:0x45B
    if(Outer.HasValidEnemy())
    {
        // End:0x3DC
        if(Outer.IsWeaponAimingAt(Outer.Enemy, Outer.EnemyAngleEpsilon_Melee) || Outer.bConfused)
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
            Outer.StartMeleeAttack();
            J0x116:

            Outer.Sleep(0.1000000);
            // End:0x1E3
            if(Outer.ContinousAttack && Outer.EnemyDistance_Melee < Outer.GetEnemyInfo().DistanceToEnemy)
            {
                Outer.MyPKPawn.EndPawnAction(5);
            }
            // End:0x116
            if(!(int(Outer.MyPKPawn.PawnAction) != 5))
                goto J0x116;
            // End:0x2E8
            if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyMinDistance_Melee)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTimeWhenTooCloseToPlayer * 0.9000000, Outer.EscapeTimeWhenTooCloseToPlayer * 1.2000000);
            }
            // End:0x3C3
            if((Outer.LastMeleeMissedTime > Outer.LastMeleeHitTime) && FRand() < Outer.ChanceOfEscapeAfterFire)
            {
                Outer.ActualEscapeTime = RandRange(Outer.EscapeTime * 0.7000000, Outer.EscapeTime * 1.2000000);
            }
            GotoState('Idle', 'DelayBetweenAttacks');            
        }
        else
        {
            // End:0x45B
            if(FRand() < 0.2000000)
            {
                Outer.Focus = none;
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }
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
        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * 0.8000000, false);
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
