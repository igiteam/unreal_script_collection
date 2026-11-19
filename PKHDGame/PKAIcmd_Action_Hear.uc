class PKAIcmd_Action_Hear extends PKAICmd_Base_UtilitySelectedCmd within PKAIController;

static function float EvaluateActivation(EvilAIController AI, EvilUtilBasedAICmdMetaDataPacket ActivationData)
{
    return 0.0100000;
    //return ReturnValue;    
}
