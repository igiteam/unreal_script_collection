class PKDownloadContentManagerPC extends DownloadableContentManager;

event Init()
{
    local OnlineSubsystemSteamworks OnlineSub;

    super.Init();
    OnlineSub = OnlineSubsystemSteamworks(Class'Engine.GameEngine'.static.GetOnlineSubsystem());
    OnlineSub.AddReadUGCFileCompleteDelegate(ReadUGCFileComplete);
    OnlineSub.AddReadUGCFileStartedDelegate(ReadUGCFileStarted);
    //return;    
}

simulated function ReadUGCFileStarted(bool bWasSuccessful, string Filename, string EntryTitle, string EntryDescription)
{
    local PKFrontEnd FrontEnd;

    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0x76
    if(FrontEnd != none)
    {
        FrontEnd.UGCDownloadTracker.Setup(true, EntryTitle);
    }
    //return;    
}

simulated function ReadUGCFileComplete(bool bWasSuccessful, string Filename, string EntryTitle, string EntryDescription)
{
    local PKFrontEnd FrontEnd;
    local PKDownloadContentEnumeratorPC DLCEnum;

    FrontEnd = Class'PKFrontEnd'.static.GetFrontEnd();
    // End:0x3B
    if(FrontEnd == none)
    {        
    }
    else
    {
        // End:0xA5
        if(bWasSuccessful)
        {
            DLCEnum = PKDownloadContentEnumeratorPC(Class'Engine.GameEngine'.static.GetDLCEnumerator());
            DLCEnum.LoadUGCDirectory(Filename);            
        }
        FrontEnd.UGCDownloadTracker.PlayCloseAnimation();
    }
    //return;    
}
