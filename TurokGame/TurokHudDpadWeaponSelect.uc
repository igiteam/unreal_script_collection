class TurokHudDpadWeaponSelect extends TurokHudElement
    transient
    native;

struct native UVSize
{
    var int mX;
    var int mY;
    var int mWidth;
    var int mHeight;

    structdefaultproperties
    {
        mX=0
        mY=0
        mWidth=0
        mHeight=0
    }
};

var int mXPos;
var int mYPos;
var bool mbIsMultiPlayer;
var bool mbDrawElement;
var bool mbDualWield;
var bool mbDualWieldLeftSelected;
var bool mbDualWieldRightSelected;
var float mFadeInAnimLength;
var float mFadeInAnimTime;
var float mFadeOutAnimLength;
var float mFadeOutAnimTime;
var float mBlinkAnimLength;
var float mBlinkAnimTime;
var int mTriBlinkLength;
var int mTriBlinkCnt;
var @NULL mWeaponLeft;
var @NULL mWeaponRight;
var @NULL mKnife;
var @NULL mBow;
var @NULL mHighlightedWeap;
var int mWeaponOffsetX;
var int mWeaponOffsetY;
var int mArrowOffsetX;
var int mArrowOffsetY;
var int mDualWieldArrowsOffsetX;
var int mDualWieldWeaponsSpacingOffset;
var int mDualWieldWeaponsOffsetX;
var int mDualWieldWeaponsOffsetY;
var int mWeaponEdgeLeftSide;
var int mWeaponEdgeRightSide;
var @NULL mWeaponTintColor;
var @NULL mHighlightWeaponTintColor;
var @NULL mArrowTintColor;
var int mWeaponAlpha;
var @NULL mTexture;
var @NULL mLongArmUV;
var @NULL mShortArmUV;
var @NULL mNoVertArmUV;
var @NULL mVertArmUV;
var @NULL mVertArrowBigUV;
var @NULL mVertArrowSmallUV;
var @NULL mHorzArrowBigUV;
var @NULL mHorzArrowSmallUV;
var @NULL mDualWieldArrowBigUV;
var @NULL mDualWieldArrowSmallUV;

// Export UTurokHudDpadWeaponSelect::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudDpadWeaponSelect::execShowHud(FFrame&, void* const)
native function ShowHud(@NULL kKnife, @NULL kBow, @NULL kLeftWeapon, @NULL kRightWeapon);

// Export UTurokHudDpadWeaponSelect::execChangeSelectedWeapon(FFrame&, void* const)
native function ChangeSelectedWeapon(@NULL kNewWeapon);

// Export UTurokHudDpadWeaponSelect::execSelectDualWieldLeft(FFrame&, void* const)
native function SelectDualWieldLeft();

// Export UTurokHudDpadWeaponSelect::execSelectDualWieldRight(FFrame&, void* const)
native function SelectDualWieldRight();

// Export UTurokHudDpadWeaponSelect::execKillHud(FFrame&, void* const)
native function KillHud();

// Export UTurokHudDpadWeaponSelect::execInstantKillHud(FFrame&, void* const)
native function InstantKillHud();

function Init(@NULL hudRef)
{
    super.Init(hudRef);
    mbIsMultiPlayer = Class'TurokUtil'.static.IsMultiplayerGame();
    //return;    
}

defaultproperties
{
    mFadeInAnimLength=0.1250000
    mFadeInAnimTime=10.0000000
    mFadeOutAnimLength=0.1250000
    mFadeOutAnimTime=10.0000000
    mBlinkAnimLength=0.0800000
    mBlinkAnimTime=10.0000000
    mTriBlinkLength=2
    mTriBlinkCnt=10
    mWeaponOffsetX=10
    mWeaponOffsetY=10
    mArrowOffsetX=25
    mArrowOffsetY=25
    mDualWieldArrowsOffsetX=10
    mDualWieldWeaponsSpacingOffset=10
    mDualWieldWeaponsOffsetX=5
    mDualWieldWeaponsOffsetY=10
    mWeaponTintColor=(R=212,G=169,B=107,A=0)
    mHighlightWeaponTintColor=(R=255,G=243,B=226,A=0)
    mArrowTintColor=(R=128,G=102,B=65,A=0)
    mWeaponAlpha=255
    mTexture=Texture2D'TurokHud.DpadWeaponSelect.WeaponSwitchArt_HD'
    mLongArmUV=(mX=22,mY=196,mWidth=230,mHeight=56)
    mShortArmUV=(mX=90,mY=138,mWidth=162,mHeight=56)
    mNoVertArmUV=(mX=82,mY=69,mWidth=58,mHeight=56)
    mVertArmUV=(mX=12,mY=20,mWidth=58,mHeight=174)
    mVertArrowBigUV=(mX=168,mY=10,mWidth=30,mHeight=24)
    mVertArrowSmallUV=(mX=209,mY=13,mWidth=25,mHeight=21)
    mHorzArrowBigUV=(mX=171,mY=44,mWidth=24,mHeight=31)
    mHorzArrowSmallUV=(mX=210,mY=47,mWidth=21,mHeight=25)
    mDualWieldArrowBigUV=(mX=166,mY=84,mWidth=35,mHeight=31)
    mDualWieldArrowSmallUV=(mX=206,mY=87,mWidth=30,mHeight=25)
}