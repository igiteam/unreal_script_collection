class AdvGFxUI_Menu_PartyMenu extends AdvGFxUI_Menu_Base
    config(UI);

const MAX_SLOTS = 16;

enum PartyMenuFunction
{
    PMF_PartyMenu,                  // 0
    PMF_VoteForKick,                // 1
    PMF_Kick,                       // 2
    PMF_MutePlayer,                 // 3
    PMF_MAX                         // 4
};

struct PlayerSlot
{
    var AdvPRI PRI;
    var GFxObject MC;
    var GFxObject LevelMC;
    var GFxClikWidget Btn;
    var GFxObject IconTF;
    var GFxObject LevelTF;
    var GFxObject Speaker;
    var GFxObject Crown;
    var GFxClikWidget Level;
    var bool bMuted;

    structdefaultproperties
    {
        PRI=none
        MC=none
        LevelMC=none
        Btn=none
        IconTF=none
        LevelTF=none
        Speaker=none
        Crown=none
        Level=none
        bMuted=false
    }
};

var array<PlayerSlot> PlayerPlaces;
var transient int NumPlayers;
var transient int CurrentSelectedSlot;
var GFxObject ButtonsMC;
var GFxObject TitleMC;
var GFxObject TitleTF;
var GFxObject FooterMC;
var GFxObject FooterTF;
var GFxObject FooterBottomTF;
var const localized string TitleString;
var const localized string TitlePartyString;
var transient bool bForceUpdatePlayerPanel;
var AdvGFxUI_PauseMenu ParentMenu;
var AdvGFxUI_Menu_PartyMenu.PartyMenuFunction MenuFunction;
var int CurrentSelectedPlayerSlot;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local PlayerSlot Slot;

    super.Start(StartPaused);
    Advance(0.0000000);
    ButtonsMC = MenuMC.GetObject("buttons");
    TitleMC = MenuMC.GetObject("title");
    FooterMC = MenuMC.GetObject("footer");
    FooterTF = FooterMC.GetObject("textField1");
    FooterBottomTF = FooterMC.GetObject("textField2");
    I = 0;
    J0x135:

    // End:0x44E [Loop If]
    if(I < 16)
    {
        Slot.MC = ButtonsMC.GetObject("player" $ string(I + 1));
        Slot.Btn = GFxClikWidget(Slot.MC.GetObject("batonix", Class'GFxUI.GFxClikWidget'));
        Slot.Crown = Slot.MC.GetObject("crown");
        Slot.Speaker = Slot.MC.GetObject("speaker");
        Slot.IconTF = Slot.MC.GetObject("textField");
        Slot.LevelMC = Slot.MC.GetObject("level");
        Slot.LevelTF = Slot.LevelMC.GetObject("levelTF");
        Slot.Level = GFxClikWidget(Slot.LevelMC.GetObject("UILoader", Class'GFxUI.GFxClikWidget'));
        PlayerPlaces.AddItem(Slot);        
        I++;
        // [Loop Continue]
        goto J0x135;
    }
    TitleTF = TitleMC.GetObject("textField");
    TitleTF.SetText(TitlePartyString);
    UpdatePlayersPanel();
    TrackChat(true);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x614
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
    {
        OnlineSub.PlayerInterface.AddMutingChangeDelegate(OnMutingChange);
        OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(byte(GetLP().ControllerId), OnPartyMemberListChanged);
    }
    InitXP();
    return true;
    //return ReturnValue;    
}

