class PKGfxMoviePlayer extends UTGFxTweenableMoviePlayer
    config(UI);

const PAIN_SCENE_PRIORITY_BLOCKASYNC = 100;
const PAIN_SCENE_PRIORITY_NOTIFICATION = 80;
const PAIN_SCENE_PRIORITY_MAXBLOCKING = 79;
const PAIN_SCENE_PRIORITY_MESSAGEBOX = 70;
const PAIN_SCENE_PRIORITY_OPTIONS = 69;
const PAIN_SCENE_PRIORITY_STATS = 68;
const PAIN_SCENE_PRIORITY_POSTGAME = 67;
const PAIN_SCENE_PRIORITY_WHATSUP = 66;
const PAIN_SCENE_PRIORITY_PAUSE = 65;
const PAIN_SCENE_PRIORITY_VERYHIGH = 60;
const PAIN_SCENE_PRIORITY_HIGH = 50;
const PAIN_SCENE_PRIORITY_GAMEOVER = 30;
const PAIN_SCENE_PRIORITY_ELEVATED = 25;
const PAIN_SCENE_PRIORITY_ABOVENORMAL = 11;
const PAIN_SCENE_PRIORITY_NORMAL = 10;
const PAIN_SCENE_PRIORITY_COOPSPECTATE = 9;
const PAIN_SCENE_PRIORITY_DISCOVERABLES = 7;
const PAIN_SCENE_PRIORITY_MPSCENE = 5;
const PAIN_SCENE_PRIORITY_TUTORIAL = 3;
const PAIN_SCENE_PRIORITY_LOWEST = 1;

var const localized string LocalPlayer1FormatString;
var const localized string LocalPlayer2FormatString;
var const localized string DecimalSeparator;

static final function GetLocalPRIs(out PainPRI LocalPRI1, out PainPRI LocalPRI2)
{
    local PKPlayerController PC;
    local GameReplicationInfo GRI;

    LocalPRI1 = none;
    LocalPRI2 = none;
    GRI = Class'Engine.Engine'.static.GetCurrentWorldInfo().GRI;
    // End:0x110
    if(GRI != none)
    {
        // End:0x10F
        foreach GRI.LocalPlayerControllers(Class'PKPlayerController', PC)
        {
            // End:0xDA
            if(LocalPRI1 == none)
            {
                LocalPRI1 = PainPRI(PC.PlayerReplicationInfo);
                // End:0x10E
                continue;
            }
            LocalPRI2 = PainPRI(PC.PlayerReplicationInfo);
            // End:0x10F
            break;            
        }        
    }
    //return;    
}

static function string GetFormattedPlayerName(PainPRI PlayerTest, PainPRI LocalPRI1, PainPRI LocalPRI2, optional bool bIncludeControllerIcon = true)
{
    local string Retval;
    local bool bIsLocalPlayer;

    // End:0x1A
    if(PlayerTest == none)
    {
        return "";        
    }
    else
    {
        // End:0x78
        if(PlayerTest == LocalPRI1)
        {
            Retval = Repl(default.LocalPlayer1FormatString, "*p", PlayerTest.PlayerName);
            bIsLocalPlayer = true;            
        }
        else
        {
            // End:0xD6
            if(PlayerTest == LocalPRI2)
            {
                Retval = Repl(default.LocalPlayer2FormatString, "*p", PlayerTest.PlayerName);
                bIsLocalPlayer = true;                
            }
            else
            {
                Retval = PlayerTest.PlayerName;
            }
        }
    }
    // End:0x1B9
    if((bIncludeControllerIcon && bIsLocalPlayer) && PlayerTest.Owner != none)
    {
        Retval = GetControllerIcon(LocalPlayer(PKPlayerController(PlayerTest.Owner).Player).ControllerId) @ Retval;
    }
    return Retval;
    //return ReturnValue;    
}

static final function string GetControllerIcon(int LocalControllerId)
{
    local string controllersSection;

    controllersSection = "ControllerFont_PC";
    switch(LocalControllerId)
    {
        // End:0x86
        case 0:
            return Class'GFxUI.GFxObject'.static.TranslateString(Localize(controllersSection, "Controller_Player1", "PKHDGame"));
        // End:0xDC
        case 1:
            return Class'GFxUI.GFxObject'.static.TranslateString(Localize(controllersSection, "Controller_Player2", "PKHDGame"));
        // End:0x133
        case 2:
            return Class'GFxUI.GFxObject'.static.TranslateString(Localize(controllersSection, "Controller_Player3", "PKHDGame"));
        // End:0x18A
        case 3:
            return Class'GFxUI.GFxObject'.static.TranslateString(Localize(controllersSection, "Controller_Player4", "PKHDGame"));
        // End:0xFFFF
        default:
            return "";
            break;
    }
    //return ReturnValue;    
}

static final function GetLoggedInControllerIds(out array<int> ControllerIds, optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local int ControllerId;

    MaxPlayersToCheck = Min(Class'Engine.OnlineSubsystem'.static.GetNumSupportedLogins(), MaxPlayersToCheck);
    ControllerIds.Length = 0;
    ControllerId = 0;
    J0x52:

    // End:0xC2 [Loop If]
    if(ControllerId < MaxPlayersToCheck)
    {
        // End:0xB4
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(ControllerId, bRequireOnlineLogin))
        {
            ControllerIds.AddItem(ControllerId);
        }
        ControllerId++;
        // [Loop Continue]
        goto J0x52;
    }
    //return;    
}

static final function int GetLoggedInPlayerCount(optional bool bRequireOnlineLogin, optional int MaxPlayersToCheck = 4)
{
    local array<int> Ids;

    GetLoggedInControllerIds(Ids, bRequireOnlineLogin, MaxPlayersToCheck);
    return Ids.Length;
    //return ReturnValue;    
}

function string TrimFloat(coerce string Str, optional int NumDigits = 1)
{
    local int DecimalIdx;

    DecimalIdx = InStr(Str, ".");
    // End:0x81
    if(DecimalIdx != -1)
    {
        Str = Left(Str, (DecimalIdx + NumDigits) + 1);
        Str = Repl(Str, ".", DecimalSeparator);
    }
    return Str;
    //return ReturnValue;    
}

defaultproperties
{
    LocalPlayer1FormatString="<font color='#ffea99'>*p</font>"
    LocalPlayer2FormatString="<font color='#ffc199'>*p</font>"
    DecimalSeparator="."
    bAutoPlay=true
    TimingMode=GFxTimingMode.TM_Real
    Priority=10
}