class PandoraPDAManager extends Actor
    native
    notplaceable;

var array<byte> PDAMsgData;
var array<PDAMessage> UnlockedPDAMessages;
var PandoraPlayerController myPC;
var PandoraGameInfo myGameInfo;
var PandoraGameInfo.EMessage_Type SortBy;

// Export UPandoraPDAManager::execConvertPDAMsgData(FFrame&, void* const)
native function ConvertPDAMsgData();

// Export UPandoraPDAManager::execBuildUnlockedPDAMsgs(FFrame&, void* const)
native function BuildUnlockedPDAMsgs();

// Export UPandoraPDAManager::execUnlockPDAMessage(FFrame&, void* const)
native function bool UnlockPDAMessage(PandoraGameInfo pGameInfo, PDAMessage msg, string UnlockUISceneName);

function string GetLastUnlockedPDAMessage()
{
    local string UISceneName;

    UISceneName = "";
    // End:0x8F
    if(!UnlockedPDAMessages[0].bViewed)
    {
        UISceneName = UnlockedPDAMessages[0].UISceneName;
        // End:0x8F
        if(!UnlockedPDAMessages[0].bViewed)
        {
            UnlockedPDAMessages[0].bViewed = true;
            // End:0x8F
            if(myPC != none)
            {
                myPC.ProfileSettings.SetProfileDirty(true);
            }
        }
    }
    return UISceneName;
    //return ReturnValue;    
}

function ResetPDAMessages(optional int EpisodeNo = 0)
{
    local int Index;

    Index = 0;
    J0x0C:

    // End:0x54 [Loop If]
    if(Index < UnlockedPDAMessages.Length)
    {
        // End:0x4A
        if(UnlockedPDAMessages[Index].EpisodeNo >= EpisodeNo)
        {
            UnlockedPDAMessages.Remove(Index--, 1);
        }
        Index++;
        // [Loop Continue]
        goto J0x0C;
    }
    // End:0x7E
    if(myPC != none)
    {
        myPC.ProfileSettings.SetProfileDirty(true);
    }
    //return;    
}

function int GetUnlockedNewMessageCount()
{
    local int NewMessageCount, I;

    // End:0x12
    if(int(SortBy) == int(0))
    {
        return 0;
    }
    NewMessageCount = 0;
    I = 0;
    J0x20:

    // End:0x83 [Loop If]
    if(I < UnlockedPDAMessages.Length)
    {
        // End:0x79
        if((int(UnlockedPDAMessages[I].eMsgType) == int(SortBy)) && !UnlockedPDAMessages[I].bViewed)
        {
            NewMessageCount++;
        }
        I++;
        // [Loop Continue]
        goto J0x20;
    }
    return NewMessageCount;
    //return ReturnValue;    
}
