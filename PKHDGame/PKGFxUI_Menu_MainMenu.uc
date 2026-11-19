class PKGFxUI_Menu_MainMenu extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxClikWidget CampaignBtn;
var GFxClikWidget MultiBtn;
var GFxClikWidget OptionsBtn;
var GFxClikWidget LeaderStatsBtn;
var GFxClikWidget ExitBtn;
var GFxClikWidget DLCBtn1;
var GFxClikWidget DLCBtn2;
var GFxClikWidget DLCBtn3;
var const localized string DLC1String;
var const localized string DLC2String;
var const localized string DLC3String;
var const localized string DLC4String;
var const localized string DLC5String;
var const localized string DLC6String;
var const localized string DLC7String;
var GFxObject VersionMC;
var GFxObject VersionTF;
var const localized string TitleString;
var const localized string RestartNewGameMsg;
var const localized string CampaignString;
var const localized string MultiString;
var const localized string OptionsString;
var const localized string LeaderStatsString;
var const localized string ExitString;
var transient bool bIsOpeningBlockedByMessageBox;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    FlushPlayerInput(false);
    ButtonsMC = MenuMC.GetObject("buttons");
    CampaignBtn = GFxClikWidget(ButtonsMC.GetObject("campaign_btn", Class'GFxUI.GFxClikWidget'));
    MultiBtn = GFxClikWidget(ButtonsMC.GetObject("multi_btn", Class'GFxUI.GFxClikWidget'));
    OptionsBtn = GFxClikWidget(ButtonsMC.GetObject("options_btn", Class'GFxUI.GFxClikWidget'));
    LeaderStatsBtn = GFxClikWidget(ButtonsMC.GetObject("stats_btn", Class'GFxUI.GFxClikWidget'));
    ExitBtn = GFxClikWidget(ButtonsMC.GetObject("exit_btn", Class'GFxUI.GFxClikWidget'));
    DLCBtn1 = GFxClikWidget(ButtonsMC.GetObject("dlc_btn", Class'GFxUI.GFxClikWidget'));
    DLCBtn2 = GFxClikWidget(ButtonsMC.GetObject("dlc_btn2", Class'GFxUI.GFxClikWidget'));
    DLCBtn3 = GFxClikWidget(ButtonsMC.GetObject("dlc_btn3", Class'GFxUI.GFxClikWidget'));
    CampaignBtn.SetString("label", CampaignString);
    MultiBtn.SetString("label", MultiString);
    OptionsBtn.SetString("label", OptionsString);
    LeaderStatsBtn.SetString("label", LeaderStatsString);
    ExitBtn.SetString("label", ExitString);
    VersionMC = RootMC.GetObject("version");
    VersionTF = VersionMC.GetObject("textField");
    // End:0x451
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ExitBtn.SetBool("visible", false);
    }
    // End:0x529
    if(PainGRI(GetPC().WorldInfo.GRI) != none)
    {
        VersionMC.SetVisible(true);
        VersionTF.SetText(PainGRI(GetPC().WorldInfo.GRI).BuildString);        
    }
    else
    {
        VersionMC.SetVisible(false);
    }
    DLCBtn1.SetString("label", DLC5String);
    DLCBtn2.SetString("label", DLC6String);
    DLCBtn3.SetString("label", DLC7String);
    // End:0x63B
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(12)) == int(0))
    {
        DLCBtn1.SetBool("visible", true);        
    }
    else
    {
        DLCBtn1.SetBool("visible", false);
    }
    // End:0x6C6
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(13)) == int(0))
    {
        DLCBtn2.SetBool("visible", true);        
    }
    else
    {
        DLCBtn2.SetBool("visible", false);
    }
    // End:0x751
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(14)) == int(0))
    {
        DLCBtn3.SetBool("visible", true);        
    }
    else
    {
        DLCBtn3.SetBool("visible", false);
    }
    return true;
    //return ReturnValue;    
}

function OnDLCBtn1(EventData ev)
{
    PKEngine(Class'Engine.Engine'.static.GetEngine()).SteamActivateGameOverlayToStore(229270, 2);
    //return;    
}

function OnDLCBtn2(EventData ev)
{
    PKEngine(Class'Engine.Engine'.static.GetEngine()).SteamActivateGameOverlayToStore(229290, 2);
    //return;    
}

function OnDLCBtn3(EventData ev)
{
    PKEngine(Class'Engine.Engine'.static.GetEngine()).SteamActivateGameOverlayToStore(229310, 2);
    //return;    
}

function PlayOpenAnimation()
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x104
    if((UIManager != none) && UIManager.OpenMessageBoxes.Length > 0)
    {
        bIsOpeningBlockedByMessageBox = true;
        RootMC.SetVisible(false);
        // End:0x102
        if(FrontEnd.footer != none)
        {
            FrontEnd.footer.RootMC.SetVisible(false);
        }
        return;
    }
    RootMC.SetVisible(true);
    // End:0x192
    if(FrontEnd.footer != none)
    {
        FrontEnd.footer.RootMC.SetVisible(true);
    }
    super.PlayOpenAnimation();
    GetMenuGame().SetPartyRichPresenceString(GetPKPC());
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    // End:0x6B
    if(!GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.AddItem('GenericExit');        
    }
    else
    {
        ButtonAliases.AddItem('GenericBack');
    }
    FrontEnd.footer.FooterUpdate(ButtonAliases);
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
    Class'PKUIManager'.static.ShowUIMessage('ExitGameConfirm', Localize("MessageBoxStrings", "ExitGame_Title", "PKHDGame"), Localize("MessageBoxStrings", "ExitGame_Message", "PKHDGame"), ButtonAliases, OnExitGameOptionSelected);
    //return;    
}

