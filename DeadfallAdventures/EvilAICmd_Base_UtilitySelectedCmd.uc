class EvilAICmd_Base_UtilitySelectedCmd extends EvilAICmd_Base_Combat within EvilAIController;

static function bool InitUtilitySelectedCommand(EvilAIController Controller, EvilUtilBasedAICmdMetaDataPacket MetaData)
{
    local EvilAICmd_Base_UtilitySelectedCmd Cmd;

    MetaData.LastActivationTime = Controller.WorldInfo.TimeSeconds;
    MetaData.NumberOfActivations++;
    MetaData.bActive = true;
    // End:0xFB
    if(Controller != none)
    {
        Cmd = new (Controller) default.Class;
        // End:0xFB
        if(Cmd != none)
        {
            Controller.PushCommand(Cmd);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static function bool DeactivateUtilitySelectedCommand(EvilAIController Controller, EvilUtilBasedAICmdMetaDataPacket MetaData)
{
    local EvilAICmd_Base_UtilitySelectedCmd Cmd;

    Cmd = EvilAICmd_Base_UtilitySelectedCmd(Controller.GetAICommandInStack(default.Class));
    // End:0xEB
    if(Cmd != none)
    {
        // End:0xEB
        if(Controller.AbortCommand(Cmd))
        {
            MetaData.LastDeactivationTime = Controller.WorldInfo.TimeSeconds;
            MetaData.bActive = false;
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

static function float EvaluateActivation(EvilAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return 0.0000000;
    //return ReturnValue;    
}
