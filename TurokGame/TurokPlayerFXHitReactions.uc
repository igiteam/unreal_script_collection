class TurokPlayerFXHitReactions extends Component;

const ACTIVE_VIGNETTE = 0x01;
const ACTIVE_BLUR = 0x02;

enum EDamageType
{
    DAMAGETYPE_Big,                 // 0
    DAMAGETYPE_Small,               // 1
    DAMAGETYPE_Melee,               // 2
    DAMAGETYPE_Groggy,              // 3
    DAMAGETYPE_MAX                  // 4
};

struct EffectsUpdateManager
{
    var byte CurDamageType;
    var bool NeverUpdated;
    var int ActiveEffects;
    var float VignetteLife;
    var float VignetteTime;
    var float BlurLife;
    var float BlurTime;
    var float ExposureLife;
    var float ExposureTime;

    structdefaultproperties
    {
        CurDamageType=0
        NeverUpdated=false
        ActiveEffects=0
        VignetteLife=0.0000000
        VignetteTime=0.0000000
        BlurLife=0.0000000
        BlurTime=0.0000000
        ExposureLife=0.0000000
        ExposureTime=0.0000000
    }
};

var @NULL mMatEffectMan;
var(HitReaction) private float mBlurKernelSize;
var(HitReaction) private float mMaxNearBlurAmount;
var(HitReaction) private float mMaxFarBlurAmount;
var(HitReaction) private float mFocusDistance;
var(HitReaction) private float mFocusInnerRadius;
var(HitReaction) private float mBlurHitStrength[3];
var private float mPreviousBlurKernelSize;
var private float mPreviousMaxNearBlurAmount;
var private float mPreviousMaxFarBlurAmount;
var private float mPreviousFocusDistance;
var private float mPreviousFocusInnerRadius;
var private @NULL mVignetteTexture;
var(HitReaction) private float mVignetteHitStrength[3];
var private float mPreviousVignetteStrength;
var(Groggy) private float mTransitionSmoothingRate;
var(Groggy) private float mTintR;
var(Groggy) private float mTintG;
var(Groggy) private float mTintB;
var private float mPreviousTintR;
var private float mPreviousTintG;
var private float mPreviousTintB;
var private float mTotalVignetteStrength;
var private float mTotalBlurStrength;
var private float mTotalColorTintStrength;
var private float mTargetGroggyVignetteStrength;
var private float mTargetGroggyBlurStrength;
var private float mTargetGroggyColorTintStrength;
var private float mCurrentGroggyVignetteStrength;
var private float mCurrentGroggyBlurStrength;
var private float mCurrentGroggyColorTintStrength;
var(Groggy) private float mVignetteStartStrength;
var(Groggy) private float mVignetteEndStrength;
var(Groggy) private float mVignetteStartPcnt;
var(Groggy) private float mVignetteEndPcnt;
var(Groggy) private float mBlurStartStrength;
var(Groggy) private float mBlurEndStrength;
var(Groggy) private float mBlurStartPcnt;
var(Groggy) private float mBlurEndPcnt;
var(Groggy) private float mColorTintStartStrength;
var(Groggy) private float mColorTintEndStrength;
var(Groggy) private float mColorTintStartPcnt;
var(Groggy) private float mColorTintEndPcnt;
var(PlayerFXHitReactions) array mVignetteFadeSeconds;
var(PlayerFXHitReactions) array mBlurOffsetMax;
var(PlayerFXHitReactions) array mBlurFadeSeconds;
var(PlayerFXHitReactions) array mExposureDarken;
var(PlayerFXHitReactions) array mExposureBloomScale;
var(PlayerFXHitReactions) array mExposureFadeSeconds;
var(PlayerFXHitReactions) @NULL mImpactPSTemplate;
var(PlayerFXHitReactions) float mImpactPSDistFromCam;
var(PlayerFXHitReactions) float mParentIntensityFudge;
var @NULL mImpactEmitter;
var @NULL Owner;
var @NULL mLocalPlayer;
var export editinline @NULL mReactionManager;

function Init(@NULL Target, @NULL ReactionManager)
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    tppm.SetVignetteTexture(mVignetteTexture);
    Owner = Target;
    mReactionManager = ReactionManager;
    mLocalPlayer = LocalPlayer(Owner.Player);
    // DebugMode: 0
    assert(mLocalPlayer != none);
    //return;    
}

