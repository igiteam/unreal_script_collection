class PKGFxUI_Info extends PKGfxMoviePlayer
    config(UI);

var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject ButtonsMC;
var GFxObject TextMC;
var GFxObject TextTF;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxClikWidget OkBtn;
var GFxClikWidget CancelBtn;
var const localized string TitleString;
var const localized string OK;
var const localized string Yes;
var const localized string No;
var string MessageTag;
var transient bool bResult;
//var delegate<OnMessageBoxFinish> __OnMessageBoxFinish__Delegate;

simulated function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    TitleMC = MenuMC.GetObject("title");
    TitleTF = TitleMC.GetObject("textField");
    ButtonsMC = MenuMC.GetObject("buttons");
    OkBtn = GFxClikWidget(ButtonsMC.GetObject("ok_btn", Class'GFxUI.GFxClikWidget'));
    CancelBtn = GFxClikWidget(ButtonsMC.GetObject("cancel_btn", Class'GFxUI.GFxClikWidget'));
    TextMC = ButtonsMC.GetObject("poleInfo");
    TextTF = TextMC.GetObject("textField");
    TitleTF.SetText(TitleString);
    OkBtn.SetString("label", OK);
    CancelBtn.SetBool("visible", false);
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    MenuMC.GotoAndPlay("open");
    ButtonsMC.GotoAndStop("info");
    //return;    
}

function PlayCloseAnimation()
{
    MenuMC.GotoAndPlay("close");
    //return;    
}

delegate OnMessageBoxFinish(bool bMessageBoxResult)
{
    //return;    
}

function OnOpenAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    OnMessageBoxFinish(bResult);
    PainGFxHudWrapper(GetPC().myHUD).RemoveMessageBoxReference(self);
    Close(true);
    //return;    
}

function OnOkBtn()
{
    bResult = true;
    PlayCloseAnimation();
    //return;    
}

function OnCancelBtn()
{
    bResult = false;
    PlayCloseAnimation();
    //return;    
}

function OnBack()
{
    OnCancelBtn();
    //return;    
}

function SetText(string txt)
{
    TextTF.super(PKGFxUI_Info).SetText(txt);
    //return;    
}

defaultproperties
{
    TitleString="Information"
    OK="OK"
    Yes="Yes"
    No="No"
    MovieInfo=SwfMovie'PKHD_UI.PKConfirm'
    bCaptureInput=true
    bResetMousePositionOnStart=true
    SoundThemes=/* Array type was not detected. */
}