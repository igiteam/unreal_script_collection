class AdvGFxUI_Menu_MainMenu extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget CampaignBtn;
var GFxClikWidget MultiBtn;
var GFxClikWidget SurvivalBtn;
var GFxClikWidget OptionsBtn;
var GFxClikWidget LeaderStatsBtn;
var GFxClikWidget CreditsBtn;
var GFxClikWidget ExitBtn;
var GFxObject VersionTF;
var const localized string TitleString;
var const localized string RestartNewGameMsg;
var const localized string CampaignString;
var const localized string MultiString;
var const localized string SurvivalString;
var const localized string OptionsString;
var const localized string LeaderStatsString;
var const localized string CreditsString;
var const localized string ExitString;
var const localized string MarketplaceButton;
var const localized string DLCUninstalledTitle;
var const localized string DLCUninstalledMsg;
var transient bool bIsOpeningBlockedByMessageBox;

function bool Start(optional bool StartPaused = false)
{
    local bool bWasUsingGamepad;

    AdvEngine(Class'AdvEngine'.static.GetEngine()).SetCheckMapLoading(false);
    super.Start(StartPaused);
    Advance(0.0000000);
    bWasUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
    FlushPlayerInput(false);
    GetPC().PlayerInput.bUsingGamepad = bWasUsingGamepad;
    ButtonsMC = MenuMC.GetObject("buttons");
    CampaignBtn = GFxClikWidget(ButtonsMC.GetObject("campaign_btn", Class'GFxUI.GFxClikWidget'));
    MultiBtn = GFxClikWidget(ButtonsMC.GetObject("multi_btn", Class'GFxUI.GFxClikWidget'));
    SurvivalBtn = GFxClikWidget(ButtonsMC.GetObject("survival_btn", Class'GFxUI.GFxClikWidget'));
    OptionsBtn = GFxClikWidget(ButtonsMC.GetObject("options_btn", Class'GFxUI.GFxClikWidget'));
    LeaderStatsBtn = GFxClikWidget(ButtonsMC.GetObject("stats_btn", Class'GFxUI.GFxClikWidget'));
    CreditsBtn = GFxClikWidget(ButtonsMC.GetObject("credits_btn", Class'GFxUI.GFxClikWidget'));
    ExitBtn = GFxClikWidget(ButtonsMC.GetObject("exit_btn", Class'GFxUI.GFxClikWidget'));
    CampaignBtn.SetString("label", CampaignString);
    MultiBtn.SetString("label", MultiString);
    SurvivalBtn.SetString("label", SurvivalString);
    OptionsBtn.SetString("label", OptionsString);
    LeaderStatsBtn.SetString("label", LeaderStatsString);
    CreditsBtn.SetString("label", CreditsString);
    ExitBtn.SetString("label", ExitString);
    VersionTF = RootMC.GetObject("builddate");
    // End:0x50A
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        ExitBtn.SetString("label", MarketplaceButton);        
    }
    else
    {
        // End:0x56D
        if(GetPC().WorldInfo.IsConsoleBuild(0))
        {
            ExitBtn.SetBool("visible", false);
        }
    }
    // End:0x622
    if(AdvGRI(GetPC().WorldInfo.GRI) != none)
    {
        VersionTF.SetText(AdvGRI(GetPC().WorldInfo.GRI).BuildString);
    }
    Frontend.GetPartyGame().RefreshPartySettings();
    LeaderStatsBtn.SetBool("disabled", false);
    // End:0x71C
    if(bDemoMode)
    {
        MultiBtn.SetBool("disabled", true);
        // End:0x71C
        if(GetPC().WorldInfo.IsConsoleBuild(1))
        {
            ExitBtn.SetBool("disabled", true);
        }
    }
    // End:0x7E1
    if(bMultiplayerBetaIMode)
    {
        MultiBtn.SetBool("disabled", false);
        CampaignBtn.SetBool("disabled", true);
        // End:0x7E1
        if(GetPC().WorldInfo.IsConsoleBuild(1))
        {
            ExitBtn.SetBool("disabled", true);
        }
    }
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x104
    if((UIManager != none) && UIManager.OpenMessageBoxes.Length > 0)
    {
        bIsOpeningBlockedByMessageBox = true;
        RootMC.SetVisible(false);
        // End:0x102
        if(Frontend.footer != none)
        {
            Frontend.footer.RootMC.SetVisible(false);
        }
        return;
    }
    RootMC.SetVisible(true);
    // End:0x192
    if(Frontend.footer != none)
    {
        Frontend.footer.RootMC.SetVisible(true);
    }
    super.PlayOpenAnimation();
    GetMenuGame().SetPartyRichPresenceString(GetAdvPC());
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    // End:0x68
    if(!GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.AddItem('GenericExit');        
    }
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    // End:0x36
    if(bIsOpeningBlockedByMessageBox)
    {
        bIsOpeningBlockedByMessageBox = false;
        PlayOpenAnimation();
    }
    //return;    
}

