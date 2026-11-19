class MOHAHUDObj extends Object
    native;

const MAX_WEAPON_TYPE_SP = 25;
const MAX_SP_MISSIONS = 7;
const MAX_SP_MEDALS = 6;
const MAX_HUD_NOTIFICATIONS = 8;
const NUM_MP_MAPS = 6;
const NUM_MP_AWARDS = 19;
const NUM_WEAPON_CLASSES = 7;
const MAX_RIVALS = 8;
const NUM_WEAPON_EXP_LEVELS = 3;
const NUM_MP_MEDALS = 15;
const NUM_MP_WEAPON_UPGRADES = 4;
const MAX_MISSION_SKILL_DROPS = 5;
const MAX_UPGRADEABLE_WEAPONS_SP = 16;
const NUM_XBLACH_UPGRADED_WEAPONS = 5;
const NUM_KILL_TIMES_TO_TRACK = 5;
const NUM_CONSECUTIVE_HEADSHOT_XBLACH = 10;
const MAX_DIFFICULTIES = 3;
const MAX_HUD_RENDERMODES = 4;
const MAX_SP_CHEAT_FLAGS = 7;
const WIDESCREEN_ASPECT_RATIO = 1.7777f;
const WIDESCREEN_INVERSE_ASPECT_RATIO = 0.5625f;
const MAX_HEALTH_DROPPED_PICKUPS = 1;
const MAX_HEALTH_DROPPED_PICKUPS_MP = 10;

enum EJustifyX
{
    EJX_L,                          // 0
    EJX_C,                          // 1
    EJX_R,                          // 2
    EJX_NA,                         // 3
    EJX_MAX                         // 4
};

enum EJustifyY
{
    EJY_T,                          // 0
    EJY_C,                          // 1
    EJY_B,                          // 2
    EJY_NA,                         // 3
    EJY_MAX                         // 4
};

enum ELinkAlignHorz
{
    LINK_ALIGN_HORZ_CENTER,         // 0
    LINK_ALIGN_HORZ_LEFT,           // 1
    LINK_ALIGN_HORZ_RIGHT,          // 2
    LINK_ALIGN_HORZ_MAX             // 3
};

enum ELinkAlignVert
{
    LINK_ALIGN_VERT_CENTER,         // 0
    LINK_ALIGN_VERT_TOP,            // 1
    LINK_ALIGN_VERT_BOTTOM,         // 2
    LINK_ALIGN_VERT_MAX             // 3
};

var float screenSafeZoneHorizPerc;
var float screenSafeZoneVertPerc;
var float screenSafeOffsetHorizPerc;
var float screenSafeOffsetVertPerc;
var float normalizedPosX;
var float normalizedPosY;
var int PosX;
var int PosY;
var MOHAHUDObj.EJustifyX justifyX;
var MOHAHUDObj.EJustifyY justifyY;
var MOHAHUDObj.ELinkAlignHorz linkAlignHorz;
var MOHAHUDObj.ELinkAlignVert linkAlignVert;
var Color currentColor;
var bool bFadeOut;
var bool bRender;
var bool bRenderAlways;
var bool bIsBlinking;
var float fMaxAlpha;
var float fStartTime;
var float fFadeInTime;
var float fMaxAlphaTime;
var float fFadeOutTime;
var int RenderInMode[4];
var int RenderGroup;
var float fBlinkAlphaMult;
var float fCurrentBlinkTime;
var float fBlinkFreq;
var float Rotation;
var int baseSizeX;
var int baseSizeY;
var int SizeX;
var int SizeY;
var int minSizeX;
var int minSizeY;
var int maxSizeX;
var int maxSizeY;
var MOHAHUDObj parentObject;
var array<MOHAHUDObj> childrenObjects;
var int relativeOffsetX;
var int relativeOffsetY;
var int baseRelativeOffsetX;
var int baseRelativeOffsetY;
var MOHAHUD MOHAHUD;

// Export UMOHAHUDObj::execInit(FFrame&, void* const)
native function Init();

// Export UMOHAHUDObj::execSetPosition(FFrame&, void* const)
native function SetPosition(float normalizedX, float normalizedY);

// Export UMOHAHUDObj::execSetSize(FFrame&, void* const)
native function SetSize(float X, float Y, optional bool Base);

// Export UMOHAHUDObj::execSetColor(FFrame&, void* const)
native function SetColor(byte R, byte G, byte B, byte A);

// Export UMOHAHUDObj::execGetSize(FFrame&, void* const)
native function GetSize(Canvas Canvas, out int xSizePix, out int ySizePix, optional bool bSetSize);

