class UIScene_PasswordBox extends PKGfxMoviePlayer
    config(UI);

var name MessageName;
var string TitleString;
var string BodyString;
var string ContinueString;
var string CancelString;
var string RetryString;
var GFxObject RootMC;
var GFxObject KursorMC;
var GFxObject MenuMC;
var GFxObject TitleMC;
var GFxObject TextMC;
var GFxObject ButtonsMC;
var GFxClikWidget PasswordInp;
var GFxClikWidget ContinueBtn;
var GFxClikWidget CancelBtn;
var GFxClikWidget RetryBtn;
var GFxObject ContinueTF;
var GFxObject CancelTF;
var GFxObject RetryTF;
var GFxObject BodyLabel;
var GFxObject TitleLabel;
var name ContinueInputAlias;
var name CancelInputAlias;
var name RetryInputAlias;
var bool bContinueVisible;
var bool bCancelVisible;
var bool bRetryVisible;
var bool bFinished;
var bool bIsOpening;
var bool bIsMenuPPOverrideOn;
//var delegate<OnOptionSelected> __OnOptionSelected__Delegate;
//var delegate<OnStartButtonPressed> __OnStartButtonPressed__Delegate;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x25
    if(bIsOpening || int(InputEvent) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool Start(optional bool StartPaused = false)
{
    local float X, Y;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    FlushPlayerInput(false);
    PlaySoundFromTheme('Popup_Enter');
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    TitleMC = MenuMC.GetObject("title");
    TitleLabel = TitleMC.GetObject("textField");
    ButtonsMC = MenuMC.GetObject("buttons");
    ContinueBtn = GFxClikWidget(ButtonsMC.GetObject("ok_btn", Class'GFxUI.GFxClikWidget'));
    CancelBtn = GFxClikWidget(ButtonsMC.GetObject("midl_btn", Class'GFxUI.GFxClikWidget'));
    RetryBtn = GFxClikWidget(ButtonsMC.GetObject("cancel_btn", Class'GFxUI.GFxClikWidget'));
    ContinueTF = ButtonsMC.GetObject("test1");
    CancelTF = ButtonsMC.GetObject("test2");
    RetryTF = ButtonsMC.GetObject("test3");
    TextMC = ButtonsMC.GetObject("poleInfo");
    BodyLabel = TextMC.GetObject("textField");
    PasswordInp = GFxClikWidget(TextMC.GetObject("password", Class'GFxUI.GFxClikWidget'));
    KursorMC = RootMC.GetObject("kursor");
    // End:0x3CB
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        KursorMC.SetVisible(false);        
    }
    else
    {
        KursorMC.SetVisible(PainGFxHudWrapper(GetPC().myHUD).bShowCursor);
    }
    TitleLabel.SetBool("html", true);
    TitleLabel.SetString("htmlText", TitleString);
    ContinueTF.SetBool("html", true);
    ContinueTF.SetString("htmlText", ContinueString);
    CancelTF.SetBool("html", true);
    CancelTF.SetString("htmlText", CancelString);
    RetryTF.SetBool("html", true);
    RetryTF.SetString("htmlText", RetryString);
    // End:0x675
    if((CancelString == "") && RetryString == "")
    {
        CancelTF.GetPosition(X, Y);
        ContinueTF.SetPosition(X, Y);
        CancelBtn.GetPosition(X, Y);
        ContinueBtn.SetPosition(X, Y);        
    }
    else
    {
        // End:0x749
        if(RetryString == "")
        {
            RetryTF.GetPosition(X, Y);
            CancelTF.SetPosition(X, Y);
            RetryBtn.GetPosition(X, Y);
            CancelBtn.SetPosition(X, Y);
        }
    }
    ContinueBtn.SetString("label", "");
    CancelBtn.SetString("label", "");
    RetryBtn.SetString("label", "");
    ContinueBtn.SetBool("visible", bContinueVisible);
    CancelBtn.SetBool("visible", bCancelVisible);
    RetryBtn.SetBool("visible", bRetryVisible);
    return true;
    //return ReturnValue;    
}

function string GetPasswordText()
{
    return PasswordInp.GetString("text");
    //return ReturnValue;    
}

delegate bool OnOptionSelected(UIScene_PasswordBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return true;
    //return ReturnValue;    
}

delegate OnStartButtonPressed(int ControllerIdx)
{
    return;
    //return;    
}

function PlayOpenAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("open");
    bIsOpening = true;
    PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
    // End:0xAE
    if(PP != none)
    {
        PP.SetMenuOverride(true, 0.4000000);
        bIsMenuPPOverrideOn = true;
    }
    //return;    
}

function PlayCloseAnimation()
{
    local PKPostProcessManager PP;

    MenuMC.GotoAndPlay("close");
    // End:0xB0
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0xB0
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function StartExit()
{
    PlayCloseAnimation();
    PlaySoundFromTheme('Popup_Leave');
    bFinished = true;
    //return;    
}

event OnClose()
{
    local PKPostProcessManager PP;
    local PKUIManager Manager;

    Manager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    Manager.ActivePasswordBox = none;
    ContinueString = "";
    CancelString = "";
    RetryString = "";
    // End:0x100
    if(bIsMenuPPOverrideOn)
    {
        PP = PKPostProcessManager(PKPlayerController(GetPC()).GetPPManager());
        // End:0x100
        if(PP != none)
        {
            PP.SetMenuOverride(false, 0.4000000);
            bIsMenuPPOverrideOn = false;
        }
    }
    //return;    
}

function OnCloseAnimationComplete()
{
    Close();
    //return;    
}

function OnOpenAnimationComplete()
{
    bIsOpening = false;
    //return;    
}

function Callback_ContinueButtonPressed(int ControllerIdx)
{
    // End:0x68
    if(!bFinished && ContinueString != "")
    {
        PlaySoundFromTheme('Popup_Accept');
        // End:0x68
        if(OnOptionSelected(self, ContinueInputAlias, ControllerIdx))
        {
            StartExit();
        }
    }
    //return;    
}

function Callback_CancelButtonPressed(int ControllerIdx)
{
    // End:0x68
    if(!bFinished && CancelString != "")
    {
        PlaySoundFromTheme('Popup_Continue');
        // End:0x68
        if(OnOptionSelected(self, CancelInputAlias, ControllerIdx))
        {
            StartExit();
        }
    }
    //return;    
}

function Callback_RetryButtonPressed(int ControllerIdx)
{
    // End:0x68
    if(!bFinished && RetryString != "")
    {
        PlaySoundFromTheme('Popup_Continue');
        // End:0x68
        if(OnOptionSelected(self, RetryInputAlias, ControllerIdx))
        {
            StartExit();
        }
    }
    //return;    
}

function Callback_StartButtonPressed(int ControllerIdx)
{
    OnStartButtonPressed(ControllerIdx);
    //return;    
}

defaultproperties
{
    MovieInfo=SwfMovie'PKHD_UI.PKPassword'
    bOnlyOwnerFocusable=true
    bCaptureInput=true
    bHideLesserMovies=true
    SoundThemes=/* Array type was not detected. */
    Priority=70
}