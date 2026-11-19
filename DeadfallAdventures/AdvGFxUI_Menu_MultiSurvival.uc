class AdvGFxUI_Menu_MultiSurvival extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget NewBtn;
var GFxClikWidget JoinBtn;
var GFxClikWidget SkinBtn;
var GFxClikWidget QuickBtn;
var GFxClikWidget CommunityBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string PrivateString;
var const localized string JoinString;
var const localized string QuickString;
var const localized string CommunityString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    // End:0x8B
    if(AdvLocalPlayer(GetLP()).bRestoreUsingGamepad)
    {
        GetPC().PlayerInput.bUsingGamepad = true;
    }
    GetMenuGame().MultiGameModeSelected = 3;
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    NewBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    SkinBtn = GFxClikWidget(ButtonsMC.GetObject("playerset_btn", Class'GFxUI.GFxClikWidget'));
    QuickBtn = GFxClikWidget(ButtonsMC.GetObject("quick_btn", Class'GFxUI.GFxClikWidget'));
    CommunityBtn = GFxClikWidget(ButtonsMC.GetObject("communitygame_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x3B7
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    NewBtn.SetString("label", PrivateString);
    JoinBtn.SetString("label", JoinString);
    SkinBtn.SetString("label", Localize("AdvGFxUI_Menu_MultiMenu", "SkinString", "ADVGame"));
    QuickBtn.SetString("label", QuickString);
    CommunityBtn.SetString("label", CommunityString);
    AdvLocalPlayer(GetLP()).bPartyTypeUpdated = false;
    Frontend.ConditionalCreatePartySession();
    GetMenuGRI().LoadPartyTypeFromProfile(GetAdvPC());
    AdvPartyGRI(GetMenuGRI()).bSurvival = true;
    Frontend.GetPartyGame().RefreshPartySettings();
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericSelect');    
    ButtonAliases.AddItem('GenericBack');    
    AddNATStatus(ButtonAliases);
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetMenuGRI());
    // End:0x6F
    if(GRI != none)
    {
        GRI.SetLobbyState(1);
        GRI.SetCurrentPartyType(2, none);
    }
    OnLeaveParty();
    //return;    
}

function OnNewGameBtn(EventData ev)
{
    Action = "newgame";
    PlayCloseAnimation();
    GetMenuGRI().LoadPartyTypeFromProfile(GetAdvPC());
    // End:0x89
    if((Frontend != none) && Frontend.AttemptNetworkedMatchTransition(false))
    {
        PlayCloseAnimation();        
    }
    else
    {
        GetMenuGRI().SetCurrentPartyType(2, none);
        Action = "";
    }
    //return;    
}

function OnJoinBtn(EventData ev)
{
    Action = "join";
    PlayCloseAnimation();
    //return;    
}

function OnQuickBtn(EventData ev)
{
    Action = "quick";
    PlayCloseAnimation();
    //return;    
}

function OnCommunityBtn(EventData ev)
{
    Action = "community";
    PlayCloseAnimation();
    //return;    
}

function OnPlayerSettingBtn(EventData ev)
{
    Action = "skin";
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x96
        case "back":
            GetMenuGame().MultiGameModeSelected = 7;
            AdvPartyGRI(GetMenuGRI()).bSurvival = false;
            bTransitionResult = Frontend.OpenMainMenu();
            // End:0x325
            break;
        // End:0xCD
        case "quick":
            bTransitionResult = Frontend.OpenGameSearchScreen();
            // End:0x325
            break;
        // End:0x1B0
        case "community":
            AdvLocalPlayer(GetLP()).bRestoreUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
            GetMenuGame().MultiGameModeSelected = 3;
            GetMenuGRI().SetPlaylist(-2);
            bTransitionResult = Frontend.HandleCompetitiveMatchModeSelection(0, false);
            // End:0x325
            break;
        // End:0x291
        case "newgame":
            AdvLocalPlayer(GetLP()).bRestoreUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
            GetMenuGame().MultiGameModeSelected = 3;
            GetMenuGRI().SetPlaylist(-1);
            bTransitionResult = Frontend.HandleCompetitiveMatchModeSelection(0, false);
            // End:0x325
            break;
        // End:0x2E9
        case "join":
            GetMenuGame().MultiGameModeSelected = 3;
            bTransitionResult = Frontend.OpenMultiMenuGametypeScreen();
            // End:0x325
            break;
        // End:0x31F
        case "skin":
            bTransitionResult = Frontend.OpenSurvivalSkinScreen();
            // End:0x325
            break;
        // End:0xFFFF
        default:
            // End:0x325
            break;
            break;
    }
    // End:0x351
    if(bTransitionResult)
    {
        Frontend.CloseMultiSurvivalScreen();
    }
    Action = "";
    //return;    
}

function OnLeaveParty()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local bool bHasParty, bIsLeader;

    bHasParty = AdvPlayerController(GetPC()).HasParty();
    bIsLeader = GetPC().IsPartyLeader();
    // End:0x2EE
    if(bHasParty)
    {
        // End:0x1AC
        if(bIsLeader)
        {
            ButtonAliases.AddItem('AcceptLeave');            
            ButtonAliases.AddItem('CancelStay');            
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            UIManager.ShowUIMessage('ConfirmQuit', "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_Title>", "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_LeaderMessage>", ButtonAliases, OnLeaveParty_Confirmed, GetLP());            
        }
        else
        {
            // End:0x2EB
            if(!bIsLeader)
            {
                ButtonAliases.AddItem('AcceptLeave');                
                ButtonAliases.AddItem('CancelStay');                
                UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
                UIManager.ShowUIMessage('ConfirmQuit', "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_Title>", "<Strings:ADVGame.MessageBoxStrings.LeavePartyLobby_MemberMessage>", ButtonAliases, OnLeaveParty_Confirmed, GetLP());
            }
        }        
    }
    else
    {
        Frontend.GetPartyGame().DestroyParty(OnDestroyPartyComplete);
    }
    //return;    
}

function bool OnLeaveParty_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5D
    if(SelectedInputAlias == 'AcceptLeave')
    {
        Frontend.GetPartyGame().DestroyParty(OnDestroyPartyComplete);
    }
    return true;
    //return ReturnValue;    
}

function OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    local AdvPlayerController PCIter;
    local WorldInfo WI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
    // End:0xFE
    if(SessionName == 'Party')
    {
        // End:0xFD
        foreach WI.LocalPlayerControllers(Class'AdvPlayerController', PCIter)
        {
            // End:0xFC
            if(PCIter.IsPrimaryPlayer())
            {
                PCIter.ClientRegisterWithParty(true);
            }            
        }        
    }
    Class'AdvEngine'.static.CloseInputBlockingScene(4);
    Action = "back";
    PlayCloseAnimation();
    //return;    
}

defaultproperties
{
    TitleString="Survival"
    PrivateString="Create Private Match"
    JoinString="Ranked Game"
    QuickString="Public Game Browser"
    CommunityString="Create Public Game"
    MovieInfoPath="UI_AdvUI.AdvMultiSurvival"
}