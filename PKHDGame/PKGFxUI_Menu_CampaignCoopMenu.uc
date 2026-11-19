class PKGFxUI_Menu_CampaignCoopMenu extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget SplitScreenBtn;
var GFxClikWidget JoinBtn;
var GFxClikWidget CreateBtn;
var GFxClikWidget BackBtn;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    SplitScreenBtn = GFxClikWidget(ButtonsMC.GetObject("splitscreen_btn", Class'GFxUI.GFxClikWidget'));
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("joincoop_btn", Class'GFxUI.GFxClikWidget'));
    CreateBtn = GFxClikWidget(ButtonsMC.GetObject("createcoop_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x279
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(Class'PKGFxUI_Menu_CampaignMenu'.default.CoopMenuString);
    SplitScreenBtn.SetString("label", Class'PKGFxUI_Menu_CampaignMenu'.default.SplitScreenString);
    JoinBtn.SetString("label", Class'PKGFxUI_Menu_CampaignMenu'.default.JoinCoopString);
    CreateBtn.SetString("label", Class'PKGFxUI_Menu_CampaignMenu'.default.NewCoopString);
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

function OnSplitScreenBtn(EventData ev)
{
    local array<name> ButtonAliases;
    local PKEngine Eng;

    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    Eng.SwitchPadLayoutForSplitScreen();
    ButtonAliases.AddItem('GenericAccept');
    ButtonAliases.AddItem('GenericBack');
    Class'PKUIManager'.static.CloseAllUIMessageBoxes(GetLP());
    Class'PKUIManager'.static.ShowUIMessage('SplitScreen', Localize("MessageBoxErrorStrings", "JoinCoopPlayer_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "JoinCoopPlayer_Message", "PKHDGame"), ButtonAliases, OnConfirmSplitScreenGame,,,,, false);
    //return;    
}

function bool OnConfirmSplitScreenGame(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKEngine Eng;

    Eng = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x97
    if(SelectedInputAlias == 'GenericAccept')
    {
        // End:0x95
        if(Eng.GamePlayers.Length == 2)
        {
            Action = "splitscreen";
            PlayCloseAnimation();
            return true;            
        }
        else
        {
            return false;
        }
    }
    Eng.SwitchPadLayoutToDefault();
    return true;
    //return ReturnValue;    
}

function bool CanCreateLocalPlayer(int ControllerId)
{
    local Engine Eng;

    Eng = Class'Engine.Engine'.static.GetEngine();
    return (Eng.GamePlayers.Length < 2) && Class'PKUIManager'.static.IsUIMessageActive('SplitScreen');
    //return ReturnValue;    
}

function OnCreateCoop(EventData ev)
{
    GetMenuGRI().CurrentPartyType = 1;
    Action = "create";
    // End:0x5C
    if(!FrontEnd.AttemptNetworkedMatchTransition(true))
    {
        return;
    }
    PlayCloseAnimation();
    //return;    
}

function OnJoinCoop(EventData ev)
{
    GetMenuGRI().CurrentPartyType = 1;
    Action = "join";
    PKEngine(Class'PKEngine'.static.GetEngine()).SetCanBreakFullscreenMovie(true);
    // End:0x99
    if(!FrontEnd.AttemptNetworkedMatchTransition(true))
    {
        return;
    }
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
    local bool bTransitionResult;

    GetMenuGame().MultiGameModeSelected = 0;
    switch(Action)
    {
        // End:0x6B
        case "back":
            bTransitionResult = FrontEnd.OpenCampaignScreen();
            // End:0x26E
            break;
        // End:0xEC
        case "splitscreen":
            GetMenuGame().MultiGameModeSelected = 6;
            GetMenuGame().bPublicGameSelected = false;
            bTransitionResult = FrontEnd.OpenMapSelectScreen();
            // End:0x26E
            break;
        // End:0x168
        case "create":
            GetMenuGame().MultiGameModeSelected = 5;
            GetMenuGame().bPublicGameSelected = true;
            bTransitionResult = FrontEnd.OpenMapSelectScreen();
            // End:0x26E
            break;
        // End:0x268
        case "join":
            GetMenuGame().MultiGameModeSelected = 5;
            // End:0x1FA
            if(GetPC().WorldInfo.IsConsoleBuild(0))
            {
                bTransitionResult = FrontEnd.OpenGameSearchScreen();                
            }
            else
            {
                bTransitionResult = FrontEnd.OpenMultiServersScreen();
                // End:0x265
                if(bTransitionResult)
                {
                    FrontEnd.MultiServersMenu.ConfigForSearchingOnlyForCoopGames();
                }
            }
            // End:0x26E
            break;
        // End:0xFFFF
        default:
            // End:0x26E
            break;
            break;
    }
    // End:0x29A
    if(bTransitionResult)
    {
        FrontEnd.CloseCampaignCoopScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.PKCoop'
}