function bool OnExitGameOptionSelected(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKPlayerController PKPC;

    // End:0x7E
    if(SelectedInputAlias == 'GenericYes')
    {
        PKPC = PKPlayerController(GetPC());
        // End:0x64
        if(PKPC != none)
        {
            PKPC.ClientSaveAllPlayerData(true);
        }
        Action = "back";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function bool OnJanuarySubscriptionFound(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKEngine Eng;

    // End:0x7A
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        Eng = PKEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x77
        if(Eng != none)
        {
            Eng.SteamActivateGameOverlayToBuyFullGame();
        }        
    }
    else
    {
        Action = "single";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnCampaignBtn(EventData ev)
{
    local array<name> ButtonAliases;
    local PKUIManager UIManager;
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    // End:0x173
    if(PC.IsFreeJanuaryWeekendSubscribed())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericOpenSteamStore');
        ButtonAliases.AddItem('GenericCancel');
        UIManager.ShowUIMessage('JanuarySubscription', Localize("MessageBoxErrorStrings", "JanDemoMode_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "JanDemoMode_Message", "PKHDGame"), ButtonAliases, OnJanuarySubscriptionFound, GetLP(),,,,, false);        
    }
    else
    {
        Action = "single";
        // End:0x1AD
        if(!FrontEnd.AttemptNetworkedMatchTransition(true))
        {
            return;
        }
        PlayCloseAnimation();
    }
    //return;    
}

function OnMultiBtn(EventData ev)
{
    FrontEnd.bOnMPScreens = true;
    // End:0x6A
    if(!FrontEnd.AttemptNetworkedMatchTransition())
    {
        FrontEnd.bOnMPScreens = false;
        return;
    }
    FrontEnd.bOnMPScreens = false;
    Action = "multi";
    PlayCloseAnimation();
    //return;    
}

function OnOptionsBtn(EventData ev)
{
    Action = "options";
    PlayCloseAnimation();
    //return;    
}

function OnStatsBtn(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x1D1
    if(((FrontEnd.OnlineSub != none) && NotEqual_InterfaceInterface(FrontEnd.OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && FrontEnd.OnlineSub.PlayerInterface.IsGuestLogin(byte(GetLP().ControllerId)))
    {
        ButtonAliases.AddItem('GenericAccept');
        Class'PKUIManager'.static.ShowUIMessage('NotSignedInError', "<Strings:PKHDGame.MessageBoxErrorStrings.IllegalGuestAction_StatisticsTitle>", "<Strings:PKHDGame.MessageBoxErrorStrings.IllegalGuestAction_StatisticsMessage>", ButtonAliases);        
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
    OnBack(ev);
    //return;    
}

function OnBetaWWWBtn(EventData ev)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).OpenPainkillerBetaWWW();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x95
        case "back":
            // End:0x82
            if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(0))
            {
                PKPartyPC(GetPC()).RestartFrontEnd();                
            }
            else
            {
                ConsoleCommand("quit");
            }
            // End:0x1E1
            break;
        // End:0xCD
        case "single":
            bTransitionResult = FrontEnd.OpenCampaignScreen();
            // End:0x1E1
            break;
        // End:0x16B
        case "multi":
            // End:0x13E
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {
                bTransitionResult = FrontEnd.OpenMultiMenuXboxScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenMultiMenuScreen();
            }
            // End:0x1E1
            break;
        // End:0x1A4
        case "options":
            bTransitionResult = FrontEnd.OpenOptionsScreen();
            // End:0x1E1
            break;
        // End:0x1DB
        case "stats":
            bTransitionResult = FrontEnd.OpenLeaderStatsScreen();
            // End:0x1E1
            break;
        // End:0xFFFF
        default:
            // End:0x1E1
            break;
            break;
    }
    // End:0x20D
    if(bTransitionResult)
    {
        FrontEnd.CloseMainMenu();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    DLC1String="Get Medieval Horror DLC"
    DLC2String="Get the Clock Strikes Meat Night DLC"
    DLC3String="Get Operation \"Zombie Bunker\" DLC"
    DLC4String="Get The Full Metal Rocket DLC"
    DLC5String="Get The Heaven's Above DLC"
    DLC6String="Get Demonic Vacation at the Blood Sea DLC"
    DLC7String="Get City Critters DLC"
    TitleString="Main Menu"
    CampaignString="Campaign"
    MultiString="Multiplayer"
    OptionsString="Options"
    LeaderStatsString="Statistics"
    ExitString="Exit"
    MovieInfo=SwfMovie'PKHD_UI.PKMainMenu'
}