function SetMenuFunction(AdvGFxUI_Menu_PartyMenu.PartyMenuFunction NewMenuFunction)
{
    MenuFunction = NewMenuFunction;
    switch(MenuFunction)
    {
        // End:0x86
        case 2:
            TitleTF.SetText("<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.KickPlayer>");
            // End:0x14A
            break;
        // End:0xEA
        case 1:
            TitleTF.SetText("<Strings:ADVGame.AdvGFxUI_Menu_PartyWindow.VoteKickPlayer>");
            // End:0x14A
            break;
        // End:0x11B
        case 3:
            TitleTF.SetText(TitlePartyString);
            // End:0x14A
            break;
        // End:0xFFFF
        default:
            TitleTF.SetText(TitlePartyString);
            // End:0x14A
            break;
            break;
    }
    //return;    
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

function UpdatePlayersPanel()
{
    local AdvGRI GRI;
    local int I;
    local QWord DummyUid;

    I = 0;
    J0x0B:

    // End:0xD6 [Loop If]
    if(I < 16)
    {
        SetSlotActive(I, false);
        SetSlotText(I, Class'AdvGFxUI_Menu_PartyWindow'.default.PlayerSlotAvail);
        SetSlotSpeaker(I, false);
        SetSlotCrown(I, false);
        SetSlotIconTF(I, " ");
        SetSlotLevel(I, false);
        SetSlotVisible(I, false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x674
    if(GRI != none)
    {
        NumPlayers = 0;
        I = 0;
        J0x142:

        // End:0x671 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x663
            if(IsValidPRI(AdvPRI(GRI.PRIArray[I])) && (int(MenuFunction) != int(0)) || BelongsToParty(AdvPRI(GRI.PRIArray[I])))
            {
                SetSlotVisible(I, true);
                SetSlotPRI(NumPlayers, AdvPRI(GRI.PRIArray[I]));
                SetSlotActive(NumPlayers, true);
                SetSlotText(NumPlayers, GRI.PRIArray[I].PlayerName);
                SetSlotLevel(NumPlayers, true, AdvPRI(GRI.PRIArray[I]).PlayerLevel);
                // End:0x41A
                if(GRI.PRIArray[I].UniqueId.Uid != DummyUid && GRI.PRIArray[I].UniqueId == AdvPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId)
                {
                    SetSlotCrown(NumPlayers, true);
                }
                // End:0x4A5
                if(PlayerIsMuted(GRI.PRIArray[I].UniqueId))
                {
                    SetSlotSpeaker(NumPlayers, true, true);
                    PlayerPlaces[NumPlayers].bMuted = true;                    
                }
                else
                {
                    PlayerPlaces[NumPlayers].bMuted = false;
                }
                // End:0x658
                if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayerController(GRI.PRIArray[I].Owner) != none) && LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player) != none)
                {
                    SetSlotIconTF(NumPlayers, GetControllerIcon(LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player).ControllerId));
                }
                NumPlayers++;
            }
            I++;
            // [Loop Continue]
            goto J0x142;
        }        
    }
    else
    {
        bForceUpdatePlayerPanel = true;
    }
    CurrentSelectedSlot = 0;
    PlayerPlaces[CurrentSelectedSlot].Btn.SetBool("focused", true);
    FooterUpdate(CurrentSelectedSlot);
    //return;    
}

function OnPlayerSelect(int SlotIdx, int ControllerIdx)
{
    // End:0x356
    if(SlotIdx < NumPlayers)
    {
        // End:0x356
        if(PlayerPlaces[SlotIdx].PRI != none)
        {
            switch(MenuFunction)
            {
                // End:0xEF
                case 2:
                    // End:0xEC
                    if(CanKickPlayer(PlayerPlaces[SlotIdx].PRI))
                    {
                        KickPlayer(PlayerPlaces[SlotIdx].PRI, GetLP(), OnKick_Confirmed);
                        CurrentSelectedPlayerSlot = SlotIdx;
                    }
                    // End:0x356
                    break;
                // End:0x1D4
                case 1:
                    // End:0x1D1
                    if(CanVoteKickPlayer(PlayerPlaces[SlotIdx].PRI) && GetPC().PlayerReplicationInfo != PlayerPlaces[SlotIdx].PRI)
                    {
                        VoteKickPlayer(PlayerPlaces[SlotIdx].PRI, GetLP(), OnVoteKick_Confirmed);
                        CurrentSelectedPlayerSlot = SlotIdx;
                    }
                    // End:0x356
                    break;
                // End:0x2BF
                case 3:
                    // End:0x261
                    if(PlayerPlaces[SlotIdx].bMuted)
                    {
                        GetPC().GameplayUnmutePlayer(PlayerPlaces[SlotIdx].PRI.UniqueId);                        
                    }
                    else
                    {
                        GetPC().GameplayMutePlayer(PlayerPlaces[SlotIdx].PRI.UniqueId);
                    }
                    // End:0x356
                    break;
                // End:0xFFFF
                default:
                    // End:0x353
                    if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
                    {
                        ShowGamerCardFor(PlayerPlaces[SlotIdx].PRI, GetLP().ControllerId);
                    }
                    // End:0x356
                    break;
                    break;
            }
        }
    }
    //return;    
}

