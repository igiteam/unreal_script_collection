class PKAIcmd_Action_GhostAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

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
        GotoState('MoveToEnemy');
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

function AttackDelay()
{
    //return;    
}

state MoveToEnemy
{Begin:

    // End:0x291
    if(Outer.HasValidEnemy())
    {
        // End:0x175
        if(Outer.GetEnemyInfo().DistanceToEnemy > (Outer.EnemyDistance_Melee * 1.2000000))
        {
            Outer.SetMoveGoal(Outer.Enemy, Outer.EnemyDistance_Melee * 0.8000000, false);
            // End:0x172
            if((ChildStatus != 'Success') && ChildStatus != 'Aborted')
            {
                Outer.MoveToward(Outer.Enemy,, Outer.EnemyDistance_Melee * 0.8000000,, false);
            }            
        }
        else
        {
            Outer.MoveTo(Outer.Enemy.Location + (Normal(Outer.Enemy.Location - Outer.MyPKPawn.Location) * Outer.EnemyDistance_Melee));
        }
        // End:0x291
        if(Outer.bResetFocusAfterMove)
        {
            Outer.Focus = none;
        }
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
    stop;                
}