function OnBack(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    Class'AdvUIManager'.static.ShowUIMessage('ExitGameConfirm', Localize("MessageBoxStrings", "ExitGame_Title", "ADVGame"), Localize("MessageBoxStrings", "ExitGame_Message", "ADVGame"), ButtonAliases, OnExitGameOptionSelected);
    //return;    
}

function bool OnExitGameOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PKPC;

    // End:0x81
    if(SelectedInputAlias == 'GenericYes')
    {
        PKPC = AdvPlayerController(GetPC());
        // End:0x64
        if(PKPC != none)
        {
            PKPC.ClientSaveAllPlayerData(true);
        }
        Action = "back";
        PlayCloseAnimation();        
    }
    else
    {
        ExitBtn.SetBool("focused", false);
        ExitBtn.SetBool("focused", true);
    }
    return true;
    //return ReturnValue;    
}

function OnCampaignBtn(EventData ev)
{
    Action = "selectslot";
    PlayCloseAnimation();
    //return;    
}

function OnMultiBtn(EventData ev)
{
    local array<name> ButtonAliases;
    local FamilyInfoToPackageName FInfoMP;
    local AdvPlayerController PC;

    GetMenuGRI().LoadPartyTypeFromProfile(GetAdvPC());
    Frontend.bOnMPScreens = true;
    // End:0xB7
    if(!Frontend.AttemptNetworkedMatchTransition())
    {
        GetMenuGRI().SetCurrentPartyType(2, none);
        Frontend.bOnMPScreens = false;
        return;
    }
    GetMenuGRI().SetCurrentPartyType(2, none);
    Frontend.bOnMPScreens = false;
    PC = AdvPlayerController(GetPC());
    FInfoMP = Class'AdvCharacterStore'.default.FamilyInfosToPackages[PC.GetPlayerCharacterMP()];
    // End:0x1D4
    if(FInfoMP.bVisibleInMenu || Class'AdvGFxUI_Menu_MultiPlayerSkin'.static.CheckIfSkinIsAccessibleInDLC(FInfoMP, PC))
    {
        Action = "multi";
        PlayCloseAnimation();        
    }
    else
    {
        ButtonAliases.AddItem('GenericContinue');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', DLCUninstalledTitle, DLCUninstalledMsg, ButtonAliases, OnContinueOptionSelectedMP, GetLP(),,,, false,,, true);
    }
    //return;    
}

