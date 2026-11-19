class AdvGFxUI_Menu_CampaignMenu extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget ContinueBtn;
var GFxClikWidget NewGameBtn;
var GFxClikWidget MapSelectBtn;
var GFxClikWidget DLCBtn;
var GFxClikWidget BackBtn;
var GFxObject WeaponTF;
var GFxClikWidget WeaponOptionStepper;
var GFxClikWidget WeaponLoader;
var const localized string TitleString;
var const localized string RestartNewGameMsg;
var const localized string ContinueString;
var const localized string SingleString;
var const localized string MapSelectString;
var const localized string DefaultWeaponString;

function bool CanLoadCheckpointFromMemory()
{
    local AdvPlayerController PKPC;
    local AdvEngine Engine;

    PKPC = AdvPlayerController(GetPC());
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    return (((PKPC.GetDeviceId() == -1) && Engine != none) && Engine.CurrentCheckpoint != none) && int(Engine.CurrentCheckpoint.HeaderData.ChapterNum) > int(0);
    //return ReturnValue;    
}

function SetupButtonsAfterSaveDataRead()
{
    local bool bShowContinueButton, bShowMapSelectButton;
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    bShowContinueButton = (Engine.SaveSlotData[Engine.SelectedSaveSlot].bContainsData && !Engine.SaveSlotData[Engine.SelectedSaveSlot].bIsCorrupted) || (Engine.CurrentCheckpoint != none) && int(Engine.CurrentCheckpoint.HeaderData.ChapterNum) > 0;
    bShowMapSelectButton = Engine.HasAllLevelsCommandline() || (Engine.CurrentCheckpoint != none) && (((Engine.CurrentCheckpoint.HeaderData.CompletedLevelsMaskA > 0) || Engine.CurrentCheckpoint.HeaderData.CompletedLevelsMaskB > 0) || Engine.CurrentCheckpoint.HeaderData.CompletedLevelsMaskA == -1) || Engine.CurrentCheckpoint.HeaderData.CompletedLevelsMaskB == -1;
    ContinueBtn.SetBool("disabled", !bShowContinueButton || bDemoMode);
    MapSelectBtn.SetBool("disabled", !bShowMapSelectButton);
    // End:0x3E8
    if(!bDemoMode)
    {
        // End:0x3B6
        if(bShowContinueButton)
        {
            ContinueBtn.SetBool("focused", bShowContinueButton);            
        }
        else
        {
            MapSelectBtn.SetBool("focused", bShowMapSelectButton);
        }
    }
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    local GFxObject OptionListProvider;
    local int OptionSelectedIndex;

    super.Start(StartPaused);
    Advance(0.0000000);
    AdvEngine(Class'Engine.Engine'.static.GetEngine()).SetAllowSaveFirstCheckpoint(false);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    ContinueBtn = GFxClikWidget(ButtonsMC.GetObject("continue_btn", Class'GFxUI.GFxClikWidget'));
    NewGameBtn = GFxClikWidget(ButtonsMC.GetObject("single_btn", Class'GFxUI.GFxClikWidget'));
    MapSelectBtn = GFxClikWidget(ButtonsMC.GetObject("mapselect_btn", Class'GFxUI.GFxClikWidget'));
    DLCBtn = GFxClikWidget(ButtonsMC.GetObject("dlc_btn", Class'GFxUI.GFxClikWidget'));
    WeaponOptionStepper = GFxClikWidget(ButtonsMC.GetObject("weapon", Class'GFxUI.GFxClikWidget'));
    WeaponLoader = GFxClikWidget(ButtonsMC.GetObject("weaponLoader", Class'GFxUI.GFxClikWidget'));
    WeaponTF = ButtonsMC.GetObject("weaponTF");
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x3E4
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    ContinueBtn.SetString("label", ContinueString);
    NewGameBtn.SetString("label", SingleString);
    MapSelectBtn.SetString("label", MapSelectString);
    DLCBtn.SetString("label", Class'AdvGFxUI_Menu_MapSelectDLC'.default.TitleString);
    ContinueBtn.SetBool("disabled", true);
    MapSelectBtn.SetBool("disabled", true);
    SetupButtonsAfterSaveDataRead();
    // End:0x5A0
    if(bDemoMode)
    {
        NewGameBtn.SetBool("focused", true);
        MapSelectBtn.SetBool("disabled", true);
    }
    // End:0x5EE
    if(Frontend.bHasSinglePlayerDLC)
    {
        DLCBtn.SetBool("visible", true);        
    }
    else
    {
        DLCBtn.SetBool("visible", false);
    }
    // End:0x82D
    if(((AdvPlayerController(GetPC()) != none) && AdvPlayerController(GetPC()).HasPreorder()) && AdvPlayerController(GetPC()).ProfileSettings != none)
    {
        OptionListProvider = CreateArray();
        OptionListProvider.SetElementString(0, Localize("AdvWeap_Webley_Base", "ItemName", "ADVGame"));
        OptionListProvider.SetElementString(1, Localize("AdvWeap_Remington_Base", "ItemName", "ADVGame"));
        AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(83, OptionSelectedIndex);
        WeaponOptionStepper.SetObject("dataProvider", OptionListProvider);
        WeaponOptionStepper.SetFloat("selectedIndex", float(OptionSelectedIndex));
        WeaponTF.SetText(DefaultWeaponString);        
    }
    else
    {
        WeaponOptionStepper.SetBool("visible", false);
        WeaponLoader.SetBool("visible", false);
        WeaponTF.SetText("");
    }
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    Frontend.footer.FooterUpdate(ButtonAliases);
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
    local AdvEngine Engine;
    local array<name> ButtonAliases;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0xA0
    if(((Action != "") || Class'AdvUIManager'.static.IsUIMessageActive('NewCampaign')) || Class'AdvUIManager'.static.IsUIMessageActive('Tutorial'))
    {
        return;
    }
    ButtonAliases.AddItem('GenericYes');    
    ButtonAliases.AddItem('GenericNo');    
    GetMenuGame().SelectedLevelID = 0;
    // End:0x221
    if(Engine.SaveSlotData[Engine.SelectedSaveSlot].bContainsData && !Engine.SaveSlotData[Engine.SelectedSaveSlot].bIsCorrupted)
    {
        Class'AdvUIManager'.static.ShowUIMessage('NewCampaign', SingleString, RestartNewGameMsg, ButtonAliases, OnNewCamaignMessageFinish, LocalPlayer(GetPC().Player));        
    }
    else
    {
        Action = "single";
        PlayCloseAnimation();
    }
    //return;    
}

