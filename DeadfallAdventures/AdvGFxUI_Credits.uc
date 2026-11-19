class AdvGFxUI_Credits extends AdvGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject BackTF;
var const localized string TitleString;
var string CreditsFile;
var transient GFxObject CreditsView;
var transient int CurrentCreditLineNumber;
var config float CreditScrollTime;
var transient float CreditPollTime;
var transient float LastPollTime;
var config float CreditEndDelayTime;
var transient bool bScrollingCreditsDone;
var transient bool bLogosDone;
var config float LogoDisplayTime;
var transient OnlineSubsystem.ENetworkNotificationPosition LastPosition;
var MusicTrackStruct MTS;
var SoundCue CreditsMusic;

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x6A
    if((int(InputEvent) == int(0)) && ((ButtonName == 'XboxTypeS_Start') || ButtonName == 'XboxTypeS_Back') || ButtonName == 'Escape')
    {
        ReturnToMainMenu();
    }
    return true;
    //return ReturnValue;    
}

function bool Start(optional bool StartPaused = false)
{
    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleTF = ButtonsMC.GetObject("title");
    CreditsView = ButtonsMC.GetObject("credits");
    BackTF = ButtonsMC.GetObject("backTextField");
    TitleTF.SetText(Localize("AdvGFxUI_Menu_OptionsMenu", "CreditsString", "ADVGame"));
    // End:0x2C6
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        BackTF.SetBool("html", true);
        BackTF.SetString("htmlText", (Localize("ControllerFont" $ ((AdvPlayerController(GetPC()).IsPCGamepadMode()) ? "_XBOX" : Class'AdvFrontEnd'.static.GetLocKeySuffix()), "Controller_Start", "ADVGame")) @ (Localize("MovieOverlay", "SkipMovie", "ADVGame")));
    }
    InitializeCredits();
    MTS.TheSoundCue = CreditsMusic;
    GetPC().WorldInfo.UpdateMusicTrack(MTS);
    return true;
    //return ReturnValue;    
}

function OnBack(EventData ev)
{
    ReturnToMainMenu();
    //return;    
}

function bool IsDataFound(string TestMe)
{
    return Left(TestMe, 1) != "?";
    //return ReturnValue;    
}

function bool NextLine(out string OutCurrentLine)
{
    local string LineName;

    // End:0x35
    if(CurrentCreditLineNumber < 10)
    {
        LineName = "line_0000" $ string(CurrentCreditLineNumber);        
    }
    else
    {
        // End:0x69
        if(CurrentCreditLineNumber < 100)
        {
            LineName = "line_000" $ string(CurrentCreditLineNumber);            
        }
        else
        {
            // End:0x9F
            if(CurrentCreditLineNumber < 1000)
            {
                LineName = "line_00" $ string(CurrentCreditLineNumber);                
            }
            else
            {
                // End:0xD4
                if(CurrentCreditLineNumber < 10000)
                {
                    LineName = "line_0" $ string(CurrentCreditLineNumber);                    
                }
            }
        }
    }
    CurrentCreditLineNumber++;
    OutCurrentLine = Localize("Credits", LineName, CreditsFile);
    return IsDataFound(OutCurrentLine);
    //return ReturnValue;    
}

final function UpdateCredits(float DeltaTime)
{
    local float TimeSinceLastUpdate;
    local string CreditLine;

    // End:0x10E
    if(!bScrollingCreditsDone && CreditPollTime > 0.0000000)
    {
        TimeSinceLastUpdate = GetPC().WorldInfo.TimeSeconds - LastPollTime;
        // End:0x10E
        if(TimeSinceLastUpdate >= CreditPollTime)
        {
            LastPollTime = GetPC().WorldInfo.TimeSeconds;
            // End:0x102
            if(NextLine(CreditLine))
            {
                SendLine(CreditLine, TimeSinceLastUpdate - CreditPollTime);                
            }
            else
            {
                bScrollingCreditsDone = true;
            }
        }
    }
    // End:0x165
    if(bScrollingCreditsDone && !bLogosDone)
    {
        GetPC().SetTimer(CreditScrollTime, false, 'FadeInLogos', self);
        bLogosDone = true;
    }
    //return;    
}

function ReturnToMainMenu(optional bool bReturnToStartScreen = false)
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    // End:0x5A
    if(PC != none)
    {
        PC.ReturnToMainMenu(bReturnToStartScreen);
    }
    Close();
    //return;    
}

function InitializeCredits()
{
    local array<ASValue> args;
    local ASValue Retval;

    args.Length = 1;
    args[0].Type = 2;
    args[0].N = CreditScrollTime;
    Retval = CreditsView.Invoke("Initialize", args);
    CreditPollTime = Retval.N;
    LastPollTime = GetPC().WorldInfo.TimeSeconds;
    //return;    
}

private final function SendLine(string NewLine, float StartDelay)
{
    CreditsView.ActionScriptVoid("StartLine");
    //return;    
}

private final function FadeInLogos()
{
    GetPC().SetTimer(LogoDisplayTime, false, 'FadeOutLogos', self);
    ActionScript_FadeInLogos();
    //return;    
}

function ActionScript_FadeInLogos()
{
    CreditsView.ActionScriptVoid("FadeInLogos");
    //return;    
}

private final function FadeOutLogos()
{
    GetPC().SetTimer(CreditEndDelayTime, false, 'ReturnToMainMenu', self);
    ActionScript_FadeOutLogos();
    //return;    
}

function ActionScript_FadeOutLogos()
{
    CreditsView.ActionScriptVoid("FadeOutLogos");
    //return;    
}

function Init(optional LocalPlayer LocPlay)
{
    super(AdvGfxMoviePlayer).Init(LocPlay);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x176
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
    {
        OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        LastPosition = OnlineSub.SystemInterface.GetNetworkNotificationPosition();
        OnlineSub.SystemInterface.SetNetworkNotificationPosition(2);
    }
    //return;    
}

event OnClose()
{
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x12A
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
    {
        OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        OnlineSub.SystemInterface.SetNetworkNotificationPosition(LastPosition);
    }
    super.OnClose();
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xC3
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        // End:0xC3
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
        {
            ReturnToMainMenu(true);
        }
    }
    //return;    
}

defaultproperties
{
    CreditsFile="Credits"
    CreditScrollTime=13.0000000
    CreditEndDelayTime=1.0000000
    LogoDisplayTime=0.1000000
    MTS=(TheSoundCue=none,bAutoPlay=false,bPersistentAcrossLevels=false,FadeInTime=5.0000000,FadeInVolumeLevel=1.0000000,FadeOutTime=5.0000000,FadeOutVolumeLevel=0.0000000,MP3Filename="")
    CreditsMusic=SoundCue'mst_EndCredits.cues.mst_EndCredits_01'
    bDisplayFooter=false
    MovieInfo=SwfMovie'UI_AdvCommon.AdvCredits'
    bDiscardNonOwnerInput=true
    OnPostAdvance=UpdateCredits
}