function UnInit()
{
    // DebugMode: 0
    assert(mLocalPlayer != none);
    StopAllScreenFX();
    mLocalPlayer = none;
    //return;    
}

function StopAllScreenFX()
{
    local @NULL tppm;

    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    tppm.BeginSettings();
    tppm.SetFloatNative(15, 0.0000000);
    tppm.SetFloatNative(16, 0.0000000);
    tppm.SetFloatNative(14, 0.0000000);
    tppm.SetFloatNative(17, 0.0000000);
    tppm.SetFloatNative(12, 0.0000000);
    tppm.SetFloatNative(13, 0.0000000);
    tppm.SetFloatNative(28, 0.0000000);
    tppm.SetColorNative(44, 1.0000000, 1.0000000, 1.0000000);
    tppm.EndSettings();
    TurokHud(TurokPlayerController(Owner).myHUD).mStealthVignette.SetFadePcnt(0.0000000);
    mPreviousBlurKernelSize = 0.0000000;
    mPreviousMaxNearBlurAmount = 0.0000000;
    mPreviousMaxFarBlurAmount = 0.0000000;
    mPreviousFocusDistance = 0.0000000;
    mPreviousFocusInnerRadius = 0.0000000;
    mPreviousVignetteStrength = 0.0000000;
    mPreviousTintR = 0.0000000;
    mPreviousTintG = 0.0000000;
    mPreviousTintB = 0.0000000;
    //return;    
}

function SetImpactPSLocation(@NULL HitFromDir)
{
    local @NULL cameraLoc, cameraRot, EmitterLoc;

    // End:0x57
    if(mImpactEmitter != none)
    {
        TurokPlayerController(Owner).GetPlayerViewPoint(cameraLoc, cameraRot);
        EmitterLoc = cameraLoc + (HitFromDir * mImpactPSDistFromCam);
        mImpactEmitter.SetLocation(EmitterLoc);
    }
    //return;    
}

function RegisterNewHit(byte DamageType, @NULL HitFromMomentum)
{
    mMatEffectMan.CurDamageType = DamageType;
    mMatEffectMan.NeverUpdated = true;
    // End:0xAB
    if(int(DamageType) != int(3))
    {
        mMatEffectMan.VignetteLife = mVignetteFadeSeconds[int(DamageType)];
        mMatEffectMan.VignetteTime = mVignetteFadeSeconds[int(DamageType)];
        mMatEffectMan.BlurLife = mBlurFadeSeconds[int(DamageType)];
        mMatEffectMan.BlurTime = mBlurFadeSeconds[int(DamageType)];
    }
    //return;    
}

