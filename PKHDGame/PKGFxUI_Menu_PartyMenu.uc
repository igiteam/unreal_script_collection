class PKGFxUI_Menu_PartyMenu extends PKGFxUI_Menu_Base
    config(UI);

struct PlayerSlot
{
    var PainPRI PRI;
    var GFxObject MC;
    var GFxClikWidget Btn;
    var GFxObject IconTF;
    var GFxObject Speaker;
    var GFxObject Crown;

    structdefaultproperties
    {
        PRI=none
        MC=none
        Btn=none
        IconTF=none
        Speaker=none
        Crown=none
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
var transient bool bForceUpdatePlayerPanel;
var PainGFxUI_PauseMenu ParentMenu;

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

    // End:0x333 [Loop If]
    if(I < 8)
    {
        Slot.MC = ButtonsMC.GetObject("player" $ string(I + 1));
        Slot.Btn = GFxClikWidget(Slot.MC.GetObject("batonix", Class'GFxUI.GFxClikWidget'));
        Slot.Crown = Slot.MC.GetObject("crown");
        Slot.Speaker = Slot.MC.GetObject("speaker");
        Slot.IconTF = Slot.MC.GetObject("textField");
        PlayerPlaces.AddItem(Slot);
        I++;
        // [Loop Continue]
        goto J0x135;
    }
    TitleTF = TitleMC.GetObject("textField");
    TitleTF.SetText(TitleString);
    UpdatePlayersPanel();
    TrackChat(true);
    return true;
    //return ReturnValue;    
}

function UpdatePlayersPanel()
{
    local PainGRI GRI;
    local int I;

    I = 0;
    J0x0B:

    // End:0xAD [Loop If]
    if(I < 8)
    {
        SetSlotActive(I, false);
        SetSlotText(I, Class'PKGFxUI_Menu_PartyWindow'.default.PlayerSlotAvail);
        SetSlotSpeaker(I, false);
        SetSlotCrown(I, false);
        SetSlotIconTF(I, " ");
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    CurrentSelectedSlot = 0;
    PlayerPlaces[CurrentSelectedSlot].Btn.SetBool("focused", true);
    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x51C
    if(GRI != none)
    {
        NumPlayers = 0;
        I = 0;
        J0x16A:

        // End:0x519 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x50B
            if(IsValidPRI(PainPRI(GRI.PRIArray[I])))
            {
                SetSlotPRI(NumPlayers, PainPRI(GRI.PRIArray[I]));
                SetSlotActive(NumPlayers, true);
                SetSlotText(NumPlayers, GRI.PRIArray[I].PlayerName);
                // End:0x317
                if(GRI.PRIArray[I].UniqueId == PainPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId)
                {
                    SetSlotCrown(NumPlayers, true);
                }
                // End:0x376
                if(PlayerIsMuted(GRI.PRIArray[I].UniqueId))
                {
                    SetSlotSpeaker(NumPlayers, true, true);
                }
                // End:0x500
                if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayerController(GRI.PRIArray[I].Owner) != none) && LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player) != none)
                {
                    SetSlotIconTF(NumPlayers, GetControllerIcon(LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player).ControllerId));
                }
                NumPlayers++;
            }
            I++;
            // [Loop Continue]
            goto J0x16A;
        }        
    }
    else
    {
        bForceUpdatePlayerPanel = true;
    }
    FooterUpdate(CurrentSelectedSlot);
    //return;    
}

function OnPlayerSelect(int SlotIdx, int ControllerIdx)
{
    // End:0xAE
    if(SlotIdx < 8)
    {
        // End:0xAE
        if(PlayerPlaces[SlotIdx].PRI != none)
        {
            // End:0xAE
            if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
            {
                ShowGamerCardFor(PlayerPlaces[SlotIdx].PRI);
            }
        }
    }
    //return;    
}

function OnPlayerFocus(int SlotIdx)
{
    // End:0x36
    if(SlotIdx < 8)
    {
        CurrentSelectedSlot = SlotIdx;
        FooterUpdate(CurrentSelectedSlot);
    }
    //return;    
}

