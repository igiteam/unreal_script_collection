class AdvAICmd_Treeter_Melee extends EvilAICmd_Base_Melee within EvilAIController;

state InCombat
{Begin:

    // End:0x159
    if((!Outer.HasValidEnemy() || VSize(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge * 1.2000000)) || !Outer.CanMeleeAttack())
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "No valid enemy or out of range in AdvAICmd_Treeter_Melee");
    }
    // End:0x253
    if((VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2))) && Outer.CanEngageCharge())
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge);
    }
    // End:0x31B
    if((Outer.HasValidEnemy() && Outer.HasEnemyWithinDistance(Outer.EnemyDistance_MeleeCharge,,, false)) && Outer.CanEngageCharge())
    {
        Outer.DoChargeAttack(Outer.Enemy);
    }
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, false);
    // End:0x501
    if((Outer.HasValidEnemy() && !Outer.IsFiring()) && (Outer.CommandList.ChildStatus == 'Success') || Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Melee,,, false))
    {
        DoMeleeAttack(Outer.Enemy);
        // End:0x501
        if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && FRand() < Outer.DodgeChance)
        {
            Outer.DoDodge();
        }
    }
    goto 'Begin';
    stop;                    
}
