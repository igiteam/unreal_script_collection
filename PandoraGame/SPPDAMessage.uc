class SPPDAMessage extends Object
    native
    perobjectconfig
    editinlinenew;

var private SPStoryDataStore CurrentStoryData;
var bool bPlayMessageReceivedSound;
var bool bDisplayNotificationOnHud;
var bool bBindDataStore;
var bool bAvailable;
var float displayTimer;
var() string notificationText;
/** Designer can adjust the display duration */
var() float displayDuration;
var() float FadeTime;
var float messegeSendTime;
/** Name of the sender, i.e.: . */
var() databinding const localized string Sender;
/** Sender's image */
var() databinding Surface SenderImage;
var() databinding const localized string Subject;
var() databinding const localized string Message;
var() databinding const localized SoundCue voiceMail;

event BindToDataStore()
{
    InitializeGameDataStore();
    //return;    
}

event NotifyHud()
{
    local WorldInfo wInfo;
    local PlayerPawn P;
    local SPHud HUD;

    wInfo = Class'SPHud'.static.GetWorldInfo();
    // End:0x89
    if(bBindDataStore && wInfo != none)
    {
        // End:0x80
        foreach wInfo.AllPawns(Class'PlayerPawn', P)
        {
            HUD = P.playerHud;
            // End:0x7F
            if(HUD != none)
            {
                HUD.PDAMessageReceived();
            }            
        }        
        bBindDataStore = false;
    }
    //return;    
}

simulated function InitializeGameDataStore()
{
    local DataStoreClient DataStoreManager;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x65
    if(DataStoreManager != none)
    {
        CurrentStoryData = SPStoryDataStore(DataStoreManager.FindDataStore('SPStoryDataStore'));
        // End:0x65
        if(CurrentStoryData != none)
        {
            CurrentStoryData.CreateStoryDataProvider(self);            
        }
    }
    //return;    
}

simulated function CleanupGameDataStore()
{
    // End:0x1B
    if(CurrentStoryData != none)
    {
        CurrentStoryData.ClearDataProviders();
    }
    CurrentStoryData = none;
    //return;    
}