function bool OnVoteKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0xA7
    if((PlayerPlaces[CurrentSelectedPlayerSlot].PRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        VoteKickPlayerSubmit(PlayerPlaces[CurrentSelectedPlayerSlot].PRI, AdvPRI(GetPC().PlayerReplicationInfo));
        PlayCloseAnimation();
    }
    return true;
    //return ReturnValue;    
}

function OnPlayerFocus(int SlotIdx)
{
    // End:0x3D
    if(SlotIdx < NumPlayers)
    {
        CurrentSelectedSlot = SlotIdx;
        FooterUpdate(CurrentSelectedSlot);
    }
    //return;    
}

static function bool CanOpenPlayerCardFor(AdvPRI PRI, int ControllerId)
{
    local UniqueNetId ZeroId;

    return PRI.UniqueId != ZeroId && (PRI == none) || !PRI.bIsGuest;
    //return ReturnValue;    
}

static function ShowGamerCardFor(AdvPRI PRI, int ControllerId)
{
    local OnlineSubsystem OnlineSubs;
    local OnlinePlayerInterfaceEx PlayerIntEx;

    // End:0xFD
    if(Class'AdvGFxUI_Menu_PartyMenu'.static.CanOpenPlayerCardFor(PRI, ControllerId))
    {
        OnlineSubs = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0xFD
        if(OnlineSubs != none)
        {
            PlayerIntEx = OnlineSubs.PlayerInterfaceEx;
            // End:0xFD
            if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
            {
                PlayerIntEx.ShowGamerCardUI(byte(ControllerId), PRI.UniqueId);
            }
        }
    }
    //return;    
}

function ShowFriendsUI()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xD4
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xD4
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            ControllerId = GetLP().ControllerId;
            PlayerInt.ShowFriendsUI(byte(ControllerId));
        }
    }
    //return;    
}

function bool IsSessionFull()
{
    local OnlineGameSettings GameSettings;
    local WorldInfo WI;
    local int HumanCount, PRIIndex;

    // End:0x234
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0xE5
        if(GameSettings == none)
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
        }
        // End:0x234
        if(GameSettings != none)
        {
            WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
            // End:0x234
            if(WI != none)
            {
                PRIIndex = 0;
                J0x137:

                // End:0x1EA [Loop If]
                if(PRIIndex < WI.GRI.PRIArray.Length)
                {
                    // End:0x1DC
                    if(!WI.GRI.PRIArray[PRIIndex].bBot)
                    {
                        HumanCount++;
                    }
                    PRIIndex++;
                    // [Loop Continue]
                    goto J0x137;
                }
                return (GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections) <= HumanCount;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

final function bool CanInviteLivePartyPlayers()
{
    local LocalPlayer LP;
    local bool bCanMassInviteLiveParty;

    bCanMassInviteLiveParty = false;
    LP = GetLP();
    // End:0xD7
    if(((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none)))
    {
        bCanMassInviteLiveParty = OnlineSub.PartyChatInterface.IsInPartyChat(byte(LP.ControllerId));
    }
    return bCanMassInviteLiveParty && !IsSessionFull();
    //return ReturnValue;    
}

final function InviteLivePartyPlayers()
{
    local LocalPlayer LP;

    LP = GetLP();
    // End:0xCF
    if((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PartyChatInterface, OnlinePartyChatInterface(none))) && CanInviteLivePartyPlayers())
    {
        OnlineSub.PartyChatInterface.ShowPartyUI(byte(LP.ControllerId));
    }
    //return;    
}

function AdvPRI GetSlotPRI(int SlotIdx)
{
    // End:0x37
    if(SlotIdx < 16)
    {
        return PlayerPlaces[SlotIdx].PRI;
    }
    return none;
    //return ReturnValue;    
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

function SetSlotVisible(int SlotIdx, bool bVisible)
{
    // End:0xA5
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].Btn.SetBool("visible", bVisible);
        PlayerPlaces[SlotIdx].MC.SetVisible(bVisible);
    }
    //return;    
}

