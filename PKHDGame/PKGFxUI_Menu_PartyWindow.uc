class PKGFxUI_Menu_PartyWindow extends PKGfxMoviePlayer
    config(UI);

struct PlayerPartySlot
{
    var PainPRI PRI;
    var GFxObject MC;
    var GFxObject TF;
    var GFxObject IconTF;
    var GFxObject Speaker;
    var GFxObject Crown;

    structdefaultproperties
    {
        PRI=none
        MC=none
        TF=none
        IconTF=none
        Speaker=none
        Crown=none
    }
};

var PKFrontEnd FrontEnd;
var GFxObject RootMC;
var GFxObject PartyMC;
var GFxObject HeaderTitleMC;
var GFxObject HeaderTitleTF;
var GFxObject FooterMC;
var GFxObject FooterTF;
var array<PlayerPartySlot> PlayerPlaces;
var transient int NumPlayers;
var transient int CurrentMaxSlots;
var transient PKTypes.EPKPartyType PartyTypeLocalCopy;
var transient bool bRequestedCoopMode;
var transient bool bForcedCoopMode;
var transient bool bForceUpdatePlayerPanel;
var transient bool bForceUpdateTitle;
var const localized string HeaderTitleString;
var const localized string HeaderTitleStringPC;
var const localized string PlayerSlotAvail;
var const localized string PlayerSlotNotSigned;
var const localized string ShowPlayersMenuString;
var const localized string ShowPartyMenuString;
var const localized string ShowFriendsMenuString;
var const localized string PlayerConnectingString;

function bool Start(optional bool StartPaused = false)
{
    local int I;
    local PlayerPartySlot PlayerSlot;

    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    PartyMC = RootMC.GetObject("party");
    HeaderTitleMC = RootMC.GetObject("title");
    HeaderTitleTF = HeaderTitleMC.GetObject("textField");
    FooterMC = PartyMC.GetObject("nextmenu");
    FooterTF = FooterMC.GetObject("textField");
    I = 0;
    J0x14F:

    // End:0x339 [Loop If]
    if(I < 8)
    {
        PlayerSlot.MC = PartyMC.GetObject("slot" $ string(I + 1));
        PlayerSlot.TF = PlayerSlot.MC.GetObject("textField");
        PlayerSlot.Crown = PlayerSlot.MC.GetObject("crown");
        PlayerSlot.Speaker = PlayerSlot.MC.GetObject("speaker");
        PlayerSlot.IconTF = PlayerSlot.MC.GetObject("tfIcon");
        PlayerPlaces.AddItem(PlayerSlot);
        I++;
        // [Loop Continue]
        goto J0x14F;
    }
    HeaderTitleTF.SetText(HeaderTitleString);
    FooterTF.SetText(" ");
    UpdatePartyCoopMode();
    UpdatePlayersPanel();
    UpdateTitle();
    TrackChat(true);
    return true;
    //return ReturnValue;    
}

function string GetPartyFormattedPlayerName(PainPRI PRI)
{
    local PKPartyPC TempPC;
    local UniqueNetId ZeroId;

    TempPC = PKPartyPC(PRI.Owner);
    // End:0xC2
    if((((TempPC != none) && int(TempPC.Role) == int(ROLE_Authority)) && TempPC.IsLocalPlayerController()) && !TempPC.bSignedIn)
    {
        return PlayerSlotNotSigned;        
    }
    else
    {
        // End:0xFF
        if(PRI.UniqueId == ZeroId)
        {
            return PlayerConnectingString;
        }
    }
    return PRI.PlayerName;
    //return ReturnValue;    
}

