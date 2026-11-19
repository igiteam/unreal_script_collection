class PKAIcmd_Action_Hunt extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

function Pushed()
{
    super.Pushed();
    GotoState('SubState0');
    //return;    
}

function Popped()
{
    super.Popped();
    Outer.DelayToHunt = RandRange(0.1000000, 1.0000000);
    Outer.ClearAllTimers(self);
    //return;    
}

function bool ShouldDeactivate()
{
    return Outer.DelayToHunt > 0.0000000;
    //return ReturnValue;    
}

function DelayTimer()
{
    //return;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x1C5
    if(!AI.HasValidEnemy() && AI.GetEnemyInfo().bInitialized)
    {
        // End:0x1C5
        if((AI.DelayToHunt <= 0.0000000) && !AI.bWalkAreaWhenAttack)
        {
            // End:0x1C5
            if((((AI.GetEnemyInfo().LastSeenTime + 10.0000000) > AI.WorldInfo.TimeSeconds) && AI.GetEnemyInfo().DistanceToEnemy > AI.EnemyDistance_Melee) || !AI.ShouldDeactivateActivePKAction() && ActivationData.bActive)
            {
                return 0.1000000;
            }
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

state SubState0
{
    function DelayTimer()
    {
        // End:0x126
        if(Outer.GetEnemyInfo().DistanceToEnemy > Outer.EnemyDistance_Melee)
        {
            Outer.SetMovePoint(Outer.GetRandomLocation(Outer.MyPKPawn.GetCollisionRadius() * 2.0000000, true, Outer.GetEnemyInfo().KnownLocation),, Outer.bDontRunWhenHunt);            
        }
        else
        {
            Outer.SetMovePoint(Outer.GetEnemyInfo().KnownLocation,, Outer.bDontRunWhenHunt);
        }
        //return;        
    }
Begin:

    // End:0x1A5
    if(!Outer.IsTimerActive('DelayTimer', self))
    {
        // End:0x11F
        if(Outer.GetEnemyInfo().DistanceToEnemy < Outer.EnemyDistance_Melee)
        {
            Outer.SetFocalPoint(Outer.GetEnemyInfo().KnownLocation);
            Outer.SetTimer(RandRange(1.0000000, 1.5000000), false, 'DelayTimer', self);
            GotoState('SubState1');            
        }
        else
        {
            // End:0x194
            if(Outer.bAlwaysSee)
            {
                Outer.SetFocalPoint(Outer.GetEnemyInfo().KnownLocation);
            }
            GotoState('SubState2');
        }        
    }
    Outer.Sleep(0.0500000);
    goto 'Begin';
    stop;                
}

state SubState1
{
    function DelayTimer()
    {
        Outer.DelayToHunt = RandRange(0.1000000, 1.0000000);
        //return;        
    }
Begin:

    // End:0x64
    if(!Outer.IsTimerActive('DelayTimer', self))
    {
        Outer.DelayToHunt = RandRange(0.1000000, 1.0000000);        
    }
    stop;                
}

state SubState2
{Begin:

    Outer.SetMovePoint(Outer.GetEnemyInfo().KnownLocation,, Outer.bDontRunWhenHunt);
    Outer.SetTimer(RandRange(1.0000000, 1.5000000), false, 'DelayTimer', self);
    GotoState('SubState1');
    stop;                    
}
