class AdvGFxUI_Menu_PartyWindow extends AdvGfxMoviePlayer
    config(UI);

const MAX_SLOTS = 16;

struct PlayerPartySlot
{
    var AdvPRI PRI;
    var GFxObject MC;
    var GFxObject LevelMC;
    var GFxObject TF;
    var GFxObject LevelTF;
    var GFxObject IconTF;
    var GFxObject Speaker;
    var GFxObject Crown;
    var GFxClikWidget Level;
    var bool bMuted;

    structdefaultproperties
    {
        PRI=none
        MC=none
        LevelMC=none
        TF=none
        LevelTF=none
        IconTF=none
        Speaker=none
        Crown=none
        Level=none
        bMuted=false
    }
};

var AdvFrontEnd Frontend;
var GFxObject RootMC;
var GFxObject PartyMC;
var GFxObject HeaderTitleMC;
var GFxObject HeaderTitleTF;
var GFxObject FooterMC;
var GFxObject FooterTF;
var array<PlayerPartySlot> PlayerPlaces;
var transient int NumPlayers;
var transient AdvTypes.EPKPartyType PartyTypeLocalCopy;
var transient AdvTypes.EMultiGameMode GameModeLocalCopy;
var transient bool bForceUpdatePlayerPanel;
var transient bool bForceUpdateTitle;
var const localized string HeaderTitleString;
var const localized string HeaderTitleStringPC;
var const localized string PlayerSlotAvail;
var const localized string PlayerSlotNotSigned;
var const localized string ShowPlayersMenuString;
var const localized string ShowPartyMenuString;
var const localized string ShowFriendsMenuString;
var const localized string ShowPartyDetailsMenuString;
var const localized string PlayerConnectingString;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local PlayerPartySlot PlayerSlot;
    local OnlineSubsystem OnlineSub;
    local AdvGRI GRI;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    RootMC = GetVariableObject("_root");
    PartyMC = RootMC.GetObject("party");
    HeaderTitleMC = RootMC.GetObject("title");
    HeaderTitleTF = HeaderTitleMC.GetObject("textField");
    FooterMC = PartyMC.GetObject("nextmenu");
    FooterTF = FooterMC.GetObject("textField");
    I = 0;
    J0x196:

    // End:0x88E [Loop If]
    if(I < 16)
    {
        PlayerSlot.MC = PartyMC.GetObject("slot" $ string(I + 1));
        PlayerSlot.TF = PlayerSlot.MC.GetObject("textField");
        PlayerSlot.Crown = PlayerSlot.MC.GetObject("crown");
        PlayerSlot.Speaker = PlayerSlot.MC.GetObject("speaker");
        PlayerSlot.IconTF = PlayerSlot.MC.GetObject("tfIcon");
        PlayerSlot.LevelMC = PlayerSlot.MC.GetObject("level");
        PlayerSlot.LevelTF = PlayerSlot.LevelMC.GetObject("levelTF");
        PlayerSlot.Level = GFxClikWidget(PlayerSlot.LevelMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        // End:0x86A
        if(Class'Core.Object'.static.GetLanguage() ~= "JPN")
        {
            PlayerSlot.TF.SetInt("_width", PlayerSlot.TF.GetInt("_width") + 150);
            PlayerSlot.TF.SetInt("_height", PlayerSlot.TF.GetInt("_height") + 5);
            PlayerSlot.TF.SetFloat("_xscale", PlayerSlot.TF.GetFloat("_xscale") * 0.7500000);
            PlayerSlot.TF.SetFloat("_yscale", PlayerSlot.TF.GetFloat("_yscale") * 0.7500000);
            PlayerSlot.TF.SetFloat("_x", PlayerSlot.TF.GetFloat("_x") + float(6));
            PlayerSlot.LevelTF.SetFloat("_x", PlayerSlot.LevelTF.GetFloat("_x") + float(6));
            PlayerSlot.LevelTF.SetFloat("_xscale", PlayerSlot.LevelTF.GetFloat("_xscale") * 0.7500000);
            PlayerSlot.LevelTF.SetFloat("_yscale", PlayerSlot.LevelTF.GetFloat("_yscale") * 0.7500000);
        }
        PlayerPlaces.AddItem(PlayerSlot);        
        I++;
        // [Loop Continue]
        goto J0x196;
    }
    HeaderTitleTF.SetText(" ");
    FooterTF.SetText(" ");
    // End:0x90C
    if(GRI != none)
    {
        PartyTypeLocalCopy = GRI.GetCurrentPartyType();
    }
    // End:0x983
    if((Frontend != none) && Frontend.GetMenuGame() != none)
    {
        GameModeLocalCopy = Frontend.GetMenuGame().MultiGameModeSelected;        
    }
    else
    {
        // End:0x9D9
        if(GRI != none)
        {
            GameModeLocalCopy = GRI.GetMultiGameMode(GRI.GameClass);
        }
    }
    UpdatePlayersPanel();
    UpdateTitle();
    TrackChat(true);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xB4B
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
    {
        OnlineSub.PlayerInterface.AddMutingChangeDelegate(OnMutingChange);
        OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(byte(GetLP().ControllerId), OnPartyMemberListChanged);
    }
    InitXP();
    return true;
    //return ReturnValue;    
}

