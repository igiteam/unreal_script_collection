class TurokUIGamertag extends UIObject
    native
    hidecategories(Object,UIRoot,Object);

var @NULL mGamertagLabel;
var @NULL mGamerscoreLabel;
var() @NULL mGamertagTextColor;
var() @NULL mGamerscoreTextColor;
var() float mFadeAnimTime;
var() int mTagScoreSpacing;
var() string mStyleName;
var() float mTextScale;
var string mGamertagText;
var string mGamerscore;
var string mMaxGamerscore;
var bool mbGamerTagRefreshed;
var private @NULL mAchievements;

// Export UTurokUIGamertag::execTick(FFrame&, void* const)
native function Tick();

// Export UTurokUIGamertag::execStartFadeIn(FFrame&, void* const)
native function StartFadeIn();

// Export UTurokUIGamertag::execStartFadeOut(FFrame&, void* const)
native function StartFadeOut();

// Export UTurokUIGamertag::execPostSetupInitialize(FFrame&, void* const)
native function PostSetupInitialize();

// Export UTurokUIGamertag::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokUIGamertag::execProcessInput(FFrame&, void* const)
native function bool ProcessInput(int kControllerId, name kKey, byte kEvent, float kAmountDepressed);

// Export UTurokUIGamertag::execNotifyReadAchievementsCompleted(FFrame&, void* const)
native function NotifyReadAchievementsCompleted(bool bSuccessful);

defaultproperties
{
    mGamertagTextColor=(R=238,G=149,B=45,A=255)
    mGamerscoreTextColor=(R=103,G=67,B=19,A=255)
    mFadeAnimTime=0.1250000
    mTagScoreSpacing=20
    mStyleName="TurokMenuFont_ConduitTCBoldCombo"
    mTextScale=0.7200000
    mGamertagText="myGamerTag"
    mGamerscore="0"
    mMaxGamerscore="1000"
    // Reference: UIComp_Event'Default__TurokUIGamertag.WidgetEventComponent'
    begin object name=WidgetEventComponent
    end object
    EventProvider=WidgetEventComponent
}