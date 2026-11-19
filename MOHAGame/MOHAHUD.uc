class MOHAHUD extends HUD
    transient
    native
    config(Game)
    hidecategories(Navigation);

const DEFAULT_RESOLUTION_SCALE = 1.0f;
const MAX_NPC_BEADS = 40;
const MAX_GRENADE_INDICATORS = 3;
const MAX_HIT_INDICATORS = 8;
const MAX_DEBUG_STRINGS = 500;

enum EToggleWeaponInfoType
{
    GUN_ONLY,                       // 0
    GRENADE_ONLY,                   // 1
    Both,                           // 2
    EToggleWeaponInfoType_MAX       // 3
};

enum EToggleWeaponInfoComplexity
{
    ALL_INFO,                       // 0
    FOLDER_INFO,                    // 1
    GENERAL_INFO,                   // 2
    EToggleWeaponInfoComplexity_MAX // 3
};

enum EHUDRenderGroup
{
    HUD_RENDERGROUP_SHEET,          // 0
    HUD_RENDERGROUP_SHEET_1,        // 1
    HUD_RENDERGROUP_SHEET_2,        // 2
    HUD_RENDERGROUP_TEXT,           // 3
    HUD_RENDERGROUP_TEXT_1,         // 4
    HUD_RENDERGROUP_MISC,           // 5
    HUD_RENDERGROUP_MISC_1,         // 6
    HUD_RENDERGROUP_SCOPE,          // 7
    HUD_RENDERGROUP_BLACK_IMG,      // 8
    HUD_RENDERGROUP_MAX             // 9
};

enum EScreenResolution
{
    SCREEN_RESOLUTION_UNKNOWN,      // 0
    SCREEN_RESOLUTION_640x480,      // 1
    SCREEN_RESOLUTION_480p,         // 2
    SCREEN_RESOLUTION_800x600,      // 3
    SCREEN_RESOLUTION_1024x768,     // 4
    SCREEN_RESOLUTION_1280x720,     // 5
    SCREEN_RESOLUTION_1280x1024,    // 6
    SCREEN_RESOLUTION_1600x1200,    // 7
    SCREEN_RESOLUTION_MAX           // 8
};

enum EHUDRenderMode
{
    HUD_RENDERMODE_DEFAULT,         // 0
    HUD_RENDERMODE_SCOPE,           // 1
    HUD_RENDERMODE_AIRDROP,         // 2
    HUD_RENDERMODE_INTHEPLANE,      // 3
    HUD_RENDERMODE_MAX              // 4
};

struct native DebugString
{
    var string Str;
    var float R;
    var float G;
    var float B;
    var Vector vPos;
    var bool b3D;

    structdefaultproperties
    {
        Str=""
        R=0.0000000
        G=0.0000000
        B=0.0000000
        vPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        b3D=false
    }
};

var config bool bShowOIRDebug;
var bool bDebugShowTitleSafe;
var bool bDebugShowScreenSafe;
var bool bAlwaysDrawPostRender;
var bool DrawHackObjectives;
var bool bHUDPermanentlyDisabled;
var bool bHUDDrawnThisTick;
var int DrawNPCSpawnerType;
var int DrawCCStimulusType;
var int DrawAffordanceAIDType;
var int DrawAffordanceUnitTestType;
var int DrawRangeFinder;
var int DrawDamageHistory;
var int DrawGuardsType;
var MOHAAIPawn MissingTransitionPawn;
var(HUD) config float ResolutionScale_640x480;
var(HUD) config float ResolutionScale_800x600;
var(HUD) config float ResolutionScale_960x720;
var(HUD) config float ResolutionScale_1024x768;
var(HUD) config float ResolutionScale_1280x720;
var(HUD) config float ResolutionScale_1280x1024;
var(HUD) config float ResolutionScale_1600x1200;
var MOHAHUD.EScreenResolution CurrentScreenResolution;
var MOHAHUD.EHUDRenderMode hud_renderMode;
var MOHAHUDImg hud_ammoCountBg;
var MOHAHUDRichText hud_ammoCount;
var MOHAHUDStr hud_grenadeAmmoCount;
var MOHAHUDStr hud_buildname;
var MOHAHUDCursor hud_cursor;
var MOHAHUDImg hud_compass;
var MOHAHUDCompass hud_compassInner;
var MOHAHUDMiniMap hud_compassMiniMap;
var array<MOHAHUDCompassBead> hud_objectiveCompassBeads;
var MOHAHUDCompassBead hud_npcCompassBeads[40];
var int hud_beadCount;
var int lastCanvasResX;
var int lastCanvasResY;
var float resolutionScale;
var MOHAHUDImg hud_grenadeIndicator_main;
var MOHAHUDGrenadeIndicator hud_grenadeIndicator_arrow[3];
var MOHAHUDHitIndicator hud_hitIndicator[8];
var float fHitIndicatorLifetime;
var MOHAHUDHealth hud_health;
var MOHAHUDExpBar hud_weaponExperience;
var MOHAHUDExpBar hud_grenadeExperience;
var MOHAHUDMessageQueue hud_messageQueue;
var MOHAHUDMessageQueue hud_medalMomentQueue;
var MOHAHUD_Letterbox hud_letterBox;
var MOHAHUDImg hud_blackImg;
var MOHAHUDRichText hud_csaText;
var MOHAHUDImg hud_stanceIcon;
var MOHAHUDRichText hud_gameText;
var MOHAHUDRichText hud_TRCMessage;
var MOHAHUDStr hud_stopWatch;
var float fStopWatchExpireTime;
var MOHAHUDImg hud_weaponHitNotify;
var MOHAHUDImg hud_weaponZoomSlider;
var MOHAHUDTrueTriggerMeter hud_trueTriggerMeter;
var array<MOHAHUDObj> hud_objectList;
var array<Actor> PostRenderedActors;
var array<Actor> PostRenderedTripods;
var MOHAPlayerController hud_localPlayerController;
var Vector2D NPCCompassBeadSize;
var Vector2D GrenadeIndicatorArrowSize;
var int GrenadeAmmoCount;
var int AmmoInClip;
var int ReserveAmmo;
var config float inactiveFadeTime;
var float fHudTimeSeconds;
var array<DebugString> debugStrings;
var int debugStrIndex;
var int numPendingStrings;

// Export UMOHAHUD::execDrawHUD(FFrame&, void* const)
native function DrawHUD();

// Export UMOHAHUD::execPauseTick(FFrame&, void* const)
native function PauseTick(float DeltaSeconds);

// Export UMOHAHUD::execUpdateCompassBeads(FFrame&, void* const)
native function UpdateCompassBeads();

// Export UMOHAHUD::execShouldRenderCursor(FFrame&, void* const)
native function bool ShouldRenderCursor(MOHAPlayerPawn Player);

// Export UMOHAHUD::execRemoveHUDObject(FFrame&, void* const)
native function RemoveHUDObject(MOHAHUDObj obj);

// Export UMOHAHUD::execAddHUDObject(FFrame&, void* const)
native function AddHUDObject(MOHAHUDObj obj);

// Export UMOHAHUD::execSortHUDObjects(FFrame&, void* const)
native function SortHUDObjects();

// Export UMOHAHUD::execSetScreenResolution(FFrame&, void* const)
native function SetScreenResolution();

// Export UMOHAHUD::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange();

// Export UMOHAHUD::execIsNewObjectiveMsgActive(FFrame&, void* const)
native function bool IsNewObjectiveMsgActive(EALAObjective obj);

// Export UMOHAHUD::execGetLargeTextFont(FFrame&, void* const)
native function Font GetLargeTextFont();

// Export UMOHAHUD::execGetMediumTextFont(FFrame&, void* const)
native function Font GetMediumTextFont();

// Export UMOHAHUD::execGetSmallTextFont(FFrame&, void* const)
native function Font GetSmallTextFont();

// Export UMOHAHUD::execGetMultiplayerFont(FFrame&, void* const)
native function Font GetMultiplayerFont();

// Export UMOHAHUD::execDrawIcon(FFrame&, void* const)
native simulated function DrawIcon(Texture2D Texture, float X, float Y, float XL, float YL, float U, float V, float UL, float VL);

// Export UMOHAHUD::execDrawColoredIcon(FFrame&, void* const)
native simulated function DrawColoredIcon(Texture2D Texture, float X, float Y, float XL, float YL, float U, float V, float UL, float VL, LinearColor inColor);