reliable client simulated function InitXP()
{
    local int PlayerXP;

    // End:0xEF
    if(GetPC().PlayerReplicationInfo != none)
    {
        AdvPlayerController(GetPC()).ProfileSettings.GetProfileSettingValueInt(36, PlayerXP);
        AdvPRI(GetPC().PlayerReplicationInfo).InitXP(PlayerXP);
        GetPC().PlayerReplicationInfo.bForceNetUpdate = true;        
    }
    else
    {
        GetPC().SetTimer(0.0100000, false, 'InitXP', self);
    }
    //return;    
}

static function string GetPartyFormattedPlayerName(AdvPRI PRI)
{
    local ADVPartyPC TempPC;

    TempPC = ADVPartyPC(PRI.Owner);
    // End:0xD4
    if((((TempPC != none) && int(TempPC.Role) == int(ROLE_Authority)) && TempPC.IsLocalPlayerController()) && !TempPC.bSignedIn)
    {
        return Class'AdvGFxUI_Menu_PartyWindow'.default.PlayerSlotNotSigned;
    }
    return PRI.PlayerName;
    //return ReturnValue;    
}

function UpdatePlayersPanel()
{
    local AdvGRI GRI;
    local int I;
    local QWord DummyUid;

    I = 0;
    J0x0B:

    // End:0xD5 [Loop If]
    if(I < 16)
    {
        SetSlotPRI(I, none);
        SetSlotActive(I, false);
        SetSlotText(I, PlayerSlotAvail);
        SetSlotSpeaker(I, false);
        SetSlotCrown(I, false);
        SetSlotIconTF(I, " ");
        SetSlotLevel(I, false);
        SetSlotVisible(I, false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0x11F
    if(Frontend != none)
    {
        // End:0x11F
        if(!Frontend.CurrentScene.bDisplayPartyWindow)
        {
            return;
        }
    }
    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x684
    if(GRI != none)
    {
        NumPlayers = 0;
        I = 0;
        J0x18B:

        // End:0x681 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x673
            if(IsValidPRI(AdvPRI(GRI.PRIArray[I])))
            {
                SetSlotVisible(I, true);
                SetSlotPRI(NumPlayers, AdvPRI(GRI.PRIArray[I]));
                SetSlotActive(NumPlayers, true);
                SetSlotText(NumPlayers, GetPartyFormattedPlayerName(AdvPRI(GRI.PRIArray[I])));
                SetSlotLevel(NumPlayers, true, AdvPRI(GRI.PRIArray[I]).PlayerLevel);
                // End:0x40B
                if(GRI.PRIArray[I].UniqueId.Uid != DummyUid && GRI.PRIArray[I].UniqueId == AdvPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId)
                {
                    SetSlotCrown(NumPlayers, true);
                }
                // End:0x4B5
                if(PlayerIsMuted(GRI.PRIArray[I].UniqueId, GetLP().ControllerId))
                {
                    SetSlotSpeaker(NumPlayers, true, true);
                    PlayerPlaces[NumPlayers].bMuted = true;                    
                }
                else
                {
                    PlayerPlaces[NumPlayers].bMuted = false;
                }
                // End:0x668
                if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayerController(GRI.PRIArray[I].Owner) != none) && LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player) != none)
                {
                    SetSlotIconTF(NumPlayers, GetControllerIcon(LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player).ControllerId));
                }
                NumPlayers++;
            }
            I++;
            // [Loop Continue]
            goto J0x18B;
        }        
    }
    else
    {
        bForceUpdatePlayerPanel = true;
    }
    //return;    
}