function bool OnContinueOptionSelectedMP(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    PC.SetPlayerCharacterMP(-1);
    Class'AdvFrontEnd'.static.PrepareDefaultMultiplayerSkin(PC);
    PC.ClientSaveAllPlayerData();
    Action = "multi";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnSurvivalBtn(EventData ev)
{
    local array<name> ButtonAliases;
    local FamilyInfoToPackageName FInfoSV;
    local AdvPlayerController PC;

    GetMenuGRI().LoadPartyTypeFromProfile(GetAdvPC());
    Frontend.bOnMPScreens = true;
    // End:0xB7
    if(!Frontend.AttemptNetworkedMatchTransition())
    {
        GetMenuGRI().SetCurrentPartyType(2, none);
        Frontend.bOnMPScreens = false;
        return;
    }
    GetMenuGRI().SetCurrentPartyType(2, none);
    Frontend.bOnMPScreens = false;
    PC = AdvPlayerController(GetPC());
    FInfoSV = Class'AdvCharacterStore'.default.FamilyInfosToPackages[PC.GetPlayerCharacterMP()];
    // End:0x1D4
    if(FInfoSV.bVisibleInMenu || Class'AdvGFxUI_Menu_MultiPlayerSkin'.static.CheckIfSkinIsAccessibleInDLC(FInfoSV, PC))
    {
        Action = "multi";
        PlayCloseAnimation();        
    }
    else
    {
        ButtonAliases.AddItem('GenericContinue');        
        Class'AdvUIManager'.static.ShowUIMessage('PauseOptionConfirm', DLCUninstalledTitle, DLCUninstalledMsg, ButtonAliases, OnContinueOptionSelectedSV, GetLP(),,,, false,,, true);
    }
    Action = "survival";
    PlayCloseAnimation();
    //return;    
}

function bool OnContinueOptionSelectedSV(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    PC.SetPlayerCharacterSV(-1);
    Class'AdvFrontEnd'.static.PrepareDefaultSurvivalSkin(PC);
    PC.ClientSaveAllPlayerData();
    Action = "multi";
    PlayCloseAnimation();
    return true;
    //return ReturnValue;    
}

function OnOptionsBtn(EventData ev)
{
    Action = "options";
    PlayCloseAnimation();
    //return;    
}

function OnCreditsBtn(EventData ev)
{
    Action = "credits";
    PlayCloseAnimation();
    //return;    
}

function OnStatsBtn(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x1D0
    if(((Frontend.OnlineSub != none) && NotEqual_InterfaceInterface(Frontend.OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && Frontend.OnlineSub.PlayerInterface.IsGuestLogin(byte(GetLP().ControllerId)))
    {
        ButtonAliases.AddItem('GenericAccept');        
        Class'AdvUIManager'.static.ShowUIMessage('NotSignedInError', "<Strings:ADVGame.MessageBoxErrorStrings.IllegalGuestAction_StatisticsTitle>", "<Strings:ADVGame.MessageBoxErrorStrings.IllegalGuestAction_StatisticsMessage>", ButtonAliases);        
    }
    else
    {
        Action = "stats";
        PlayCloseAnimation();
    }
    //return;    
}

function OnExitBtn(EventData ev)
{
    local OnlineSubsystem.ELoginStatus LoginStatus;

    // End:0x262
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        LoginStatus = Class'Engine.UIInteraction'.static.GetLoginStatus(GetLP().ControllerId);
        // End:0x168
        if((int(LoginStatus) != int(2)) && !OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId)))
        {
            Class'AdvUIManager'.static.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "XboxLive_Title", "GenericContinue", GetLP());            
        }
        else
        {
            // End:0x236
            if(OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId)))
            {
                Class'AdvUIManager'.static.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "XboxLive_Title", "GenericContinue", GetLP());                
            }
            else
            {
                AdvPlayerController(GetPC()).ShowMarketPlace();
            }
        }        
    }
    else
    {
        OnBack(ev);
    }
    //return;    
}

function OnBetaWWWBtn(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).OpenPainkillerBetaWWW();
    //return;    
}

