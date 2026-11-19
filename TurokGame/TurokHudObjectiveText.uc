class TurokHudObjectiveText extends TurokHudElement
    transient
    native;

const OBJECTIVE_BUFFER_SIZE = 10;
const kT_ObjectiveHudTitle = 1780702694;

var string mObjectiveTitle;
var string mObjectiveText1;
var string mObjectiveText2;
var string mObjectiveText3;
var array mObjectiveBuffer;
var @NULL mTitleFont;
var @NULL mTextFont;
var float mTitleScale;
var float mModifiedTitleScale;
var float mTextScale;
var float mModifiedTextScale;
var int mTitleWidth;
var int mText1Width;
var int mText2Width;
var int mText3Width;
var int mTitleSpacing;
var int mTextSpacing;
var float mAnimTime;
var float mAnimLength;
var float mFadeInAnimTime;
var float mFadeInAnimLength;
var float mFadeOutAnimTime;
var float mFadeOutAnimLength;
var float mScreenPosX;
var float mBufferedSpeedModifier;
var @NULL mObjectiveTitleColor;
var @NULL mObjectiveTextColor;
var int mCurrentlyRenderingHash;
var bool mObjectivesBuffered;

// Export UTurokHudObjectiveText::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudObjectiveText::execStartAnim(FFrame&, void* const)
native function StartAnim(string Text);

// Export UTurokHudObjectiveText::execInitObjText(FFrame&, void* const)
native function InitObjText(int textHash);

// Export UTurokHudObjectiveText::execSplitString(FFrame&, void* const)
native function SplitString(string Text);

// Export UTurokHudObjectiveText::execSquelch(FFrame&, void* const)
native function Squelch();

// Export UTurokHudObjectiveText::execResetObjText(FFrame&, void* const)
native function ResetObjText();

defaultproperties
{
    mTitleFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTextFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mTitleScale=0.2990000
    mTextScale=0.8570000
    mTitleSpacing=25
    mTextSpacing=23
    mAnimTime=5.0000000
    mAnimLength=4.0000000
    mFadeInAnimTime=2.0000000
    mFadeInAnimLength=0.0625000
    mFadeOutAnimTime=3.0000000
    mFadeOutAnimLength=2.0000000
    mScreenPosX=0.2500000
    mBufferedSpeedModifier=1.0000000
    mObjectiveTitleColor=(R=118,G=247,B=245,A=255)
    mObjectiveTextColor=(R=215,G=255,B=255,A=255)
}