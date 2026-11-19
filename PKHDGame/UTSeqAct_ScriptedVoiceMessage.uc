class UTSeqAct_ScriptedVoiceMessage extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var() SoundNodeWave VoiceToPlay;
var() string SpeakingCharacterName;

event Activated()
{
    local UTGameReplicationInfo GRI;
    local EvilPlayerReplicationInfo PRI, Sender;
    local int I;

    GRI = UTGameReplicationInfo(GetWorldInfo().GRI);
    // End:0x1B5
    if(GRI != none)
    {
        I = 0;
        J0x4C:

        // End:0x115 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            PRI = EvilPlayerReplicationInfo(GRI.PRIArray[I]);
            // End:0x107
            if((PRI != none) && PRI.PlayerName ~= SpeakingCharacterName)
            {
                Sender = PRI;
                // [Explicit Break]
                goto J0x115;
            }
            I++;
            // [Loop Continue]
            goto J0x4C;
        }
        J0x115:

        // End:0x163
        if(Sender != none)
        {
            GRI.BroadcastLocalizedMessage(Class'UTScriptedVoiceMessage',, Sender,, VoiceToPlay);            
        }
        else
        {
            ScriptLog(("Failed to find character '" $ SpeakingCharacterName) $ "' for scripted voice message");
        }
    }
    //return;    
}

static event int GetObjClassVersion()
{
    return super(SequenceObject).GetObjClassVersion() + 1;
    //return ReturnValue;    
}

defaultproperties
{
    VariableLinks=none
    ObjName="Play Voice Message"
}