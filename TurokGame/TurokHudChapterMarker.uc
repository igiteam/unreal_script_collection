class TurokHudChapterMarker extends TurokHudElement
    transient
    native;

enum eChapterMarkerAnimStep
{
    CMAS_FADE_IN,                   // 0
    CMAS_SHOW,                      // 1
    CMAS_FADE_OUT,                  // 2
    CMAS_MAX                        // 3
};

var private bool mIsShowing;
var private int mChapterNum;
var private float mStartTime;
var private float mElapsedTime;
var private float mFadeInLength;
var private float mShowLength;
var private float mFadeOutLength;
var private byte mAnimState;
var private @NULL mBgTexture;
var private string mChapterTitleStr;
var private @NULL mChapterTitleColor;
var private @NULL mChapterFont;
var private float mLargeFontScale;
var private float mLargeFontScale_SD;

// Export UTurokHudChapterMarker::execDrawNative(FFrame&, void* const)
native function DrawNative();

// Export UTurokHudChapterMarker::execSetupNative(FFrame&, void* const)
native function SetupNative();

function ShowChapterMarker(int chapterNum)
{
    mChapterNum = chapterNum;
    mAnimState = 0;
    SetupNative();
    mIsShowing = true;
    //return;    
}

function Init(@NULL hudRef)
{
    super.Init(hudRef);
    mIsShowing = false;
    mChapterNum = -1;
    mAnimState = 0;
    mElapsedTime = 0.0000000;
    mStartTime = 0.0000000;
    //return;    
}

function Draw()
{
    // End:0x13
    if(mIsShowing)
    {
        DrawNative();
    }
    //return;    
}

function Reset()
{
    super.Reset();
    mIsShowing = false;
    mChapterNum = -1;
    mAnimState = 0;
    mElapsedTime = 0.0000000;
    mStartTime = 0.0000000;
    //return;    
}

defaultproperties
{
    mChapterNum=-1
    mFadeInLength=0.2500000
    mShowLength=5.0000000
    mFadeOutLength=5.0000000
    mBgTexture=Texture2D'TurokHud.Chaptermarker_BG'
    mChapterTitleColor=(R=255,G=174,B=0,A=255)
    mChapterFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mLargeFontScale=0.4030000
    mLargeFontScale_SD=0.3433000
}