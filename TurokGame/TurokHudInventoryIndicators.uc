class TurokHudInventoryIndicators extends TurokHudElement
    transient
    native;

struct native TurokHudInventoryImgInfo
{
    var @NULL WeaponIcon;
    var float fImgPosX;
    var float fImgPosY;
    var float fImgWidth;
    var float fImgHeight;
    var float fVertSpacingMod;

    structdefaultproperties
    {
        WeaponIcon=none
        fImgPosX=0.0000000
        fImgPosY=0.0000000
        fImgWidth=0.0000000
        fImgHeight=0.0000000
        fVertSpacingMod=0.0000000
    }
};

var float mPickupAnimTime;
var float mPickupAnimLength;
var float mPickupAnimPauseTime;
var float mPickupAnimPauseLength;
var bool mbShowWeaponPickupHud;
var bool mbShowAmmoPickupHud;
var bool mbShowCollectablePickupHud;
var bool mbShowWeaponSwapHud;
var bool mbPickupIsSmallWeapon;
var bool mbDrawSmallWeaponLeft;
var bool mbDrawSmallWeaponRight;
var bool mbSkipFirstDraw;
var bool mSwapFadeWeaponScaleForward;
var bool mSwapFadeIn;
var bool mSwapFadeOut;
var bool mSwapStaticAnimate;
var int mChosenWeaponHand;
var @NULL mInvWeapon1;
var @NULL mInvWeapon2;
var class<Class> mPickupAmmoClass;
var @NULL mPickupWeaponInfo;
var @NULL mInvWeapon1Info;
var @NULL mInvWeapon2Info;
var string mCollectableString;
var int mCollectableSpacing;
var @NULL mCollectableImage;
var @NULL mCollectableImageUVs;
var @NULL mCollectableImageSize;
var float SWAP_HUD_X;
var float SWAP_HUD_Y;
var float mFontScaleValue;
var int mSwapWeaponImgXPosDelta1;
var int mSwapWeaponImgXPosDelta2;
var int mSwapWeaponImgYPosDelta3;
var int mSwapWeaponImgOffsetX1;
var int mSwapWeaponImgOffsetY1;
var int mSwapWeaponImgOffsetX2;
var int mSwapWeaponImgOffsetY2;
var int mSwapWeaponImgOffsetY3;
var int mSwapArrowImgOffsetX1;
var int mSwapArrowImgOffsetY1;
var int mSwapArrowImgOffsetX2;
var int mSwapArrowImgOffsetY2;
var int mSwapButtonImgOffsetX1;
var int mSwapButtonImgOffsetY1;
var int mSwapButtonImgOffsetX2;
var int mSwapButtonImgOffsetY2;
var int mSwapHoldTextOffsetX1;
var int mSwapHoldTextOffsetY1;
var int mSwapHoldTextOffsetX2;
var int mSwapHoldTextOffsetY2;
var float SWAP_LRG_HUD_X;
var float SWAP_LRG_HUD_Y;
var int mSwapLrgWeaponImgOffsetY1;
var int mSwapLrgWeaponImgOffsetY2;
var int mSwapLrgArrowOffsetX1;
var int mSwapLrgArrowOffsetY1;
var int mSwapLrgArrowOffsetX2;
var int mSwapLrgArrowOffsetY2;
var int mSwapLrgButtonImgOffsetY;
var int mSwapLrgHoldTextOffsetY;
var int mPickupWeaponOffsetX;
var float mSwapAnimFadeInLength;
var float mSwapAnimFadeInTime;
var float mSwapAnimFadeOutPauseLength;
var float mSwapAnimFadeOutPauseAtTime;
var float mSwapAnimFadeOutPauseTime;
var float mSwapAnimFadeOutLength;
var float mSwapAnimFadeOutTime;
var float mSwapAnimFadeOutOverallTime;
var float mSwapAnimLength;
var float mSwapSmallArrowAnimLength;
var float mSwapAnimTime;
var float mSwapAnimTranslateLength;
var float mSwapAnimTranslateTime;
var float mSwapFadeLevelOfGrayness;
var float mSwapFadeWeaponScaleAmount;
var float mSwapFadeWeaponScaleAnimLength;
var float mSwapFadeWeaponScaleAnimTime;
var int mSwapAnimFadeInFrames;
var int mSwapAnimFadeInRows;
var int mSwapAnimFadeOutFrames;
var int mSwapAnimFadeOutRows;
var int mSwapAnimFrames;
var int mSwapAnimRows;
var int mSwapSmallArrowAnimFrames;
var int mSwapSmallArrowAnimRows;
var int mButtonInAnimFramesStage1;
var int mButtonInAnimFramesStage2;
var int mButtonInAnimFramesStage3;
var int mButtonInAnimFramesStage4;
var int mButtonInAnimFramesTotal;
var int mButtonOutAnimFramesStage1;
var int mButtonOutAnimFramesStage2;
var int mButtonOutAnimFramesStage3;
var int mButtonOutAnimFramesStage4;
var int mButtonOutAnimFramesTotal;
var @NULL mWeaponSwapLargeArrow;
var @NULL mWeaponSwapLargeArrowFadeIn;
var @NULL mWeaponSwapLargeArrowFadeOut;
var @NULL mWeaponSwapSmallArrow;
var @NULL mWeaponSwapSmallArrowFadeIn;
var @NULL mWeaponSwapSmallArrowFadeOut;
var @NULL mXButtonColored;
var @NULL mXButtonWhite;
var @NULL mYButtonColored;
var @NULL mYButtonWhite;
var @NULL mSquareButtonColored;
var @NULL mSquareButtonWhite;
var @NULL mTriangleButtonColored;
var @NULL mTriangleButtonWhite;
var @NULL mSwapDrawFont;
var @NULL mAmmoDrawFont;
var string mHoldText;

