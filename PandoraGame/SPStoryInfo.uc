class SPStoryInfo extends Info
    native
    config(Game);

var private SPStoryDataStore CurrentStoryData;
var bool bPlayMessageReceivedSound;
var bool bDisplayNotificationOnHud;
var bool bBindDataStore;
var() databinding bool bAvailable;
var float displayTimer;
/** Designer can adjust the display duration */
var() float displayDuration;
var() string notificationText;
var() float FadeTime;
var databinding int storySendTime;
/** Name of the sender, i.e.: . */
var() databinding globalconfig string Sender;
/** Sender's image */
var() databinding Surface SenderImage;
var() databinding globalconfig string Subject;
var() databinding globalconfig string Message;

simulated function PostBeginPlay()
{
    InitializeGameDataStore();
    //return;    
}

function Reset()
{
    super(Actor).Reset();
    //return;    
}

simulated event Destroyed()
{
    super(Actor).Destroyed();
    CleanupGameDataStore();
    //return;    
}

simulated function Timer()
{
    //return;    
}

function Tick(float DeltaTime)
{
    local PlayerPawn P;
    local SPHud HUD;

    // End:0x6E
    if(bBindDataStore)
    {
        // End:0x5B
        foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
        {
            HUD = P.playerHud;
            // End:0x5A
            if(HUD != none)
            {
                HUD.bBindStoryDataProvider = true;
            }            
        }        
        InitializeGameDataStore();
        bBindDataStore = false;
    }
    // End:0x8B
    if(bAvailable)
    {
        displayTimer += DeltaTime;
        bDisplayNotificationOnHud = true;
    }
    // End:0xA2
    if(displayTimer > displayDuration)
    {
        bDisplayNotificationOnHud = false;
    }
    //return;    
}

simulated function InitializeGameDataStore()
{
    local DataStoreClient DataStoreManager;

    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x54
    if(DataStoreManager != none)
    {
        CurrentStoryData = SPStoryDataStore(DataStoreManager.FindDataStore('SPStoryDataStore'));
        // End:0x54
        if(CurrentStoryData != none)
        {            
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
