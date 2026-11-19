class TurokSeqAct_FullScreenVideo extends SeqAct_Latent
    native
    hidecategories(Object);

struct native SDVideoSettings
{
    var() bool mScaleAndCenter;
    var() float mScaleWidth;
    var() float mScaleHeight;

    structdefaultproperties
    {
        mScaleAndCenter=false
        mScaleWidth=0.0000000
        mScaleHeight=0.0000000
    }
};

var() @NULL mHDVideo;
var() @NULL mSDVideoSettings;
var() bool mHasMusic;
var bool mIsDone;
var bool mStopTriggered;
var @NULL mHud;

event MovieFinishedPlaying()
{
    mIsDone = true;
    //return;    
}

defaultproperties
{
    mHasMusic=true
    InputLinks[0]=(LinkDesc="Play",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    InputLinks[1]=(LinkDesc="Stop",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,DrawY=0,bHidden=false)
    OutputLinks[0]=(Links=none,LinkDesc="Done",bHasImpulse=false,bDisabled=false,bDisabledPIE=false,LinkAction="None",LinkedOp=none,ActivateDelay=0.0000000,DrawY=0,bHidden=false)
    ObjName="Full-Screen Video"
    ObjCategory="Turok Cinema"
}