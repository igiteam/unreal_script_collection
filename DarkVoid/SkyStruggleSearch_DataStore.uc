class SkyStruggleSearch_DataStore extends UIDataStore_OnlineGameSearch
    transient
    native;

event Init()
{
    super.Init();
    // End:0x38
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete);
    }
    //return;    
}

// Export USkyStruggleSearch_DataStore::execTriggerSearchCompleteEvent(FFrame&, void* const)
native function TriggerSearchCompleteEvent(bool bWasSuccessful);

function OnSearchComplete(bool bWasSuccessful)
{
    local OnlineGameSearch GameSearchObj;

    // End:0x6B
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSearchObj = GameInterface.GetGameSearch();
        // End:0x60
        if((GameSearchObj != none) && GameSearchObj.Results.Length > 0)
        {
            TriggerSearchCompleteEvent(true);            
        }
        else
        {
            TriggerSearchCompleteEvent(false);
        }
    }
    super.OnSearchComplete(bWasSuccessful);
    //return;    
}
