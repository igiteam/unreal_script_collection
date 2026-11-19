class AdvGFxUI_Menu_DemoScreen extends AdvGfxMoviePlayer
    config(UI);

var AdvGFxUI_Menu_Footer footer;
var GFxClikWidget BuyBtn;
var GFxClikWidget BackBtn;

function bool Start(optional bool StartPaused = false)
{
    local GFxObject LogoMC, RootMC, Ticker, TextMC, TitleTF, TextTF,
	    ButtonsMC, MenuMC;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    // End:0x76
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        InitializeFooter();
        UpdateFooter();
    }
    RootMC = GetVariableObject("_root");
    LogoMC = RootMC.GetObject("demoMC");
    Ticker = LogoMC.GetObject("ticker");
    Ticker.SetVisible(false);
    TextMC = RootMC.GetObject("textMC");
    TitleTF = TextMC.GetObject("textField");
    TextTF = TextMC.GetObject("textField2");
    TitleTF.SetText(Localize("DemoSplashScreenTexts", "SplashScreenTitle", "AdvGame"));
    TextTF.SetText(Localize("DemoSplashScreenTexts", "SplashScreenDescription", "AdvGame"));
    MenuMC = RootMC.GetObject("menu");
    ButtonsMC = MenuMC.GetObject("buttons");
    BuyBtn = GFxClikWidget(ButtonsMC.GetObject("continue_btn", Class'GFxUI.GFxClikWidget'));
    BackBtn = GFxClikWidget(ButtonsMC.GetObject("back_btn", Class'GFxUI.GFxClikWidget'));
    BuyBtn.SetString("label", Localize("AdvGFxUI_Menu_MainMenu", "LeaderStatsString", "ADVGame"));
    BackBtn.SetString("label", Localize("AdvGFxUI_PauseMenu", "PauseMenuOptionText[2]", "ADVGame"));
    return true;
    //return ReturnValue;    
}

function InitializeFooter()
{
    // End:0x71
    if(footer == none)
    {
        footer = new Class'AdvGFxUI_Menu_Footer';
        footer.SetPriority(70);
        footer.Init(GetLP());
    }
    //return;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('GenericMarketplace');    
    ButtonAliases.AddItem('MainMenu');    
    footer.FooterUpdate(ButtonAliases);
    //return;    
}

function OnBack(EventData ev)
{
    AdvPlayerController(GetPC()).ReturnToMainMenu(false);
    PlayCloseAnimation();
    //return;    
}

function OnContinueBtn(EventData ev)
{
    AdvEngine(Class'AdvEngine'.static.GetEngine()).SteamActivateGameOverlayToStore(231330, 2);
    //return;    
}

function PlayCloseAnimation()
{
    // End:0x82
    if(AdvPlayerControllerMP(GetPC()).AdvHudWrapper.AdvDemoScreen != none)
    {
        AdvPlayerControllerMP(GetPC()).AdvHudWrapper.AdvDemoScreen = none;
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    Close(true);
    //return;    
}

event OnClose()
{
    super(GFxMoviePlayer).OnClose();
    // End:0x44
    if(footer != none)
    {
        footer.Close();
        footer = none;
    }
    //return;    
}

function bool ActivatePauseScene(LocalPlayer LP)
{
    FlushPlayerInput(false);
    Init(LP);
    return true;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local EventData ev;

    // End:0x2F
    if(GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    // End:0x9E
    if((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId)
    {
        // End:0x9E
        if(ButtonName == 'XboxTypeS_B')
        {
            OnBack(ev);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    MovieInfoPath="UI_AdvFSM.AdvThx"
    bPauseGameWhileActive=true
    bOnlyOwnerFocusable=true
}