// Export UMOHAHUD::execRenderLineCheckDebug(FFrame&, void* const)
native function RenderLineCheckDebug();

exec function TurnOffHUD()
{
    bShowHUD = false;
    bHUDPermanentlyDisabled = true;
    //return;    
}

function ModifyLetterBox(SeqAct_ToggleLetterbox Action)
{
    // End:0x5B
    if(Action.InputLinks[0].bHasImpulse)
    {
        hud_letterBox.SetNewOpeningParams(Action);
        hud_letterBox.ActivateLetterbox(Action.bAnimateBars);        
    }
    else
    {
        // End:0xB6
        if(Action.InputLinks[1].bHasImpulse)
        {
            hud_letterBox.SetNewClosingParams(Action);
            hud_letterBox.DeactivateLetterbox(Action.bAnimateBars);            
        }
        else
        {
            // End:0x15E
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x124
                if(hud_letterBox.bActive)
                {
                    hud_letterBox.SetNewClosingParams(Action);
                    hud_letterBox.DeactivateLetterbox(Action.bAnimateBars);                    
                }
                else
                {
                    hud_letterBox.SetNewOpeningParams(Action);
                    hud_letterBox.ActivateLetterbox(Action.bAnimateBars);
                }
            }
        }
    }
    //return;    
}

function SetHUDStringText(MOHAHUDStr Str, string txt, optional bool bShouldFade = false)
{
    // End:0x3A
    if(Str.Text != txt)
    {
        Str.UpdateStr(Canvas, txt);
    }
    // End:0x73
    if((txt != "") && bShouldFade)
    {
        Str.StartFade(0.0000000, 5.0000000, 3.0000000);
    }
    //return;    
}

function SetHUDRichText(MOHAHUDRichText Str, string txt, optional bool bShouldFade = true)
{
    // End:0x3A
    if(Str.RawText != txt)
    {
        Str.UpdateStr(Canvas, txt);
    }
    // End:0x73
    if((txt != "") && bShouldFade)
    {
        Str.StartFade(0.0000000, 5.0000000, 3.0000000);
    }
    //return;    
}

function SetExtraText(string txt)
{
    SetHUDRichText(hud_gameText, txt);
    //return;    
}

