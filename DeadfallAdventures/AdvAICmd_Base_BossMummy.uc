class AdvAICmd_Base_BossMummy extends EvilAICmd_Base_Combat within AdvAI_BossMummy;

var float LastSpawnAttackTime;
var int FarAttackCounter;
var Actor Obstacle;

function Pushed()
{
    super.Pushed();
    Outer.SetTimer(GetTransitionCheckTime(), false, 'CheckTimedCombatTransition');
    GotoState('InCombat');
    //return;    
}

state InCombat
{Begin:

    // End:0x5DB
    if(Outer.HasValidEnemy())
    {
        // End:0x474
        if(Outer.ClearFireLineToEnemy(Obstacle, false, true) || (Obstacle == none) || EvilPawn(Obstacle) == none)
        {
            // End:0x1BF
            if(((!Outer.bForceSpawnSlaves && Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyDistance_Shoot) && Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_MeleeCharge) && Outer.WorldInfo.TimeSeconds > (Outer.LastFireTime + 2.0000000))
            {
                GotoState('FarAttack');                
            }
            else
            {
                // End:0x24C
                if(!Outer.bForceSpawnSlaves && Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyDistance_MeleeCharge)
                {
                    GotoState('MeleeAttack');                    
                }
                else
                {
                    // End:0x2ED
                    if(Outer.bForceSpawnSlaves || (Outer.WorldInfo.TimeSeconds > (LastSpawnAttackTime + 1.0000000)) && Outer.bCanSpawnSlaves)
                    {
                        GotoState('SpawnAttack');                        
                    }
                    else
                    {
                        // End:0x471
                        if((Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_Shoot) || FarAttackCounter == 2)
                        {
                            Outer.SetMovePoint(Outer.GetShootLocation(Outer.EnemyDistance_Shoot - Outer.MyEvilPawn.GetCollisionRadius(), Outer.Enemy, FMax(Outer.EnemyDistance_MeleeCharge, Outer.EnemyDistance_Shoot - Outer.EnemyDistance_MeleeCharge), true));
                            FarAttackCounter = 0;
                        }
                    }
                }
            }            
        }
        else
        {
            Outer.SetMovePoint(Outer.GetShootLocation(Outer.EnemyDistance_Shoot - Outer.MyEvilPawn.GetCollisionRadius(), Outer.Enemy, FMax(Outer.EnemyDistance_MeleeCharge, Outer.EnemyDistance_Shoot - Outer.EnemyDistance_MeleeCharge), true));
        }
        Outer.SetFocalPoint(Outer.Enemy.Location);        
    }
    else
    {
        Outer.ReturnToIdle();
    }
    Outer.WaitForLanding();
    Outer.Sleep(0.1000000);
    goto 'Begin';
    stop;        
}

state MeleeAttack
{Begin:

    // End:0x101
    if(Outer.CanMeleeAttack())
    {
        Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * 0.8000000);
        Outer.StartMeleeAttack();
        J0xA8:

        Outer.Sleep(0.1000000);
        // End:0xA8
        if(!(int(Outer.MyAdvPawn.PawnAction) != 5))
            goto J0xA8;
    }
    Outer.EvadeAwayFromActor(Outer.Enemy, EvilPawn(Outer.Enemy), true);
    Outer.ProcessStimulus(Outer.Enemy, 3, 'Teleport update');
    GotoState('InCombat');
    stop;            
}

state FarAttack
{Begin:

    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.FinishRotation();
    Outer.StartShootAttack();
    J0x8A:

    Outer.Sleep(0.1000000);
    // End:0x8A
    if(!(int(Outer.MyEvilPawn.PawnAction) != 11))
        goto J0x8A;
    FarAttackCounter++;
    GotoState('InCombat');
    stop;                
}

state SpawnAttack
{Begin:

    Outer.TriggerEventClass(Class'SeqEvent_SpawnSlaves', Outer.MyEvilPawn);
    Outer.ClearLatentAction(Class'SeqAct_SpawnSlaves', true);
    Outer.bForceSpawnSlaves = false;
    Outer.bSpawningSlaves = true;
    Outer.SetFocalPoint(Outer.Enemy.Location);
    Outer.FinishRotation();
    Outer.MyEvilPawn.ServerDoPawnAction(54,,, Outer.MyEvilPawn.PackAnimInfo(86, 0));
    J0x190:

    Outer.Sleep(0.1000000);
    // End:0x190
    if(!(int(Outer.MyEvilPawn.PawnAction) != 54))
        goto J0x190;
    Outer.Focus = Outer.Enemy;
    Class'AdvAICmd_Levitate'.static.InitJump(Outer);
    Outer.Focus = none;
    Outer.ClearLatentAction(Class'SeqAct_SpawnSlaves', false);
    LastSpawnAttackTime = Outer.WorldInfo.TimeSeconds;
    Outer.bCanSpawnSlaves = false;
    GotoState('InCombat');
    stop;                
}
