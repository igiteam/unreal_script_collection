class EvilAICmd_Base_Melee extends EvilAICmd_Base_Combat within EvilAIController;

var int CombatIteration;

function Pushed()
{
    super.Pushed();
    StartMeleeTimeout();
    GotoState('InCombat');
    Outer.MyEvilPawn.bCanSlowDown = false;
    //return;    
}

function Popped()
{
    Outer.MyEvilPawn.bCanSlowDown = true;
    Outer.LastMeleeCommandTime = Outer.WorldInfo.TimeSeconds;
    super.Popped();
    //return;    
}

function Resumed(name OldCommandName)
{
    super(GameAICommand).Resumed(OldCommandName);
    // End:0x4D
    if(!Outer.HasValidEnemy())
    {
        GotoState('InCombat', 'Begin');
    }
    //return;    
}

function DoMeleeAttack(optional Pawn NewEnemy)
{
    Outer.ClearTimer('MeleeTimeout');
    Outer.DoMeleeAttack(NewEnemy);
    //return;    
}

function StartMeleeTimeout()
{
    local float Time;

    Time = ((Outer.Enemy != none) ? (Outer.GetEnemyInfo().DistanceToEnemy / Outer.MyEvilPawn.GroundSpeed) + 2.0000000 : 3.0000000);
    Outer.SetTimer(Time, false, 'MeleeTimeout', self);
    //return;    
}

function MeleeTimeout()
{
    // End:0xCF
    if((Outer.Enemy != none) && Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_MeleeCharge)
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "Melee timed out");        
    }
    else
    {
        StartMeleeTimeout();
    }
    //return;    
}

state InCombat
{Begin:

    // End:0x16F
    if((!Outer.HasValidEnemy() || VSize(Outer.Enemy.Location - Outer.Pawn.Location) > RandRange(Outer.EnemyDistance_MeleeCharge / float(++CombatIteration), Outer.EnemyDistance_MeleeCharge)) || !Outer.CanMeleeAttack())
    {
        Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "No valid enemy or out of range");
    }
    // End:0x24C
    if(VSizeSq(Outer.Enemy.Location - Outer.Pawn.Location) > (Outer.EnemyDistance_MeleeCharge ** float(2)))
    {
        Outer.SetEnemyMoveGoal(Outer.EnemyDistance_MeleeCharge * 0.7000000);
    }
    // End:0x312
    if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && Outer.CanEngageCharge())
    {
        Outer.DoChargeAttack(Outer.Enemy);
    }
    Outer.SetEnemyMoveGoal(Outer.EnemyDistance_Melee * 0.7000000, false);
    // End:0x506
    if((Outer.HasValidEnemy() && !Outer.IsFiring()) && VSize(Outer.Enemy.Location - Outer.Pawn.Location) < Outer.EnemyDistance_Melee)
    {
        DoMeleeAttack(Outer.Enemy);
        // End:0x506
        if((Outer.HasValidEnemy() && Outer.CommandList.ChildStatus == 'Success') && FRand() < Outer.DodgeChance)
        {
            Outer.DoDodge();
        }
    }
    goto 'Begin';
    stop;                
}

defaultproperties
{
    ForcedBehavior=EBehaviorMode.BM_Attack
}