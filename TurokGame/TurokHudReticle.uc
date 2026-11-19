class TurokHudReticle extends TurokHudElement
    transient
    native;

var int mRetAccuracyTravelX;
var int mRetAccuracyTravelY;
var int mReticleTranslationX;
var int mReticleTranslationY;
var float mRotStart;
var float mRotEnd;
var float mExpExagThreshold;
var float mExpExagLowThreshold;
var bool mNoReticle;
var bool mIsFriendly;
var bool mbTestReticleTravel;
var bool mbTestDirection;
var array mRetCornerTexs;
var array mRetHorizTexs;
var array mRetVertTexs;
var array mRetCenterTexs;
var @NULL CurrentWeaponRH;
var @NULL CurrentWeaponLH;
var @NULL mReticleComponentMaterial;
var @NULL mReticleMatInstance;
var @NULL mReticleColor;
var @NULL mReticleColorFoe;
var @NULL mReticleColorFriend;
var @NULL TempColor;
var float mAxisTranslation;
var float mRetAlphaMin;
var float mRetAlphaChange;
var float mRotPcnt;
var float fRotation;
var float mTestAccuracy;
var float mTestMultiplier;

// Export UTurokHudReticle::execDrawNative(FFrame&, void* const)
native function DrawNative(float currentAccuracy);

event SetFriendly()
{
    mIsFriendly = true;
    mRetCornerTexs.Remove(0, mRetCornerTexs.Length);
    mRetHorizTexs.Remove(0, mRetHorizTexs.Length);
    mRetVertTexs.Remove(0, mRetVertTexs.Length);
    mRetCenterTexs.Remove(0, mRetCenterTexs.Length);
    mRetCenterTexs[0] = Texture2D'TurokHud.Reticles.friendly.FriendlyCenter';
    mRetAccuracyTravelX = 0;
    mRetAccuracyTravelY = 0;
    mReticleTranslationX = 0;
    mReticleTranslationY = 0;
    mAxisTranslation = 0.0000000;
    mRotStart = 0.0000000;
    mRotEnd = 0.0000000;
    //return;    
}

event UnSetFriendly()
{
    mIsFriendly = false;
    SetWeaponType(CurrentWeaponRH, CurrentWeaponLH);
    //return;    
}

