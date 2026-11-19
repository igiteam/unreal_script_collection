class AdvAICmd_CoverAI_Base_Melee extends EvilAICmd_Base_Melee within EvilAIController;

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
{    J0x00:
    // End:0x145 [Loop If]
    if(((Outer.HasValidEnemy() && Outer.Enemy.IsAliveAndWell()) && !Outer.IsFiring()) && VSize(Outer.Enemy.Location - Outer.Pawn.Location) < Outer.EnemyDistance_Melee)
    {
        DoMeleeAttack(Outer.Enemy);
        goto 'Begin';
        // [Loop Continue]
        goto J0x00;
    }
    Outer.BeginCombatCommand(Outer.GetDefaultCommand(), "after melee in AdvAICmd_CoverAI_Base_Melee");
    stop;                
}