function UpdatePlayersPanel()
{
    local PainGRI GRI;
    local int I;

    I = 0;
    J0x0B:

    // End:0xB3 [Loop If]
    if(I < CurrentMaxSlots)
    {
        SetSlotPRI(I, none);
        SetSlotActive(I, false);
        SetSlotText(I, PlayerSlotAvail);
        SetSlotSpeaker(I, false);
        SetSlotCrown(I, false);
        SetSlotIconTF(I, " ");
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x4CF
    if(GRI != none)
    {
        NumPlayers = 0;
        I = 0;
        J0x11F:

        // End:0x4CC [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x4BE
            if(IsValidPRI(PainPRI(GRI.PRIArray[I])))
            {
                SetSlotPRI(NumPlayers, PainPRI(GRI.PRIArray[I]));
                SetSlotActive(NumPlayers, true);
                SetSlotText(NumPlayers, GetPartyFormattedPlayerName(PainPRI(GRI.PRIArray[I])));
                // End:0x2CA
                if(GRI.PRIArray[I].UniqueId == PainPRI(GetPC().PlayerReplicationInfo).PartyOwnerUniqueId)
                {
                    SetSlotCrown(NumPlayers, true);
                }
                // End:0x329
                if(PlayerIsMuted(GRI.PRIArray[I].UniqueId))
                {
                    SetSlotSpeaker(NumPlayers, true, true);
                }
                // End:0x4B3
                if((GetPC().WorldInfo.IsConsoleBuild(1) && PlayerController(GRI.PRIArray[I].Owner) != none) && LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player) != none)
                {
                    SetSlotIconTF(NumPlayers, GetControllerIcon(LocalPlayer(PlayerController(GRI.PRIArray[I].Owner).Player).ControllerId));
                }
                NumPlayers++;
            }
            I++;
            // [Loop Continue]
            goto J0x11F;
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
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x3DF
    if(GetPC().WorldInfo.IsConsoleBuild(1) && GRI != none)
    {
        PartyTypeLocalCopy = GRI.CurrentPartyType;
        HeaderTitleTF.SetBool("html", true);
        // End:0x1C6
        if((FrontEnd != none) && FrontEnd.CurrentScene.bCanOpenChangePartyType)
        {
            HeaderTitleTF.SetString("htmlText", ((Localize("ControllerFont_XBOX", "Controller_Back", "PKHDGame")) @ HeaderTitleString) @ Class'PKGFxUI_Menu_PartyType'.default.PartyTypeString[int(PartyTypeLocalCopy)]);            
        }
        else
        {
            // End:0x23C
            if(int(PartyTypeLocalCopy) != int(2))
            {
                HeaderTitleTF.SetString("htmlText", HeaderTitleString @ Class'PKGFxUI_Menu_PartyType'.default.PartyTypeString[int(PartyTypeLocalCopy)]);                
            }
            else
            {
                HeaderTitleTF.SetString("htmlText", HeaderTitleStringPC);
            }
        }
        FooterTF.SetBool("html", true);
        // End:0x370
        if(FrontEnd != none)
        {
            // End:0x34A
            if(FrontEnd.CurrentScene.bCanOpenPartyMenu)
            {
                FooterTF.SetString("htmlText", (Localize("ControllerFont_XBOX", "Controller_X", "PKHDGame")) @ ShowPartyMenuString);                
            }
            else
            {
                FooterTF.SetText(" ");
            }            
        }
        else
        {
            FooterTF.SetString("htmlText", (Localize("ControllerFont_XBOX", "Controller_X", "PKHDGame")) @ ShowPlayersMenuString);
        }        
    }
    else
    {
        // End:0x43D
        if(GRI != none)
        {
            HeaderTitleTF.SetText(HeaderTitleStringPC);
            FooterTF.SetText(" ");            
        }
        else
        {
            bForceUpdateTitle = true;
        }
    }
    //return;    
}

function UpdatePartyCoopMode()
{
    local PainGRI GRI;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x167
    if(!GetPC().WorldInfo.IsConsoleBuild(0) || (GRI.IsCoopMultiplayerGame() || int(GRI.CurrentPartyType) == int(2)) || (FrontEnd != none) && int(FrontEnd.GetMenuGame().MultiGameModeSelected) == int(5))
    {
        // End:0x159
        if(int(GRI.CurrentPartyType) == int(2))
        {
            bForcedCoopMode = true;
        }
        SetPartyCoopMode_Internal(true);        
    }
    else
    {
        bForcedCoopMode = false;
        // End:0x18D
        if(!bRequestedCoopMode)
        {
            SetPartyCoopMode_Internal(false);
        }
    }
    //return;    
}

function SetPartyCoopMode(bool bIsCoop)
{
    bRequestedCoopMode = bIsCoop;
    bForceUpdatePlayerPanel = true;
    SetPartyCoopMode_Internal(bIsCoop);
    //return;    
}

function SetPartyCoopMode_Internal(bool bIsCoop)
{
    // End:0x50
    if(bIsCoop || bForcedCoopMode)
    {
        CurrentMaxSlots = 2;
        PartyMC.GotoAndStop("coop");        
    }
    else
    {
        CurrentMaxSlots = 8;
        PartyMC.GotoAndStop("multi");
    }
    //return;    
}

function SetSlotPRI(int SlotIdx, PainPRI PRI)
{
    // End:0x47
    if(SlotIdx < CurrentMaxSlots)
    {
        PlayerPlaces[SlotIdx].PRI = PRI;
    }
    //return;    
}

function SetSlotActive(int SlotIdx, bool bIsActive)
{
    // End:0xAE
    if(SlotIdx < CurrentMaxSlots)
    {
        // End:0x6B
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
    // End:0x5D
    if(SlotIdx < CurrentMaxSlots)
    {
        PlayerPlaces[SlotIdx].TF.SetText(Text);
    }
    //return;    
}

function SetSlotCrown(int SlotIdx, bool bVisible)
{
    // End:0xA0
    if(GetPC().WorldInfo.IsConsoleBuild(1) && bVisible)
    {
        // End:0x9D
        if(SlotIdx < CurrentMaxSlots)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(true);
        }        
    }
    else
    {
        // End:0xF4
        if(SlotIdx < CurrentMaxSlots)
        {
            PlayerPlaces[SlotIdx].Crown.SetVisible(false);
        }
    }
    //return;    
}

function SetSlotSpeaker(int SlotIdx, bool bVisible, optional bool bMuted = false)
{
    // End:0xF8
    if(SlotIdx < CurrentMaxSlots)
    {
        // End:0x6E
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
    // End:0xAA
    if(SlotIdx < CurrentMaxSlots)
    {
        PlayerPlaces[SlotIdx].IconTF.SetBool("html", true);
        PlayerPlaces[SlotIdx].IconTF.SetString("htmlText", IconButtonAlias);
    }
    //return;    
}

function Tick(float DeltaTime)
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    // End:0x7D
    if(bForceUpdatePlayerPanel)
    {
        UpdatePlayersPanel();
        bForceUpdatePlayerPanel = false;
    }
    // End:0xA0
    if(bForceUpdateTitle)
    {
        UpdateTitle();
        bForceUpdateTitle = false;
    }
    // End:0x20E
    if(GRI != none)
    {
        // End:0xE6
        if(NumPlayers != GRI.PRIArray.Length)
        {
            UpdatePlayersPanel();
        }
        // End:0x134
        if(int(PartyTypeLocalCopy) != int(GRI.CurrentPartyType))
        {
            UpdatePartyCoopMode();
            UpdatePlayersPanel();
            UpdateTitle();
        }
        I = 0;
        J0x13F:

        // End:0x20E [Loop If]
        if(I < CurrentMaxSlots)
        {
            // End:0x1EB
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
            goto J0x13F;
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
    super(GFxMoviePlayer).OnClose();
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
    HeaderTitleString="Party Type:"
    HeaderTitleStringPC="Local Players"
    PlayerSlotAvail="Player slot empty"
    PlayerSlotNotSigned="Not signed in"
    ShowPlayersMenuString="Show Players"
    ShowPartyMenuString="Show Party"
    ShowFriendsMenuString="Show Friends"
    PlayerConnectingString="Connecting"
    MovieInfo=SwfMovie'PKHD_UI.PKPartyTime'
    bAllowFocus=false
}