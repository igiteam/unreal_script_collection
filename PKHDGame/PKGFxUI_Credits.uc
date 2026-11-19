class PKGFxUI_Credits extends PKGFxUI_Menu_Base
    config(UI);

var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var const localized string TitleString;
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

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x69
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
    TitleTF.SetText(Localize("PKGFxUI_Menu_OptionsMenu", "CreditsString", "PKHDGame"));
    InitializeCredits();
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
    OutCurrentLine = Localize("credits", LineName, "Credits");
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

function ReturnToMainMenu()
{
    local WorldInfo WI;
    local PKPlayerController PC;
    local UniqueNetId RequestingPlayerId;

    PC = PKPlayerController(GetPC());
    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x205
    if((PC != none) && WI != none)
    {
        // End:0xC7
        if(PC.PlayerReplicationInfo != none)
        {
            RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
        }
        // End:0x14D
        if((int(WI.NetMode) < int(NM_Client)) && WI.Game != none)
        {
            WI.Game.TellClientsToReturnToPartyHost();            
        }
        else
        {
            // End:0x205
            if(int(WI.NetMode) == int(NM_Client))
            {
                // End:0x205
                if(PC.IsPrimaryPlayer())
                {
                    // End:0x1E5
                    if(PC.IsPartyLeader())
                    {
                        PC.ClientReturnToParty(RequestingPlayerId);                        
                    }
                    else
                    {
                        PC.ReturnToMainMenu(false);
                    }
                }
            }
        }
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
    local OnlineSubsystem OnlineSub;

    super(UTGFxTweenableMoviePlayer).Init(LocPlay);
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
    local OnlineSubsystem OnlineSub;

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
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xED
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        // End:0xED
        if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
        {
            Close();
            PKPlayerController(GetPC()).ReturnToMainMenu(true);
        }
    }
    //return;    
}

defaultproperties
{
    CreditScrollTime=15.0000000
    CreditEndDelayTime=2.0000000
    LogoDisplayTime=5.0000000
    bDisplayFooter=false
    MovieInfo=SwfMovie'PKHD_UI.PKCredits'
    bDiscardNonOwnerInput=true
    OnPostAdvance=UpdateCredits
}