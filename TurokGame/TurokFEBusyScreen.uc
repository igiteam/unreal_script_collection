class TurokFEBusyScreen extends TurokUISceneController
    native;

enum eIconAlignment
{
    ICONALIGN_Center,               // 0
    ICONALIGN_BottomRight,          // 1
    ICONALIGN_BottomLeft,           // 2
    ICONALIGN_Custom,               // 3
    ICONALIGN_MAX                   // 4
};

enum eCycleState
{
    CYCLESTATE_NotCycling,          // 0
    CYCLESTATE_TextCycle,           // 1
    CYCLESTATE_AltTextCycle,        // 2
    CYCLESTATE_MAX                  // 3
};

struct native TextCycler
{
    var byte mState;
    var @NULL mNextUpdateTime;
    var const @NULL kInitialDelay;
    var const @NULL kCycleDelay;

    structdefaultproperties
    {
        mState=0
        mNextUpdateTime=none
        kInitialDelay=none
        kCycleDelay=none
    }
};

var string mText;
var string mAltText;
var @NULL mTextCycler;
var() float mFadeTime;
var float mCurrentFade;
var int mFadeDir;
var bool mEatInput;
var const bool kDefaultEatInput;
var byte mAlignment;
var const byte kDefaultAlignment;
var() const @NULL kBottomRightPos;
var() const @NULL kBottomRightPos_SD;
var() const @NULL kBottomLeftPos;
var() const @NULL kBottomLeftPos_SD;
var const @NULL kBottomRightColor;
var const @NULL kBottomLeftColor;
var const @NULL kCentredColor;
var private @NULL mCustomPos;
var() const float kSouthGutter;
var() const float kEastGutter;
var init const string kDefaultText;
var float mTextScale;
var float mTextScaleSD;
var @NULL mBusyLabel;
var @NULL mBusyIcon;
var @NULL mBusyBGGlow;
var @NULL mBGGrayOut;
var private @NULL mBusyScene;
var @NULL mBusyFlipBook;

event SCInitialized()
{
    super.SCInitialized();
    mBusyLabel = UILabel(Scene.FindChild(name("Message")));
    // DebugMode: 0
    assert(mBusyLabel != none);
    mBusyIcon = UIImage(Scene.FindChild(name("BusyIcon")));
    // DebugMode: 0
    assert(mBusyIcon != none);
    mBusyBGGlow = UIImage(Scene.FindChild(name("BGGlowForCenterScreen")));
    // DebugMode: 0
    assert(mBusyBGGlow != none);
    mBGGrayOut = UIImage(Scene.FindChild(name("BGGrayOut")));
    // DebugMode: 0
    assert(mBGGrayOut != none);
    // End:0x10C
    if(Class'TurokUI'.static.IsSD())
    {
        mBusyLabel.SetScale(mTextScaleSD);        
    }
    else
    {
        mBusyLabel.SetScale(mTextScale);
    }
    mBusyLabel.SetValue(mText);
    UpdateAlignment();
    //return;    
}

event SCTick(float DeltaTime)
{
    mCurrentFade = mCurrentFade + (DeltaTime * float(mFadeDir));
    // End:0x35
    if(mCurrentFade > mFadeTime)
    {
        mCurrentFade = mFadeTime;
    }
    // End:0x62
    if(mCurrentFade < float(0))
    {
        SceneClient.GoBackSceneController(5);
        mCurrentFade = 0.0000000;
    }
    Scene.Opacity = mCurrentFade / mFadeTime;
    super.SCTick(DeltaTime);
    //return;    
}

event SCCleanUpOnExit()
{
    mBusyLabel = none;
    mBusyIcon = none;
    mBusyBGGlow = none;
    mBGGrayOut = none;
    //return;    
}

// Export UTurokFEBusyScreen::execInstance(FFrame&, void* const)
native static final function @NULL Instance();

// Export UTurokFEBusyScreen::execSetText(FFrame&, void* const)
native function SetText(string Text);

// Export UTurokFEBusyScreen::execSetAltText(FFrame&, void* const)
native function SetAltText(string AltText);

// Export UTurokFEBusyScreen::execSetEatInput(FFrame&, void* const)
native function SetEatInput(bool EatInput);

// Export UTurokFEBusyScreen::execSetAlignment(FFrame&, void* const)
native function SetAlignment(byte Alignment);

// Export UTurokFEBusyScreen::execSetAlignmentCustom(FFrame&, void* const)
native function SetAlignmentCustom(float X, float Y);

// Export UTurokFEBusyScreen::execOpen(FFrame&, void* const)
native function Open(@NULL scene_client);

// Export UTurokFEBusyScreen::execClose(FFrame&, void* const)
native function Close();

// Export UTurokFEBusyScreen::execSetToDefaults(FFrame&, void* const)
native function SetToDefaults();

// Export UTurokFEBusyScreen::execHideBusyWidget(FFrame&, void* const)
native function HideBusyWidget();

// Export UTurokFEBusyScreen::execStartTextCycle(FFrame&, void* const)
native function StartTextCycle(float InitialDelay, float CycleDelay);

// Export UTurokFEBusyScreen::execStopTextCycle(FFrame&, void* const)
native function StopTextCycle();

// Export UTurokFEBusyScreen::execIsTextCycling(FFrame&, void* const)
native function bool IsTextCycling();

// Export UTurokFEBusyScreen::execRefreshLabel(FFrame&, void* const)
native function RefreshLabel();

// Export UTurokFEBusyScreen::execUpdateAlignment(FFrame&, void* const)
native function UpdateAlignment();

defaultproperties
{
    mTextCycler=(mState=0,mNextUpdateTime=none,kInitialDelay=none,kCycleDelay=none)
    mFadeTime=0.5000000
    mAlignment=1
    kDefaultAlignment=1
    kBottomRightPos=(X=1150.0000000,Y=600.0000000)
    kBottomRightPos_SD=(X=852.0000000,Y=585.0000000)
    kBottomLeftPos=(X=96.0000000,Y=620.0000000)
    kBottomLeftPos_SD=(X=100.0000000,Y=620.0000000)
    kBottomRightColor=(R=255,G=161,B=0,A=255)
    kBottomLeftColor=(R=255,G=161,B=0,A=255)
    kCentredColor=(R=255,G=161,B=0,A=255)
    kSouthGutter=10.0000000
    kEastGutter=13.0000000
    mTextScale=0.8500000
    mTextScaleSD=1.0000000
    mBusyScene=UIScene'TurokFELoading.BusyWidget'
    mBusyFlipBook=TextureFlipBook'TurokFELoading.LoadingIndicatorFlipbook'
    SceneName="TurokFELoading.BusyWidget"
}