// Export UTurokHudInventoryIndicators::execDrawSmallWeaponSwapHud(FFrame&, void* const)
native simulated function DrawSmallWeaponSwapHud();

// Export UTurokHudInventoryIndicators::execDrawLargeWeaponSwapHud(FFrame&, void* const)
native simulated function DrawLargeWeaponSwapHud();

// Export UTurokHudInventoryIndicators::execDrawAmmoPickupHud(FFrame&, void* const)
native simulated function DrawAmmoPickupHud();

// Export UTurokHudInventoryIndicators::execDrawWeaponPickupHud(FFrame&, void* const)
native simulated function DrawWeaponPickupHud();

// Export UTurokHudInventoryIndicators::execDrawCollectablePickupHud(FFrame&, void* const)
native simulated function DrawCollectablePickupHud();

// Export UTurokHudInventoryIndicators::execInitCollectablePickupAnim(FFrame&, void* const)
native simulated function InitCollectablePickupAnim(string kDisplayString, int kNumCollectables, @NULL kIcon, @NULL kIconUVs, @NULL kIconSize);

// Export UTurokHudInventoryIndicators::execInsertPrioritizedDraw(FFrame&, void* const)
private native final simulated function InsertPrioritizedDraw();

// Export UTurokHudInventoryIndicators::execRemovePriorityDraw(FFrame&, void* const)
private native final simulated function RemovePriorityDraw();

// Export UTurokHudInventoryIndicators::execKillWeaponSwapAnim(FFrame&, void* const)
native simulated function KillWeaponSwapAnim();

event ResetHUD()
{
    Reset();
    //return;    
}

function Reset()
{
    mbShowWeaponSwapHud = false;
    mbShowWeaponPickupHud = false;
    mbShowAmmoPickupHud = false;
    RemovePriorityDraw();
    //return;    
}

function Draw()
{
    // End:0x5D
    if(mbShowWeaponSwapHud == true)
    {
        // End:0x52
        if(mbSkipFirstDraw == false)
        {
            mHud.MPObjectiveItemAlpha = 64.0000000;
            // End:0x45
            if(mbPickupIsSmallWeapon == true)
            {
                DrawSmallWeaponSwapHud();                
            }
            else
            {
                DrawLargeWeaponSwapHud();
            }            
        }
        else
        {
            mbSkipFirstDraw = false;
        }        
    }
    else
    {
        // End:0x8A
        if(mbShowWeaponPickupHud == true)
        {
            mHud.MPObjectiveItemAlpha = 64.0000000;
            DrawWeaponPickupHud();            
        }
        else
        {
            // End:0xB7
            if(mbShowAmmoPickupHud == true)
            {
                mHud.MPObjectiveItemAlpha = 64.0000000;
                DrawAmmoPickupHud();                
            }
            else
            {
                // End:0xCA
                if(mbShowCollectablePickupHud)
                {
                    DrawCollectablePickupHud();
                }
            }
        }
    }
    //return;    
}

