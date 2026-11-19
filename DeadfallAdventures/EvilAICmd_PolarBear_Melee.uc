class EvilAICmd_PolarBear_Melee extends EvilAICmd_Base_Melee within EvilAIController;

state InCombat
{Begin:

    // End:0x12F
    if(!Outer.HasValidEnemy() || VSize(Outer.Enemy.Location - Outer.Pawn.Location) > Outer.EnemyDistance_MeleeCharge)
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "No valid enemy or out of range in EvilAICmd_PolarBear_Melee");
    }
    // End:0x205
    if(VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2)))
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge);
    }
    // End:0x2CB
    if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && Outer.CanEngageCharge())
    {
        Outer.DoChargeAttack(Outer.Enemy);
    }
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee, false);
    // End:0x3E0
    if(Outer.HasValidEnemy() && (Outer.CommandList.ChildStatus == 'Success') || Outer.HasEnemyWithinDistance(Outer.EnemyDistance_Melee))
    {
        DoMeleeAttack(Outer.Enemy);
    }
    goto 'Begin';
    stop;        
}