function SetupUIElements()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3A [Loop If]
    if(I < hud_objectList.Length)
    {
        hud_objectList[I].Init();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    hud_health.Setup(0.0300000, 0.9700000);
    hud_health.EnableElement(true);
    hud_stanceIcon.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_stanceIcon.Link(hud_health, 2, 1);
    hud_stanceIcon.JustifyXRight();
    hud_stanceIcon.JustifyYBottom();
    hud_stanceIcon.SetSize(80.0000000, 80.0000000);
    hud_stanceIcon.SetTileUV(448.0000000, 448.0000000);
    hud_stanceIcon.SetTileSizeUV(64.0000000, 64.0000000);
    hud_stanceIcon.SetRelativeOffset(10, 0);
    hud_stanceIcon.EnableElement(false);
    hud_ammoCountBg.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_ammoCountBg.SetPosition(0.9450000, 0.9700000);
    hud_ammoCountBg.SetSize(280.0000000, 32.0000000);
    hud_ammoCountBg.SetTileUV(45.0000000, 0.0000000);
    hud_ammoCountBg.SetTileSizeUV(402.0000000, 64.0000000);
    hud_ammoCountBg.JustifyXRight();
    hud_ammoCountBg.JustifyYBottom();
    hud_ammoCount.Link(hud_ammoCountBg, 0, 0);
    hud_ammoCount.SetRelativeOffset(62, int(-9.5000000));
    hud_ammoCount.SetRenderGroup(6);
    hud_ammoCount.Setup(0.0000000, 0.0000000, GetMediumTextFont());
    hud_ammoCount.EnableElement(true);
    hud_messageQueue.DefaultFont = GetMediumTextFont();
    hud_messageQueue.UpgradeMsgFont = GetMediumTextFont();
    hud_messageQueue.MedalMsgFont = GetMediumTextFont();
    hud_messageQueue.UpdateObjectiveFont(GetMediumTextFont());
    hud_messageQueue.Setup();
    hud_messageQueue.SetRenderInMode(3);
    hud_medalMomentQueue.DefaultFont = GetMediumTextFont();
    hud_medalMomentQueue.MedalMsgFont = GetMediumTextFont();
    hud_medalMomentQueue.Setup();
    hud_grenadeAmmoCount.Link(hud_ammoCountBg, 0, 0);
    hud_grenadeAmmoCount.SetRelativeOffset(-81, int(-9.5000000));
    hud_grenadeAmmoCount.UpdateFont(GetMediumTextFont());
    hud_grenadeAmmoCount.SetRenderGroup(6);
    hud_weaponExperience.ExperienceLevelBg = new Class'MOHAHUDImg';
    hud_weaponExperience.ExperienceLevelBg.MOHAHUD = self;
    hud_weaponExperience.ExperienceLevelBg.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_weaponExperience.ExperienceLevelBg.SetPosition(0.9600000, 0.9700000);
    hud_weaponExperience.ExperienceLevelBg.Link(hud_weaponExperience, 2, 2);
    hud_weaponExperience.ExperienceLevelBg.SetSize(128.0000000, 320.0000000);
    hud_weaponExperience.ExperienceLevelBg.SetTileUV(0.0000000, 191.0000000);
    hud_weaponExperience.ExperienceLevelBg.SetTileSizeUV(128.0000000, 320.0000000);
    hud_weaponExperience.ExperienceLevelBg.JustifyXRight();
    hud_weaponExperience.ExperienceLevelBg.JustifyYBottom();
    hud_weaponExperience.ExperienceLevelBg.SetRelativeOffset(85, 21);
    hud_weaponExperience.ExperienceLevelBg.currentColor.A = 0;
    hud_weaponExperience.ExperienceLevelBg.EnableElement(false);
    hud_weaponExperience.SetPosition(0.9300000, 0.9100000);
    hud_weaponExperience.JustifyXRight();
    hud_weaponExperience.JustifyYBottom();
    hud_weaponExperience.SetColor(100, 200, 100, byte(255));
    hud_weaponExperience.SetRenderGroup(5);
    hud_weaponExperience.ExperienceLevelIcon = new Class'MOHAHUDImg';
    hud_weaponExperience.ExperienceLevelIcon.MOHAHUD = self;
    hud_weaponExperience.ExperienceLevelIcon.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_weaponExperience.ExperienceLevelIcon.Link(hud_weaponExperience.ExperienceLevelBg, 0, 1);
    hud_weaponExperience.ExperienceLevelIcon.SetSize(64.0000000, 64.0000000);
    hud_weaponExperience.ExperienceLevelIcon.SetTileUV(0.0000000, 128.0000000);
    hud_weaponExperience.ExperienceLevelIcon.SetTileSizeUV(64.0000000, 64.0000000);
    hud_weaponExperience.ExperienceLevelIcon.JustifyXRight();
    hud_weaponExperience.ExperienceLevelIcon.JustifyYTop();
    hud_weaponExperience.ExperienceLevelIcon.SetRelativeOffset(32, 16);
    hud_weaponExperience.ExperienceLevelIcon.currentColor.A = 0;
    hud_weaponExperience.ExperienceLevelIcon.EnableElement(false);
    hud_grenadeExperience.ExperienceLevelBg = new Class'MOHAHUDImg';
    hud_grenadeExperience.ExperienceLevelBg.MOHAHUD = self;
    hud_grenadeExperience.ExperienceLevelBg.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_grenadeExperience.ExperienceLevelBg.Link(hud_grenadeExperience, 2, 2);
    hud_grenadeExperience.ExperienceLevelBg.SetSize(128.0000000, 320.0000000);
    hud_grenadeExperience.ExperienceLevelBg.SetTileUV(0.0000000, 191.0000000);
    hud_grenadeExperience.ExperienceLevelBg.SetTileSizeUV(128.0000000, 320.0000000);
    hud_grenadeExperience.ExperienceLevelBg.JustifyXRight();
    hud_grenadeExperience.ExperienceLevelBg.JustifyYBottom();
    hud_grenadeExperience.ExperienceLevelBg.SetRelativeOffset(90, 21);
    hud_grenadeExperience.ExperienceLevelBg.currentColor.A = 0;
    hud_grenadeExperience.ExperienceLevelBg.EnableElement(false);
    hud_grenadeExperience.SetPosition(0.7950000, 0.9100000);
    hud_grenadeExperience.JustifyXRight();
    hud_grenadeExperience.JustifyYBottom();
    hud_grenadeExperience.bGrenadeExperience = true;
    hud_grenadeExperience.SetColor(100, 200, 100, byte(255));
    hud_grenadeExperience.SetRenderGroup(5);
    hud_grenadeExperience.ExperienceLevelIcon = new Class'MOHAHUDImg';
    hud_grenadeExperience.ExperienceLevelIcon.MOHAHUD = self;
    hud_grenadeExperience.ExperienceLevelIcon.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    hud_grenadeExperience.ExperienceLevelIcon.SetPosition(0.9600000, 0.8000000);
    hud_grenadeExperience.ExperienceLevelIcon.Link(hud_grenadeExperience.ExperienceLevelBg, 0, 1);
    hud_grenadeExperience.ExperienceLevelIcon.SetSize(64.0000000, 64.0000000);
    hud_grenadeExperience.ExperienceLevelIcon.SetTileUV(0.0000000, 128.0000000);
    hud_grenadeExperience.ExperienceLevelIcon.SetTileSizeUV(64.0000000, 64.0000000);
    hud_grenadeExperience.ExperienceLevelIcon.JustifyXRight();
    hud_grenadeExperience.ExperienceLevelIcon.JustifyYTop();
    hud_grenadeExperience.ExperienceLevelIcon.SetRelativeOffset(32, 16);
    hud_grenadeExperience.ExperienceLevelIcon.currentColor.A = 0;
    hud_grenadeExperience.ExperienceLevelIcon.EnableElement(false);
    hud_cursor.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_cursor.SetPosition(0.5000000, 0.5000000);
    hud_cursor.JustifyXCenter();
    hud_cursor.JustifyYCenter();
    hud_cursor.UpdateCursorType(0);
    hud_cursor.SetRenderGroup(0);
    hud_compass.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_compass.Link(hud_health, 1, 1);
    hud_compass.SetSize(200.0000000, 200.0000000);
    hud_compass.SetMinSize(int(float(200) * 0.6500000), int(float(200) * 0.6500000));
    hud_compass.SetTileSizeUV(256.0000000, 256.0000000);
    hud_compass.SetTileUV(0.0000000, 0.0000000);
    hud_compass.JustifyXLeft();
    hud_compass.JustifyYBottom();
    hud_compass.SetRelativeOffset(0, -10);
    hud_compass.SetRenderGroup(0);
    hud_compass.SetRenderInMode(2);
    hud_compassInner.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_compassInner.Link(hud_compass, 0, 0);
    hud_compassInner.SetSize(200.0000000, 200.0000000);
    hud_compassInner.SetMinSize(int(float(200) * 0.6500000), int(float(200) * 0.6500000));
    hud_compassInner.SetTileSizeUV(256.0000000, 256.0000000);
    hud_compassInner.SetTileUV(256.0000000, 0.0000000);
    hud_compassInner.JustifyXCenter();
    hud_compassInner.JustifyYCenter();
    hud_compassInner.SetRenderGroup(0);
    hud_compassInner.SetRenderInMode(2);
    I = 0;
    J0xDE9:

    // End:0xF61 [Loop If]
    if(I < 40)
    {
        hud_npcCompassBeads[I].Init();
        hud_npcCompassBeads[I].UpdateImage(Texture2D'HUD.HUDMultiIcons02');
        hud_npcCompassBeads[I].SetPosition(0.0000000, 0.0000000);
        hud_npcCompassBeads[I].SetSize(NPCCompassBeadSize.X, NPCCompassBeadSize.Y);
        hud_npcCompassBeads[I].SetTileSizeUV(32.0000000, 32.0000000);
        hud_npcCompassBeads[I].JustifyXCenter();
        hud_npcCompassBeads[I].JustifyYCenter();
        hud_npcCompassBeads[I].Link(hud_compass, 0, 0);
        hud_npcCompassBeads[I].EnableElement(hud_compass.bRender);
        hud_npcCompassBeads[I].beadActor = none;
        hud_npcCompassBeads[I].SetRenderInMode(2);
        I++;
        // [Loop Continue]
        goto J0xDE9;
    }
    hud_grenadeIndicator_main.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_grenadeIndicator_main.SetPosition(0.5000000, 0.3700000);
    hud_grenadeIndicator_main.SetSize(64.0000000, 64.0000000);
    hud_grenadeIndicator_main.SetTileSizeUV(64.0000000, 64.0000000);
    hud_grenadeIndicator_main.SetTileUV(320.0000000, 256.0000000);
    hud_grenadeIndicator_main.JustifyXCenter();
    hud_grenadeIndicator_main.JustifyYCenter();
    hud_grenadeIndicator_main.SetMaxAlpha(0.9000000);
    hud_grenadeIndicator_main.EnableElement(false);
    hud_grenadeIndicator_main.SetRenderGroup(0);
    I = 0;
    J0x105B:

    // End:0x11D6 [Loop If]
    if(I < 3)
    {
        hud_grenadeIndicator_arrow[I].UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
        hud_grenadeIndicator_arrow[I].SetPosition(0.0000000, 0.0000000);
        hud_grenadeIndicator_arrow[I].SetSize(GrenadeIndicatorArrowSize.X, GrenadeIndicatorArrowSize.Y);
        hud_grenadeIndicator_arrow[I].SetTileSizeUV(64.0000000, 64.0000000);
        hud_grenadeIndicator_arrow[I].SetTileUV(256.0000000, 256.0000000);
        hud_grenadeIndicator_arrow[I].JustifyXCenter();
        hud_grenadeIndicator_arrow[I].JustifyYCenter();
        hud_grenadeIndicator_arrow[I].Link(hud_grenadeIndicator_main, 0, 0);
        hud_grenadeIndicator_arrow[I].SetMaxAlpha(0.9000000);
        hud_grenadeIndicator_arrow[I].EnableElement(false);
        hud_grenadeIndicator_arrow[I].SetRenderGroup(0);
        I++;
        // [Loop Continue]
        goto J0x105B;
    }
    hud_gameText.Setup(0.5000000, 0.7500000, GetMediumTextFont());
    hud_gameText.EnableElement(false);
    hud_gameText.SetRenderGroup(3);
    hud_gameText.SetRenderInMode(1);
    hud_gameText.SetRenderInMode(2);
    hud_gameText.SetRenderInMode(3);
    hud_TRCMessage.Setup(0.5000000, 0.5000000, GetSmallTextFont());
    hud_TRCMessage.EnableElement(false);
    hud_TRCMessage.SetRenderGroup(3);
    hud_TRCMessage.SetAlwaysRender(true);
    hud_TRCMessage.JustifyXCenter();
    hud_TRCMessage.TextString_Start.SetBounds(0.1000000, 0.9000000, 0.0000000, 1.0000000);
    hud_TRCMessage.TextString_End.SetBounds(0.1000000, 0.9000000, 0.0000000, 1.0000000);
    hud_TRCMessage.SetRenderInMode(1);
    hud_TRCMessage.SetRenderInMode(2);
    hud_TRCMessage.SetRenderInMode(3);
    hud_csaText.Setup(0.5000000, 0.6000000, GetMediumTextFont());
    hud_csaText.SetRenderInMode(1);
    hud_csaText.SetRenderGroup(6);
    hud_stopWatch.SetPosition(0.5000000, 0.3000000);
    hud_stopWatch.JustifyXCenter();
    hud_stopWatch.JustifyYCenter();
    hud_stopWatch.UpdateFont(GetMediumTextFont());
    hud_stopWatch.EnableElement(false);
    hud_stopWatch.SetRenderGroup(3);
    hud_blackImg.UpdateImage(Texture2D'EngineResources.Black');
    hud_blackImg.SetPosition(0.5000000, 0.5000000);
    hud_blackImg.SetSize(1280.0000000, 720.0000000);
    hud_blackImg.SetTileSizeUV(32.0000000, 32.0000000);
    hud_blackImg.JustifyXCenter();
    hud_blackImg.JustifyYCenter();
    // End:0x1513
    if(!WorldInfo.bStartGameInBlack)
    {
        hud_blackImg.EnableElement(false);
    }
    hud_blackImg.SetRenderGroup(8);
    hud_blackImg.SetRenderInMode(3);
    hud_blackImg.SetRenderInMode(2);
    SetupHitIndicator();
    hud_weaponHitNotify.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponHitNotify.SetPosition(0.5000000, 0.5000000);
    hud_weaponHitNotify.SetSize(45.0000000, 45.0000000);
    hud_weaponHitNotify.SetTileSizeUV(96.0000000, 96.0000000);
    hud_weaponHitNotify.SetTileUV(416.0000000, 384.0000000);
    hud_weaponHitNotify.JustifyXCenter();
    hud_weaponHitNotify.JustifyYCenter();
    hud_weaponHitNotify.SetRenderGroup(0);
    hud_weaponHitNotify.EnableElement(false);
    hud_weaponZoomSlider.UpdateImage(Texture2D'HUD.HUD_CompassCombined01');
    hud_weaponZoomSlider.SetPosition(0.5000000, 0.5000000);
    hud_weaponZoomSlider.SetSize(44.0000000, 24.0000000);
    hud_weaponZoomSlider.SetTileSizeUV(44.0000000, 24.0000000);
    hud_weaponZoomSlider.SetTileUV(426.0000000, 339.0000000);
    hud_weaponZoomSlider.JustifyXCenter();
    hud_weaponZoomSlider.JustifyYCenter();
    hud_weaponZoomSlider.SetRenderGroup(6);
    hud_weaponZoomSlider.SetRenderInMode(1);
    hud_weaponZoomSlider.EnableElement(false);
    hud_trueTriggerMeter.Setup(0.0700000, 0.5000000);
    hud_trueTriggerMeter.SetRenderInMode(1);
    //return;    
}

