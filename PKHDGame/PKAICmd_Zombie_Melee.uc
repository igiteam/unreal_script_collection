class PKAICmd_Zombie_Melee extends EvilAICmd_Base_Melee within EvilAIController;

state InCombat
{Begin:

    // End:0x13F
    if((!Outer.HasValidEnemy() || VSize(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge * 1.2000000)) || !Outer.CanMeleeAttack())
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "No valid enemy or out of range");
    }
    // End:0x238
    if((VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2))) && Outer.CanEngageCharge())
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge);
    }
    // End:0x2FF
    if((Outer.HasValidEnemy() && Outer.HasEnemyWithinDistance(Outer.EnemyDistance_MeleeCharge)) && Outer.CanEngageCharge())
    {
        Outer.DoChargeAttack(Outer.Enemy);
    }
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, false);
    // End:0x4E3
    if((Outer.HasValidEnemy() && !Outer.IsFiring()) && (Outer.CommandList.ChildStatus == 'Success') || Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Melee))
    {
        DoMeleeAttack(Outer.Enemy);
        // End:0x4E3
        if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && FRand() < Outer.DodgeChance)
        {
            Outer.DoDodge();
        }
    }
    goto 'Begin';
    stop;            
}
