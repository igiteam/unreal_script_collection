class TurokHudDinoMelee extends TurokHudElement
    transient
    native;

const UPDOWNMAXFRAMES = 4;
const LEFTRIGHTMAXFRAMES = 4;
const TRIGGERMAXFRAMES = 2;
const FRAMESPERROW = 4;

var @NULL mAnimTexture360;
var @NULL mAnimTexturePS3;
var string mRtText;
var string mLtText;
var string mLsText;
var @NULL mTextFont;
var float mTextScale;
var int mUpDownFramesOrder[4];
var int mLeftRightFramesOrder[4];
var int mTriggerFramesOrder[2];
var int mStickCurFrame;
var int mTrigCurFrame;
var float mTriggerAnimTime;
var float mTriggerAnimLength;
var float mStickAnimTime;
var float mStickAnimLength;
var byte mState;
var bool mbRunning;
var float mPosition;
var int mTileSizeX;
var int mTileSizeY;
var int mTriggerTileOffsetX;
var int mTriggerTileOffsetY;
var int mUpDownTileOffsetX;
var int mUpDownTileOffsetY;
var int mLeftRightTileOffsetX;
var int mLeftRightTileOffsetY;
var int mTriggerTextOffsetX;
var int mTriggerTextOffsetY;
var int mLeftRightTextOffsetX;
var int mLeftRightTextOffsetY;
var int mUpDownTextOffsetX;
var int mUpDownTextOffsetY;
var int mTriggerOffsetX;
var int mTriggerOffsetY;
var int mLeftRightOffsetX;
var int mLeftRightOffsetY;
var int mUpDownOffsetX;
var int mUpDownOffsetY;
var int mAlternatingSpacing;

// Export UTurokHudDinoMelee::execDraw(FFrame&, void* const)
native simulated function Draw();

// Export UTurokHudDinoMelee::execReset(FFrame&, void* const)
native simulated function Reset();

// Export UTurokHudDinoMelee::execGetAnimTexture(FFrame&, void* const)
native simulated function @NULL GetAnimTexture();

function DrawPrioritized(@NULL HUD)
{
    Draw();
    //return;    
}

// Export UTurokHudDinoMelee::execDrawKnifeKillIcon(FFrame&, void* const)
native function DrawKnifeKillIcon(int XPos, int YPos);

function Init(@NULL HUD)
{
    super.Init(HUD);
    mRtText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(1825738297);
    mLtText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-792365991);
    mLsText = Class'TurokEngine.TurokUI'.static.GetLocalizedString(-1475588951);
    //return;    
}

function SetState(byte NewState)
{
    mState = NewState;
    //return;    
}

function Start()
{
    mbRunning = true;
    mHud.AddPrioritizedDrawCall(DrawPrioritized, self, 5);
    //return;    
}

function Stop()
{
    mbRunning = false;
    mHud.RemovePrioritizedDrawCall(self);
    //return;    
}

defaultproperties
{
    mAnimTexture360=Texture2D'TurokHud.DinoMelee.DinoMauling_360_HD'
    mAnimTexturePS3=Texture2D'TurokHud.DinoMelee.DinoMauling_PS3_HD'
    mTextFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTextScale=0.3280000
    mUpDownFramesOrder[0]=3
    mUpDownFramesOrder[2]=3
    mUpDownFramesOrder[3]=4
    mLeftRightFramesOrder[0]=2
    mLeftRightFramesOrder[1]=3
    mLeftRightFramesOrder[2]=1
    mLeftRightFramesOrder[3]=3
    mTriggerFramesOrder[0]=5
    mTriggerFramesOrder[1]=6
    mTriggerAnimLength=0.1300000
    mStickAnimLength=0.0900000
    mState=1
    mPosition=0.7000000
    mTileSizeX=128
    mTileSizeY=128
    mTriggerTextOffsetX=19
    mTriggerTextOffsetY=45
    mLeftRightTextOffsetY=83
    mUpDownTextOffsetY=83
    mTriggerOffsetX=8
    mAlternatingSpacing=25
}