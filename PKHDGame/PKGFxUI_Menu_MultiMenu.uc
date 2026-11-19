class PKGFxUI_Menu_MultiMenu extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget NewBtn;
var GFxClikWidget JoinBtn;
var GFxClikWidget SettingsBtn;
var GFxClikWidget CommunityBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string NewString;
var const localized string JoinString;
var const localized string SettingsString;
var const localized string CommunityString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    NewBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    SettingsBtn = GFxClikWidget(ButtonsMC.GetObject("playerset_btn", Class'GFxUI.GFxClikWidget'));
    CommunityBtn = GFxClikWidget(ButtonsMC.GetObject("community_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x2BA
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    NewBtn.SetString("label", NewString);
    JoinBtn.SetString("label", JoinString);
    SettingsBtn.SetString("label", SettingsString);
    CommunityBtn.SetString("label", CommunityString);
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

function OnNewGameBtn(EventData ev)
{
    Action = "newgame";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    Action = "join";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerSettingBtn(EventData ev)
{
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function OnCommunity(EventData ev)
{
    local PKEngine Engine;

    Engine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    Engine.SteamActivateGameOverlayToCommunity();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x49
        case "back":
            bTransitionResult = FrontEnd.OpenMainMenu();
            // End:0xF8
            break;
        // End:0x82
        case "newgame":
            bTransitionResult = FrontEnd.OpenMultiHostScreen();
            // End:0xF8
            break;
        // End:0xB8
        case "join":
            bTransitionResult = FrontEnd.OpenMultiServersScreen();
            // End:0xF8
            break;
        // End:0xF2
        case "settings":
            bTransitionResult = FrontEnd.OpenMultiPlayerSettingsScreen();
            // End:0xF8
            break;
        // End:0xFFFF
        default:
            // End:0xF8
            break;
            break;
    }
    // End:0x124
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiMenuScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Multiplayer"
    NewString="New game"
    JoinString="Join game"
    SettingsString="Player settings"
    CommunityString="Community maps"
    MovieInfo=SwfMovie'PKHD_UI.PKMultiMenu'
}