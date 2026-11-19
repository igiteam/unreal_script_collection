class TurokUIInviteNotification extends TurokUISceneController
    native;

var private @NULL mStaticReferenceScene;
var @NULL mFont;
var @NULL mInviteText;
var @NULL mBGLeft;
var @NULL mBGMiddle;
var @NULL mBGRight;
var @NULL mIcon;
var private float mFadeTime;
var private float mCurrentFade;
var private float mFadeDir;
var private float mFadeInRate;
var private float mFadeOutRate;
var private float mLife;
var private bool mIsInitialized;

// Export UTurokUIInviteNotification::execInstance(FFrame&, void* const)
native static final function @NULL Instance();

// Export UTurokUIInviteNotification::execInitialize(FFrame&, void* const)
native function Initialize(@NULL pScene, @NULL pSceneClient);

// Export UTurokUIInviteNotification::execDeinitialize(FFrame&, void* const)
native function Deinitialize();

// Export UTurokUIInviteNotification::execShutDown(FFrame&, void* const)
native function ShutDown();

// Export UTurokUIInviteNotification::execShow(FFrame&, void* const)
native function Show(string Message);

// Export UTurokUIInviteNotification::execTick(FFrame&, void* const)
native function Tick(float elapsed);

// Export UTurokUIInviteNotification::execUpdatePositions(FFrame&, void* const)
private native final function UpdatePositions();

event SCCleanUpOnExit()
{
    Deinitialize();
    //return;    
}

defaultproperties
{
    mStaticReferenceScene=UIScene'TurokFEInviteNotification.InviteNotification'
    mFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mFadeTime=1.0000000
    mFadeDir=4.0000000
    mFadeInRate=4.0000000
    mFadeOutRate=-0.5000000
    SceneName="TurokFEInviteNotification.InviteNotification"
}