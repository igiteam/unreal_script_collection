class PKGFxUI_Menu_CampaignMenu extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget ContinueBtn;
var GFxClikWidget NewGameBtn;
var GFxClikWidget MapSelectBtn;
var GFxClikWidget CoopBtn;
var GFxClikWidget DLCBtn;
var GFxClikWidget SurvivalSP;
var GFxClikWidget CommunityBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string RestartNewGameMsg;
var const localized string ContinueString;
var const localized string SingleString;
var const localized string MapSelectString;
var const localized string CoopMenuString;
var const localized string SplitScreenString;
var const localized string NewCoopString;
var const localized string JoinCoopString;
var const localized string SurvivalSPString;
var const localized string CommunityString;

function SetupButtonsAfterSaveDataRead()
{
    local bool bShowContinueButton, bShowMapSelectButton;
    local PKPlayerController PKPC;
    local int CompletedLevelsMask;

    PKPC = PKPlayerController(GetPC());
    CompletedLevelsMask = PKPC.PersistentData.GetValue(34);
    bShowContinueButton = FrontEnd.SaveSlotData.bContainsData && !FrontEnd.SaveSlotData.bIsCorrupted;
    bShowMapSelectButton = ((bShowContinueButton || CompletedLevelsMask > 0) || int(PKPC.IsDLCInstalled(4)) == int(1)) || int(PKPC.IsDLCInstalled(5)) == int(1);
    ContinueBtn.SetBool("disabled", !bShowContinueButton);
    MapSelectBtn.SetBool("disabled", !bShowMapSelectButton);
    // End:0x201
    if(bShowContinueButton)
    {
        ContinueBtn.SetBool("focused", bShowContinueButton);        
    }
    else
    {
        MapSelectBtn.SetBool("focused", bShowMapSelectButton);
    }
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    ContinueBtn = GFxClikWidget(ButtonsMC.GetObject("continue_btn", Class'GFxUI.GFxClikWidget'));
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("single_btn", Class'GFxUI.GFxClikWidget'));
    MapSelectBtn = GFxClikWidget(ButtonsMC.GetObject("mapselect_btn", Class'GFxUI.GFxClikWidget'));
    CoopBtn = GFxClikWidget(ButtonsMC.GetObject("createcoop_btn", Class'GFxUI.GFxClikWidget'));
    DLCBtn = GFxClikWidget(ButtonsMC.GetObject("dlc_btn", Class'GFxUI.GFxClikWidget'));
    SurvivalSP = GFxClikWidget(ButtonsMC.GetObject("survival_btn", Class'GFxUI.GFxClikWidget'));
    CommunityBtn = GFxClikWidget(ButtonsMC.GetObject("community_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x395
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    ContinueBtn.SetString("label", ContinueString);
    NewGameBtn.SetString("label", SingleString);
    MapSelectBtn.SetString("label", MapSelectString);
    CoopBtn.SetString("label", CoopMenuString);
    CommunityBtn.SetString("label", CommunityString);
    CommunityBtn.SetBool("disabled", true);
    ContinueBtn.SetBool("disabled", true);
    MapSelectBtn.SetBool("disabled", true);
    DLCBtn.SetString("label", Class'PKGFxUI_Menu_MapSelect'.default.DLCMapsLabel);
    SurvivalSP.SetString("label", SurvivalSPString);
    DLCBtn.SetBool("visible", true);
    // End:0x62C
    if(int(PKPlayerController(GetPC()).IsDLCInstalled(11)) == int(1))
    {
        SurvivalSP.SetBool("visible", true);        
    }
    else
    {
        SurvivalSP.SetBool("visible", false);
    }
    SetupButtonsAfterSaveDataRead();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');
    ButtonAliases.AddItem('GenericBack');
    FrontEnd.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnContinueBtn(EventData ev)
{
    Action = "continue";
    PlayCloseAnimation();
    //return;    
}

function OnSingleBtn(EventData ev)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    GetMenuGame().SelectedLevelID = 0;
    FrontEnd.SaveSlotData.bContainsData = false;
    Class'PKUIManager'.static.ShowUIMessage('Tutorial', Localize("MessageBoxStrings", "Tutorial_Title", "PKHDGame"), Localize("MessageBoxStrings", "Tutorial_Message", "PKHDGame"), ButtonAliases, OnAcceptTutorialMessageFinish, LocalPlayer(GetPC().Player));
    //return;    
}

function bool OnNewCamaignMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericYes');
    ButtonAliases.AddItem('GenericNo');
    // End:0x15B
    if(SelectedInputAlias == 'GenericYes')
    {
        FrontEnd.SaveSlotData.bContainsData = false;
        Class'PKUIManager'.static.CloseAllUIMessageBoxes(GetLP());
        Class'PKUIManager'.static.ShowUIMessage('Tutorial', Localize("MessageBoxStrings", "Tutorial_Title", "PKHDGame"), Localize("MessageBoxStrings", "Tutorial_Message", "PKHDGame"), ButtonAliases, OnAcceptTutorialMessageFinish);
    }
    return true;
    //return ReturnValue;    
}

