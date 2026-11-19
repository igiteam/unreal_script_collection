class TurokHudAmmoDisplay extends TurokHudElement
    transient
    native;

const AMMO_BLINK_NUM = 6;

enum EBulletType
{
    HUD_BULLET_TYPE_FULL,           // 0
    HUD_BULLET_TYPE_EMPTY,          // 1
    HUD_BULLET_TYPE_MAX             // 2
};

struct native WeaponSwitchInfo
{
    var float fWeaponUVPosX;
    var float fWeaponUVPosY;
    var float fWeaponUVSizeX;
    var float fWeaponUVSizeY;
    var float fFadeOutTime;
    var float fSplineValue;

    structdefaultproperties
    {
        fWeaponUVPosX=0.0000000
        fWeaponUVPosY=0.0000000
        fWeaponUVSizeX=0.0000000
        fWeaponUVSizeY=0.0000000
        fFadeOutTime=0.0000000
        fSplineValue=0.0000000
    }
};

struct native AmmoBlinkInfo
{
    var int StartIndex;
    var int EndIndex;

    structdefaultproperties
    {
        StartIndex=0
        EndIndex=0
    }
};

struct native WeaponDrawInfo
{
    var @NULL CurrentWeapon;
    var @NULL WeaponTexture;
    var bool bHasPrimaryAmmo;
    var int MaxSecondaryAmmo;

    structdefaultproperties
    {
        CurrentWeapon=none
        WeaponTexture=none
        bHasPrimaryAmmo=false
        MaxSecondaryAmmo=0
    }
};

var float SafezoneBufferX;
var float SafezoneBufferY;
var float mLHWidth;
var float mLHHeight;
var float mRHWidth;
var float mRHHeight;
var @NULL AmmoDisplayCorner;
var @NULL AmmoDisplayGradient;
var @NULL AmmoDisplaySecondaryAmmos;
var @NULL AmmoDisplaySecondaryAmmo;
var @NULL AmmoDisplayBlack;
var @NULL WeaponDrawInfoLH;
var @NULL WeaponDrawInfoRH;
var @NULL mAmmoFont;
var float mAmmoTextScale;
var float mXTextScale;
var int RHWeaponFiringMode;
var @NULL AmmoBlinkInfos[6];
var int AmmoBlinkIndex;
var bool bResetBlinkInfo;
var private bool bAllowWeaponIconFadeOut;
var int LastClipAmmoRH;
var int LastClipAmmoLH;
var int LastAltClipAmmo;
var int LastBowAmmoType;
var @NULL mLowAmmoFullColor;
var @NULL mAmmoFullColor;
var @NULL mAmmoEmptyColor;
var @NULL mAmmoFullDrawColor;
var @NULL mAmmoEmptyDrawColor;
var @NULL mWhite;
var @NULL mAmmoFullTextColor;
var @NULL mWeaponProfileColor;
var @NULL mBackgroundColor;
var private @NULL TempColor;
var private @NULL TempColor2;
var private @NULL RightWeaponInfo;
var private @NULL LeftWeaponInfo;
var private @NULL RightSlideSpline;
var private @NULL LeftSlideSpline;
var private float mWeaponSwitchColorMod;
var private float fFlashTextTimeRH;
var private float fFlashTextTimeLH;
var private float fFlashTextTimeAlt;
var private float fFlashTextDuration;

// Export UTurokHudAmmoDisplay::execDrawSwitchWeapon(FFrame&, void* const)
native simulated function DrawSwitchWeapon();

// Export UTurokHudAmmoDisplay::execDrawRH(FFrame&, void* const)
native simulated function DrawRH(int primary_ammo, int secondary_ammo);

// Export UTurokHudAmmoDisplay::execDrawLH(FFrame&, void* const)
native simulated function DrawLH(int primary_ammo);

// Export UTurokHudAmmoDisplay::execDrawArrowHud(FFrame&, void* const)
native simulated function DrawArrowHud(int nonExplodeyAmmo, int explodeyAmmo);

// Export UTurokHudAmmoDisplay::execUpdateNative(FFrame&, void* const)
native simulated function UpdateNative(const int rh_clip_ammo, const int lh_clip_ammo, const int alt_ammo);

