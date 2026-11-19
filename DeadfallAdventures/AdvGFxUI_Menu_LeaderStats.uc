class AdvGFxUI_Menu_LeaderStats extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget LeaderboardBtn;
var GFxClikWidget SingleStatsBtn;
var GFxClikWidget MultiStatsBtn;
var GFxClikWidget SurvivalStatsBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string LeaderboardString;
var const localized string SingleStatsString;
var const localized string MultiStatsString;
var const localized string SurvivalStatsString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    LeaderboardBtn = GFxClikWidget(ButtonsMC.GetObject("leaderboard_btn", Class'GFxUI.GFxClikWidget'));
    SingleStatsBtn = GFxClikWidget(ButtonsMC.GetObject("statssingle_btn", Class'GFxUI.GFxClikWidget'));
    MultiStatsBtn = GFxClikWidget(ButtonsMC.GetObject("statsmulti_btn", Class'GFxUI.GFxClikWidget'));
    SurvivalStatsBtn = GFxClikWidget(ButtonsMC.GetObject("statssurvival_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x2F8
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    LeaderboardBtn.SetString("label", LeaderboardString);
    SingleStatsBtn.SetString("label", SingleStatsString);
    MultiStatsBtn.SetString("label", MultiStatsString);
    SurvivalStatsBtn.SetString("label", SurvivalStatsString);
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

function OnLeaderBoardBtn(EventData ev)
{
    local OnlineSubsystem.ELoginStatus LoginStatus;

    LoginStatus = Class'Engine.UIInteraction'.static.GetLoginStatus(GetLP().ControllerId);
    // End:0x12C
    if((int(LoginStatus) != int(2)) && !OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId)))
    {
        Class'AdvUIManager'.static.DisplayErrorMessage("NeedGoldTierLeaderboard_Message", "XboxLive_Title", "GenericContinue", GetLP());        
    }
    else
    {
        // End:0x1F8
        if(OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId)))
        {
            Class'AdvUIManager'.static.DisplayErrorMessage("NeedGoldTierLeaderboard_Message", "XboxLive_Title", "GenericContinue", GetLP());            
        }
        else
        {
            Action = "leaderboard";
            PlayCloseAnimation();
        }
    }
    //return;    
}

function OnStatsSingleBtn(EventData ev)
{
    Action = "singlestats";
    PlayCloseAnimation();
    //return;    
}

function OnStatsMultiBtn(EventData ev)
{
    Action = "multistats";
    PlayCloseAnimation();
    //return;    
}

function OnStatsSurvivalBtn(EventData ev)
{
    Action = "survivalstats";
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
            bTransitionResult = Frontend.OpenMainMenu();
            // End:0x144
            break;
        // End:0x86
        case "leaderboard":
            bTransitionResult = Frontend.OpenLeaderboardScreen();
            // End:0x144
            break;
        // End:0xC3
        case "singlestats":
            bTransitionResult = Frontend.OpenPlayerStatsScreen();
            // End:0x144
            break;
        // End:0xFF
        case "multistats":
            bTransitionResult = Frontend.OpenPlayerStatsMPScreen();
            // End:0x144
            break;
        // End:0x13E
        case "survivalstats":
            bTransitionResult = Frontend.OpenPlayerStatsSurvivalScreen();
            // End:0x144
            break;
        // End:0xFFFF
        default:
            // End:0x144
            break;
            break;
    }
    // End:0x170
    if(bTransitionResult)
    {
        Frontend.CloseLeaderStatsScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    TitleString="Stats"
    LeaderboardString="Leaderboards"
    SingleStatsString="Campaign Stats"
    MultiStatsString="Multiplayer Stats"
    SurvivalStatsString="Survival Stats"
    MovieInfoPath="UI_AdvUI.AdvLeaderStats"
}