function UpdateGroggy()
{
    local float player_health, player_max_health, step_amount;

    // End:0x5D
    if(TurokPawn(Owner.Pawn) == none)
    {
        mTargetGroggyVignetteStrength = 0.0000000;
        mTargetGroggyBlurStrength = 0.0000000;
        mTargetGroggyColorTintStrength = 0.0000000;
        mCurrentGroggyVignetteStrength = 0.0000000;
        mCurrentGroggyBlurStrength = 0.0000000;
        mCurrentGroggyColorTintStrength = 0.0000000;
        return;
    }
    player_health = float(Owner.Pawn.Health);
    player_max_health = float(TurokPawn(Owner.Pawn).mDefaultHealth);
    mTargetGroggyVignetteStrength = (player_health - (player_max_health * mVignetteEndPcnt)) / ((mVignetteStartPcnt - mVignetteEndPcnt) * player_max_health);
    mTargetGroggyVignetteStrength = 1.0000000 - FClamp(mTargetGroggyVignetteStrength, 0.0000000, 1.0000000);
    // End:0x127
    if(mTargetGroggyVignetteStrength > 0.0000000)
    {
        mTargetGroggyVignetteStrength = FClamp((mTargetGroggyVignetteStrength * (mVignetteEndStrength - mVignetteStartStrength)) + mVignetteStartStrength, 0.0000000, 1.0000000);
    }
    step_amount = (mVignetteStartPcnt - mVignetteEndPcnt) * mTransitionSmoothingRate;
    // End:0x15E
    if(mTargetGroggyVignetteStrength > mCurrentGroggyVignetteStrength)
    {
        mCurrentGroggyVignetteStrength += step_amount;        
    }
    else
    {
        mCurrentGroggyVignetteStrength -= (step_amount * 0.2500000);
    }
    // End:0x19B
    if(Abs(mTargetGroggyVignetteStrength - mCurrentGroggyVignetteStrength) <= (step_amount + 0.0010000))
    {
        mCurrentGroggyVignetteStrength = mTargetGroggyVignetteStrength;
    }
    mTargetGroggyBlurStrength = (player_health - (player_max_health * mBlurEndPcnt)) / ((mBlurStartPcnt - mBlurEndPcnt) * player_max_health);
    mTargetGroggyBlurStrength = 1.0000000 - FClamp(mTargetGroggyBlurStrength, 0.0000000, 1.0000000);
    // End:0x222
    if(mTargetGroggyBlurStrength > 0.0000000)
    {
        mTargetGroggyBlurStrength = FClamp((mTargetGroggyBlurStrength * (mBlurEndStrength - mBlurStartStrength)) + mBlurStartStrength, 0.0000000, 1.0000000);
    }
    step_amount = (mBlurStartPcnt - mBlurEndPcnt) * mTransitionSmoothingRate;
    // End:0x259
    if(mTargetGroggyBlurStrength > mCurrentGroggyBlurStrength)
    {
        mCurrentGroggyBlurStrength += step_amount;        
    }
    else
    {
        mCurrentGroggyBlurStrength -= (step_amount * 0.2500000);
    }
    // End:0x296
    if(Abs(mTargetGroggyBlurStrength - mCurrentGroggyBlurStrength) <= (step_amount + 0.0010000))
    {
        mCurrentGroggyBlurStrength = mTargetGroggyBlurStrength;
    }
    mTargetGroggyColorTintStrength = (player_health - (player_max_health * mColorTintEndPcnt)) / ((mColorTintStartPcnt - mColorTintEndPcnt) * player_max_health);
    mTargetGroggyColorTintStrength = 1.0000000 - FClamp(mTargetGroggyColorTintStrength, 0.0000000, 1.0000000);
    // End:0x31D
    if(mTargetGroggyColorTintStrength > 0.0000000)
    {
        mTargetGroggyColorTintStrength = FClamp((mTargetGroggyColorTintStrength * (mColorTintEndStrength - mColorTintStartStrength)) + mColorTintStartStrength, 0.0000000, 1.0000000);
    }
    step_amount = (mColorTintStartPcnt - mColorTintEndPcnt) * mTransitionSmoothingRate;
    // End:0x354
    if(mTargetGroggyColorTintStrength > mCurrentGroggyColorTintStrength)
    {
        mCurrentGroggyColorTintStrength += step_amount;        
    }
    else
    {
        mCurrentGroggyColorTintStrength -= (step_amount * 0.2500000);
    }
    // End:0x391
    if(Abs(mTargetGroggyColorTintStrength - mCurrentGroggyColorTintStrength) <= (step_amount + 0.0010000))
    {
        mCurrentGroggyColorTintStrength = mTargetGroggyColorTintStrength;
    }
    //return;    
}