function PrioritizedDraw(@NULL HUD)
{
    Draw();
    //return;    
}

simulated function InitWeaponSwapAnim(class<Class> weapon_class, @NULL tim, @NULL wm)
{
    mHoldText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(597124970);
    SWAP_HUD_X = mHud.CenterX;
    SWAP_HUD_Y = mHud.SizeY * 0.7100000;
    SWAP_LRG_HUD_X = mHud.CenterX;
    SWAP_LRG_HUD_Y = mHud.SizeY * 0.7800000;
    mSwapAnimFadeInTime = 0.0000000;
    mSwapAnimFadeOutTime = 0.0000000;
    mSwapAnimTranslateTime = 0.0000000;
    mSwapAnimFadeOutPauseTime = 0.0000000;
    mSwapAnimFadeOutOverallTime = 0.0000000;
    mSwapFadeWeaponScaleAnimTime = 0.0000000;
    mSwapFadeWeaponScaleForward = true;
    mbShowWeaponSwapHud = true;
    mbSkipFirstDraw = false;
    mbShowWeaponPickupHud = false;
    mbShowAmmoPickupHud = false;
    mSwapFadeIn = false;
    mSwapFadeOut = false;
    mSwapStaticAnimate = true;
    mChosenWeaponHand = -1;
    mPickupWeaponInfo.WeaponIcon = weapon_class.default.mHudAmmoDisplay.WeaponIcon;
    mPickupWeaponInfo.fImgPosX = weapon_class.default.mHudAmmoDisplay.fImgPosX;
    mPickupWeaponInfo.fImgPosY = weapon_class.default.mHudAmmoDisplay.fImgPosY;
    mPickupWeaponInfo.fImgWidth = weapon_class.default.mHudAmmoDisplay.fImgWidth;
    mPickupWeaponInfo.fImgHeight = weapon_class.default.mHudAmmoDisplay.fImgHeight;
    mPickupWeaponInfo.fVertSpacingMod = weapon_class.default.mHudAmmoDisplay.fVertSpacingMod;
    mbPickupIsSmallWeapon = true;
    mInvWeapon1 = tim.GetWeaponRightSlot();
    mInvWeapon2 = tim.GetWeaponLeftSlot();
    mbDrawSmallWeaponLeft = true;
    mbDrawSmallWeaponRight = true;
    // End:0x270
    if((mInvWeapon1 == none) || mInvWeapon1.Class == weapon_class)
    {
        mbDrawSmallWeaponRight = false;
    }
    // End:0x29D
    if((mInvWeapon2 == none) || mInvWeapon2.Class == weapon_class)
    {
        mbDrawSmallWeaponLeft = false;
    }
    mInvWeapon1Info.WeaponIcon = mInvWeapon1.mHudAmmoDisplay.WeaponIcon;
    mInvWeapon1Info.fImgPosX = mInvWeapon1.mHudAmmoDisplay.fImgPosX;
    mInvWeapon1Info.fImgPosY = mInvWeapon1.mHudAmmoDisplay.fImgPosY;
    mInvWeapon1Info.fImgWidth = mInvWeapon1.mHudAmmoDisplay.fImgWidth;
    mInvWeapon1Info.fImgHeight = mInvWeapon1.mHudAmmoDisplay.fImgHeight;
    mInvWeapon1Info.fVertSpacingMod = mInvWeapon1.mHudAmmoDisplay.fVertSpacingMod;
    mInvWeapon2Info.WeaponIcon = mInvWeapon2.mHudAmmoDisplay.WeaponIcon;
    mInvWeapon2Info.fImgPosX = mInvWeapon2.mHudAmmoDisplay.fImgPosX;
    mInvWeapon2Info.fImgPosY = mInvWeapon2.mHudAmmoDisplay.fImgPosY;
    mInvWeapon2Info.fImgWidth = mInvWeapon2.mHudAmmoDisplay.fImgWidth;
    mInvWeapon2Info.fImgHeight = mInvWeapon2.mHudAmmoDisplay.fImgHeight;
    mInvWeapon2Info.fVertSpacingMod = mInvWeapon2.mHudAmmoDisplay.fVertSpacingMod;
    InsertPrioritizedDraw();
    //return;    
}