function bool OnAcceptTutorialMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5B
    if(SelectedInputAlias == 'GenericYes')
    {
        GetMenuGame().SelectedLevelID = 17;
        Action = "singletut";
        PlayCloseAnimation();        
    }
    else
    {
        Action = "single";
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnMapSelectBtn(EventData ev)
{
    Action = "mapselect";
    PlayCloseAnimation();
    //return;    
}

function OnCreateCoop(EventData ev)
{
    Action = "coop";
    PlayCloseAnimation();
    //return;    
}

function OnCommunity(EventData ev)
{
    Action = "community";
    PlayCloseAnimation();
    //return;    
}

function OnDLC()
{
    Action = "dlc";
    PlayCloseAnimation();
    //return;    
}

function OnSurvival()
{
    Action = "survival";
    PlayCloseAnimation();
    //return;    
}

function OnOpenAnimationComplete()
{
    super.OnOpenAnimationComplete();
    Action = "";
    //return;    
}

function OnCloseAnimationComplete()
{
    local PKPlayerController PC;
    local PKGameMenu MenuGame;
    local bool bTransitionResult;

    GetMenuGame().MultiGameModeSelected = 0;
    PC = PKPlayerController(GetPC());
    switch(Action)
    {
        // End:0x88
        case "back":
            bTransitionResult = FrontEnd.OpenMainMenu();
            // End:0x516
            break;
        // End:0x1ED
        case "continue":
            // End:0x1EA
            if(PC != none)
            {
                MenuGame = GetMenuGame();
                MenuGame.bPublicGameSelected = false;
                // End:0x130
                if(int(PC.GetLastCompletedLevelID()) != int(0))
                {
                    bTransitionResult = FrontEnd.OpenMapSelectScreen();                    
                }
                else
                {
                    // End:0x1EA
                    if(FrontEnd.PrepareCheckpointSystem(PC))
                    {
                        MenuGame.ContinueGameFromCheckpoint(FrontEnd.SaveSlotData.bIsLevelStart, int(FrontEnd.SaveSlotData.ChapterNum));
                        Close();
                    }
                }
            }
            // End:0x516
            break;
        // End:0x247
        case "single":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenMapSelectScreen();
            // End:0x516
            break;
        // End:0x2CB
        case "singletut":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenDifficultyScreen(int(GetMenuGame().MultiGameModeSelected) == int(6));
            // End:0x516
            break;
        // End:0x328
        case "mapselect":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenMapSelectScreen();
            // End:0x516
            break;
        // End:0x3A9
        case "splitscreen":
            GetMenuGame().MultiGameModeSelected = 6;
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenMapSelectScreen();
            // End:0x516
            break;
        // End:0x3DF
        case "coop":
            bTransitionResult = FrontEnd.OpenCampaignCoopScreen();
            // End:0x516
            break;
        // End:0x479
        case "dlc":
            GetMenuGame().SelectedLevelID = 0;
            GetMenuGame().bPublicGameSelected = false;
            FrontEnd.bShouldReturnToCampaignMenuAfterDLC = true;
            bTransitionResult = FrontEnd.OpenMapSelectDLC();
            // End:0x516
            break;
        // End:0x4D5
        case "survival":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenSurvivalSP();
            // End:0x516
            break;
        // End:0x510
        case "community":
            bTransitionResult = FrontEnd.OpenCommunitySPScreen();
            // End:0x516
            break;
        // End:0xFFFF
        default:
            // End:0x516
            break;
            break;
    }
    // End:0x542
    if(bTransitionResult)
    {
        FrontEnd.CloseCampaignScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Campaign"
    RestartNewGameMsg="This will start a new game: all levels will be locked again. Are you sure you want to exit your current game and start a new game?"
    ContinueString="Continue Game"
    SingleString="Sign a New Pact"
    MapSelectString="Select Level"
    CoopMenuString="Co-op Mode"
    SplitScreenString="Create Local Co-op Game"
    NewCoopString="Create Co-op Game"
    JoinCoopString="Join Co-op Game"
    SurvivalSPString="Solo Survival"
    CommunityString="Community Levels"
    MovieInfo=SwfMovie'PKHD_UI.PKCampaign'
}