class AdvGFxUI_Menu_MultiMenu extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject DescMC;
var GFxObject TitleTF;
var GFxObject DescTF;
var GFxClikWidget QuickBtn;
var GFxClikWidget FindBtn;
var GFxClikWidget PrivateBtn;
var GFxClikWidget SettingsBtn;
var GFxClikWidget SkinBtn;
var GFxClikWidget CommunityBtn;
var GFxClikWidget BackBtn;
var const localized string TitleString;
var const localized string QuickString;
var const localized string FindString;
var const localized string PrivateString;
var const localized string SettingsString;
var const localized string SkinString;
var const localized string CommunityString;
var const localized string RankedMatchDesc;
var const localized string PrivateMatchDesc;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    // End:0x8B
    if(AdvLocalPlayer(GetLP()).bRestoreUsingGamepad)
    {
        GetPC().PlayerInput.bUsingGamepad = true;
    }
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    DescMC = ButtonsMC.GetObject("desc");
    TitleTF = TitleMC.GetObject("textField");
    DescTF = DescMC.GetObject("textField");
    QuickBtn = GFxClikWidget(ButtonsMC.GetObject("quick_btn", Class'GFxUI.GFxClikWidget'));
    FindBtn = GFxClikWidget(ButtonsMC.GetObject("find_btn", Class'GFxUI.GFxClikWidget'));
    PrivateBtn = GFxClikWidget(ButtonsMC.GetObject("private_btn", Class'GFxUI.GFxClikWidget'));
    SettingsBtn = GFxClikWidget(ButtonsMC.GetObject("playerset_btn", Class'GFxUI.GFxClikWidget'));
    SkinBtn = GFxClikWidget(ButtonsMC.GetObject("skin_btn", Class'GFxUI.GFxClikWidget'));
    CommunityBtn = GFxClikWidget(ButtonsMC.GetObject("communitygame_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn.SetString("label", back);
    // End:0x43F
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackBtn.SetBool("visible", false);
    }
    TitleTF.SetText(TitleString);
    QuickBtn.SetString("label", QuickString);
    FindBtn.SetString("label", FindString);
    PrivateBtn.SetString("label", PrivateString);
    CommunityBtn.SetString("label", CommunityString);
    SettingsBtn.SetString("label", SettingsString);
    SkinBtn.SetString("label", SkinString);
    FindBtn.SetBool("focused", true);
    // End:0x5E8
    if(bMultiplayerBetaIMode)
    {
        SettingsBtn.SetBool("disabled", true);
    }
    AdvLocalPlayer(GetLP()).bPartyTypeUpdated = false;
    Frontend.ConditionalCreatePartySession();
    GetMenuGRI().SetCurrentPartyType(1);
    Frontend.GetPartyGame().RefreshPartySettings();
    GetMenuGame().MultiGameModeSelected = 7;
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

function OnPrivateBtn(EventData ev)
{
    Action = "newgame";
    GetMenuGRI().LoadPartyTypeFromProfile(GetAdvPC());
    // End:0x7F
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

function OnFindBtn(EventData ev)
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
    Action = "settings";
    PlayCloseAnimation();
    //return;    
}

function OnSkinBtn(EventData ev)
{
    Action = "skin";
    PlayCloseAnimation();
    //return;    
}

function OnFindBtnOver(EventData ev)
{
    DescMC.SetVisible(true);
    DescTF.SetText(RankedMatchDesc);
    //return;    
}

function OnPrivateBtnOver(EventData ev)
{
    DescMC.SetVisible(true);
    DescTF.SetText(PrivateMatchDesc);
    //return;    
}

function OnPlayerSettingBtnOver(EventData ev)
{
    DescMC.SetVisible(false);
    DescTF.SetText("");
    //return;    
}

function OnSkinBtnOver(EventData ev)
{
    DescMC.SetVisible(false);
    DescTF.SetText("");
    //return;    
}

function OnBackOver(EventData ev)
{
    DescMC.SetVisible(false);
    DescTF.SetText("");
    //return;    
}

function OnQuickBtnOver(EventData ev)
{
    DescMC.SetVisible(true);
    DescTF.SetText(PrivateMatchDesc);
    //return;    
}

function OnCommunityOver(EventData ev)
{
    DescMC.SetVisible(true);
    DescTF.SetText(PrivateMatchDesc);
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x8E
        case "back":
            GetMenuGRI().SetCurrentPartyType(2, none);
            GetMenuGame().MultiGameModeSelected = 7;
            bTransitionResult = Frontend.OpenMainMenu();
            // End:0x2F1
            break;
        // End:0x14F
        case "community":
            AdvLocalPlayer(GetLP()).bRestoreUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
            GetMenuGRI().SetPlaylist(-2);
            bTransitionResult = Frontend.HandleCompetitiveMatchModeSelection(0, false);
            // End:0x2F1
            break;
        // End:0x186
        case "quick":
            bTransitionResult = Frontend.OpenGameSearchScreen();
            // End:0x2F1
            break;
        // End:0x245
        case "newgame":
            AdvLocalPlayer(GetLP()).bRestoreUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
            GetMenuGRI().SetPlaylist(-1);
            bTransitionResult = Frontend.HandleCompetitiveMatchModeSelection(0, false);
            // End:0x2F1
            break;
        // End:0x27B
        case "join":
            bTransitionResult = Frontend.OpenMultiMenuGametypeScreen();
            // End:0x2F1
            break;
        // End:0x2B5
        case "settings":
            bTransitionResult = Frontend.OpenMultiPlayerSettingsScreen();
            // End:0x2F1
            break;
        // End:0x2EB
        case "skin":
            bTransitionResult = Frontend.OpenMultiPlayerSkinScreen();
            // End:0x2F1
            break;
        // End:0xFFFF
        default:
            // End:0x2F1
            break;
            break;
    }
    // End:0x31D
    if(bTransitionResult)
    {
        Frontend.CloseMultiMenuScreen();
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
    TitleString="Multiplayer"
    QuickString="Public Game Browser"
    FindString="Ranked Game"
    PrivateString="Create Private Match"
    SettingsString="Create a Class"
    SkinString="Select Skin"
    CommunityString="Create Public Game"
    RankedMatchDesc="In this mode you can gain experience points, unlock achievements, new skins and weapons. You can't customize rules of the match."
    PrivateMatchDesc="In this mode you can play just for fun. You can't gain experience points, unlock achievements, new skins and weapons, but you can customize rules of the match."
    MovieInfoPath="UI_AdvUI.AdvMultiMenu"
}