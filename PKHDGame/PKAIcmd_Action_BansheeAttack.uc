class PKAIcmd_Action_BansheeAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAI_Banshee;

var bool bNoMove;

function Pushed()
{
    super.Pushed();
    // End:0x56
    if(Outer.DefaultNearAttackPriority > 0.0000000)
    {
        Outer.FarAttackPriority = 0.0000000;
    }
    GotoState('Idle');
    //return;    
}

function TickFade()
{
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.Unfade();
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x4C
    if(AI.HasValidEnemy() || AI.IsAttacking())
    {
        return 0.5000000;
    }
    return 0.0000000;
    //return ReturnValue;    
}

function UpdateFarAttackPrio()
{
    // End:0x11A
    if(Outer.HasValidEnemy())
    {
        Outer.DelayBeforeHunt = 0.5000000;
        // End:0x117
        if((!IsAttacking() && FRand() < Outer.ScreamFreq) && Outer.GetEnemyInfo().DistanceToEnemy < Outer.ScreamDistanceMax)
        {
            Outer.FarAttackPriority = 1.0000000;
            Outer.AbortMoving();
        }        
    }
    else
    {
        // End:0x18B
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

    // End:0x137
    if(Outer.HasValidEnemy())
    {
        // End:0x89
        if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyDistance_Melee)
        {
            GotoState('Attack');            
        }
        else
        {
            // End:0x11A
            if((Outer.FarAttackPriority >= 1.0000000) && Outer.GetEnemyInfo().DistanceToEnemy < Outer.ScreamDistanceMax)
            {
                GotoState('AttackScream');                
            }
            else
            {
                // End:0x137
                if(!bNoMove)
                {
                    GotoState('MoveToEnemy');
                }
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

state AttackScream
{
    function bool IsAttacking()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    // End:0x170
    if(Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.ScreamAttack();
        J0x94:

        Outer.Sleep(0.1000000);
        // End:0x110
        if(FRand() < 0.4500000)
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
        }
        // End:0x94
        if(!(int(Outer.MyEvilPawn.PawnAction) != 33))
            goto J0x94;
        Outer.FarAttackPriority = 0.0000000;
    }
    GotoState('Idle');
    stop;        
}

state Attack
{Begin:

    // End:0x20C
    if(Outer.HasValidEnemy())
    {
        // End:0x1AD
        if(Outer.IsAimingAt(Outer.Enemy, Outer.EnemyAngleEpsilon_Melee))
        {
            Outer.SetFocalPoint(Outer.Enemy.Location);
            Outer.StartMeleeAttack();
            J0xF2:

            Outer.Sleep(0.1000000);
            // End:0x16E
            if(FRand() < 0.4500000)
            {
                Outer.SetFocalPoint(Outer.Enemy.Location);
            }
            // End:0xF2
            if(!(int(Outer.MyPKPawn.PawnAction) != 5))
                goto J0xF2;            
        }
        else
        {
            // End:0x20C
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

    // End:0xC9
    if(Outer.HasValidEnemy())
    {
        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * 0.8000000, false);
        // End:0xC9
        if(Outer.bResetFocusAfterMove)
        {
            Outer.Focus = none;
        }
    }
    GotoState('Idle');
    stop;                    
}
