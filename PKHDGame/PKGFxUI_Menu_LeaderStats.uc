class PKGFxUI_Menu_LeaderStats extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget LeaderboardBtn;
var GFxClikWidget StatsBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string LeaderboardString;
var const localized string StatsString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    LeaderboardBtn = GFxClikWidget(ButtonsMC.GetObject("leader_btn", Class'GFxUI.GFxClikWidget'));
    StatsBtn = GFxClikWidget(ButtonsMC.GetObject("stats_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x226
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    LeaderboardBtn.SetString("label", LeaderboardString);
    StatsBtn.SetString("label", StatsString);
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

function OnLeaderBtn(EventData ev)
{
    local array<name> ButtonAliases;

    // End:0x16C
    if(!Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId, true))
    {
        ButtonAliases.AddItem('GenericAccept');
        Class'PKUIManager'.static.ShowUIMessage('ConfirmNetworkLost', Localize("MessageBoxErrorStrings", "SignedOut_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), Localize("MessageBoxErrorStrings", "NeedGoldTierLeaderboard_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "PKHDGame"), ButtonAliases,, GetLP());        
    }
    else
    {
        Action = "leaderboard";
        PlayCloseAnimation();
    }
    //return;    
}

function OnStatsBtn(EventData ev)
{
    Action = "stats";
    PlayCloseAnimation();
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
            // End:0xC3
            break;
        // End:0x86
        case "leaderboard":
            bTransitionResult = FrontEnd.OpenLeaderboardScreen();
            // End:0xC3
            break;
        // End:0xBD
        case "stats":
            bTransitionResult = FrontEnd.OpenPlayerStatsScreen();
            // End:0xC3
            break;
        // End:0xFFFF
        default:
            // End:0xC3
            break;
            break;
    }
    // End:0xEF
    if(bTransitionResult)
    {
        FrontEnd.CloseLeaderStatsScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Statistics"
    LeaderboardString="Leaderboards"
    StatsString="Player Statistics"
    MovieInfo=SwfMovie'PKHD_UI.PKLeaderStats'
}