class AdvGFxUI_Menu_Initial extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject FooterMC;
var GFxObject FooterTF;
var const localized string FooterLeftString;
var const localized string FooterRightString;
var transient bool bIsOpening;
var transient bool bIsClosing;

function bool Start(optional bool StartPaused = false)
{
    EvilEngine(Class'Engine.Engine'.static.GetEngine()).SetAA(EvilLocalPlayer(GetLP()), EvilEngine(Class'Engine.Engine'.static.GetEngine()).GetAntialiasing() - 1);
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    FooterMC = MenuMC.GetObject("logo").GetObject("footer");
    FooterTF = FooterMC.GetObject("start").GetObject("textField2");
    KursorMC = RootMC.GetObject("kursor");
    KursorMC.SetVisible(false);
    // End:0x23C
    if(!bInitialized)
    {
        MenuMC.GetPosition(MenuBasePosX, MenuBasePosY);
    }
    // End:0x2C6
    if(AdvPlayerController(GetPC()).IsPCGamepadConnected() && !AdvLocalPlayer(GetLP()).bForceNoGamepadUI)
    {
        AdvLocalPlayer(GetLP()).bPCGamepadMode = true;        
    }
    else
    {
        AdvLocalPlayer(GetLP()).bPCGamepadMode = false;
    }
    StartTextUpdate();
    PlayOpenAnimation();
    bInitialized = true;
    Frontend.GetPartyGame().RefreshPartySettings();
    return true;
    //return ReturnValue;    
}

function PlayOpenAnimation()
{
    // End:0x35
    if(bDemoMode)
    {
        MenuMC.GotoAndPlay("demo");        
    }
    else
    {
        MenuMC.GotoAndPlay("open");
    }
    FooterMC.GotoAndPlay("open");
    GetMenuGame().SetPartyRichPresenceString(GetAdvPC());
    bIsOpening = true;
    //return;    
}

function OnOpenAnimationComplete()
{
    bIsOpening = false;
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

    // End:0x80
    if(GetPC().WorldInfo.IsConsoleBuild(2))
    {
        Button = Localize("ControllerFont_PS3", "Controller_Start", "ADVGame");        
    }
    else
    {
        // End:0x12F
        if(GetPC().WorldInfo.IsConsoleBuild(1) || AdvPlayerController(GetPC()).IsPCGamepadMode())
        {
            Button = Localize("ControllerFont_XBOX", "Controller_Start", "ADVGame");            
        }
        else
        {
            Button = Localize("ControllerFont_PC", "Controller_A", "ADVGame");
        }
    }
    FooterTF.SetBool("html", true);
    FooterTF.SetString("htmlText", (FooterLeftString @ Button) @ FooterRightString);
    //return;    
}

function OnCloseAnimationComplete()
{
    Frontend.CloseInitialScreen();
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x65
    if(Frontend.IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    // End:0x1F5
    if((((int(InputEvent) == int(0)) && !bIsClosing) && !bIsOpening) && (GetPC().WorldInfo.IsConsoleBuild(0) && ButtonName == 'XboxTypeS_Start') || !GetPC().WorldInfo.IsConsoleBuild(0))
    {
        Frontend.InvalidateCheckpointData();
        Frontend.TransitionFromStart(ControllerId);
        FooterMC.GotoAndPlay("close");
        bIsClosing = true;
        PlaySoundFromTheme('press');        
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    FooterLeftString="Press"
    FooterRightString="to start"
    bDisplayFooter=false
    MovieInfoPath="UI_AdvUI.AdvInitialMenu"
}