function MOHAHUDObj CreateHUDObject(class<MOHAHUDObj> ObjectClass, optional bool bDontAddToList = false)
{
    local MOHAHUDObj Object;

    Object = new ObjectClass;
    // End:0x3C
    if((Object != none) && !bDontAddToList)
    {
        AddHUDObject(Object);
    }
    return Object;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    local int I;
    local Pawn P;
    local MOHASquad squad;
    local AffordanceNodeVolume vol;
    local MOHAPlayerController localPlayerController;

    super.PostBeginPlay();
    // End:0x3E
    foreach DynamicActors(Class'MOHAPlayerController', localPlayerController)
    {
        // End:0x3D
        if(NetConnection(localPlayerController.Player) == none)
        {
            hud_localPlayerController = localPlayerController;
            // End:0x3E
            break;
        }        
    }    
    hud_health = MOHAHUDHealth(CreateHUDObject(Class'MOHAHUDHealth'));
    hud_stanceIcon = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_weaponExperience = MOHAHUDExpBar(CreateHUDObject(Class'MOHAHUDExpBar'));
    hud_grenadeExperience = MOHAHUDExpBar(CreateHUDObject(Class'MOHAHUDExpBar'));
    hud_messageQueue = MOHAHUDMessageQueue(CreateHUDObject(Class'MOHAHUDMessageQueue'));
    hud_medalMomentQueue = MOHAHUDMessageQueue(CreateHUDObject(Class'MOHAHUDMessageQueue'));
    hud_ammoCountBg = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_ammoCount = MOHAHUDRichText(CreateHUDObject(Class'MOHAHUDRichText'));
    hud_grenadeAmmoCount = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_cursor = MOHAHUDCursor(CreateHUDObject(Class'MOHAHUDCursor'));
    hud_compass = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_compassInner = MOHAHUDCompass(CreateHUDObject(Class'MOHAHUDCompass'));
    hud_grenadeIndicator_main = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_letterBox = MOHAHUD_Letterbox(CreateHUDObject(Class'MOHAHUD_Letterbox'));
    hud_csaText = MOHAHUDRichText(CreateHUDObject(Class'MOHAHUDRichText'));
    hud_gameText = MOHAHUDRichText(CreateHUDObject(Class'MOHAHUDRichText'));
    hud_TRCMessage = MOHAHUDRichText(CreateHUDObject(Class'MOHAHUDRichText'));
    hud_stopWatch = MOHAHUDStr(CreateHUDObject(Class'MOHAHUDStr'));
    hud_weaponHitNotify = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_weaponZoomSlider = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    hud_trueTriggerMeter = MOHAHUDTrueTriggerMeter(CreateHUDObject(Class'MOHAHUDTrueTriggerMeter'));
    I = 0;
    J0x27D:

    // End:0x2B4 [Loop If]
    if(I < 3)
    {
        hud_grenadeIndicator_arrow[I] = MOHAHUDGrenadeIndicator(CreateHUDObject(Class'MOHAHUDGrenadeIndicator', true));
        I++;
        // [Loop Continue]
        goto J0x27D;
    }
    I = 0;
    J0x2BB:

    // End:0x2F2 [Loop If]
    if(I < 40)
    {
        hud_npcCompassBeads[I] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead'));
        I++;
        // [Loop Continue]
        goto J0x2BB;
    }
    I = 0;
    J0x2F9:

    // End:0x330 [Loop If]
    if(I < 8)
    {
        hud_hitIndicator[I] = MOHAHUDHitIndicator(CreateHUDObject(Class'MOHAHUDHitIndicator'));
        I++;
        // [Loop Continue]
        goto J0x2F9;
    }
    hud_blackImg = MOHAHUDImg(CreateHUDObject(Class'MOHAHUDImg'));
    SetupUIElements();
    // End:0x38F
    if(Canvas != none)
    {
        lastCanvasResX = int(Canvas.ClipX);
        lastCanvasResY = int(Canvas.ClipY);        
    }
    else
    {
        lastCanvasResX = 0;
        lastCanvasResY = 0;
    }
    // End:0x3CD
    foreach DynamicActors(Class'Engine.Pawn', P)
    {
        // End:0x3CC
        if(MOHAPawn(P) != none)
        {
            AddPostRenderedActor(P);
        }        
    }    
    // End:0x3EE
    foreach DynamicActors(Class'MOHASquad', squad)
    {
        AddPostRenderedActor(squad);        
    }    
    // End:0x40F
    foreach DynamicActors(Class'EAKynapse.AffordanceNodeVolume', vol)
    {
        AddPostRenderedActor(vol);        
    }    
    DrawHackObjectives = false;
    // End:0x43C
    if(hud_localPlayerController != none)
    {
        ToggleCompass(hud_localPlayerController.bShowCompass);
    }
    //return;    
}

function ClientRestart()
{
    hud_stanceIcon.EnableElement(false);
    //return;    
}

