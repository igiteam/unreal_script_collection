class PKAIcmd_Action_JumpUp extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

var Vector JumpVelocity;

function Pushed()
{
    super.Pushed();
    GotoState('Attack');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.LastJumpTime = Outer.WorldInfo.TimeSeconds;
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x4E
    if(ActivationData.bActive && !AI.ShouldDeactivateActivePKAction())
    {
        return 0.7000000;
    }
    // End:0x1EA
    if(((AI.HasValidEnemy() && AI.ActualEscapeTime <= float(0)) && !AI.IsAttacking()) && AI.WorldInfo.TimeSeconds > (AI.LastJumpTime + AI.MinDelayBetweenJumps))
    {
        // End:0x1EA
        if((AI.GetEnemyInfo().DistanceToEnemy > AI.MinJumpRange) && AI.GetEnemyInfo().DistanceToEnemy < AI.MaxJumpRange)
        {
            return 0.5500000;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

state Attack
{Begin:

    // End:0x1B7
    if(Outer.HasValidEnemy())
    {
        Outer.MyPKPawn.ZeroMovementVariables();
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.FinishRotation();
        JumpVelocity = Outer.GetJumpVelocity();
        // End:0x109
        if(VSize(JumpVelocity) <= 0.0000000)
        {
            goto 'End';
        }
        Outer.StartJumpAttack();
        J0x128:

        Outer.Sleep(FMax(0.0500000, Outer.MyPKPawn.GetFallDuration()));
        // End:0x128
        if(!(int(Outer.MyPKPawn.PawnAction) != 25))
            goto J0x128;
    }
End:


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
Begin:

    Outer.SetFocalPoint(Outer.Enemy.Location);
    stop;                    
}
