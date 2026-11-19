class MOHAHUD_MP extends MOHAHUD
    transient
    native
    config(Game)
    hidecategories(Navigation);

const MP_MAX_TEAMS = 2;

var const Texture2D MP_HUD_Elements;
var transient int m_TeamIndex;
var const Texture2D BlackTexture;
var transient bool bBlack;
var MOHAHUDScrollText hud_message;
var MOHAHUDStr hud_supertitle;
var MOHAHUDStr hud_subtitle;
var MOHAHUDStr hud_spawn_message;
var MOHAHUDStr hud_game_message;
var TeamInfo hud_CachedTeamInfo[2];
var MOHAHUDImg hud_VoipInner;
var MOHAHUDImg hud_VoipOuter;
var MOHAVoiceChatMenu hud_chatMenu;
var bool bDisplayErrorStrings;
var bool bFadeErrors;
var array<string> sErrorStringArray;
var int iMaxErrorLinesToDisplay;
var int iErrorPulseSeconds;
var int iErrorPulseIncrements;
var const localized string TimeMsg;
var int HUD_FolderU;
var int HUD_FolderV;
var int HUD_FolderUL;
var int HUD_FolderVL;
var float HUD_FolderScale;
var int HUD_AxisBannerU;
var int HUD_AxisBannerV;
var int HUD_BannerUL;
var int HUD_BannerVL;
var int HUD_AlliedBannerU;
var int HUD_AlliedBannerV;
var float HUD_MyTeamSizeScale;
var float HUD_OtherTeamSizeScale;
var int HUD_AlliedFlagU;
var int HUD_AlliedFlagV;
var int HUD_AlliedCircleU;
var int HUD_AlliedCircleV;
var int HUD_NeutralFlagU;
var int HUD_NeutralFlagV;
var int HUD_AxisFlagU;
var int HUD_AxisFlagV;
var int HUD_AxisCircleU;
var int HUD_AxisCircleV;
var float HUD_FlagCircleAlpha;
var int HUD_FlagUL;
var int HUD_FlagVL;
var float HUD_FlagScale;
var int HUD_VoipU;
var int HUD_VoipV;
var int HUD_Voip2U;
var int HUD_Voip2V;
var int HUD_VoipUL;
var int HUD_VoipVL;
var float HUD_VoipScale;
var int HUD_AlliedIconU;
var int HUD_AlliedIconV;
var int HUD_AxisIconU;
var int HUD_AxisIconV;
var int HUD_IconUL;
var int HUD_IconVL;
var float HUD_IconScale;
var float HUD_GapBetweenTimeAndScore;
var float HUD_GapBetweenScoreBanners;
var float HUD_GapFromLeftSideForBanners;
var float HUD_GapFromLeftForTime;
var float HUD_GapFromTopForTime;

// Export UMOHAHUD_MP::execCacheTeamInfoObjects(FFrame&, void* const)
native function CacheTeamInfoObjects();

// Export UMOHAHUD_MP::execUpdateCompassBeads(FFrame&, void* const)
native function UpdateCompassBeads();

// Export UMOHAHUD_MP::execDrawHUD(FFrame&, void* const)
native function DrawHUD();

// Export UMOHAHUD_MP::execFormatTime(FFrame&, void* const)
native function FormatTime(float InSeconds, out string outString, optional bool bShowHours, optional bool bShowMins);

// Export UMOHAHUD_MP::execDrawFlagStatus(FFrame&, void* const)
native function DrawFlagStatus();

function Font GetFontSizeIndex(int FontSize)
{
    // End:0x17
    if(FontSize == 4)
    {
        return GetMultiplayerFont();
    }
    return super(HUD).GetFontSizeIndex(FontSize);
    //return ReturnValue;    
}

function SetbShowScores(bool InbShowScores, optional bool FinalScoreboardOverride)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x61
    if((GRI.RoundStatus == 1) || GRI.RoundStatus == 2)
    {
        // End:0x61
        if(bShowScores)
        {
            // End:0x61
            if(!FinalScoreboardOverride)
            {
                ScriptTrace();
                return;
            }
        }
    }
    super(HUD).SetbShowScores(InbShowScores);
    //return;    
}

exec function ChatMenu()
{
    hud_chatMenu.ShowMenu();
    //return;    
}

exec function ChatInput(int choice)
{
    hud_chatMenu.UserInput(choice);
    //return;    
}