function UpdateTitle()
{
    local AdvGRI GRI;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x273
    if(GetPC().WorldInfo.IsConsoleBuild(1) && GRI != none)
    {
        FooterTF.SetBool("html", true);
        // End:0x1CB
        if(Frontend != none)
        {
            // End:0x1A5
            if(Frontend.CurrentScene.bCanOpenPartyMenu && Frontend.CurrentScene.bDisplayPartyWindow)
            {
                FooterTF.SetString("htmlText", (Localize("ControllerFont_XBOX", "Controller_X", "ADVGame")) @ ShowPartyDetailsMenuString);                
            }
            else
            {
                FooterTF.SetText(" ");
            }            
        }
        else
        {
            // End:0x24D
            if(int(PartyTypeLocalCopy) != int(2))
            {
                FooterTF.SetString("htmlText", (Localize("ControllerFont_XBOX", "Controller_X", "ADVGame")) @ ShowPlayersMenuString);                
            }
            else
            {
                FooterTF.SetText(" ");
            }
        }        
    }
    else
    {
        // End:0x2A8
        if(GRI != none)
        {
            FooterTF.SetText(" ");            
        }
        else
        {
            bForceUpdateTitle = true;
        }
    }
    //return;    
}

function SetSlotVisible(int SlotIdx, bool bVisible)
{
    // End:0x56
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].MC.SetVisible(bVisible);
    }
    //return;    
}

function SetSlotPRI(int SlotIdx, AdvPRI PRI)
{
    // End:0x40
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].PRI = PRI;
    }
    //return;    
}

function SetSlotActive(int SlotIdx, bool bIsActive)
{
    // End:0xA7
    if(SlotIdx < 16)
    {
        // End:0x64
        if(bIsActive)
        {
            PlayerPlaces[SlotIdx].MC.GotoAndStop("active");            
        }
        else
        {
            PlayerPlaces[SlotIdx].MC.GotoAndStop("empty");
        }
    }
    //return;    
}

function SetSlotText(int SlotIdx, string Text)
{
    // End:0x56
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].TF.SetText(Text);
    }
    //return;    
}

function SetSlotCrown(int SlotIdx, bool bVisible)
{
    // End:0x99
    if(GetPC().WorldInfo.IsConsoleBuild(1) && bVisible)
    {
        // End:0x96
        if(SlotIdx < 16)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(true);
        }        
    }
    else
    {
        // End:0xE6
        if(SlotIdx < 16)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(false);
        }
    }
    //return;    
}

function SetSlotSpeaker(int SlotIdx, bool bVisible, optional bool bMuted = false)
{
    // End:0xF1
    if(SlotIdx < 16)
    {
        // End:0x67
        if(bMuted)
        {
            PlayerPlaces[SlotIdx].Speaker.GotoAndStop("mute");            
        }
        else
        {
            PlayerPlaces[SlotIdx].Speaker.GotoAndStop("active");
        }
        PlayerPlaces[SlotIdx].Speaker.SetVisible(bVisible);
    }
    //return;    
}

function SetSlotIconTF(int SlotIdx, string IconButtonAlias)
{
    // End:0xA3
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].IconTF.SetBool("html", true);
        PlayerPlaces[SlotIdx].IconTF.SetString("htmlText", IconButtonAlias);
    }
    //return;    
}