function SetSlotActive(int SlotIdx, bool bIsActive)
{
    // End:0xAE
    if(SlotIdx < 16)
    {
        // End:0x67
        if(bIsActive)
        {
            PlayerPlaces[SlotIdx].Btn.SetBool("disabled", false);            
        }
        else
        {
            PlayerPlaces[SlotIdx].Btn.SetBool("disabled", true);
        }
    }
    //return;    
}

function SetSlotText(int SlotIdx, string Text)
{
    // End:0x5D
    if(SlotIdx < 16)
    {
        PlayerPlaces[SlotIdx].Btn.SetString("label", Text);
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
    local int I;
    local AdvGRI GRI;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.Tick(DeltaTime);
    // End:0x7D
    if(bForceUpdatePlayerPanel)
    {
        bForceUpdatePlayerPanel = false;
        UpdatePlayersPanel();
    }
    // End:0x1C9
    if(GRI != none)
    {
        // End:0xC3
        if(NumPlayers != GRI.PRIArray.Length)
        {
            UpdatePlayersPanel();
        }
        I = 0;
        J0xCE:

        // End:0x1C9 [Loop If]
        if(I < NumPlayers)
        {
            // End:0x1BB
            if(!PlayerPlaces[I].bMuted)
            {
                // End:0x1A6
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
            goto J0xCE;
        }
    }
    FooterUpdate(CurrentSelectedSlot);
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x145
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        // End:0x145
        if(((int(InputEvent) == int(0)) && ControllerId == GetLP().ControllerId) && Class'Engine.UIInteraction'.static.IsLoggedIn(ControllerId))
        {
            // End:0xD1
            if(ButtonName == 'XboxTypeS_X')
            {
                ShowFriendsUI();
                return true;                
            }
            else
            {
                // End:0x122
                if(ButtonName == 'XboxTypeS_RightShoulder')
                {
                    KickPlayer(GetSlotPRI(CurrentSelectedSlot), GetLP(), OnKick_Confirmed);
                    return true;
                }
            }
            // End:0x145
            if(ButtonName == 'XboxTypeS_Y')
            {
                InviteLivePartyPlayers();
                return true;
            }
        }
    }
    // End:0x18F
    if(Frontend != none)
    {
        return Frontend.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    // End:0x1BE
    if(ControllerId != GetLP().ControllerId)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function FooterUpdate(int SlotIdx)
{
    local array<name> ButtonAliases;
    local AdvPRI CurrentPRI;

    CurrentPRI = GetSlotPRI(SlotIdx);
    // End:0x240
    if((SlotIdx < NumPlayers) && GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ButtonAliases.Length = 0;
        // End:0xD4
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
        {
            ButtonAliases.AddItem('GenericSelect');            
        }
        ButtonAliases.AddItem('GenericBack');        
        // End:0x142
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
        {
            ButtonAliases.AddItem('InviteFriends');            
        }
        // End:0x1B2
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId) && CanKickPlayer(CurrentPRI))
        {
            ButtonAliases.AddItem('KickPlayer');            
        }
        FooterTF.SetBool("html", true);
        FooterTF.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));
        FooterBottomUpdate(SlotIdx);        
    }
    else
    {
        FooterTF.SetBool("visible", false);
        FooterBottomTF.SetBool("visible", false);
        FooterTF.SetString("text", " ");
        FooterBottomTF.SetString("text", " ");
    }
    //return;    
}

function FooterBottomUpdate(int SlotIdx)
{
    local array<name> ButtonAliases;

    // End:0x102
    if(SlotIdx < NumPlayers)
    {
        ButtonAliases.Length = 0;
        // End:0x8A
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId) && CanInviteLivePartyPlayers())
        {
            ButtonAliases.AddItem('InviteParty');            
        }
        FooterBottomTF.SetBool("html", true);
        FooterBottomTF.SetString("htmlText", Class'AdvGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));
    }
    //return;    
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

