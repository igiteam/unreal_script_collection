class TurokHudCheckpoint extends TurokHudElement
    transient
    native;

enum eCheckpointHudAnimStep
{
    CHAS_FADE_IN,                   // 0
    CHAS_SHOW,                      // 1
    CHAS_FADE_OUT,                  // 2
    CHAS_MAX                        // 3
};

var private bool mIsShowing;
var private float mStartTime;
var private float mElapsedTime;
var private float mFadeInLength;
var private float mShowLength;
var private float mFadeOutLength;
var private byte mAnimState;
var private string mCheckpointStr;
var private @NULL mCheckpointColor;
var private @NULL mCheckpointFont;
var private float mFontScale;
var private float mFontScale_SD;

// Export UTurokHudCheckpoint::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudCheckpoint::execSetupNative(FFrame&, void* const)
native function SetupNative();

function ShowCheckpoint()
{
    mAnimState = 0;
    SetupNative();
    mIsShowing = true;
    //return;    
}

function Init(@NULL hudRef)
{
    super.Init(hudRef);
    mIsShowing = false;
    mAnimState = 0;
    mElapsedTime = 0.0000000;
    mStartTime = 0.0000000;
    //return;    
}

function Reset()
{
    super.Reset();
    mIsShowing = false;
    mAnimState = 0;
    mElapsedTime = 0.0000000;
    mStartTime = 0.0000000;
    //return;    
}

defaultproperties
{
    mFadeInLength=0.2500000
    mShowLength=3.0000000
    mFadeOutLength=1.0000000
    mCheckpointColor=(R=236,G=236,B=236,A=255)
    mCheckpointFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mFontScale=0.2990000
    mFontScale_SD=0.2990000
}