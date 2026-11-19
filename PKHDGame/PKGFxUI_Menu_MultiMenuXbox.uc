class PKGFxUI_Menu_MultiMenuXbox extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget QuickMatchBtn;
var GFxClikWidget SettingsBtn;
var GFxClikWidget DeathmatchBtn;
var GFxClikWidget TeamDeathmatchBtn;
var GFxClikWidget CTFBtn;
var GFxClikWidget SurvivalBtn;
var const localized string TitleString;
var const localized string QuickString;
var const localized string SettingsString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    QuickMatchBtn = GFxClikWidget(ButtonsMC.GetObject("quickmatch_btn", Class'GFxUI.GFxClikWidget'));
    SettingsBtn = GFxClikWidget(ButtonsMC.GetObject("playerset_btn", Class'GFxUI.GFxClikWidget'));
    DeathmatchBtn = GFxClikWidget(ButtonsMC.GetObject("deathmatch_btn", Class'GFxUI.GFxClikWidget'));
    TeamDeathmatchBtn = GFxClikWidget(ButtonsMC.GetObject("teamdeathmatch_btn", Class'GFxUI.GFxClikWidget'));
    CTFBtn = GFxClikWidget(ButtonsMC.GetObject("capture_btn", Class'GFxUI.GFxClikWidget'));
    SurvivalBtn = GFxClikWidget(ButtonsMC.GetObject("survival_btn", Class'GFxUI.GFxClikWidget'));
    TitleTF.SetText(TitleString);
    QuickMatchBtn.SetString("label", QuickString);
    SettingsBtn.SetString("label", SettingsString);
    DeathmatchBtn.SetString("label", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[0].Typename);
    TeamDeathmatchBtn.SetString("label", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[1].Typename);
    CTFBtn.SetString("label", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[2].Typename);
    SurvivalBtn.SetString("label", Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[3].Typename);
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
    GetMenuGRI().CurrentPartyType = 2;
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

function OnQuickBtn(EventData ev)
{
    Action = "quickmatch";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerSettingBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function OnDeathBtn(EventData ev)
{
    Action = "deathmatch";
    PlayCloseAnimation();
    //return;    
}

function OnTeamDeathBtn(EventData ev)
{
    Action = "teamdeathmatch";
    PlayCloseAnimation();
    //return;    
}

function OnCaptureBtn(EventData ev)
{
    Action = "ctf";
    PlayCloseAnimation();
    //return;    
}

function OnSurvivalBtn(EventData ev)
{
    Action = "survival";
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    GetMenuGame().MultiGameModeSelected = 0;
    switch(Action)
    {
        // End:0x6B
        case "back":
            bTransitionResult = FrontEnd.OpenMainMenu();
            // End:0x1B2
            break;
        // End:0xA7
        case "quickmatch":
            bTransitionResult = FrontEnd.OpenGameSearchScreen();
            // End:0x1B2
            break;
        // End:0xE1
        case "settings":
            bTransitionResult = FrontEnd.OpenMultiPlayerSettingsScreen();
            // End:0x1B2
            break;
        // End:0x115
        case "deathmatch":
            GetMenuGame().MultiGameModeSelected = 1;
            // End:0x1B2
            break;
        // End:0x14D
        case "teamdeathmatch":
            GetMenuGame().MultiGameModeSelected = 2;
            // End:0x1B2
            break;
        // End:0x17A
        case "ctf":
            GetMenuGame().MultiGameModeSelected = 3;
            // End:0x1B2
            break;
        // End:0x1AC
        case "survival":
            GetMenuGame().MultiGameModeSelected = 4;
            // End:0x1B2
            break;
        // End:0xFFFF
        default:
            // End:0x1B2
            break;
            break;
    }
    // End:0x25F
    if(int(GetMenuGame().MultiGameModeSelected) != int(0))
    {
        bTransitionResult = FrontEnd.OpenMultiMenuXboxCreateJoinScreen(Class'PKGFxUI_Menu_MultiHost'.default.SupportedGameTypes[int(GetMenuGame().MultiGameModeSelected) - int(1)].Typename);
    }
    // End:0x28B
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiMenuXboxScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Multiplayer"
    QuickString="Quick Match"
    SettingsString="Player settings"
    bCanOpenPartyMenu=true
    bCanOpenChangePartyType=true
    bDisplayPartyWindow=true
    MovieInfo=SwfMovie'PKHD_UI.PKMultiMenuXbox'
}