function bool OnNewCamaignMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0xE4
    if(SelectedInputAlias == 'GenericYes')
    {
        Engine.SaveSlotData[Engine.SelectedSaveSlot].bContainsData = false;
        AdvPlayerController(GetPC()).ClearPlayerProfileOnSignThePact();
        Action = "single";
        PlayCloseAnimation();        
    }
    else
    {
        NewGameBtn.SetBool("focused", false);
        NewGameBtn.SetBool("focused", true);
    }
    return true;
    //return ReturnValue;    
}

function bool OnAcceptTutorialMessageFinish(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5B
    if(SelectedInputAlias == 'GenericYes')
    {
        GetMenuGame().SelectedLevelID = 3;
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

function OnDLC(EventData ev)
{
    Action = "dlc";
    PlayCloseAnimation();
    //return;    
}

function OnWeaponChange(EventData ev)
{
    local int SelectedIndex;

    SelectedIndex = int(WeaponOptionStepper.GetFloat("selectedIndex"));
    switch(SelectedIndex)
    {
        // End:0xA7
        case 0:
            WeaponLoader.SetString("source", "img://UI_AdvMultiplayer.Textures.t_webley");
            // End:0x104
            break;
        // End:0x101
        case 1:
            WeaponLoader.SetString("source", "img://UI_AdvMultiplayer.Textures.t_pietta");
            // End:0x104
            break;
        // End:0xFFFF
        default:
            break;
    }
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
    local AdvPlayerController PC;
    local AdvGameMenu MenuGame;
    local bool bTransitionResult;
    local AdvEngine Eng;
    local int OptionSelectedIndex;

    GetMenuGame().MultiGameModeSelected = 7;
    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    PC = AdvPlayerController(GetPC());
    // End:0x1BD
    if(PC.HasPreorder() && PC.ProfileSettings != none)
    {
        PC.ProfileSettings.GetProfileSettingValueInt(83, OptionSelectedIndex);
        // End:0x1BD
        if(float(OptionSelectedIndex) != WeaponOptionStepper.GetFloat("selectedIndex"))
        {
            PC.ProfileSettings.SetProfileSettingValueInt(83, int(WeaponOptionStepper.GetFloat("selectedIndex")));
            PC.ClientSaveAllPlayerData(true);
        }
    }
    switch(Action)
    {
        // End:0x206
        case "back":
            bTransitionResult = Frontend.OpenMainMenu();
            // End:0x7F4
            break;
        // End:0x683
        case "continue":
            // End:0x680
            if(PC != none)
            {
                MenuGame = GetMenuGame();
                MenuGame.bPublicGameSelected = false;
                // End:0x4AC
                if(Eng.SaveSlotData[Eng.SelectedSaveSlot].bContainsData && !Eng.SaveSlotData[Eng.SelectedSaveSlot].bIsCorrupted)
                {
                    MenuGame.ContinueGameFromCheckpoint(Eng.SaveSlotData[Eng.SelectedSaveSlot].bIsLevelStart, int(Eng.SaveSlotData[Eng.SelectedSaveSlot].HeaderData.ChapterNum), Eng.SaveSlotData[Eng.SelectedSaveSlot].HeaderData.Difficulty, Eng.SaveSlotData[Eng.SelectedSaveSlot].HeaderData.DifficultyOther);
                    Close();                    
                }
                else
                {
                    // End:0x656
                    if((Eng.CurrentCheckpoint != none) && int(Eng.CurrentCheckpoint.HeaderData.ChapterNum) > 0)
                    {
                        MenuGame.ContinueGameFromCheckpoint(bool(Eng.CurrentCheckpoint.bIsLevelStart), int(Eng.CurrentCheckpoint.HeaderData.ChapterNum), Eng.CurrentCheckpoint.HeaderData.Difficulty, Eng.CurrentCheckpoint.HeaderData.DifficultyOther);
                        Close();                        
                    }
                    else
                    {
                        bTransitionResult = Frontend.OpenMapSelectScreen();
                    }
                }
            }
            // End:0x7F4
            break;
        // End:0x6DD
        case "single":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = Frontend.OpenDifficultyScreen();
            // End:0x7F4
            break;
        // End:0x73A
        case "singletut":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = Frontend.OpenDifficultyScreen();
            // End:0x7F4
            break;
        // End:0x797
        case "mapselect":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = Frontend.OpenMapSelectScreen();
            // End:0x7F4
            break;
        // End:0x7EE
        case "dlc":
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = Frontend.OpenMapSelectDLC();
            // End:0x7F4
            break;
        // End:0xFFFF
        default:
            // End:0x7F4
            break;
            break;
    }
    // End:0x820
    if(bTransitionResult)
    {
        Frontend.CloseCampaignScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Adventure"
    RestartNewGameMsg="This will start a new game: all progress will be lost. Are you sure you want to end your current game and start a new game?"
    ContinueString="Continue Game"
    SingleString="Start New Adventure"
    MapSelectString="Select Level"
    DefaultWeaponString="Default Weapon"
    MovieInfoPath="UI_AdvUI.AdvCampaign"
}