// Export UMOHAHUDObj::execLink(FFrame&, void* const)
native function Link(MOHAHUDObj Parent, MOHAHUDObj.ELinkAlignHorz alignHorz, MOHAHUDObj.ELinkAlignVert alignVert);

// Export UMOHAHUDObj::execUnLink(FFrame&, void* const)
native function UnLink();

// Export UMOHAHUDObj::execUpdatePos(FFrame&, void* const)
native function UpdatePos();

// Export UMOHAHUDObj::execGetTopLeft(FFrame&, void* const)
native function GetTopLeft(out int posPixX, out int posPixY);

// Export UMOHAHUDObj::execGetAlignmentPos(FFrame&, void* const)
native function GetAlignmentPos(out int posPixX, out int posPixY);

// Export UMOHAHUDObj::execEnableElement(FFrame&, void* const)
native function EnableElement(bool new_bRender);

// Export UMOHAHUDObj::execIsEnabled(FFrame&, void* const)
native function bool IsEnabled();

// Export UMOHAHUDObj::execUpdateAlpha(FFrame&, void* const)
native function UpdateAlpha();

// Export UMOHAHUDObj::execStartFade(FFrame&, void* const)
native function StartFade(float new_fFadeInTime, float new_fMaxAlpha, float new_fFadeOutTime);

// Export UMOHAHUDObj::execStartFadeIn(FFrame&, void* const)
native function StartFadeIn(float new_fFadeInTime, float fFadeInDelay);

// Export UMOHAHUDObj::execStartFadeOut(FFrame&, void* const)
native function StartFadeOut(float new_fFadeOutTime, float fFadeOutDelay);

// Export UMOHAHUDObj::execRender(FFrame&, void* const)
native function bool Render(Canvas Canvas);

// Export UMOHAHUDObj::execStartBlink(FFrame&, void* const)
native function StartBlink(float fFreq);

// Export UMOHAHUDObj::execStopBlink(FFrame&, void* const)
native function StopBlink();

// Export UMOHAHUDObj::execIsBlinking(FFrame&, void* const)
native function bool IsBlinking();

// Export UMOHAHUDObj::execShouldRender(FFrame&, void* const)
native function bool ShouldRender();

// Export UMOHAHUDObj::execSetRenderGroup(FFrame&, void* const)
native function SetRenderGroup(int iRenderGroup);

// Export UMOHAHUDObj::execSetRelativeOffset(FFrame&, void* const)
native function SetRelativeOffset(int X, int Y, optional bool Base);

// Export UMOHAHUDObj::execOnResolutionChange(FFrame&, void* const)
native function OnResolutionChange(float resolutionScale);

// Export UMOHAHUDObj::execSetMinSize(FFrame&, void* const)
native function SetMinSize(int X, int Y);

// Export UMOHAHUDObj::execSetMaxSize(FFrame&, void* const)
native function SetMaxSize(int X, int Y);

// Export UMOHAHUDObj::execSetRenderInMode(FFrame&, void* const)
native function SetRenderInMode(MOHAHUD.EHUDRenderMode RenderMode);

// Export UMOHAHUDObj::execSetAlwaysRender(FFrame&, void* const)
native function SetAlwaysRender(bool bShouldRender);

function DisableFade()
{
    bFadeOut = false;
    //return;    
}

event SetMaxAlpha(float new_fMaxAlpha)
{
    fMaxAlpha = new_fMaxAlpha;
    currentColor.A = byte(new_fMaxAlpha);
    //return;    
}

event JustifyXHelper(MOHAHUDObj.EJustifyX new_justify)
{
    justifyX = new_justify;
    //return;    
}

event JustifyXLeft()
{
    JustifyXHelper(0);
    //return;    
}

event JustifyXCenter()
{
    JustifyXHelper(1);
    //return;    
}

event JustifyXRight()
{
    JustifyXHelper(2);
    //return;    
}

event JustifyYHelper(MOHAHUDObj.EJustifyY new_justify)
{
    justifyY = new_justify;
    //return;    
}

event JustifyYTop()
{
    JustifyYHelper(0);
    //return;    
}

event JustifyYCenter()
{
    JustifyYHelper(1);
    //return;    
}

event JustifyYBottom()
{
    JustifyYHelper(2);
    //return;    
}

defaultproperties
{
    screenSafeZoneHorizPerc=0.9000000
    screenSafeZoneVertPerc=0.9000000
    screenSafeOffsetHorizPerc=0.0500000
    screenSafeOffsetVertPerc=0.0500000
    currentColor=(R=255,G=255,B=255,A=255)
    fMaxAlpha=1.0000000
    RenderInMode=1
    RenderGroup=1
    fBlinkAlphaMult=1.0000000
}