function SetSlotLevel(int SlotIdx, bool bVisible, optional int Level = 0)
{
    // End:0x211
    if(SlotIdx < 16)
    {
        // End:0x1CB
        if(bVisible)
        {
            // End:0xE7
            if(Level == 0)
            {
                bForceUpdatePlayerPanel = true;
                PlayerPlaces[SlotIdx].LevelTF.SetText("");
                PlayerPlaces[SlotIdx].Level.SetString("source", "img://UI_AdvCommon.Textures.Blank");                
            }
            else
            {
                PlayerPlaces[SlotIdx].LevelTF.SetText(string(Level));
                PlayerPlaces[SlotIdx].Level.SetString("source", "img://" $ Class'AdvClassInfo_MP_Base'.default.RankIconPath[Clamp(Level - 1, 0, Class'AdvClassInfo_MP_Base'.default.RankIconPath.Length)]);
            }
        }
        PlayerPlaces[SlotIdx].LevelMC.SetVisible(bVisible);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local AdvGRI GRI;
    local int I;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    // End:0x7D
    if(bForceUpdatePlayerPanel)
    {
        bForceUpdatePlayerPanel = false;
        UpdatePlayersPanel();
    }
    // End:0xA0
    if(bForceUpdateTitle)
    {
        UpdateTitle();
        bForceUpdateTitle = false;
    }
    // End:0x433
    if(GRI != none)
    {
        // End:0xE6
        if(NumPlayers != GRI.PRIArray.Length)
        {
            UpdatePlayersPanel();
        }
        // End:0x2E3
        if((int(PartyTypeLocalCopy) != int(GRI.GetCurrentPartyType())) || (((Frontend != none) && Frontend.GetMenuGame() != none) && int(GameModeLocalCopy) != int(Frontend.GetMenuGame().MultiGameModeSelected)) || int(GameModeLocalCopy) != int(GRI.GetMultiGameMode(GRI.GameClass)))
        {
            PartyTypeLocalCopy = GRI.GetCurrentPartyType();
            // End:0x288
            if((Frontend != none) && Frontend.GetMenuGame() != none)
            {
                GameModeLocalCopy = Frontend.GetMenuGame().MultiGameModeSelected;                
            }
            else
            {
                GameModeLocalCopy = GRI.GetMultiGameMode(GRI.GameClass);
            }
            UpdatePlayersPanel();
            UpdateTitle();
        }
        I = 0;
        J0x2EE:

        // End:0x433 [Loop If]
        if(I < NumPlayers)
        {
            // End:0x425
            if(!PlayerPlaces[I].bMuted && (Frontend == none) || Frontend.CurrentScene.bDisplayPartyWindow)
            {
                // End:0x410
                if((PlayerPlaces[I].PRI != none) && Class'AdvUIManager'.static.GetChatIconOpacity(PlayerPlaces[I].PRI) > 0.5000000)
                {
                    SetSlotSpeaker(I, true);                    
                }
                else
                {
                    SetSlotSpeaker(I, false);
                }
            }
            I++;
            // [Loop Continue]
            goto J0x2EE;
        }
    }
    //return;    
}

function SetHidden(bool bHide)
{
    // End:0x50
    if(bHide)
    {
        PartyMC.SetVisible(false);
        HeaderTitleMC.SetVisible(false);        
    }
    else
    {
        PartyMC.SetVisible(true);
        HeaderTitleMC.SetVisible(true);
    }
    //return;    
}

static function bool IsValidPRI(AdvPRI PRI)
{
    // End:0x37
    if((PRI != none) && !PRI.bIsInactive)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool BelongsToParty(AdvPRI PRI)
{
    local QWord DummyUid;

    // End:0xB1
    if(PRI.PartyOwnerUniqueId.Uid != DummyUid && PRI.PartyOwnerUniqueId == AdvPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool PlayerIsMuted(UniqueNetId NetId, int ControllerId)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xB5
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xB5
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            return PlayerInt.IsMuted(byte(ControllerId), NetId);
        }
    }
    return false;
    //return ReturnValue;    
}

function OnMutingChange()
{
    bForceUpdatePlayerPanel = true;
    //return;    
}

function OnPartyMemberListChanged(bool bJoinedOrLeft, string PlayerName, UniqueNetId PlayerID)
{
    bForceUpdatePlayerPanel = true;
    //return;    
}

event OnClose()
{
    local OnlineSubsystem OnlineSub;

    super(GFxMoviePlayer).OnClose();
    TrackChat(false);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x168
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
    {
        OnlineSub.PlayerInterface.ClearMutingChangeDelegate(OnMutingChange);
        OnlineSub.PartyChatInterface.ClearPartyMemberListChangedDelegate(byte(GetLP().ControllerId), OnPartyMemberListChanged);
    }
    //return;    
}

function TrackChat(bool bTrack)
{
    // End:0x13A
    if((GetPC().OnlineSub != none) && NotEqual_InterfaceInterface(GetPC().OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        // End:0xDE
        if(bTrack)
        {
            GetPC().OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);            
        }
        else
        {
            GetPC().OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
        }
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer, bool bIsTalking)
{
    local AdvPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

static function AdvPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local AdvGRI GRI;
    local int I;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x150
    if(GRI != none)
    {
        I = 0;
        J0x61:

        // End:0x150 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x142
            if((GRI.PRIArray[I] != none) && GRI.PRIArray[I].UniqueId == TestID)
            {
                return AdvPRI(GRI.PRIArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x61;
        }
    }
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    HeaderTitleString="Party Type:"
    HeaderTitleStringPC="Local Players"
    PlayerSlotAvail="Player slot empty"
    PlayerSlotNotSigned="Not signed in"
    ShowPlayersMenuString="Show Players"
    ShowPartyMenuString="Show Party"
    ShowFriendsMenuString="Show Friends"
    ShowPartyDetailsMenuString="Party Details"
    PlayerConnectingString="Connecting"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvPartyTime'
    bAllowFocus=false
}