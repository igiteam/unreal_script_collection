class AdvDownloadContentManager extends DownloadableContentManager
    native(Online)
    config(Game);

struct native SeasonPassItem
{
    var int LicenseMask;
    var int OfferId;

    structdefaultproperties
    {
        LicenseMask=0
        OfferId=0
    }
};

var int SeasonPassLicenseMask;
var const bool bHasSeasonPassInstalled;
var config array<config SeasonPassItem> SeasonPassItems;

// Export UAdvDownloadContentManager::execInstallDLCs(FFrame&, void* const)
native function InstallDLCs(const out array<OnlineContent> DLCBundles);

// Export UAdvDownloadContentManager::execInstallDLC(FFrame&, void* const)
native function bool InstallDLC(const out OnlineContent DLCBundle);

// Export UAdvDownloadContentManager::execGetDownloadableSeasonPassOffers(FFrame&, void* const)
native function GetDownloadableSeasonPassOffers(const out array<OnlineContent> DLCBundles, out array<int> SeasonPassOfferIds);

function AdvLocalPlayer GetMainLP()
{
    local AdvEngine Eng;

    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    return AdvLocalPlayer(Eng.GamePlayers[0]);
    //return ReturnValue;    
}

function OnStorageDeviceChange()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerInt;
    local DownloadableContentEnumerator DLCEnumerator;
    local int DLCIndex;
    local bool bDlcHasInvalidDevice;
    local AdvLocalPlayer LP;
    local AdvEngine Eng;
    local AdvFrontEnd Frontend;
    local bool bOnTitleScreen;
    local AdvPreGamePC LobbyPC;

    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x352
    if(InstalledDLC.Length > 0)
    {
        Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
        bOnTitleScreen = (Frontend != none) && Frontend.bOnTitleScreen;
        DLCEnumerator = Class'Engine.GameEngine'.static.GetDLCEnumerator();
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x352
        if((DLCEnumerator != none) && OnlineSub != none)
        {
            PlayerInt = OnlineSub.PlayerInterfaceEx;
            // End:0x352
            if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterfaceEx(none)))
            {
                DLCIndex = 0;
                J0x16B:

                // End:0x259 [Loop If]
                if(DLCIndex < DLCEnumerator.DLCBundles.Length)
                {
                    // End:0x24B
                    if((DLCEnumerator.DLCBundles[DLCIndex].DeviceID > 0) && !PlayerInt.IsDeviceValid(DLCEnumerator.DLCBundles[DLCIndex].DeviceID))
                    {
                        bDlcHasInvalidDevice = true;
                        // [Explicit Break]
                        goto J0x259;
                    }
                    DLCIndex++;
                    // [Loop Continue]
                    goto J0x16B;
                }
                J0x259:

                // End:0x352
                if(bDlcHasInvalidDevice)
                {
                    // End:0x348
                    if(Class'Engine.WorldInfo'.static.IsMenuLevel() && !Eng.IsPlayingLoadingMovie())
                    {
                        ClearDLC();
                        LP = GetMainLP();
                        // End:0x345
                        if(!bOnTitleScreen)
                        {
                            LobbyPC = AdvPreGamePC(LP.Actor);
                            // End:0x33B
                            if(LobbyPC != none)
                            {
                                LobbyPC.DestroyPreGameLobbyBecauseStorageDeviceRemovalWithDLC();
                            }
                            ShowStorageDeviceRemovalWithDLC();
                        }                        
                    }
                    else
                    {
                        RebootGame();
                    }
                }
            }
        }
    }
    //return;    
}

function ShowStorageDeviceRemovalWithDLC()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvLocalPlayer LP;

    LP = GetMainLP();
    ButtonAliases.AddItem('GenericAccept');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ClearUIMessage('NoStorageDevice');
    UIManager.ShowUIMessage('DLCRemoved', Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuTitle", "ADVGame"), Localize("MessageBoxErrorStrings", "DLCRemovedAtMenuMessage", "ADVGame"), ButtonAliases, OnStorageDeviceRemoveWithDLC, LP);
    //return;    
}

function bool OnStorageDeviceRemoveWithDLC(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvLocalPlayer LP;

    LP = GetMainLP();
    AdvPlayerController(LP.Actor).ReturnToMainMenu(true);
    return true;
    //return ReturnValue;    
}

function OnContentChange()
{
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local AdvEngine Eng;

    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x81
    if(!Eng.IgnoreDLCEnumeration)
    {
        RefreshDLC();
        Eng.IgnoreDLCEnumeration = false;
    }
    // End:0xAD
    if(Eng.ForceReturnToISAfterDLCRemoval)
    {
        ClearDLC();
    }
    //return;    
}

// Export UAdvDownloadContentManager::execRebootGame(FFrame&, void* const)
private native final function RebootGame();