function bool CanOpenPlayerCardFor(PainPRI PRI)
{
    local UniqueNetId ZeroId;

    return PRI.UniqueId != ZeroId && (PRI == none) || !PRI.bIsGuest;
    //return ReturnValue;    
}

function ShowGamerCardFor(PainPRI PRI)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;

    // End:0x108
    if(CanOpenPlayerCardFor(PRI))
    {
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x108
        if(OnlineSub != none)
        {
            PlayerIntEx = OnlineSub.PlayerInterfaceEx;
            // End:0x108
            if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
            {
                ControllerId = GetLP().ControllerId;
                PlayerIntEx.ShowGamerCardUI(byte(ControllerId), PRI.UniqueId);
            }
        }
    }
    //return;    
}

function SetSlotPRI(int SlotIdx, PainPRI PRI)
{
    // End:0x40
    if(SlotIdx < 8)
    {
        PlayerPlaces[SlotIdx].PRI = PRI;
    }
    //return;    
}

function SetSlotActive(int SlotIdx, bool bIsActive)
{
    // End:0xAE
    if(SlotIdx < 8)
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
    if(SlotIdx < 8)
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
        if(SlotIdx < 8)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(true);
        }        
    }
    else
    {
        // End:0xE6
        if(SlotIdx < 8)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(false);
        }
    }
    //return;    
}

function SetSlotSpeaker(int SlotIdx, bool bVisible, optional bool bMuted = false)
{
    // End:0xF1
    if(SlotIdx < 8)
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
    if(SlotIdx < 8)
    {
        PlayerPlaces[SlotIdx].IconTF.SetBool("html", true);
        PlayerPlaces[SlotIdx].IconTF.SetString("htmlText", IconButtonAlias);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local int I;
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super.Tick(DeltaTime);
    // End:0x7D
    if(bForceUpdatePlayerPanel)
    {
        UpdatePlayersPanel();
        bForceUpdatePlayerPanel = false;
    }
    // End:0x19D
    if(GRI != none)
    {
        // End:0xC3
        if(NumPlayers != GRI.PRIArray.Length)
        {
            UpdatePlayersPanel();
        }
        I = 0;
        J0xCE:

        // End:0x19D [Loop If]
        if(I < NumPlayers)
        {
            // End:0x17A
            if((PlayerPlaces[I].PRI != none) && Class'PKUIManager'.static.GetChatIconOpacity(PlayerPlaces[I].PRI) > 0.5000000)
            {
                SetSlotSpeaker(I, true);                
            }
            else
            {
                SetSlotSpeaker(I, false);
            }
            I++;
            // [Loop Continue]
            goto J0xCE;
        }
    }
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x4A
    if(FrontEnd != none)
    {
        return FrontEnd.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    // End:0x79
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

    // End:0x115
    if(SlotIdx < 8)
    {
        ButtonAliases.Length = 0;
        // End:0x74
        if(Class'Engine.UIInteraction'.static.IsLoggedIn(GetLP().ControllerId))
        {
            ButtonAliases.AddItem('GenericSelect');
        }
        ButtonAliases.AddItem('GenericBack');
        FooterTF.SetBool("html", true);
        FooterTF.SetString("htmlText", Class'PKGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));
        FooterBottomUpdate(SlotIdx);
    }
    //return;    
}

function FooterBottomUpdate(int SlotIdx)
{
    local array<name> ButtonAliases;

    // End:0x94
    if(SlotIdx < 8)
    {
        ButtonAliases.Length = 0;
        FooterBottomTF.SetBool("html", true);
        FooterBottomTF.SetString("htmlText", Class'PKGFxUI_Menu_Footer'.static.GetStringForFooterUpdateFromArray(ButtonAliases));
    }
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
    if(FrontEnd != none)
    {
        FrontEnd.ClosePartyMenuWindow();        
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

final function bool IsValidPRI(PainPRI PRI)
{
    // End:0x37
    if((PRI != none) && !PRI.bIsInactive)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function bool PlayerIsMuted(UniqueNetId NetId)
{
    local OnlineSubsystem OnlineSub;
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
    local PainPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function PainPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
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
                return PainPRI(GRI.PRIArray[I]);
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
    TitleString="All Players"
    MovieInfo=SwfMovie'PKHD_UI.PKBigParty'
    bHideLesserMovies=true
}