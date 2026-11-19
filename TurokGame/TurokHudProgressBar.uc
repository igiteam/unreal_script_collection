class TurokHudProgressBar extends TurokHudElement
    transient
    native;

var private @NULL mBackgroundColor;
var private @NULL mForegroundColor;
var private int mYPos;
var private int mOffsetX;
var private int mOffsetY;
var private int mWidth;
var private int mDefaultWidth;
var private float mAnimTime;
var private float mAnimLength;
var private bool mbPaused;
var private bool mbStopped;
var private @NULL mBackgroundCornerCoords;
var private @NULL mForegroundCornerCoords;
var private @NULL mBackgroundMiddleCoords;
var private @NULL mForegroundMiddleCoords;
var private int mBackgroundCornerWidth;
var private int mBackgroundCornerHeight;
var private int mForegroundCornerWidth;
var private int mForegroundCornerHeight;
var private int mBackgroundMiddleWidth;
var private int mBackgroundMiddleHeight;
var private int mForegroundMiddleWidth;
var private int mForegroundMiddleHeight;
var private @NULL mBackgroundCornerTexture;
var private @NULL mBackgroundMiddleTexture;
var private @NULL mForegroundCornerTexture;
var private @NULL mForegroundMiddleTexture;

// Export UTurokHudProgressBar::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudProgressBar::execDrawProgressBar(FFrame&, void* const)
native function DrawProgressBar(@NULL kHud, float kProgressPercentage);

// Export UTurokHudProgressBar::execInit(FFrame&, void* const)
native function Init(@NULL hudRef);

// Export UTurokHudProgressBar::execSetWidth(FFrame&, void* const)
native function SetWidth(int kWidth);

// Export UTurokHudProgressBar::execGetWidth(FFrame&, void* const)
native function int GetWidth();

// Export UTurokHudProgressBar::execStart(FFrame&, void* const)
native function Start(float kAnimLength, optional int kWidth, optional float kPercentComplete);

// Export UTurokHudProgressBar::execRestart(FFrame&, void* const)
native function Restart();

// Export UTurokHudProgressBar::execStop(FFrame&, void* const)
native function Stop();

// Export UTurokHudProgressBar::execPause(FFrame&, void* const)
native function Pause();

defaultproperties
{
    mBackgroundColor=(R=255,G=255,B=255,A=255)
    mForegroundColor=(R=255,G=0,B=0,A=153)
    mYPos=523
    mOffsetX=10
    mOffsetY=9
    mWidth=300
    mDefaultWidth=150
    mAnimTime=100000.0000000
    mAnimLength=5.0000000
    mbStopped=true
    mBackgroundCornerCoords=(X=1.0000000,Y=1.0000000)
    mBackgroundMiddleCoords=(X=0.0000000,Y=1.0000000)
    mBackgroundCornerWidth=15
    mBackgroundCornerHeight=26
    mForegroundCornerWidth=4
    mForegroundCornerHeight=8
    mBackgroundMiddleWidth=4
    mBackgroundMiddleHeight=26
    mForegroundMiddleWidth=4
    mForegroundMiddleHeight=8
    mBackgroundCornerTexture=Texture2D'TurokHudMultiplayer.ProgressBar.BG_Edge'
    mBackgroundMiddleTexture=Texture2D'TurokHudMultiplayer.ProgressBar.BG_Middle'
    mForegroundCornerTexture=Texture2D'TurokHudMultiplayer.ProgressBar.Fill_Edge'
    mForegroundMiddleTexture=Texture2D'TurokHudMultiplayer.ProgressBar.Fill_Middle'
}