class PKAIcmd_Action_Throw extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

var bool bThrowInitialized;

function Pushed()
{
    super.Pushed();
    GotoState('Throw');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.ClearAllTimers(self);
    //return;    
}

function bool ShouldDeactivate()
{
    // End:0x4C
    if(bThrowInitialized && int(Outer.MyEvilPawn.PawnAction) == 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function float GetInitLastDeactivationTime(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return super.GetInitLastDeactivationTime(AI, ActivationData) + RandRange(0.0000000, AI.MinDelayBetweenThrow);
    //return ReturnValue;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x51
    if(!AI.ShouldDeactivateActivePKAction() && ActivationData.bActive)
    {
        return 0.8000000;        
    }
    else
    {
        // End:0x1E7
        if(AI.ClearThrowLine() && int(AI.MyPKPawn.PawnAction) != 9)
        {
            // End:0x1E7
            if(AI.WorldInfo.TimeSeconds > (ActivationData.LastDeactivationTime + AI.MinDelayBetweenThrow))
            {
                // End:0x1E7
                if((AI.GetEnemyInfo().DistanceToEnemy < AI.ThrowRangeMax) && AI.GetEnemyInfo().DistanceToEnemy > AI.ThrowRangeMin)
                {
                    // End:0x1E7
                    if(FRand() < 0.4000000)
                    {
                        return 0.6100000;
                    }
                }
            }
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

state Throw
{Begin:

    // End:0x111
    if(Outer.HasValidEnemy())
    {
        Outer.SetFocalPoint(Outer.Enemy.Location);
        Outer.FinishRotation();
        Outer.StartThrowAttack();
        bThrowInitialized = true;
        J0xB8:

        Outer.Sleep(0.0500000);
        // End:0xB8
        if(!(int(Outer.MyEvilPawn.PawnAction) != 9))
            goto J0xB8;
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