function bool VoiceChatMenuOpen()
{
    return hud_chatMenu.IsMenuOpen();
    //return ReturnValue;    
}

function SetMessageWindowText(string txt, optional float StrongGlowTime = 10.0000000, optional float FadeTime = 3.0000000)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x4C
    if(GRI.ServerOptions.bShowText == false)
    {
        return;
    }
    hud_message.UpdateStr(Canvas, txt);
    // End:0xA8
    if((txt != "") && StrongGlowTime > 0.0000000)
    {
        hud_message.StartFade(0.0000000, StrongGlowTime, FadeTime);
    }
    //return;    
}

simulated function UpdateHudVoip()
{
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x90
    if(((P != none) && P.IsSignedIn()) && P.IsLocalPlayerTalking(0))
    {
        hud_VoipOuter.StartFadeOut(0.2500000, 0.2000000);
        hud_VoipInner.StartFadeOut(0.5000000, 0.5000000);
    }
    //return;    
}

function SetGameText(string txt)
{
    SetHUDStringText(hud_game_message, txt);
    //return;    
}

function SetSpawnText(string txt)
{
    SetHUDStringText(hud_spawn_message, txt);
    //return;    
}

function SetSubtitleText(string txt, optional bool bShouldFade = false)
{
    SetHUDStringText(hud_subtitle, txt, bShouldFade);
    //return;    
}

event SetSupertitleText(string txt, optional bool bShouldFade = false)
{
    SetHUDStringText(hud_supertitle, txt, bShouldFade);
    //return;    
}

function SetTeamIcon(int TeamIndex)
{
    m_TeamIndex = TeamIndex;
    //return;    
}

function SetupUIElements()
{
    local Color fontColorTemp;

    super.SetupUIElements();
    fontColorTemp.R = byte(255);
    fontColorTemp.G = byte(255);
    fontColorTemp.B = byte(255);
    fontColorTemp.A = byte(255);
    hud_chatMenu.SetPosition(0.0300000, 0.3500000);
    hud_chatMenu.SetBounds(0.0300000, 1.0000000, 0.0300000, 1.0000000);
    hud_chatMenu.UpdateFont(GetSmallTextFont());
    hud_chatMenu.JustifyXLeft();
    hud_chatMenu.JustifyYTop();
    hud_chatMenu.SetRenderInMode(2);
    hud_chatMenu.SetRenderInMode(1);
    hud_chatMenu.SetAlwaysRender(true);
    hud_health.SetRenderInMode(2);
    hud_health.SetRenderInMode(1);
    hud_compass.SetRenderInMode(2);
    hud_compassInner.SetRenderInMode(2);
    hud_gameText.SetRenderInMode(1);
    hud_ammoCount.SetRenderInMode(1);
    hud_message.SetPosition(0.0000000, 0.1900000);
    hud_message.SetBounds(0.0000000, 0.4000000, 0.0250000, 0.1900000);
    hud_message.JustifyXLeft();
    hud_message.JustifyYBottom();
    hud_message.SetRenderInMode(2);
    hud_message.SetRenderInMode(1);
    hud_message.UpdateFont(GetMultiplayerFont());
    hud_message.UpdateFontColor(fontColorTemp);
    hud_message.SetAlwaysRender(true);
    hud_game_message.SetPosition(0.5000000, 0.8000000);
    hud_game_message.JustifyXCenter();
    hud_game_message.JustifyYCenter();
    hud_game_message.SetRenderInMode(2);
    hud_game_message.SetRenderInMode(1);
    hud_game_message.UpdateFont(GetMediumTextFont());
    hud_game_message.UpdateFontColor(fontColorTemp);
    hud_game_message.SetAlwaysRender(true);
    hud_spawn_message.SetPosition(0.5000000, 0.8500000);
    hud_spawn_message.JustifyXCenter();
    hud_spawn_message.JustifyYCenter();
    hud_spawn_message.SetRenderInMode(2);
    hud_spawn_message.SetRenderInMode(1);
    hud_spawn_message.UpdateFont(GetMediumTextFont());
    hud_spawn_message.UpdateFontColor(fontColorTemp);
    hud_spawn_message.SetAlwaysRender(true);
    hud_subtitle.SetPosition(0.5000000, 0.9600000);
    hud_subtitle.JustifyXCenter();
    hud_subtitle.JustifyYCenter();
    hud_subtitle.SetRenderInMode(2);
    hud_subtitle.SetRenderInMode(1);
    hud_subtitle.UpdateFont(GetMediumTextFont());
    hud_subtitle.UpdateFontColor(fontColorTemp);
    hud_subtitle.SetAlwaysRender(true);
    hud_supertitle.SetPosition(0.5000000, 0.0400000);
    hud_supertitle.JustifyXCenter();
    hud_supertitle.JustifyYCenter();
    hud_supertitle.SetRenderInMode(2);
    hud_supertitle.SetRenderInMode(1);
    hud_supertitle.UpdateFont(GetMediumTextFont());
    hud_supertitle.UpdateFontColor(fontColorTemp);
    hud_supertitle.SetAlwaysRender(true);
    hud_VoipInner.UpdateImage(MP_HUD_Elements);
    hud_VoipInner.JustifyXRight();
    hud_VoipInner.JustifyYBottom();
    hud_VoipInner.SetPosition(0.9500000, 0.5000000);
    hud_VoipInner.SetSize(float(HUD_VoipUL) * HUD_VoipScale, float(HUD_VoipVL) * HUD_VoipScale);
    hud_VoipInner.SetTileSizeUV(float(HUD_VoipUL), float(HUD_VoipVL));
    hud_VoipInner.SetTileUV(float(HUD_VoipU), float(HUD_VoipV));
    hud_VoipInner.EnableElement(true);
    hud_VoipInner.SetRenderInMode(2);
    hud_VoipInner.SetRenderInMode(1);
    hud_VoipInner.SetAlwaysRender(true);
    hud_VoipInner.StartFadeOut(0.0000000, 0.0000000);
    hud_VoipOuter.UpdateImage(MP_HUD_Elements);
    hud_VoipOuter.JustifyXRight();
    hud_VoipOuter.JustifyYBottom();
    hud_VoipOuter.SetPosition(0.9500000, 0.5000000);
    hud_VoipOuter.SetSize(float(HUD_VoipUL) * HUD_VoipScale, float(HUD_VoipVL) * HUD_VoipScale);
    hud_VoipOuter.SetTileSizeUV(float(HUD_VoipUL), float(HUD_VoipVL));
    hud_VoipOuter.SetTileUV(float(HUD_Voip2U), float(HUD_Voip2V));
    hud_VoipOuter.EnableElement(true);
    hud_VoipOuter.SetRenderInMode(2);
    hud_VoipOuter.SetRenderInMode(1);
    hud_VoipOuter.SetAlwaysRender(true);
    hud_VoipOuter.StartFadeOut(0.0000000, 0.0000000);
    //return;    
}

