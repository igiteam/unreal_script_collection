class PKGFxUI_Menu_Initial extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject FooterMC;
var GFxObject FooterTF;
var const localized string FooterLeftString;
var const localized string FooterRightString;
var transient bool bIsClosing;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    FooterMC = RootMC.GetObject("footer");
    FooterTF = FooterMC.GetObject("start").GetObject("textField2");
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    // End:0x18C
    if(!bInitialized)
    {
        MenuMC.GetPosition(MenuBasePosX, MenuBasePosY);
    }
    StartTextUpdate();
    PlayOpenAnimation();
    bInitialized = true;
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    super.PlayOpenAnimation();
    FooterMC.GotoAndPlay("open");
    GetMenuGame().SetPartyRichPresenceString(GetPKPC());
    //return;    
}

function PlayCloseAnimation()
{
    super.PlayCloseAnimation();
    // End:0x3F
    if(!bIsClosing)
    {
        FooterMC.GotoAndPlay("close");
    }
    //return;    
}

function StartTextUpdate()
{
    local string Button;

    // End:0x81
    if(GetPC().WorldInfo.IsConsoleBuild(2))
    {
        Button = Localize("ControllerFont_PS3", "Controller_Start", "PKHDGame");        
    }
    else
    {
        // End:0x13D
        if(GetPC().WorldInfo.IsConsoleBuild(1) || GetPC().PlayerInput.bUsingGamepad)
        {
            Button = Localize("ControllerFont_XBOX", "Controller_Start", "PKHDGame");            
        }
        else
        {
            Button = Localize("ControllerFont_PC", "Controller_A", "PKHDGame");
        }
    }
    FooterTF.SetBool("html", true);
    FooterTF.SetString("htmlText", (FooterLeftString @ Button) @ FooterRightString);
    //return;    
}

function OnCloseAnimationComplete()
{
    FrontEnd.CloseInitialScreen();
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x65
    if(FrontEnd.IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    // End:0x1C5
    if(((int(InputEvent) == int(0)) && !bIsClosing) && (GetPC().WorldInfo.IsConsoleBuild(0) && ButtonName == 'XboxTypeS_Start') || !GetPC().WorldInfo.IsConsoleBuild(0))
    {
        FrontEnd.TransitionFromStart(ControllerId);
        FooterMC.GotoAndPlay("close");
        bIsClosing = true;
        PlaySoundFromTheme('click');        
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    FooterLeftString="Press"
    FooterRightString="to start"
    bDisplayFooter=false
    MovieInfo=SwfMovie'PKHD_UI.PKInitialMenu'
}