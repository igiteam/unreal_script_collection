class TurokHudTeamNotification extends TurokHudElement
    transient
    native;

enum eTeamNotificationAnimStep
{
    TNAS_FADE_IN,                   // 0
    TNAS_SHOW,                      // 1
    TNAS_FADE_OUT,                  // 2
    TNAS_MAX                        // 3
};

var private bool mIsShowing;
var private int mTeamIndex;
var private float mStartTime;
var private float mElapsedTime;
var private float mFadeInLength;
var private float mShowLength;
var private float mFadeOutLength;
var private byte mAnimState;
var private @NULL mWolfPackLogo;
var private @NULL mWhiskeyLogo;
var private @NULL mTextBackdrop;
var private @NULL mTeamLogo;
var private string mYouAre;
var private string mTeamName;
var private @NULL mWhiskeyColor;
var private @NULL mWolfpackColor;
var private @NULL mTeamFont;
var private float mSmallFontScale;
var private float mLargeFontScale;
var private @NULL mYouAreSize;
var private @NULL mTeamNameSize;

// Export UTurokHudTeamNotification::execDrawNative(FFrame&, void* const)
native function DrawNative();

// Export UTurokHudTeamNotification::execSetupNative(FFrame&, void* const)
native function SetupNative();

function ShowTeamNotification(int TeamIndex)
{
    mTeamIndex = TeamIndex;
    mAnimState = 0;
    SetupNative();
    mIsShowing = true;
    //return;    
}

function Init(@NULL hudRef)
{
    super.Init(hudRef);
    mIsShowing = false;
    mTeamIndex = -1;
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
    mTeamIndex = -1;
    mElapsedTime = 0.0000000;
    mStartTime = 0.0000000;
    //return;    
}

defaultproperties
{
    mTeamIndex=-1
    mFadeInLength=0.2500000
    mShowLength=2.0000000
    mFadeOutLength=2.0000000
    mWolfPackLogo=Texture2D'TurokHudMultiplayer.TeamNotification.TeamID_Logo_WP'
    mWhiskeyLogo=Texture2D'TurokHudMultiplayer.TeamNotification.TeamID_Logo_WC'
    mTextBackdrop=Texture2D'TurokHudMultiplayer.TeamNotification.Text_BG_Backdrop'
    mWhiskeyColor=(R=255,G=163,B=0,A=255)
    mWolfpackColor=(R=92,G=181,B=246,A=255)
    mTeamFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mSmallFontScale=0.3134000
    mLargeFontScale=0.4478000
}