simulated function string PadWithSpaces(string Text, int Size)
{
    local int I;
    local string PaddedText;

    PaddedText = Text;
    I = Len(PaddedText);
    J0x18:

    // End:0x41 [Loop If]
    if(I < Size)
    {
        PaddedText = " " $ PaddedText;
        I++;
        // [Loop Continue]
        goto J0x18;
    }
    return PaddedText;
    //return ReturnValue;    
}

event DrawHUDSpectator()
{
    //return;    
}

simulated function PostBeginPlay()
{
    local int I;

    hud_message = MOHAHUDScrollText(CreateHUDObject(Class'MOHAHUDScrollText'));
    hud_subtitle = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_supertitle = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_game_message = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_spawn_message = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_VoipInner = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_VoipOuter = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_chatMenu = MOHAVoiceChatMenu(CreateHUDObject(Class'MOHAVoiceChatMenu'));
    super.PostBeginPlay();
    I = 0;
    J0xE5:

    // End:0x11C [Loop If]
    if(I < 40)
    {
        hud_npcCompassBeads[I] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead_MPPlayers', true));
        I++;
        // [Loop Continue]
        goto J0xE5;
    }
    I = 0;
    J0x123:

    // End:0x287 [Loop If]
    if(I < 40)
    {
        hud_npcCompassBeads[I].Init();
        hud_npcCompassBeads[I].UpdateImage(Texture2D'HUD.HUDMultiIcons02');
        hud_npcCompassBeads[I].SetPosition(0.0000000, 0.0000000);
        hud_npcCompassBeads[I].SetSize(20.0000000, 20.0000000);
        hud_npcCompassBeads[I].SetTileSizeUV(32.0000000, 32.0000000);
        hud_npcCompassBeads[I].JustifyXCenter();
        hud_npcCompassBeads[I].JustifyYCenter();
        hud_npcCompassBeads[I].Link(hud_compass, 0, 0);
        hud_npcCompassBeads[I].EnableElement(hud_compass.bRender);
        hud_npcCompassBeads[I].SetRenderInMode(2);
        hud_npcCompassBeads[I].beadActor = none;
        I++;
        // [Loop Continue]
        goto J0x123;
    }
    //return;    
}

