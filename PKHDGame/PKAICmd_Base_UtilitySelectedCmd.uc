class PKAICmd_Base_UtilitySelectedCmd extends EvilAICmd_Base_UtilitySelectedCmd within PKAIController;

var const float InitPriority;

static function float EvaluateActivation(EvilAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    // End:0x41
    if(PKAIController(AI) != none)
    {
        return EvaluatePKActivation(PKAIController(AI), ActivationData);        
    }
    else
    {
        return ActivationData.ActualPriority;
    }
    //return ReturnValue;    
}

static function float EvaluatePKActivation(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return ActivationData.ActualPriority;
    //return ReturnValue;    
}

static function float GetInitLastDeactivationTime(PKAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return FMax(FMax(ActivationData.LastDeactivationTime, ActivationData.LastActivationTime), AI.WorldInfo.TimeSeconds);
    //return ReturnValue;    
}

function bool ShouldDeactivate()
{
    return false;
    //return ReturnValue;    
}

function Pushed()
{
    super(EvilAICmd_Base_Combat).Pushed();
    Outer.SetTimer(0.1000000, true, 'UpdateFarAttackPrio', self);
    //return;    
}

function Popped()
{
    super(EvilAICmd_Base_Combat).Popped();
    Outer.ClearAllTimers(self);
    //return;    
}

function bool IsAttacking()
{
    return false;
    //return ReturnValue;    
}

function UpdateFarAttackPrio()
{
    //return;    
}

state FirstSeeEnemy
{Begin:

    // End:0x39
    if(Outer.CanSee(Outer.Enemy))
    {
    }
    Outer.Focus = Outer.Enemy;
    Outer.bFirstTimeSee = false;
End:


    GotoState('Idle');
    stop;            
}

state Attack
{
    function bool IsAttacking()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Idle
{    stop;    
}
