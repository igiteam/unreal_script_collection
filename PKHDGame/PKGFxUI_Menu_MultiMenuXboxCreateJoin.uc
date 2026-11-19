class PKGFxUI_Menu_MultiMenuXboxCreateJoin extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget NewBtn;
var GFxClikWidget JoinBtn;
var string TitleString;
var const localized string CreateString;
var const localized string SearchString;

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    NewBtn = GFxClikWidget(ButtonsMC.GetObject("newgame_btn", Class'GFxUI.GFxClikWidget'));
    JoinBtn = GFxClikWidget(ButtonsMC.GetObject("join_btn", Class'GFxUI.GFxClikWidget'));
    TitleTF.SetText(TitleString);
    NewBtn.SetString("label", CreateString);
    JoinBtn.SetString("label", SearchString);
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

function OnNewGameBtn(EventData ev)
{
    Action = "new";
    PlayCloseAnimation();
    //return;    
}

function OnJoinBtn(EventData ev)
{
    Action = "join";
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    local bool bTransitionResult;

    switch(Action)
    {
        // End:0x6B
        case "back":
            GetMenuGame().MultiGameModeSelected = 0;
            bTransitionResult = FrontEnd.OpenMultiMenuXboxScreen();
            // End:0xDC
            break;
        // End:0xA0
        case "new":
            bTransitionResult = FrontEnd.OpenMultiHostScreen();
            // End:0xDC
            break;
        // End:0xD6
        case "join":
            bTransitionResult = FrontEnd.OpenGameSearchScreen();
            // End:0xDC
            break;
        // End:0xFFFF
        default:
            // End:0xDC
            break;
            break;
    }
    // End:0x108
    if(bTransitionResult)
    {
        FrontEnd.CloseMultiMenuXboxCreateJoinScreen();
    }
    Action = "";
    //return;    
}

defaultproperties
{
    CreateString="Create Game"
    SearchString="Search Game"
    bCanOpenPartyMenu=true
    bCanOpenChangePartyType=true
    bDisplayPartyWindow=true
    MovieInfo=SwfMovie'PKHD_UI.PKMultiMenuXHostJoin'
}