function SetBlack(bool inBBlack)
{
    bBlack = inBBlack;
    //return;    
}

function AddErrorStringToBuffer(string errStr)
{
    // End:0x0D
    if(!bDisplayErrorStrings)
    {
        return;
    }
    // End:0x25
    if(sErrorStringArray.Length >= iMaxErrorLinesToDisplay)
    {
        sErrorStringArray.Remove(0, 1);
    }
    sErrorStringArray[sErrorStringArray.Length] = errStr;
    //return;    
}

event DrawHUDErrorBuffer()
{
    local float XL, YL;
    local Color SavedColor;
    local int I;
    local float fAlphaScalar;
    local int iScaledPulseDelta, iErrorAlpha;

    // End:0x0D
    if(!bDisplayErrorStrings)
    {
        return;
    }
    SavedColor = Canvas.DrawColor;
    SetDefaultFont();
    // End:0xA3
    if(bFadeErrors)
    {
        iScaledPulseDelta = int(float(int(float(iErrorPulseIncrements) * WorldInfo.TimeSeconds)) % float(iErrorPulseIncrements * iErrorPulseSeconds));
        fAlphaScalar = float(iScaledPulseDelta) / float(iErrorPulseIncrements * iErrorPulseSeconds);
        iErrorAlpha = 100 + (155 - int(fAlphaScalar * 155.0000000));        
    }
    else
    {
        iErrorAlpha = 255;
    }
    Canvas.SetDrawColor(byte(255), 4, 4, byte(iErrorAlpha));
    I = 0;
    J0xD0:

    // End:0x17D [Loop If]
    if(I < sErrorStringArray.Length)
    {
        Canvas.__NFUN_464__(sErrorStringArray[I], XL, YL);
        Canvas.SetPos((float(Canvas.SizeX) * 0.9500000) - XL, (float(Canvas.SizeY) * 0.0500000) + (float(3 + I) * YL));
        Canvas.__NFUN_465__(sErrorStringArray[I], true);
        I++;
        // [Loop Continue]
        goto J0xD0;
    }
    Canvas.SetDrawColor(SavedColor.R, SavedColor.G, SavedColor.B, SavedColor.A);
    //return;    
}

exec function ShowScoresFromPreGameUI()
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x65
    if(((GRI.RoundStatus == 4) || GRI.RoundStatus == 1) || GRI.RoundStatus == 2)
    {
        ShowScores();
    }
    //return;    
}

event DrawPopups(MOHAMultiplayerController mpc)
{
    local int XPos, YPos;

    // End:0xA0
    if(mpc.m_Popups.Length > 0)
    {
        XPos = Canvas.SizeX - (128 + 50);
        YPos = int(0.2700000 * float(Canvas.SizeY));
        DrawIcon(mpc.m_Popups[0].Image, float(XPos), float(YPos), 128.0000000, 128.0000000, 0.0000000, 0.0000000, 128.0000000, 128.0000000);
    }
    //return;    
}

simulated function SetupHudForITPandDead(bool InITPorDead)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    hud_health.EnableElement(!InITPorDead && GRI.ServerOptions.bShowHealthBar);
    hud_cursor.EnableElement(!InITPorDead && GRI.ServerOptions.bShowCrosshairs);
    hud_ammoCount.EnableElement(!InITPorDead);
    hud_ammoCountBg.EnableElement(!InITPorDead);
    hud_grenadeAmmoCount.EnableElement(!InITPorDead);
    hud_stanceIcon.EnableElement(false);
    ToggleCompass(!InITPorDead && GRI.ServerOptions.bShowCompass);
    //return;    
}

function NotifyStanceChange(MOHAPlayerPawn.EPlayerStance eLastStance, MOHAPlayerPawn.EPlayerStance eNextStance)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x4F
    if(GRI.ServerOptions.bShowStanceIndicator == false)
    {
        hud_stanceIcon.EnableElement(false);        
    }
    else
    {
        super.NotifyStanceChange(eLastStance, eNextStance);
    }
    //return;    
}