function RemovePostRenderedActor(Actor A)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(I < PostRenderedActors.Length)
    {
        // End:0x3B
        if(PostRenderedActors[I] == A)
        {
            PostRenderedActors[I] = none;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function AddPostRenderedActor(Actor A)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < PostRenderedActors.Length)
    {
        // End:0x2E
        if(PostRenderedActors[I] == A)
        {
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x3F:

    // End:0x7D [Loop If]
    if(I < PostRenderedActors.Length)
    {
        // End:0x73
        if(PostRenderedActors[I] == none)
        {
            PostRenderedActors[I] = A;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x3F;
    }
    PostRenderedActors[PostRenderedActors.Length] = A;
    //return;    
}

event EnableBuildName(bool Enable)
{
    //return;    
}

event PostRender()
{
    local MOHAPlayerController mpc;
    local MOHAMultiplayerController mmpc;

    bHUDDrawnThisTick = false;
    // End:0x58
    if(DrawAffordanceUnitTestType > 0)
    {
        mpc = MOHAPlayerController(PlayerOwner.Pawn.Controller);
        // End:0x58
        if(mpc != none)
        {
            mpc.DrawAffordanceUnitTests(Canvas);
        }
    }
    // End:0x8D
    if(MissingTransitionPawn != none)
    {
        // End:0x8D
        if(MissingTransitionPawn.bLogMissingTransitions)
        {
            MissingTransitionPawn.LogMissingTransitions(Canvas);
        }
    }
    super.PostRender();
    // End:0xA8
    if(!bHUDDrawnThisTick)
    {
        DrawHUD();
    }
    mmpc = MOHAMultiplayerController(PlayerOwner);
    // End:0xF0
    if(mmpc != none)
    {
        // End:0xF0
        if(float(mmpc.MessageLifeTime) > WorldInfo.TimeSeconds)
        {
            DisplayMessageOfTheDay();
        }
    }
    // End:0x11A
    if(hud_letterBox.bActive)
    {
        hud_letterBox.Render(Canvas);
    }
    RenderLineCheckDebug();
    // End:0x144
    if(ShouldDisplayDebug('Sounds'))
    {
        DrawSoundsDebug();
    }
    // End:0x164
    if(ShouldDisplayDebug('SoundSpaces'))
    {
        DrawSoundSpacesDebug();
    }
    //return;    
}

function DisplayMessageOfTheDay()
{
    local float FontDX, FontDY, X, Y;
    local int Alpha;
    local float TimeLeft;

    TimeLeft = float(MOHAMultiplayerController(PlayerOwner).MessageLifeTime) - WorldInfo.TimeSeconds;
    // End:0x45
    if(TimeLeft >= ProgressFadeTime)
    {
        Alpha = 255;        
    }
    else
    {
        Alpha = int((float(255) * TimeLeft) / ProgressFadeTime);
    }
    Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    Canvas.__NFUN_470__("A", FontDX, FontDY);
    X = ((0.5000000 * HudCanvasScale) * float(Canvas.SizeX)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeX));
    Y = ((0.5000000 * HudCanvasScale) * float(Canvas.SizeY)) + (((1.0000000 - HudCanvasScale) / 2.0000000) * float(Canvas.SizeY));
    // End:0x232
    if((WorldInfo.GRI != none) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        Canvas.DrawColor = MOTDColor;
        Canvas.DrawColor.A = byte(Alpha);
        // End:0x232
        if(WorldInfo.GRI.MessageOfTheDay != "")
        {
            Canvas.__NFUN_470__(WorldInfo.GRI.MessageOfTheDay, FontDX, FontDY);
            Canvas.SetPos(X - (FontDX / 2.0000000), Y);
            Canvas.__NFUN_465__(WorldInfo.GRI.MessageOfTheDay);
            Y += FontDY;
        }
    }
    //return;    
}

function DrawSoundsDebug()
{
    local editinline array<editinline AudioComponent> AudioComponents;
    local int I;
    local string drawStr;
    local Font oldFont;
    local Vector ScreenPos, ViewPoint, ViewDir, PawnDir;
    local Rotator ViewRotation;

    oldFont = Canvas.Font;
    Canvas.Font = Font'EngineFonts.TinyFont';
    GetPlayingSounds(AudioComponents);
    PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
    ViewDir = Vector(ViewRotation);
    I = 0;
    J0x68:

    // End:0x15C [Loop If]
    if(I < AudioComponents.Length)
    {
        PawnDir = AudioComponents[I].Location - ViewPoint;
        // End:0xB0
        if((PawnDir Dot ViewDir) < float(0))
        {
            // [Explicit Continue]
            goto J0x152;
        }
        drawStr = "*" @ string(AudioComponents[I].SoundCue);
        ScreenPos = Canvas.Project(AudioComponents[I].Location);
        Canvas.SetDrawColor(100, byte(255), 100);
        Canvas.SetPos(ScreenPos.X, ScreenPos.Y);
        Canvas.__NFUN_465__(drawStr);
        J0x152:

        ++I;
        // [Loop Continue]
        goto J0x68;
    }
    Canvas.Font = oldFont;
    //return;    
}

function DrawSoundSpacesDebug()
{
    local array<TriggerVolume_SoundSpace> ActiveSoundSpaces, LinkedSoundSpaces;
    local string drawStr;
    local Font oldFont;
    local int X, Y, I, J;

    oldFont = Canvas.Font;
    Canvas.Font = Font'EngineFonts.TinyFont';
    Class'Engine.TriggerVolume_SoundSpace'.static.GetActiveSoundSpaces(ActiveSoundSpaces);
    X = int(Canvas.ClipX - float(300));
    Y = 20;
    Canvas.SetDrawColor(50, 50, byte(255));
    drawStr = "Sound Spaces:";
    Canvas.SetPos(float(X), float(Y));
    Canvas.__NFUN_465__(drawStr);
    X += 15;
    Y += 15;
    I = 0;
    J0xDD:

    // End:0x449 [Loop If]
    if(I < ActiveSoundSpaces.Length)
    {
        Canvas.SetDrawColor(50, byte(255), 50);
        drawStr = string(ActiveSoundSpaces[I]);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        X += 15;
        Y += 15;
        drawStr = "AMB:" @ string(ActiveSoundSpaces[I].SoundNodeWave);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        X += 15;
        Y += 15;
        drawStr = "Fade In :" @ string(ActiveSoundSpaces[I].fadeInTimeSeconds);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        Y += 15;
        drawStr = "Fade Out:" @ string(ActiveSoundSpaces[I].fadeOutTimeSeconds);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        X -= 15;
        Y += 15;
        drawStr = "PLG:" @ string(ActiveSoundSpaces[I].PluginChainTemplate);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        Y += 15;
        drawStr = "MIX:" @ string(ActiveSoundSpaces[I].MixSelection);
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        Y += 15;
        Canvas.SetDrawColor(50, 50, byte(255));
        drawStr = "Links:";
        Canvas.SetPos(float(X), float(Y));
        Canvas.__NFUN_465__(drawStr);
        X += 35;
        ActiveSoundSpaces[I].GetLinkedSoundSpaces(LinkedSoundSpaces);
        J = 0;
        J0x3C7:

        // End:0x42D [Loop If]
        if(J < LinkedSoundSpaces.Length)
        {
            drawStr = string(LinkedSoundSpaces[J]);
            Canvas.SetPos(float(X), float(Y));
            Canvas.__NFUN_465__(drawStr);
            Y += 15;
            ++J;
            // [Loop Continue]
            goto J0x3C7;
        }
        X -= 50;
        Y += 15;
        ++I;
        // [Loop Continue]
        goto J0xDD;
    }
    Canvas.Font = oldFont;
    //return;    
}

function DrawActorOverlays()
{
    local int I;
    local Actor A;
    local Vector ViewPoint, ViewDir;
    local Rotator ViewRotation;

    // End:0x0D
    if(!bShowHUD)
    {
        return;
    }
    Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
    PlayerOwner.GetPlayerViewPoint(ViewPoint, ViewRotation);
    ViewDir = Vector(ViewRotation);
    I = 0;
    J0x5C:

    // End:0x104 [Loop If]
    if(I < PostRenderedActors.Length)
    {
        A = PostRenderedActors[I];
        // End:0xFA
        if((A != none) && bAlwaysDrawPostRender || !A.bHidden && A.LastRenderTime > (WorldInfo.TimeSeconds - 1.0000000))
        {
            A.PostRenderFor(PlayerOwner, Canvas, ViewPoint, ViewDir);
        }
        I++;
        // [Loop Continue]
        goto J0x5C;
    }
    I = 0;
    J0x10B:

    // End:0x159 [Loop If]
    if(I < PostRenderedTripods.Length)
    {
        DrawDebugCoordinateSystem(PostRenderedTripods[I].Location, PostRenderedTripods[I].Rotation, 100.0000000);
        I++;
        // [Loop Continue]
        goto J0x10B;
    }
    // End:0x1DD
    if(DrawHackObjectives)
    {
        // End:0x1DD
        if((MOHAGameInfo(WorldInfo.Game) != none) && MOHAGameInfo(WorldInfo.Game).GlobalObjectiveManager != none)
        {
            MOHAGameInfo(WorldInfo.Game).GlobalObjectiveManager.PostRenderFor(PlayerOwner, Canvas, ViewPoint, ViewDir);
        }
    }
    // End:0x1F2
    if(DrawRangeFinder > 0)
    {
        DrawMyRangeFinder();
    }
    // End:0x23C
    if(DrawDamageHistory > 0)
    {
        // End:0x23C
        if(MOHAPlayerPawn(PlayerOwner.Pawn) != none)
        {
            MOHAPlayerPawn(PlayerOwner.Pawn).DrawDamageHistory(Canvas);
        }
    }
    //return;    
}

function DrawMyRangeFinder()
{
    local Actor HitActor;
    local Vector HitLoc, HitNormal, TraceEnd, TraceStart;
    local Rotator ViewRotation;

    PlayerOwner.GetPlayerViewPoint(TraceStart, ViewRotation);
    TraceEnd = Vector(ViewRotation) * 100000.0000000;
    HitActor = Trace(HitLoc, HitNormal, TraceEnd, TraceStart);
    // End:0xE9
    if(HitActor != none)
    {
        Canvas.SetPos(float(Canvas.SizeX / 2), float(Canvas.SizeY / 2));
        Canvas.SetDrawColor(0, byte(255), 0);
        Canvas.__NFUN_465__("" $ string(VSize(HitLoc - TraceStart)));
        DrawDebugSphere(HitLoc, 100.0000000, 16, byte(255), 0, 0);
    }
    //return;    
}

exec function RangeFinder()
{
    // End:0x15
    if(DrawRangeFinder > 0)
    {
        DrawRangeFinder = 0;        
    }
    else
    {
        DrawRangeFinder = 1;
    }
    //return;    
}

exec function DamageHistory()
{
    // End:0x15
    if(DrawDamageHistory > 0)
    {
        DrawDamageHistory = 0;        
    }
    else
    {
        DrawDamageHistory = 1;
    }
    //return;    
}

exec function DrawGuards(bool bOn)
{
    // End:0x15
    if(DrawGuardsType > 0)
    {
        DrawGuardsType = 0;        
    }
    else
    {
        DrawGuardsType = 1;
    }
    //return;    
}

exec function toggleobjectives()
{
    DrawHackObjectives = !DrawHackObjectives;
    //return;    
}

exec function ShowOIRDebug()
{
    bShowOIRDebug = !bShowOIRDebug;
    //return;    
}

exec function DrawSpawner(optional int drawType = 1)
{
    // End:0x1E
    if(DrawNPCSpawnerType == drawType)
    {
        DrawNPCSpawnerType = 0;        
    }
    else
    {
        DrawNPCSpawnerType = drawType;
    }
    //return;    
}

exec function DrawCCStimulus(int drawType)
{
    // End:0x19
    if(DrawCCStimulusType == drawType)
    {
        DrawCCStimulusType = 0;        
    }
    else
    {
        DrawCCStimulusType = drawType;
    }
    //return;    
}

exec function DrawAffordanceAID(int drawType)
{
    // End:0x19
    if(DrawAffordanceAIDType == drawType)
    {
        DrawAffordanceAIDType = 0;        
    }
    else
    {
        DrawAffordanceAIDType = drawType;
    }
    //return;    
}

exec function AffordanceUnitTest()
{
    // End:0x15
    if(DrawAffordanceUnitTestType > 0)
    {
        DrawAffordanceUnitTestType = 0;        
    }
    else
    {
        DrawAffordanceUnitTestType = 1;
    }
    //return;    
}

exec function AUT()
{
    AffordanceUnitTest();
    //return;    
}

exec function ToggleShowHUD()
{
    bShowHUD = !bShowHUD;
    //return;    
}

simulated function Font GetDefaultFont()
{
    // End:0x4D
    if(Canvas != none)
    {
        // End:0x4D
        if((Canvas.SizeX <= 640) && Canvas.SizeY <= 480)
        {
            return Class'Engine.Engine'.static.GetSmallFont();
        }
    }
    return Class'Engine.Engine'.static.GetMediumFont();
    //return ReturnValue;    
}

simulated event SetDefaultFont()
{
    // End:0x24
    if(Canvas != none)
    {
        Canvas.Font = GetDefaultFont();
    }
    //return;    
}

simulated event SetMultiplayerFont()
{
    // End:0x24
    if(Canvas != none)
    {
        Canvas.Font = GetMultiplayerFont();
    }
    //return;    
}

exec function ShowTripod(class<Actor> aClass)
{
    local bool bFound;
    local int I;
    local Actor A;

    // End:0x1B
    if(aClass == none)
    {
        PostRenderedTripods.Remove(0, PostRenderedTripods.Length);        
    }
    else
    {
        // End:0x9C
        foreach AllActors(aClass, A)
        {
            bFound = false;
            I = 0;
            J0x3A:

            // End:0x7E [Loop If]
            if((I < PostRenderedTripods.Length) && !bFound)
            {
                // End:0x74
                if(PostRenderedTripods[I] == A)
                {
                    bFound = true;
                }
                I++;
                // [Loop Continue]
                goto J0x3A;
            }
            // End:0x9B
            if(!bFound)
            {
                PostRenderedTripods[PostRenderedTripods.Length] = A;
            }            
        }        
    }
    //return;    
}

exec function ShowPawnAnimDebug2(class<Pawn> aClass, string StartingPoint)
{
    ShowPawnAnimDebug(aClass);
    AnimDebugStartingPoint = name(StartingPoint);
    //return;    
}

exec function DebugPlayerArms(string StartingPoint)
{
    bShowAnimDebug = !bShowAnimDebug;
    // End:0x39
    if(bShowAnimDebug)
    {
        AnimDebugThis = PlayerOwner.Pawn;
        AnimDebugStartingPoint = name(StartingPoint);
    }
    //return;    
}

exec function ShowPawnAnimDebug(class<Pawn> aClass)
{
    local MOHAPlayerController mpc;
    local MOHAPawn picked;

    mpc = MOHAPlayerController(PlayerOwner.Pawn.Controller);
    // End:0xE1
    if(mpc != none)
    {
        picked = MOHAPawn(mpc.PickerGetCurrent());
        // End:0x8A
        if(picked != none)
        {
            // End:0x8A
            if(mpc.bEditActorPickerPicking)
            {
                bShowAnimDebug = true;
                AnimDebugThis = picked;
                AnimDebugStartingPoint = 'None';
            }
        }
        mpc.bEditActorPickerPicking = !mpc.bEditActorPickerPicking;
        // End:0xE1
        if((picked == none) && bShowAnimDebug)
        {
            bShowAnimDebug = false;
            AnimDebugThis = none;
            mpc.bEditActorPickerPicking = false;
        }
    }
    //return;    
}

function DrawAnimDebug()
{
    local MOHAPlayerPawn PlayerPawn;

    PlayerPawn = MOHAPlayerPawn(AnimDebugThis);
    // End:0x5E
    if((bShowAnimDebug && PlayerPawn != none) && PlayerPawn.FPArms != none)
    {
        PlayerPawn.FPArms.super(MOHAHUD).DrawAnimDebug(Canvas, AnimDebugStartingPoint);
    }
    //return;    
}

exec function OirDebugPicker()
{
    local MOHAPlayerController mpc;
    local MOHAAIPawn picked;

    mpc = MOHAPlayerController(PlayerOwner.Pawn.Controller);
    // End:0xAA
    if(mpc != none)
    {
        // End:0x89
        if(mpc.bEditActorPickerPicking)
        {
            picked = MOHAAIPawn(mpc.PickerGetCurrent());
            // End:0x89
            if(picked != none)
            {
                picked.m_bShowOIRDebug = !picked.m_bShowOIRDebug;
            }
        }
        mpc.bEditActorPickerPicking = !mpc.bEditActorPickerPicking;
    }
    //return;    
}

function DisplayCSA(string csaText, optional bool bForceRender = false)
{
    // End:0x5B
    if(csaText != "")
    {
        hud_csaText.EnableElement(true);
        hud_csaText.UpdateStr(Canvas, csaText);
        hud_csaText.SetAlwaysRender(bForceRender);
    }
    //return;    
}

function RemoveCSA()
{
    hud_csaText.EnableElement(false);
    //return;    
}

event DisplayMessage(string msg, optional float displayTime = 1.0000000, optional float fPosX = 0.5000000, optional float fPosY = 0.7500000, optional bool bAlwaysRender = false)
{
    hud_gameText.EnableElement(true);
    hud_gameText.UpdateStr(Canvas, msg);
    hud_gameText.SetPosition(fPosX, fPosY);
    // End:0xA2
    if(displayTime > 0.0000000)
    {
        hud_gameText.StartFade(0.2500000, displayTime, 0.2500000);        
    }
    else
    {
        hud_gameText.StartFadeIn(0.2500000, 0.0000000);
    }
    hud_gameText.SetAlwaysRender(bAlwaysRender);
    //return;    
}

function RemoveMessage()
{
    hud_gameText.EnableElement(false);
    //return;    
}

event DisplayTRCMessage(string msg, optional float displayTime = 1.0000000, optional float fPosX = 0.5000000, optional float fPosY = 0.7000000)
{
    hud_TRCMessage.EnableElement(true);
    hud_TRCMessage.UpdateStr(Canvas, msg);
    hud_TRCMessage.SetPosition(fPosX, fPosY);
    // End:0x9D
    if(displayTime > 0.0000000)
    {
        hud_TRCMessage.StartFade(0.2500000, displayTime, 0.2500000);        
    }
    else
    {
        hud_TRCMessage.StartFadeIn(0.2500000, 0.0000000);
    }
    //return;    
}

function RemoveTRCMessage()
{
    hud_TRCMessage.EnableElement(false);
    //return;    
}

function SetObjectiveText(string NewText, string newTitle, float fFadeInTime, float fMaxAlphaTime, float fFadeOutTime, optional SoundCue SoundCue = none, optional EALAObjective NewObj = none)
{
    hud_messageQueue.SetObjectiveText(NewText, newTitle, fFadeInTime, fMaxAlphaTime, fFadeOutTime, SoundCue, NewObj);
    //return;    
}

exec function ToggleCompass(bool toggleVal)
{
    local int I;

    hud_compass.ToggleState(toggleVal);
    hud_compassInner.ToggleState(toggleVal);
    I = 0;
    J0x39:

    // End:0x72 [Loop If]
    if(I < hud_objectiveCompassBeads.Length)
    {
        hud_objectiveCompassBeads[I].ToggleState(toggleVal);
        I++;
        // [Loop Continue]
        goto J0x39;
    }
    I = 0;
    J0x79:

    // End:0xC8 [Loop If]
    if(I < 40)
    {
        // End:0xBE
        if(hud_npcCompassBeads[I].beadActor != none)
        {
            hud_npcCompassBeads[I].ToggleState(toggleVal);
        }
        I++;
        // [Loop Continue]
        goto J0x79;
    }
    //return;    
}

function bool IsCompassEnabled()
{
    return hud_compass.IsEnabled();
    //return ReturnValue;    
}

function bool IsCursorDisabledByServer()
{
    return false;
    //return ReturnValue;    
}

event CreateCompassBeadList(array<ObjectiveActorInfo> primaryActorList, array<ObjectiveActorInfo> secondaryActorList)
{
    local int I, iNumBeads;

    iNumBeads = 0;
    I = 0;
    J0x0E:

    // End:0x56 [Loop If]
    if(I < hud_objectiveCompassBeads.Length)
    {
        RemoveHUDObject(hud_objectiveCompassBeads[I]);
        hud_objectiveCompassBeads[I].UnLink();
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    hud_objectiveCompassBeads.Remove(0, hud_objectiveCompassBeads.Length);
    I = 0;
    J0x6A:

    // End:0xCC [Loop If]
    if(I < primaryActorList.Length)
    {
        hud_objectiveCompassBeads[iNumBeads] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead_Obj'));
        InitializeCompassBead_Obj(hud_objectiveCompassBeads[iNumBeads], primaryActorList[I]);
        ++iNumBeads;
        I++;
        // [Loop Continue]
        goto J0x6A;
    }
    I = 0;
    J0xD3:

    // End:0x135 [Loop If]
    if(I < secondaryActorList.Length)
    {
        hud_objectiveCompassBeads[iNumBeads] = MOHAHUDCompassBead(CreateHUDObject(Class'MOHAHUDCompassBead_Obj'));
        InitializeCompassBead_Obj(hud_objectiveCompassBeads[iNumBeads], secondaryActorList[I]);
        ++iNumBeads;
        I++;
        // [Loop Continue]
        goto J0xD3;
    }
    //return;    
}

function InitializeCompassBead_Obj(MOHAHUDCompassBead Bead, ObjectiveActorInfo ActorInfo)
{
    Bead.Init();
    Bead.SetPosition(0.0000000, 0.0000000);
    Bead.UpdateImage(Texture2D'HUD.HUDMultiIcons02');
    Bead.SetColor(byte(255), byte(255), byte(255), byte(255));
    Bead.JustifyXCenter();
    Bead.JustifyYCenter();
    Bead.Link(hud_compass, 0, 0);
    Bead.EnableElement(hud_compass.bRender);
    Bead.SetRenderInMode(2);
    MOHAHUDCompassBead_Obj(Bead).Objective = ActorInfo.Objective;
    Bead.bActive = true;
    Bead.beadActor = ActorInfo.ObjActor;
    //return;    
}

function AddCompassBead(Pawn myPawn)
{
    local int I, beadIndex;
    local MOHAPlayerPawn PlayerPawn;

    // End:0x23
    if((myPawn == none) || myPawn.Health <= 0)
    {
        return;
    }
    PlayerPawn = MOHAPlayerPawn(PlayerOwner.Pawn);
    // End:0x49
    if(PlayerPawn == none)
    {
        return;
    }
    beadIndex = -1;
    I = 0;
    J0x5B:

    // End:0xB3 [Loop If]
    if(I < 40)
    {
        // End:0xA9
        if(hud_npcCompassBeads[I].beadActor == none)
        {
            hud_npcCompassBeads[I].beadActor = myPawn;
            beadIndex = I;
            // [Explicit Break]
            goto J0xB3;
        }
        I++;
        // [Loop Continue]
        goto J0x5B;
    }
    J0xB3:

    // End:0x1B1
    if(beadIndex >= 0)
    {
        hud_beadCount++;
        hud_npcCompassBeads[beadIndex].bActive = true;
        hud_npcCompassBeads[beadIndex].EnableElement(hud_compass.bRender);
        hud_npcCompassBeads[beadIndex].SetSize(NPCCompassBeadSize.X * resolutionScale, NPCCompassBeadSize.Y * resolutionScale, false);
        // End:0x18B
        if(PlayerPawn.IsTeammate(myPawn))
        {
            hud_npcCompassBeads[beadIndex].SetTileUV(192.0000000, 192.0000000);            
        }
        else
        {
            hud_npcCompassBeads[beadIndex].SetTileUV(224.0000000, 192.0000000);
        }        
    }
    //return;    
}

function RemoveCompassBead(Pawn myPawn)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8B [Loop If]
    if(I < 40)
    {
        // End:0x81
        if(hud_npcCompassBeads[I].beadActor == myPawn)
        {
            hud_beadCount--;
            hud_npcCompassBeads[I].beadActor = none;
            hud_npcCompassBeads[I].bActive = false;
            hud_npcCompassBeads[I].EnableElement(false);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function ResetCompassBeads()
{
    local int I;

    hud_beadCount = 0;
    I = 0;
    J0x0E:

    // End:0x6B [Loop If]
    if(I < 40)
    {
        hud_npcCompassBeads[I].beadActor = none;
        hud_npcCompassBeads[I].bActive = false;
        hud_npcCompassBeads[I].EnableElement(false);
        I++;
        // [Loop Continue]
        goto J0x0E;
    }
    //return;    
}

function AddGrenadeIndicator(Actor Grenade, float distToPlayer, float DamageRadius)
{
    local int I;
    local MOHAHUDGrenadeIndicator grenadeInd;

    I = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(I < 3)
    {
        // End:0x4D
        if(hud_grenadeIndicator_arrow[I].GrenadeActor == Grenade)
        {
            hud_grenadeIndicator_arrow[I].distToPlayer = distToPlayer;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x5E:

    // End:0x141 [Loop If]
    if(I < 3)
    {
        // End:0x137
        if(hud_grenadeIndicator_arrow[I].GrenadeActor == none)
        {
            grenadeInd = hud_grenadeIndicator_arrow[I];
            AddHUDObject(grenadeInd);
            grenadeInd.GrenadeActor = Grenade;
            grenadeInd.EnableElement(true);
            grenadeInd.SetSize(GrenadeIndicatorArrowSize.X * resolutionScale, GrenadeIndicatorArrowSize.Y * resolutionScale, false);
            grenadeInd.DamageRadius = DamageRadius;
            grenadeInd.distToPlayer = distToPlayer;
            // [Explicit Break]
            goto J0x141;
        }
        I++;
        // [Loop Continue]
        goto J0x5E;
    }
    J0x141:

    //return;    
}

function RemoveGrenadeIndicator(Actor Grenade)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x82 [Loop If]
    if(I < 3)
    {
        // End:0x78
        if(hud_grenadeIndicator_arrow[I].GrenadeActor == Grenade)
        {
            RemoveHUDObject(hud_grenadeIndicator_arrow[I]);
            hud_grenadeIndicator_arrow[I].GrenadeActor = none;
            hud_grenadeIndicator_arrow[I].EnableElement(false);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function RemoveAllGrenadeIndicators()
{
    local int I;

    hud_grenadeIndicator_main.EnableElement(false);
    I = 0;
    J0x1B:

    // End:0x76 [Loop If]
    if(I < 3)
    {
        RemoveHUDObject(hud_grenadeIndicator_arrow[I]);
        hud_grenadeIndicator_arrow[I].GrenadeActor = none;
        hud_grenadeIndicator_arrow[I].EnableElement(false);
        I++;
        // [Loop Continue]
        goto J0x1B;
    }
    //return;    
}

function SetupHitIndicator()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x36 [Loop If]
    if(I < 8)
    {
        hud_hitIndicator[I].Setup();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function NotifyHitIndicator(Rotator rHitDirection)
{
    local float fDamageYaw;
    local int I, iNextIndex;

    fDamageYaw = float(NormalizeRotAxis(rHitDirection.Yaw));
    iNextIndex = -1;
    // End:0xA2
    if(iNextIndex < 0)
    {
        I = 0;
        J0x3A:

        // End:0xA2 [Loop If]
        if(I < 8)
        {
            // End:0x98
            if(!hud_hitIndicator[I].IsEnabled() || hud_hitIndicator[I].fFadeOutTime < WorldInfo.TimeSeconds)
            {
                iNextIndex = I;
            }
            I++;
            // [Loop Continue]
            goto J0x3A;
        }
    }
    // End:0x10F
    if(iNextIndex < 0)
    {
        I = 0;
        J0xB4:

        // End:0x10F [Loop If]
        if(I < 8)
        {
            // End:0x105
            if((iNextIndex < 0) || hud_hitIndicator[I].fFadeOutTime < hud_hitIndicator[iNextIndex].fFadeOutTime)
            {
                iNextIndex = I;
            }
            I++;
            // [Loop Continue]
            goto J0xB4;
        }
    }
    hud_hitIndicator[iNextIndex].SetDamageYaw(fDamageYaw);
    hud_hitIndicator[iNextIndex].EnableElement(true);
    hud_hitIndicator[iNextIndex].StartFade(0.0000000, 0.0000000, fHitIndicatorLifetime);
    //return;    
}

event ToggleWeaponInfo(bool Enabled, optional float Duration = 3.0000000, optional MOHAHUD.EToggleWeaponInfoType infoType = 2, optional MOHAHUD.EToggleWeaponInfoComplexity complexity = 1)
{
    local float FadeInTime, FadeOutTime, holdTime;

    holdTime = Duration / 3.0000000;
    FadeInTime = ((Enabled) ? 2.0000000 * (Duration / 3.0000000) : 0.0000000);
    FadeOutTime = ((Enabled) ? 0.0000000 : 2.0000000 * (Duration / 3.0000000));
    // End:0x12B
    if((int(infoType) == int(0)) || int(infoType) == int(2))
    {
        hud_weaponExperience.ExperienceLevelBg.EnableElement(true);
        hud_weaponExperience.ExperienceLevelBg.StartFade(FadeInTime, holdTime, FadeOutTime);
        hud_weaponExperience.ExperienceLevelIcon.EnableElement(true);
        hud_weaponExperience.ExperienceLevelIcon.StartFade(FadeInTime, holdTime, FadeOutTime);
    }
    // End:0x1DD
    if((int(infoType) == int(1)) || int(infoType) == int(2))
    {
        hud_grenadeExperience.ExperienceLevelBg.EnableElement(true);
        hud_grenadeExperience.ExperienceLevelBg.StartFade(FadeInTime, holdTime, FadeOutTime);
        hud_grenadeExperience.ExperienceLevelIcon.EnableElement(true);
        hud_grenadeExperience.ExperienceLevelIcon.StartFade(FadeInTime, holdTime, FadeOutTime);
    }
    // End:0x351
    if((int(complexity) == int(0)) || int(complexity) == int(2))
    {
        // End:0x2C3
        if((int(infoType) == int(0)) || int(infoType) == int(2))
        {
            hud_weaponExperience.EnableElement(true);
            hud_weaponExperience.StartFade(FadeInTime, holdTime, FadeOutTime);
            hud_ammoCount.EnableElement(true);
            hud_ammoCount.StartFade(FadeInTime, holdTime, FadeOutTime);
            hud_ammoCountBg.EnableElement(true);
            hud_ammoCountBg.StartFade(FadeInTime, holdTime, FadeOutTime);
        }
        // End:0x351
        if((int(infoType) == int(1)) || int(infoType) == int(2))
        {
            hud_grenadeExperience.EnableElement(true);
            hud_grenadeExperience.StartFade(FadeInTime, holdTime, FadeOutTime);
            hud_grenadeAmmoCount.EnableElement(true);
            hud_grenadeAmmoCount.StartFade(FadeInTime, holdTime, FadeOutTime);
        }
    }
    //return;    
}

function FadeIn(float fDelay, float fFadeTime)
{
    hud_blackImg.EnableElement(true);
    hud_blackImg.StartFadeOut(fFadeTime, fDelay);
    //return;    
}

function FadeOut(float fDelay, float fFadeTime)
{
    hud_blackImg.EnableElement(true);
    hud_blackImg.StartFadeIn(fFadeTime, fDelay);
    //return;    
}

function NotifyStanceChange(MOHAPlayerPawn.EPlayerStance eLastStance, MOHAPlayerPawn.EPlayerStance eNextStance)
{
    // End:0x15
    if(int(eLastStance) == int(eNextStance))
    {
        return;
    }
    // End:0x59
    if(int(eNextStance) == int(1))
    {
        hud_stanceIcon.EnableElement(true);
        hud_stanceIcon.StartFadeIn(0.2500000, 0.0000000);        
    }
    else
    {
        hud_stanceIcon.StartFadeOut(0.2500000, 0.0000000);
    }
    //return;    
}

function DrawDebug3DText(coerce string Text, Vector vPos, optional byte R = byte(255), optional byte G = byte(255), optional byte B = byte(255), optional bool b3D = true)
{
    //return;    
}

protected function DrawDebugGraphs()
{
    local MOHAPlayerController PC;

    PC = MOHAPlayerController(PlayerOwner);
    // End:0x38
    if(PC != none)
    {
        PC.DebugGraphs.RenderGraphs(self);
    }
    //return;    
}

protected function DrawDebugStrings()
{
    local int I;
    local Vector vScreenSpacePos, vViewLoc;
    local Rotator vViewRot;

    // End:0x0D
    if(Canvas == none)
    {
        return;
    }
    I = 0;
    J0x14:

    // End:0x217 [Loop If]
    if(I < numPendingStrings)
    {
        // End:0xA0
        if(debugStrings[I].b3D == false)
        {
            vScreenSpacePos.X = debugStrings[I].vPos.X;
            vScreenSpacePos.Y = debugStrings[I].vPos.Y;            
        }
        else
        {
            PlayerOwner.GetPlayerViewPoint(vViewLoc, vViewRot);
            // End:0xED
            if(((debugStrings[I].vPos - vViewLoc) Dot Vector(vViewRot)) < float(0))
            {
                // [Explicit Continue]
                goto J0x20D;
            }
            vScreenSpacePos = Canvas.Project(debugStrings[I].vPos);
            // End:0x164
            if((vScreenSpacePos.X >= float(Canvas.SizeX)) || vScreenSpacePos.Y >= float(Canvas.SizeY))
            {
                // [Explicit Continue]
                goto J0x20D;
            }
        }
        Canvas.SetPos(vScreenSpacePos.X, vScreenSpacePos.Y);
        Canvas.SetDrawColor(byte(debugStrings[I].R), byte(debugStrings[I].G), byte(debugStrings[I].B));
        Canvas.__NFUN_465__(debugStrings[I].Str,, 300.0000000);
        J0x20D:

        I++;
        // [Loop Continue]
        goto J0x14;
    }
    numPendingStrings = 0;
    debugStrIndex = -1;
    //return;    
}

function SetRenderMode(MOHAHUD.EHUDRenderMode RenderMode)
{
    hud_renderMode = RenderMode;
    //return;    
}

function OnNotifyWeaponHit()
{
    hud_weaponHitNotify.EnableElement(true);
    hud_weaponHitNotify.StartFade(0.0000000, 0.2500000, 0.1000000);
    //return;    
}

defaultproperties
{
    ResolutionScale_640x480=0.6000000
    ResolutionScale_800x600=0.6500000
    ResolutionScale_960x720=0.8000000
    ResolutionScale_1024x768=0.9000000
    ResolutionScale_1280x720=1.0000000
    ResolutionScale_1280x1024=1.1000000
    ResolutionScale_1600x1200=1.5000000
    fHitIndicatorLifetime=2.5000000
    NPCCompassBeadSize=(X=20.0000000,Y=20.0000000)
    GrenadeIndicatorArrowSize=(X=64.0000000,Y=64.0000000)
    debugStrIndex=-1
}