function UpdateFX(float Delta)
{
    local @NULL tppm;
    local float hit_pcnt;
    local @NULL temp_color;

    UpdateGroggy();
    tppm = Class'Engine.Engine'.static.GetEngine().GetTurokPostProcessManager();
    tppm.BeginSettings();
    mMatEffectMan.VignetteTime -= Delta;
    // End:0xB7
    if(mMatEffectMan.VignetteLife > float(0))
    {
        hit_pcnt = FClamp(mMatEffectMan.VignetteTime / mMatEffectMan.VignetteLife, 0.0000000, 1.0000000) * mVignetteHitStrength[int(mMatEffectMan.CurDamageType)];        
    }
    else
    {
        hit_pcnt = 0.0000000;
    }
    mTotalVignetteStrength = hit_pcnt + mCurrentGroggyVignetteStrength;
    mTotalVignetteStrength = FClamp(mTotalVignetteStrength, 0.0000000, 1.0000000);
    tppm.SetVignetteTexture(mVignetteTexture);
    tppm.SetFloatNative(28, mTotalVignetteStrength);
    TurokHud(TurokPlayerController(Owner).myHUD).mStealthVignette.SetFadePcnt(mTotalVignetteStrength);
    mMatEffectMan.BlurTime -= Delta;
    // End:0x1CC
    if(mMatEffectMan.BlurLife > float(0))
    {
        hit_pcnt = FClamp(mMatEffectMan.BlurTime / mMatEffectMan.BlurLife, 0.0000000, 1.0000000) * mBlurHitStrength[int(mMatEffectMan.CurDamageType)];        
    }
    else
    {
        hit_pcnt = 0.0000000;
    }
    mTotalBlurStrength = FClamp(hit_pcnt + mCurrentGroggyBlurStrength, 0.0000000, 1.0000000);
    // End:0x2CD
    if(mTotalBlurStrength > 0.0000000)
    {
        tppm.SetFloatNative(12, mFocusDistance * mTotalBlurStrength);
        tppm.SetFloatNative(13, mFocusInnerRadius * mTotalBlurStrength);
        tppm.SetFloatNative(14, 2.0000000 * mTotalBlurStrength);
        tppm.SetFloatNative(15, mBlurKernelSize * mTotalBlurStrength);
        tppm.SetFloatNative(16, mMaxNearBlurAmount * mTotalBlurStrength);
        tppm.SetFloatNative(17, mMaxFarBlurAmount * mTotalBlurStrength);        
    }
    else
    {
        tppm.SetFloatNative(12, 0.0000000);
        tppm.SetFloatNative(13, 0.0000000);
        tppm.SetFloatNative(14, 0.0000000);
        tppm.SetFloatNative(15, 0.0000000);
        tppm.SetFloatNative(16, 0.0000000);
        tppm.SetFloatNative(17, 0.0000000);
    }
    mTotalColorTintStrength = mCurrentGroggyColorTintStrength;
    temp_color = tppm.GetTargetColor(44);
    temp_color.R = (temp_color.R - mPreviousTintR) + (mTotalColorTintStrength * mTintR);
    temp_color.G = (temp_color.G - mPreviousTintG) + (mTotalColorTintStrength * mTintG);
    temp_color.B = (temp_color.B - mPreviousTintB) + (mTotalColorTintStrength * mTintB);
    tppm.SetColorNative(44, temp_color.R, temp_color.G, temp_color.B);
    mPreviousTintR = mTotalColorTintStrength * mTintR;
    mPreviousTintG = mTotalColorTintStrength * mTintG;
    mPreviousTintB = mTotalColorTintStrength * mTintB;
    tppm.EndSettings(, 0.0000000);
    //return;    
}

function Update(float Delta)
{
    // End:0x30
    if(mMatEffectMan.NeverUpdated)
    {
        Delta = 0.0000000;
        mMatEffectMan.NeverUpdated = false;
    }
    UpdateFX(Delta);
    //return;    
}

defaultproperties
{
    mBlurKernelSize=0.1000000
    mMaxNearBlurAmount=1.6000000
    mMaxFarBlurAmount=1.0000000
    mFocusDistance=8000.0000000
    mBlurHitStrength[0]=1.0000000
    mBlurHitStrength[1]=0.3000000
    mBlurHitStrength[2]=1.0000000
    mVignetteTexture=Texture2D'TurokEngineMaterials.HitVignetteFXD'
    mVignetteHitStrength[0]=1.0000000
    mVignetteHitStrength[1]=0.3000000
    mVignetteHitStrength[2]=0.7500000
    mTransitionSmoothingRate=0.2500000
    mTintR=1.0000000
    mVignetteStartStrength=0.6500000
    mVignetteEndStrength=1.0000000
    mVignetteStartPcnt=0.6500000
    mVignetteEndPcnt=0.2000000
    mBlurEndStrength=1.0000000
    mBlurStartPcnt=0.5500000
    mColorTintEndStrength=1.0000000
    mColorTintStartPcnt=0.4500000
    mVignetteFadeSeconds=/* Array type was not detected. */
    mBlurFadeSeconds=/* Array type was not detected. */
    mImpactPSDistFromCam=20.0000000
    mParentIntensityFudge=0.3000000
}