function AddGrenadeIndicator(Actor Grenade, float distToPlayer, float DamageRadius)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x4A
    if(GRI.ServerOptions.bShowGrenadeIcon)
    {
        super.AddGrenadeIndicator(Grenade, distToPlayer, DamageRadius);
    }
    //return;    
}

function bool IsCursorDisabledByServer()
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x3A
    if(GRI.ServerOptions.bShowCrosshairs == false)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NotifyHitIndicator(Rotator rHitDirection)
{
    local MOHAGameReplicationInfo GRI;

    GRI = MOHAGameReplicationInfo(WorldInfo.GRI);
    // End:0x3A
    if(GRI.ServerOptions.bShowHitIndicator == false)
    {
        return;
    }
    super.NotifyHitIndicator(rHitDirection);
    //return;    
}

function AddCompassBead(Pawn myPawn)
{
    local int I, beadIndex;

    // End:0x0D
    if(myPawn == none)
    {
        return;
    }
    beadIndex = -1;
    I = 0;
    J0x1F:

    // End:0x77 [Loop If]
    if(I < 40)
    {
        // End:0x6D
        if(hud_npcCompassBeads[I].beadActor == none)
        {
            hud_npcCompassBeads[I].beadActor = myPawn;
            beadIndex = I;
            // [Explicit Break]
            goto J0x77;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    J0x77:

    // End:0x19D
    if(beadIndex >= 0)
    {
        AddHUDObject(hud_npcCompassBeads[beadIndex]);
        hud_npcCompassBeads[beadIndex].bActive = true;
        hud_npcCompassBeads[beadIndex].EnableElement(hud_compass.bRender);
        hud_npcCompassBeads[beadIndex].RenderGroup = 9;
        // End:0x15E
        if(int(PlayerOwner.GetTeamNum()) == int(myPawn.GetTeamNum()))
        {
            MOHAHUDCompassBead_MPPlayers(hud_npcCompassBeads[beadIndex]).bIsSameTeam = true;
            hud_npcCompassBeads[beadIndex].SetTileUV(192.0000000, 192.0000000);            
        }
        else
        {
            MOHAHUDCompassBead_MPPlayers(hud_npcCompassBeads[beadIndex]).bIsSameTeam = false;
            hud_npcCompassBeads[beadIndex].SetTileUV(224.0000000, 192.0000000);
        }
    }
    //return;    
}

simulated function UpdateCompassTeam()
{
    local PlayerController LocalPC;
    local Pawn PC;
    local MOHAMultiplayerPawn mpc;
    local int I;

    I = 0;
    J0x07:

    // End:0x7E [Loop If]
    if(I < 40)
    {
        // End:0x74
        if(hud_npcCompassBeads[I].beadActor != none)
        {
            hud_npcCompassBeads[I].beadActor = none;
            hud_npcCompassBeads[I].bActive = false;
            hud_npcCompassBeads[I].EnableElement(false);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x153
    foreach LocalPlayerControllers(LocalPC)
    {
        // End:0x152
        if(LocalPC != none)
        {
            PC = WorldInfo.PawnList;
            J0xAB:

            // End:0x14F [Loop If]
            if(PC != none)
            {
                mpc = MOHAMultiplayerPawn(PC);
                // End:0x138
                if(mpc != none)
                {
                    // End:0x138
                    if(((LocalPC != PC.Controller) && !mpc.IsInState('Dying')) && PC.PlayerReplicationInfo != LocalPC.PlayerReplicationInfo)
                    {
                        AddCompassBead(mpc);
                    }
                }
                PC = PC.NextPawn;
                // [Loop Continue]
                goto J0xAB;
            }            
            return;
        }        
    }    
    //return;    
}

event UpdateCompassBeadsScript()
{
    local array<ObjectiveActorInfo> primaryActors;
    local bool bRebuildBeadList;
    local int Index;
    local ObjectiveGameReplicationInfo obgri;
    local MPObjective_FLAG mpo_f;

    // End:0x16
    if(!hud_compass.bRender)
    {
        return;
    }
    bRebuildBeadList = false;
    obgri = ObjectiveGameReplicationInfo(WorldInfo.GRI);
    // End:0xD9
    if(obgri != none)
    {
        bRebuildBeadList = obgri.FlagObjectiveArray.Length < (hud_objectiveCompassBeads.Length / 2);
        Index = 0;
        J0x6B:

        // End:0xD9 [Loop If]
        if(Index < obgri.FlagObjectiveArray.Length)
        {
            mpo_f = obgri.FlagObjectiveArray[Index];
            // End:0xCF
            if(mpo_f.HasStateChanged())
            {
                mpo_f.ClearStateUpdate();
                bRebuildBeadList = true;
            }
            Index++;
            // [Loop Continue]
            goto J0x6B;
        }
    }
    // End:0x15B
    if(bRebuildBeadList)
    {
        Index = 0;
        J0xE9:

        // End:0x14C [Loop If]
        if(Index < obgri.FlagObjectiveArray.Length)
        {
            mpo_f = obgri.FlagObjectiveArray[Index];
            primaryActors.Add(1);
            primaryActors[primaryActors.Length - 1].ObjActor = mpo_f;
            Index++;
            // [Loop Continue]
            goto J0xE9;
        }
        CreateCompassBeadList_MP(primaryActors);
    }
    //return;    
}

function CreateCompassBeadList_MP(array<ObjectiveActorInfo> primaryActorList)
{
    local int I, iNumBeads;

    iNumBeads = 0;
    I = 0;
    J0x0E:

    // End:0x3D [Loop If]
    if(I < hud_objectiveCompassBeads.Length)
    {
        RemoveHUDObject(hud_objectiveCompassBeads[I]);
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    hud_objectiveCompassBeads.Remove(0, hud_objectiveCompassBeads.Length);
    I = 0;
    J0x51:

    // End:0x120 [Loop If]
    if(I < primaryActorList.Length)
    {
        // End:0xCD
        if(primaryActorList[I].ObjActor.IsA('MPObjective_FLAG'))
        {
            hud_objectiveCompassBeads[iNumBeads] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead_MPObj_FLAG'));
            InitializeCompassBead_MPObj_FLAG(hud_objectiveCompassBeads[iNumBeads], true, primaryActorList[I]);            
        }
        else
        {
            hud_objectiveCompassBeads[iNumBeads] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead_MPObj'));
            InitializeCompassBead_MPObj(hud_objectiveCompassBeads[iNumBeads], true, primaryActorList[I]);
        }
        ++iNumBeads;
        I++;
        // [Loop Continue]
        goto J0x51;
    }
    //return;    
}

function InitializeCompassBead_MPObj_FLAG(MOHAHUDCompassBead Bead, bool bIsPrimary, ObjectiveActorInfo ActorInfo)
{
    local MPObjective_FLAG MPObj_Flag;

    MPObj_Flag = MPObjective_FLAG(ActorInfo.ObjActor);
    InitializeCompassBead_Obj(Bead, ActorInfo);
    MOHAHUDCompassBead_MPObj_FLAG(Bead).MPObj_Flag = MPObj_Flag;
    Bead.SetRenderInMode(2);
    // End:0x1EE
    if(MPObj_Flag.bRequiresTwoToCapture == true)
    {
        // End:0xF8
        if(((int(MPObj_Flag.m_State) == int(0)) || int(MPObj_Flag.m_State) == int(1)) || int(MPObj_Flag.m_State) == int(4))
        {
            Bead.UpdateImage(MP_HUD_Elements);
            Bead.SetTileUV(64.0000000, 96.0000000);            
        }
        else
        {
            // End:0x164
            if((int(MPObj_Flag.m_State) == int(6)) || int(MPObj_Flag.m_State) == int(5))
            {
                Bead.UpdateImage(MP_HUD_Elements);
                Bead.SetTileUV(0.0000000, 96.0000000);                
            }
            else
            {
                // End:0x1CD
                if((int(MPObj_Flag.m_State) == int(3)) || int(MPObj_Flag.m_State) == int(2))
                {
                    Bead.UpdateImage(MP_HUD_Elements);
                    Bead.SetTileUV(32.0000000, 96.0000000);
                }
            }
        }
        Bead.SetSize(22.0000000, 22.0000000);        
    }
    else
    {
        // End:0x275
        if(((int(MPObj_Flag.m_State) == int(0)) || int(MPObj_Flag.m_State) == int(1)) || int(MPObj_Flag.m_State) == int(4))
        {
            Bead.UpdateImage(MP_HUD_Elements);
            Bead.SetTileUV(64.0000000, 96.0000000);            
        }
        else
        {
            // End:0x2E1
            if((int(MPObj_Flag.m_State) == int(6)) || int(MPObj_Flag.m_State) == int(5))
            {
                Bead.UpdateImage(MP_HUD_Elements);
                Bead.SetTileUV(0.0000000, 96.0000000);                
            }
            else
            {
                // End:0x34A
                if((int(MPObj_Flag.m_State) == int(3)) || int(MPObj_Flag.m_State) == int(2))
                {
                    Bead.UpdateImage(MP_HUD_Elements);
                    Bead.SetTileUV(32.0000000, 96.0000000);
                }
            }
        }
        Bead.SetSize(20.0000000, 20.0000000);
    }
    Bead.SetTileSizeUV(32.0000000, 32.0000000);
    // End:0x40A
    if((((int(MPObj_Flag.m_State) == int(1)) || int(MPObj_Flag.m_State) == int(2)) || int(MPObj_Flag.m_State) == int(4)) || int(MPObj_Flag.m_State) == int(5))
    {
        Bead.StartBlink(1.0000000);        
    }
    else
    {
        Bead.StopBlink();
    }
    //return;    
}

function InitializeCompassBead_MPObj(MOHAHUDCompassBead Bead, bool bIsPrimary, ObjectiveActorInfo ActorInfo)
{
    local MPObjective myMPObj;

    myMPObj = MPObjective(ActorInfo.ObjActor);
    InitializeCompassBead_Obj(Bead, ActorInfo);
    MOHAHUDCompassBead_MPObj(Bead).mpObj = myMPObj;
    // End:0x84
    if(bIsPrimary)
    {
        // End:0x81
        if(int(myMPObj.ObjectiveState) == int(1))
        {
            Bead.StartBlink(1.0000000);
        }        
    }
    else
    {
        // End:0xF2
        if(int(myMPObj.ObjectiveState) == int(1))
        {
            Bead.UpdateImage(Texture2D'MP_UI_Common.Logo_Allied_Blue');
            Bead.SetTileSizeUV(64.0000000, 64.0000000);
            Bead.SetTileUV(0.0000000, 0.0000000);            
        }
        else
        {
            // End:0x15D
            if(int(myMPObj.ObjectiveState) == int(0))
            {
                Bead.UpdateImage(Texture2D'MP_UI_Common.Logo_Axis_Red');
                Bead.SetTileSizeUV(64.0000000, 64.0000000);
                Bead.SetTileUV(0.0000000, 0.0000000);
            }
        }
    }
    //return;    
}

function PlayerOwnerDied()
{
    hud_stanceIcon.EnableElement(false);
    //return;    
}

defaultproperties
{
    MP_HUD_Elements=Texture2D'MP_HUD_Resources.MP_HUDElements02'
    BlackTexture=Texture2D'EngineResources.Black'
    bFadeErrors=true
    iMaxErrorLinesToDisplay=8
    iErrorPulseSeconds=3
    iErrorPulseIncrements=100
    TimeMsg="Time"
    HUD_FolderU=288
    HUD_FolderV=128
    HUD_FolderUL=224
    HUD_FolderVL=384
    HUD_FolderScale=0.6000000
    HUD_AxisBannerV=448
    HUD_BannerUL=192
    HUD_BannerVL=64
    HUD_AlliedBannerV=384
    HUD_MyTeamSizeScale=0.6000000
    HUD_OtherTeamSizeScale=0.4000000
    HUD_AlliedFlagV=256
    HUD_AlliedCircleV=320
    HUD_NeutralFlagU=64
    HUD_NeutralFlagV=256
    HUD_AxisFlagU=128
    HUD_AxisFlagV=256
    HUD_AxisCircleU=128
    HUD_AxisCircleV=320
    HUD_FlagCircleAlpha=0.7500000
    HUD_FlagUL=64
    HUD_FlagVL=64
    HUD_FlagScale=1.0000000
    HUD_VoipU=320
    HUD_Voip2U=192
    HUD_VoipUL=128
    HUD_VoipVL=128
    HUD_VoipScale=0.5000000
    HUD_AlliedIconV=96
    HUD_AxisIconU=32
    HUD_AxisIconV=96
    HUD_IconUL=32
    HUD_IconVL=32
    HUD_IconScale=1.0000000
    HUD_GapBetweenTimeAndScore=5.0000000
    HUD_GapBetweenScoreBanners=5.0000000
    HUD_GapFromLeftSideForBanners=10.0000000
    HUD_GapFromLeftForTime=10.0000000
    HUD_GapFromTopForTime=10.0000000
}