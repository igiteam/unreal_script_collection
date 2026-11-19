class UIAction_DownloadableContentAvailable extends UIAction
    native;

var transient bool bDone;
var transient OnlineContentInterface ContentInterface;
var() int TotalDownloads;
var() int NewDownloads;

function OnQueryDownloadsComplete(bool bWasSuccessful)
{
    // End:0x3A
    if(NotEqual_InterfaceInterface(ContentInterface, OnlineContentInterface(none)))
    {
        ContentInterface.GetAvailableDownloadCounts(byte(PlayerIndex), NewDownloads, TotalDownloads);
    }
    ContentInterface = none;
    bDone = true;
    //return;    
}

event RegisterCallback(OnlineContentInterface ci)
{
    // End:0x6E
    if(NotEqual_InterfaceInterface(ci, OnlineContentInterface(none)))
    {
        ContentInterface = ci;
        ci.AddQueryAvailableDownloadsComplete(byte(PlayerIndex), OnQueryDownloadsComplete);
        // End:0x6E
        if(!ci.QueryAvailableDownloads(byte(PlayerIndex)))
        {
            bDone = true;
        }
    }
    //return;    
}
