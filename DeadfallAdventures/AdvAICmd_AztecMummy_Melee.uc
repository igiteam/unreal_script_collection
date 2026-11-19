class AdvAICmd_AztecMummy_Melee extends EvilAICmd_Base_Melee within AdvAIController;

var float LastBeginInCombatTime;
var float FinisherHealthTreshold;
var bool bCanFinishEnemy;

state InCombat
{Begin:

    LastBeginInCombatTime = Outer.WorldInfo.TimeSeconds;
    // End:0x153
    if((!Outer.HasValidEnemy() || !Outer.CanMeleeAttack()) || !Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Melee,,, false) && !Outer.CanEngageCharge())
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "No valid enemy or out of range");
    }
    FinisherHealthTreshold = float(Outer.Enemy.HealthMax) * 0.7500000;
    bCanFinishEnemy = EvilPawn(Outer.Pawn).CanDoPawnAction(60, true);
    Outer.Focus = Outer.Enemy;
    // End:0x537
    if((((float(Outer.Enemy.Health) > FinisherHealthTreshold) || AdvPlayerPawn(Outer.Enemy) != none) || Outer.Enemy.IsPlayerPawn()) || !bCanFinishEnemy)
    {
        // End:0x411
        if((VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2))) && Outer.CanEngageCharge())
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge,,,,,, int(Outer.MyEvilPawn.SupremeMoveMode) <= int(1));
        }
        // End:0x537
        if((Outer.HasValidEnemy() && Outer.HasEnemyWithinDistance(Outer.EnemyDistance_MeleeCharge,, Outer.EnemyDistance_Melee, false)) && Outer.CanEngageCharge())
        {
            Outer.DoChargeAttack(Outer.Enemy);
            // End:0x537
            if(Outer.MyEvilPawn.IsInBerserkerMode())
            {
                goto 'End';
            }
        }
    }
    // End:0x835
    if((((float(Outer.Enemy.Health) > FinisherHealthTreshold) || AdvPlayerPawn(Outer.Enemy) != none) || Outer.Enemy.IsPlayerPawn()) || !bCanFinishEnemy)
    {
        // End:0x692
        if(Outer.CanEngageCharge())
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, false,,,,, int(Outer.MyEvilPawn.SupremeMoveMode) <= int(1));
        }
        // End:0x835
        if((Outer.HasValidEnemy() && !Outer.IsFiring()) && (Outer.CommandList.ChildStatus == 'Success') || Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Melee,,, false))
        {
            DoMeleeAttack(Outer.Enemy);
            // End:0x835
            if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && FRand() < Outer.DodgeChance)
            {
                Outer.DoDodge();
            }
        }
    }
    // End:0xB9E
    if(((float(Outer.Enemy.Health) < FinisherHealthTreshold) && !Outer.Enemy.IsPlayerPawn()) && AdvPlayerPawn(Outer.Enemy) == none)
    {
        bCanFinishEnemy = EvilPawn(Outer.Pawn).CanDoPawnAction(60, true) && int(EvilPawn(Outer.Enemy).PawnAction) != 61;
        // End:0xA2F
        if((Outer.HasValidEnemy() && bCanFinishEnemy) && !Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Finisher,,, false))
        {
            Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Finisher);
        }
        bCanFinishEnemy = EvilPawn(Outer.Pawn).CanDoPawnAction(60, true) && int(EvilPawn(Outer.Enemy).PawnAction) != 61;
        // End:0xB81
        if((Outer.HasValidEnemy() && Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Finisher,,, false)) && bCanFinishEnemy)
        {
            Outer.DoFinisherAttack(Outer.Enemy);
            goto 'End';            
        }
        else
        {
            Outer.Sleep(0.1000000);
        }
    }
    J0xB9E:

    // End:0xC03
    if((Outer.WorldInfo.TimeSeconds - LastBeginInCombatTime) < 0.1000000)
    {
        Outer.Sleep(0.1000000);
    }
    goto 'Begin';
    stop;            
}
