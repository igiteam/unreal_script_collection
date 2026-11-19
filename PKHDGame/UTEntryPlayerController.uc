class UTEntryPlayerController extends UTPlayerController
    config(Game)
    hidecategories(Navigation);

var PostProcessChain EntryPostProcessChain;
var array<PostProcessChain> OldPostProcessChain;
var LocalPlayer OldPlayer;

event InitInputSystem()
{
    super(PlayerController).InitInputSystem();
    AddOnlineDelegates(false);
    CameraAnimPlayer = new (self) Class'Engine.CameraAnimInst';
    // End:0xF8
    if(EntryPostProcessChain != none)
    {
        // End:0x99
        if(OldPostProcessChain.Length == 0)
        {
            OldPostProcessChain = LocalPlayer(Player).PlayerPostProcessChains;
            OldPlayer = LocalPlayer(Player);
        }
        LocalPlayer(Player).RemoveAllPostProcessingChains();
        LocalPlayer(Player).InsertPostProcessingChain(EntryPostProcessChain, -1, false);
    }
    //return;    
}

simulated function RestorePostProcessing()
{
    local int PPIdx;

    // End:0xBF
    if((OldPlayer != none) && EntryPostProcessChain != none)
    {
        OldPlayer.RemoveAllPostProcessingChains();
        PPIdx = 0;
        J0x4A:

        // End:0xA8 [Loop If]
        if(PPIdx < OldPostProcessChain.Length)
        {
            OldPlayer.InsertPostProcessingChain(OldPostProcessChain[PPIdx], -1, true);
            PPIdx++;
            // [Loop Continue]
            goto J0x4A;
        }
        OldPostProcessChain.Length = 0;
        OldPlayer = none;
    }
    //return;    
}

simulated event Destroyed()
{
    RestorePostProcessing();
    super.Destroyed();
    //return;    
}

function OnControllerChanged(int ControllerId, bool bIsConnected)
{
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x93
    if((WorldInfo.IsConsoleBuild() && LocPlayer != none) && LocPlayer.ControllerId == ControllerId)
    {
        bIsControllerConnected = bIsConnected;
    }
    //return;    
}

function OnGameInviteReceived(byte LocalUserNum, string RequestingNick)
{
    //return;    
}

function OnFriendInviteReceived(byte LocalUserNum, UniqueNetId RequestingPlayer, string RequestingNick, string Message)
{
    //return;    
}

function OnFriendMessageReceived(byte LocalUserNum, UniqueNetId SendingPlayer, string SendingNick, string Message)
{
    //return;    
}

function OnConnectionStatusChange(OnlineSubsystem.EOnlineServerConnectionStatus ConnectionStatus)
{
    local bool bInvalidConnectionStatus;

    switch(ConnectionStatus)
    {
        // End:0x93
        case 7:
            SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.DuplicateLogin_Title>", "<Strings:UTGameUI.Errors.DuplicateLogin_Message>");
            bInvalidConnectionStatus = true;
            // End:0x1AD
            break;
        // End:0x98
        case 2:
        // End:0x9D
        case 3:
        // End:0xA2
        case 5:
        // End:0x122
        case 6:
            SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.ConnectionLost_Title>", "<Strings:UTGameUI.Errors.ConnectionLost_Message>");
            bInvalidConnectionStatus = true;
            // End:0x1AD
            break;
        // End:0x1AA
        case 4:
            SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.ServiceUnavailable_Title>", "<Strings:UTGameUI.Errors.ServiceUnavailable_Message>");
            bInvalidConnectionStatus = true;
            // End:0x1AD
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x1C4
    if(bInvalidConnectionStatus)
    {
        QuitToMainMenu();
    }
    //return;    
}

function OnLinkStatusChanged(bool bConnected)
{
    local string ErrorDisplay;
    local UIDataStore_Registry Registry;

    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
    // End:0x110
    if(!bConnected)
    {
        // End:0x110
        if(!Registry.GetData("FrontEndError_Display", ErrorDisplay) || int(ErrorDisplay) == 0)
        {
            SetFrontEndErrorMessage("<Strings:UTGameUI.Errors.Error_Title>", "<Strings:UTGameUI.Errors.NetworkLinkLost_Message>");
            QuitToMainMenu();
        }
    }
    //return;    
}

function QuitToMainMenu()
{
    // End:0x59
    if(GetURLMap() == "UDKFrontEndMap")
    {
        OnlineSub.GameInterface.DestroyOnlineGame('Game');        
    }
    else
    {
        super.QuitToMainMenu();
    }
    //return;    
}

function SetPawnConstructionScene(bool bShow)
{
    //return;    
}

function ShowMidGameMenu(optional name TabTag, optional bool bEnableInput)
{
    //return;    
}

function ShowScoreboard()
{
    //return;    
}

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__UTEntryPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__UTEntryPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__UTPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__UTEntryPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    CollisionComponent=CollisionCylinder
}