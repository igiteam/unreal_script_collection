class PKAICmd_Base_EvilMonkRich extends PKAIcmd_Base_UtilActionSelector within PKAIController;

var export editinline EvilUtilBasedAICmdMetaDataPacket ThrowMeta;

function Pushed()
{
    super.Pushed();
    // End:0x2C
    if(FRand() < 0.8000000)
    {
        PossibleCommands.AddItem(ThrowMeta);
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilUtilBasedAICmdMetaDataPacket'Default__PKAICmd_Base_EvilMonkRich.Throw'
    begin object name="Throw" class=Class'EvilGame.EvilUtilBasedAICmdMetaDataPacket'
        CommandClass=Class'PKAIcmd_Action_Throw'
    end object
    ThrowMeta=Throw
    PossibleCommands=/* Array type was not detected. */
}