event SetWeaponType(@NULL cur_weap_rh, @NULL cur_weap_lh)
{
    CurrentWeaponRH = cur_weap_rh;
    CurrentWeaponLH = cur_weap_lh;
    // End:0x302
    if(CurrentWeaponRH != none)
    {
        // End:0x17A
        if(CurrentWeaponRH.mHudReticleDisplay.mInProgress)
        {
            mRetCornerTexs = Class'TurokWeapon'.default.mHudReticleDisplay.mRetCornerTexs;
            mRetCenterTexs = Class'TurokWeapon'.default.mHudReticleDisplay.mRetCenterTexs;
            mRetHorizTexs[0] = Texture2D'TurokHud.Reticles.Handgun.HandgunLeft';
            mRetVertTexs[0] = Texture2D'TurokHud.Reticles.Handgun.HandgunTop';
            mRotStart = Class'TurokWeapon'.default.mHudReticleDisplay.mRotStart;
            mRotEnd = Class'TurokWeapon'.default.mHudReticleDisplay.mRotEnd;
            mNoReticle = Class'TurokWeapon'.default.mHudReticleDisplay.mNoReticle;
            mRetAccuracyTravelX = 6;
            mRetAccuracyTravelY = 6;
            mReticleTranslationX = Class'TurokWeapon'.default.mHudReticleDisplay.mReticleTranslationX;
            mReticleTranslationY = Class'TurokWeapon'.default.mHudReticleDisplay.mReticleTranslationY;
            mExpExagThreshold = Class'TurokWeapon'.default.mHudReticleDisplay.mExpExagThreshold;
            mExpExagLowThreshold = Class'TurokWeapon'.default.mHudReticleDisplay.mExpExagLowThreshold;            
        }
        else
        {
            mRetCornerTexs = CurrentWeaponRH.mHudReticleDisplay.mRetCornerTexs;
            mRetHorizTexs = CurrentWeaponRH.mHudReticleDisplay.mRetHorizTexs;
            mRetVertTexs = CurrentWeaponRH.mHudReticleDisplay.mRetVertTexs;
            mRetCenterTexs = CurrentWeaponRH.mHudReticleDisplay.mRetCenterTexs;
            mRotStart = CurrentWeaponRH.mHudReticleDisplay.mRotStart;
            mRotEnd = CurrentWeaponRH.mHudReticleDisplay.mRotEnd;
            mNoReticle = CurrentWeaponRH.mHudReticleDisplay.mNoReticle;
            mRetAccuracyTravelX = CurrentWeaponRH.mHudReticleDisplay.mRetAccuracyTravelX;
            mRetAccuracyTravelY = CurrentWeaponRH.mHudReticleDisplay.mRetAccuracyTravelY;
            mReticleTranslationX = CurrentWeaponRH.mHudReticleDisplay.mReticleTranslationX;
            mReticleTranslationY = CurrentWeaponRH.mHudReticleDisplay.mReticleTranslationY;
            mExpExagThreshold = CurrentWeaponRH.mHudReticleDisplay.mExpExagThreshold;
            mExpExagLowThreshold = CurrentWeaponRH.mHudReticleDisplay.mExpExagLowThreshold;
        }
    }
    mRotPcnt = 0.0000000;
    mRetAlphaMin = 0.1000000;
    mRetAlphaChange = 0.5000000;
    // End:0x46C
    if(((CurrentWeaponRH != none) && CurrentWeaponLH != none) && int(CurrentWeaponRH.mWeaponType) != int(CurrentWeaponLH.mWeaponType))
    {
        mRetCornerTexs.Remove(0, mRetCornerTexs.Length);
        mRetHorizTexs.Remove(0, mRetHorizTexs.Length);
        mRetVertTexs.Remove(0, mRetVertTexs.Length);
        mRetCenterTexs.Remove(0, mRetCenterTexs.Length);
        mRetHorizTexs[0] = Texture2D'TurokHud.Reticles.DualWield.DWLeft01';
        mRetHorizTexs[1] = Texture2D'TurokHud.Reticles.DualWield.DWLeft02';
        mRetHorizTexs[2] = Texture2D'TurokHud.Reticles.DualWield.DWLeft03';
        mRetHorizTexs[3] = Texture2D'TurokHud.Reticles.DualWield.DWLeft04';
        mRetHorizTexs[4] = Texture2D'TurokHud.Reticles.DualWield.DWLeft05';
        mRetHorizTexs[5] = Texture2D'TurokHud.Reticles.DualWield.DWLeft06';
        mRetHorizTexs[6] = Texture2D'TurokHud.Reticles.DualWield.DWLeft07';
        mRetHorizTexs[7] = Texture2D'TurokHud.Reticles.DualWield.DWLeft08';
        mRetHorizTexs[8] = Texture2D'TurokHud.Reticles.DualWield.DWLeft09';
        mRetHorizTexs[9] = Texture2D'TurokHud.Reticles.DualWield.DWLeft10';
        mRetHorizTexs[10] = Texture2D'TurokHud.Reticles.DualWield.DWLeft11';
        mRetAccuracyTravelX = 28;
        mRetAccuracyTravelY = 28;
        mReticleTranslationX = 14;
        mReticleTranslationY = 14;
        mRotStart = 0.0000000;
        mRotEnd = 0.0000000;
        mNoReticle = false;
    }
    mAxisTranslation = Sqrt(float((mReticleTranslationX * mReticleTranslationX) + (mReticleTranslationY * mReticleTranslationY)));
    //return;    
}

function Init(@NULL myHUD)
{
    super.Init(myHUD);
    // End:0x45
    if(mReticleMatInstance == none)
    {
        mReticleMatInstance = new (none) Class'Engine.MaterialInstanceConstant';
        mReticleMatInstance.SetParent(mReticleComponentMaterial);
        mReticleComponentMaterial = mReticleMatInstance;
    }
    //return;    
}

function Draw()
{
    local float Accuracy;

    // End:0x7E
    if(CurrentWeaponRH != none)
    {
        Accuracy = CurrentWeaponRH.GetAccuracy();
        // End:0x64
        if(CurrentWeaponLH != none)
        {
            Accuracy = (CurrentWeaponLH.GetAccuracy() + CurrentWeaponRH.GetAccuracy()) / 2.0000000;
        }
        // End:0x7E
        if(!mNoReticle)
        {
            DrawNative(Accuracy);
        }
    }
    //return;    
}

defaultproperties
{
    mReticleComponentMaterial=Material'TurokHud.Reticles.ReticleComponentMat'
    mReticleColor=(R=255,G=242,B=0,A=255)
    mReticleColorFoe=(R=255,G=0,B=0,A=255)
    mReticleColorFriend=(R=36,G=167,B=206,A=255)
    TempColor=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    mTestMultiplier=50.0000000
}