function bool OnRemovedDeviceChosen(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvLocalPlayer LP;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x9F
    if(SelectedInputAlias == 'AcceptSelectDevice')
    {
        AdvDataProvider_PlayerStorage(GetAdvPC().OnlinePlayerData.StorageProvider).ShowDeviceSelection();        
    }
    else
    {
        // End:0x1EA
        if(SelectedInputAlias == 'CancelContinueAnyway')
        {
            LP = AdvLocalPlayer(GetLP());
            // End:0x1EA
            if(LP != none)
            {
                GetAdvPC().SetDeviceId(-1);
                LP.bWantsToSkipSaves = true;
                Eng.SelectedSaveSlot = 0;
                Eng.ClearSavedSlotData(0);
                Eng.ClearSavedSlotData(1);
                Eng.ClearSavedSlotData(2);
                // End:0x1EA
                if(Frontend.OpenCampaignScreen())
                {
                    Frontend.CloseMainMenu();
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function bool TryTransitionToSaveSlotMenu()
{
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;

    // End:0x15A
    if(!GetAdvPC().IsStorageDeviceValid())
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('AcceptSelectDevice');        
        ButtonAliases.AddItem('CancelContinueAnyway');        
        UIManager.ShowUIMessage('StorageError', Localize("MessageBoxErrorStrings", "NoPrimaryDevice", "ADVGame"), Localize("MessageBoxErrorStrings", "NoPrimaryDevice_Message", "ADVGame"), ButtonAliases, OnRemovedDeviceChosen, GetLP(),, 110, false, false, false,, true);
        return false;
    }
    AdvLocalPlayer(GetLP()).SetCanShowStorageDeviceWarning(true);
    return Frontend.OpenSaveScreen(1);
    //return ReturnValue;    
}

function OnCloseAnimationComplete()
{
    local AdvLocalPlayer LP;
    local AdvPartyGRI GRI;
    local bool bTransitionResult;
    local array<name> ButtonAliases;

    ButtonAliases.Length = 0;
    LP = AdvLocalPlayer(GetLP());
    switch(Action)
    {
        // End:0xBE
        case "back":
            // End:0xAB
            if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(0))
            {
                ADVPartyPC(GetPC()).RestartFrontEnd();                
            }
            else
            {
                ConsoleCommand("quit");
            }
            // End:0x434
            break;
        // End:0xF6
        case "single":
            bTransitionResult = Frontend.OpenCampaignScreen();
            // End:0x434
            break;
        // End:0x11D
        case "selectslot":
            bTransitionResult = TryTransitionToSaveSlotMenu();
            // End:0x434
            break;
        // End:0x204
        case "multi":
            GetMenuGame().MultiGameModeSelected = 7;
            GRI = AdvPartyGRI(GetMenuGRI());
            // End:0x1B7
            if(GRI != none)
            {
                GRI.SetLobbyState(1);
                GRI.bSurvival = false;
            }
            LP.SetCanShowStorageDeviceWarning(false);
            bTransitionResult = Frontend.OpenMultiMenuScreen();
            // End:0x434
            break;
        // End:0x2F1
        case "survival":
            GetMenuGame().MultiGameModeSelected = 3;
            GRI = AdvPartyGRI(GetMenuGRI());
            // End:0x2A1
            if(GRI != none)
            {
                GRI.SetLobbyState(1);
                GRI.bSurvival = true;
            }
            LP.SetCanShowStorageDeviceWarning(false);
            bTransitionResult = Frontend.OpenMultiSurvivalScreen();
            // End:0x434
            break;
            // End:0x434
            break;
        // End:0x32A
        case "options":
            bTransitionResult = Frontend.OpenOptionsScreen();
            // End:0x434
            break;
        // End:0x361
        case "stats":
            bTransitionResult = Frontend.OpenLeaderStatsScreen();
            // End:0x434
            break;
        // End:0x42E
        case "credits":
            // End:0x42B
            if(AdvGFxHudWrapper(GetPC().myHUD) != none)
            {
                Frontend.footer.FooterUpdate(ButtonAliases);
                AdvGFxHudWrapper(GetPC().myHUD).ShowCredits(Class'AdvGFxUI_Credits');
                bTransitionResult = true;
            }
            // End:0x434
            break;
        // End:0xFFFF
        default:
            // End:0x434
            break;
            break;
    }
    // End:0x463
    if(bTransitionResult)
    {
        Frontend.CloseMainMenu();        
    }
    else
    {
        PlayOpenAnimation();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Main Menu"
    CampaignString="Adventure"
    MultiString="Multiplayer"
    SurvivalString="Survival"
    OptionsString="Options"
    LeaderStatsString="Stats"
    CreditsString="Credits"
    ExitString="Exit"
    MarketplaceButton="Xbox Games Store"
    DLCUninstalledTitle="Downloadable content uninstalled"
    DLCUninstalledMsg="Your selected multiplayer skin is no longer available. Your skin will be set as default one."
    MovieInfoPath="UI_AdvUI.AdvMainMenu"
}