simulated function FinishWeaponSwapAnim(int weaponDroppedHand)
{
    Reset();
    mSwapFadeOut = false;
    mSwapStaticAnimate = false;
    mSwapFadeIn = false;
    mChosenWeaponHand = weaponDroppedHand;
    //return;    
}

simulated function InitWeaponPickupAnim(class<Class> weapon_class)
{
    mPickupAnimPauseTime = 0.0000000;
    mPickupAnimTime = 0.0000000;
    mbShowWeaponPickupHud = true;
    mbShowAmmoPickupHud = false;
    mbShowCollectablePickupHud = false;
    mPickupWeaponInfo.WeaponIcon = weapon_class.default.mHudAmmoDisplay.WeaponIcon;
    mPickupWeaponInfo.fImgPosX = weapon_class.default.mHudAmmoDisplay.fImgPosX;
    mPickupWeaponInfo.fImgPosY = weapon_class.default.mHudAmmoDisplay.fImgPosY;
    mPickupWeaponInfo.fImgWidth = weapon_class.default.mHudAmmoDisplay.fImgWidth;
    mPickupWeaponInfo.fImgHeight = weapon_class.default.mHudAmmoDisplay.fImgHeight;
    mPickupWeaponInfo.fVertSpacingMod = weapon_class.default.mHudAmmoDisplay.fVertSpacingMod;
    InsertPrioritizedDraw();
    //return;    
}

simulated function InitAmmoPickupAnim(class<Class> ammoPoolClass)
{
    // End:0x1F
    if((mbShowWeaponPickupHud == true) && mPickupAnimPauseTime < 0.0500000)
    {
        return;
    }
    mPickupAnimPauseTime = 0.0000000;
    mPickupAnimTime = 0.0000000;
    mbShowAmmoPickupHud = true;
    mbShowWeaponPickupHud = false;
    mbShowCollectablePickupHud = false;
    mPickupAmmoClass = ammoPoolClass;
    InsertPrioritizedDraw();
    //return;    
}

simulated event string GetAmmoString(class<Class> ammoClass)
{
    local string Value;

    switch(ammoClass)
    {
        // End:0x30
        case Class'TurokAmmoPoolHandgun':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1015785986);
            // End:0x2C0
            break;
        // End:0x59
        case Class'TurokAmmoPoolChaingun':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1218892666);
            // End:0x2C0
            break;
        // End:0x82
        case Class'TurokAmmoPoolSmg':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-343123652);
            // End:0x2C0
            break;
        // End:0xAB
        case Class'TurokAmmoPoolRailgun':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-1685888990);
            // End:0x2C0
            break;
        // End:0xD4
        case Class'TurokAmmoPoolShotgun':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(286402794);
            // End:0x2C0
            break;
        // End:0xFD
        case Class'TurokAmmoPoolSniperRifle':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-427436534);
            // End:0x2C0
            break;
        // End:0x126
        case Class'TurokAmmoPoolRailGrenade':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1972195910);
            // End:0x2C0
            break;
        // End:0x14F
        case Class'TurokAmmoPoolRocket':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-958309348);
            // End:0x2C0
            break;
        // End:0x178
        case Class'TurokAmmoPoolFlameThrower':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(462297506);
            // End:0x2C0
            break;
        // End:0x1A1
        case Class'TurokAmmoPoolNapalmGrenade':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-1523259270);
            // End:0x2C0
            break;
        // End:0x1CA
        case Class'TurokAmmoPoolArrow':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(100791952);
            // End:0x2C0
            break;
        // End:0x1F3
        case Class'TurokAmmoPoolArrowExploding':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1412544764);
            // End:0x2C0
            break;
        // End:0x21C
        case Class'TurokAmmoPoolGrenade':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-2056432167);
            // End:0x2C0
            break;
        // End:0x245
        case Class'TurokAmmoPoolShredder':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1189645810);
            // End:0x2C0
            break;
        // End:0x26E
        case Class'TurokAmmoPoolStickyGun':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-473780842);
            // End:0x2C0
            break;
        // End:0x297
        case Class'TurokAmmoPoolTazer':
            Value = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1642874887);
            // End:0x2C0
            break;
        // End:0xFFFF
        default:
            Value = "Picked Up Unknown Ammo Type";
            // End:0x2C0
            break;
            break;
    }
    return Value;
    //return ReturnValue;    
}

