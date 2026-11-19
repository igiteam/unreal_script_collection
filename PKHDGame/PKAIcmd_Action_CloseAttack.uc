class PKAIcmd_Action_CloseAttack extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

function Pushed()
{
    super.Pushed();
    GotoState('Attack');
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x4E
    if(!AI.ShouldDeactivateActivePKAction() && ActivationData.bActive)
    {
        return 0.6100000;
    }
    // End:0x1A3
    if((((AI.HasValidEnemy() && !AI.IsAttacking()) && AI.GetEnemyInfo().DistanceToEnemy < AI.EnemyDistance_Melee) && AI.CanSee(AI.GetEnemyInfo().Pawn)) && AI.WorldInfo.TimeSeconds > (ActivationData.LastDeactivationTime + 0.3000000))
    {
        return 0.5900000;
    }
    return 0.0000000;
    //return ReturnValue;    
}

state Attack
{Begin:

    // End:0xED
    if(Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.StartMeleeAttack();
        J0x94:

        Outer.Sleep(0.0500000);
        // End:0x94
        if(!(int(Outer.MyPKPawn.PawnAction) != 5))
            goto J0x94;
    }
    GotoState('Idle');
    stop;                    
}

state Idle
{
    function bool ShouldDeactivate()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}