function OnBack(int ControllerIdx)
{
    PlayCloseAnimation();
    //return;    
}

function OnCloseAnimationComplete()
{
    // End:0x31
    if(Frontend != none)
    {
        Frontend.ClosePartyMenuWindow();        
    }
    else
    {
        // End:0xB8
        if(ParentMenu != none)
        {
            ParentMenu.PlayersMenu = none;
            // End:0xB8
            if(ParentMenu.PlayersWindow != none)
            {
                ParentMenu.PlayersWindow.UpdatePlayersPanel();
            }
        }
        Close();
    }
    //return;    
}

final function bool IsValidPRI(AdvPRI PRI)
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

final function bool PlayerIsMuted(UniqueNetId NetId)
{
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xCB
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0xCB
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            return PlayerInt.IsMuted(byte(GetLP().ControllerId), NetId);
        }
    }
    return false;
    //return ReturnValue;    
}

event OnClose()
{
    super.OnClose();
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

function AdvPRI ResolveUniqueNetID(UniqueNetId TestID)
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

static function AdvGRI GetGRI()
{
    return AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    //return ReturnValue;    
}

static final function bool CanKickPlayer(AdvPRI PRI)
{
    local PlayerController PC;

    // End:0x40
    if(PRI != none)
    {
        PC = PlayerController(PRI.Owner);
    }
    // End:0xEC
    if(((((PC != none) && int(GetGRI().Role) == int(ROLE_Authority)) && GetGRI().IsPrivateCustomGame()) && !PC.IsLocalPlayerController()) && PC.IsPrimaryPlayer())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static final function bool CanVoteKickPlayer(AdvPRI PRI)
{
    local AdvGRI GRI;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0xA4
    if(((GRI != none) && !GRI.IsPrivateCustomGame()) && !GRI.KickVotingInProgress())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static final function KickPlayer(AdvPRI PRI, optional LocalPlayer LP, optional delegate<OnOptionSelected> SelectionCallback = None)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x13F
    if(CanKickPlayer(PRI))
    {
        ButtonAliases.AddItem('AcceptKick');        
        ButtonAliases.AddItem('GenericCancel');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('KickPlayer_Title', "<Strings:ADVGame.MessageBoxStrings.KickPlayer_Title>", "<Strings:ADVGame.MessageBoxStrings.KickPlayer_Msg>", ButtonAliases, SelectionCallback, LP);
    }
    //return;    
}

static final function VoteKickPlayer(AdvPRI PRI, optional LocalPlayer LP, optional delegate<OnOptionSelected> SelectionCallback = None)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x14F
    if(CanVoteKickPlayer(PRI))
    {
        ButtonAliases.AddItem('AcceptKick');        
        ButtonAliases.AddItem('GenericCancel');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('KickPlayerByVoting_Title', "<Strings:ADVGame.MessageBoxStrings.KickPlayerByVoting_Title>", "<Strings:ADVGame.MessageBoxStrings.KickPlayerByVoting_Msg>", ButtonAliases, SelectionCallback, LP);
    }
    //return;    
}

static final function KickPlayerSubmit(AdvPRI PRI)
{
    local AdvPlayerController PC;

    // End:0x11
    if(PRI == none)
    {
        return;
    }
    PC = AdvPlayerController(PRI.Owner);
    // End:0x90
    if(PC != none)
    {
        PC.ClientShowKickedMovie();
        PC.ClientReturnToMainMenu(true);
    }
    //return;    
}

static final function VoteKickPlayerSubmit(AdvPRI ToKick, AdvPRI Caller)
{
    // End:0x48
    if((ToKick != none) && Caller != none)
    {
        Caller.StartKickVoting(ToKick);
    }
    //return;    
}

function bool OnKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPRI CurrPRI;

    CurrPRI = GetSlotPRI(CurrentSelectedSlot);
    // End:0x58
    if((CurrPRI != none) && SelectedInputAlias == 'AcceptKick')
    {
        KickPlayerSubmit(CurrPRI);
    }
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    TitleString="All Players"
    TitlePartyString="Party members"
    MovieInfo=SwfMovie'UI_AdvCommon.AdvBigParty'
    bHideLesserMovies=true
}