defaultproperties
{
    mPickupAnimLength=1.5000000
    mPickupAnimPauseLength=1.0000000
    mbDrawSmallWeaponLeft=true
    mbDrawSmallWeaponRight=true
    mFontScaleValue=0.3280000
    mSwapWeaponImgXPosDelta1=18
    mSwapWeaponImgXPosDelta2=18
    mSwapWeaponImgYPosDelta3=18
    mSwapWeaponImgOffsetY1=40
    mSwapWeaponImgOffsetY2=40
    mSwapWeaponImgOffsetY3=7
    mSwapArrowImgOffsetX1=-3
    mSwapArrowImgOffsetX2=-3
    mSwapButtonImgOffsetX1=23
    mSwapButtonImgOffsetY1=22
    mSwapButtonImgOffsetX2=23
    mSwapButtonImgOffsetY2=22
    mSwapHoldTextOffsetX1=-4
    mSwapHoldTextOffsetY1=41
    mSwapHoldTextOffsetX2=-4
    mSwapHoldTextOffsetY2=41
    mSwapLrgWeaponImgOffsetY1=27
    mSwapLrgWeaponImgOffsetY2=27
    mSwapLrgArrowOffsetX1=36
    mSwapLrgArrowOffsetY1=-6
    mSwapLrgArrowOffsetX2=36
    mSwapLrgArrowOffsetY2=-6
    mSwapLrgButtonImgOffsetY=-32
    mSwapLrgHoldTextOffsetY=-12
    mPickupWeaponOffsetX=10
    mSwapAnimFadeInLength=0.1200000
    mSwapAnimFadeOutPauseLength=0.0100000
    mSwapAnimFadeOutLength=0.0100000
    mSwapAnimLength=0.3000000
    mSwapSmallArrowAnimLength=1.2500000
    mSwapAnimTranslateLength=0.6700000
    mSwapFadeLevelOfGrayness=0.5000000
    mSwapFadeWeaponScaleAmount=0.0200000
    mSwapFadeWeaponScaleAnimLength=0.0500000
    mSwapAnimFadeInFrames=16
    mSwapAnimFadeInRows=2
    mSwapAnimFadeOutFrames=16
    mSwapAnimFadeOutRows=2
    mSwapAnimFrames=16
    mSwapAnimRows=2
    mSwapSmallArrowAnimFrames=32
    mSwapSmallArrowAnimRows=4
    mButtonInAnimFramesStage1=4
    mButtonInAnimFramesStage2=4
    mButtonInAnimFramesStage3=4
    mButtonInAnimFramesStage4=4
    mButtonInAnimFramesTotal=16
    mButtonOutAnimFramesStage1=4
    mButtonOutAnimFramesStage2=2
    mButtonOutAnimFramesStage3=4
    mButtonOutAnimFramesStage4=6
    mButtonOutAnimFramesTotal=16
    mWeaponSwapLargeArrow=Texture2D'TurokHud.WeaponSwap.LargeArrow'
    mWeaponSwapLargeArrowFadeIn=Texture2D'TurokHud.WeaponSwap.LargeArrowFadeIn'
    mWeaponSwapLargeArrowFadeOut=Texture2D'TurokHud.WeaponSwap.LargeArrowFadeOut'
    mWeaponSwapSmallArrow=Texture2D'TurokHud.WeaponSwap.SmallArrow'
    mWeaponSwapSmallArrowFadeIn=Texture2D'TurokHud.WeaponSwap.SmallArrowFadeIn'
    mWeaponSwapSmallArrowFadeOut=Texture2D'TurokHud.WeaponSwap.SmallArrowFadeOut'
    mXButtonColored=Texture2D'TurokControllerButtons.HUD_360_X'
    mXButtonWhite=Texture2D'TurokControllerButtons.HUD_360_X_White'
    mYButtonColored=Texture2D'TurokControllerButtons.HUD_360_Y'
    mYButtonWhite=Texture2D'TurokControllerButtons.HUD_360_Y_White'
    mSquareButtonColored=Texture2D'TurokControllerButtons.PS3_Square_0_HD'
    mSquareButtonWhite=Texture2D'TurokControllerButtons.PS3_Square_1_HD'
    mTriangleButtonColored=Texture2D'TurokControllerButtons.PS3_Triangle_0_HD'
    mTriangleButtonWhite=Texture2D'TurokControllerButtons.PS3_Triangle_1_HD'
    mSwapDrawFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mAmmoDrawFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
}