// Export UTurokHudAmmoDisplay::execSetWeaponSwitchSpline(FFrame&, void* const)
native simulated function SetWeaponSwitchSpline(out @NULL Spline, float length_seconds);

// Export UTurokHudAmmoDisplay::execIsDrawing(FFrame&, void* const)
native simulated function bool IsDrawing();

// Export UTurokHudAmmoDisplay::execDraw(FFrame&, void* const)
native simulated function Draw();

// Export UTurokHudAmmoDisplay::execSetDryFire(FFrame&, void* const)
native simulated function SetDryFire(@NULL wpn, byte FireModeNum);

// Export UTurokHudAmmoDisplay::execFlashAmmoTextOnPickup(FFrame&, void* const)
native simulated function FlashAmmoTextOnPickup(class<Class> mPickupAmmoClass);

// Export UTurokHudAmmoDisplay::execSetWeaponType(FFrame&, void* const)
native simulated function bool SetWeaponType(@NULL rh_weapon, @NULL lh_weapon);

// Export UTurokHudAmmoDisplay::execSetupWeaponSwitchInfo(FFrame&, void* const)
native simulated function SetupWeaponSwitchInfo(@NULL Weap, out @NULL Info);

// Export UTurokHudAmmoDisplay::execAllowWeaponIconFadeOut(FFrame&, void* const)
native simulated function AllowWeaponIconFadeOut();

// Export UTurokHudAmmoDisplay::execIsDualWielding(FFrame&, void* const)
native simulated function bool IsDualWielding();

simulated function Init(@NULL hudRef)
{
    super.Init(hudRef);
    RightWeaponInfo.fFadeOutTime = 1000000000.0000000;
    LeftWeaponInfo.fFadeOutTime = 1000000000.0000000;
    // End:0x7C
    if(mAmmoFont == none)
    {
        // End:0x71
        if(mHud.Canvas.ClipY >= float(720))
        {
            mAmmoFont = TurokFont'TurokFontsNew.TurokTransferEGauge';            
        }
        else
        {
            mAmmoFont = TurokFont'TurokFontsNew.TurokTransferEGauge';
        }
    }
    //return;    
}

function Reset()
{
    RightWeaponInfo.fFadeOutTime = 100.0000000;
    LeftWeaponInfo.fFadeOutTime = 100.0000000;
    //return;    
}

defaultproperties
{
    SafezoneBufferX=1.0000000
    SafezoneBufferY=2.0000000
    mLHWidth=51.0000000
    mLHHeight=31.0000000
    mRHWidth=51.0000000
    mRHHeight=31.0000000
    AmmoDisplayCorner=Texture2D'TurokHud.AmmoDisplay.AmmoTankRoundedCorner_HD'
    AmmoDisplayGradient=Texture2D'TurokHud.AmmoDisplay.AmmoTankGradientSwitchBG_HD'
    AmmoDisplaySecondaryAmmos=Texture2D'TurokHud.AmmoDisplay.SecondaryAmmos_HD'
    AmmoDisplaySecondaryAmmo=Texture2D'TurokHud.AmmoDisplay.AmmoTankIcons_HD'
    AmmoDisplayBlack=Texture2D'EngineResources.Black'
    mAmmoFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mAmmoTextScale=0.3280000
    mXTextScale=0.2800000
    bResetBlinkInfo=true
    mLowAmmoFullColor=(R=210,G=10,B=0,A=255)
    mAmmoFullColor=(R=123,G=101,B=78,A=255)
    mAmmoEmptyColor=(R=123,G=101,B=78,A=128)
    mAmmoFullDrawColor=(R=123,G=101,B=78,A=128)
    mAmmoEmptyDrawColor=(R=123,G=101,B=78,A=128)
    mWhite=(R=255,G=255,B=255,A=255)
    mAmmoFullTextColor=(R=215,G=161,B=94,A=179)
    mWeaponProfileColor=(R=212,G=169,B=107,A=255)
    mBackgroundColor=(R=255,G=255,B=255,A=179)
    fFlashTextTimeRH=0.1333300
    fFlashTextTimeLH=0.1333300
    fFlashTextDuration=0.1333300
}