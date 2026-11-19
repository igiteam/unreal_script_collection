class TurokSeqAct_AudioDucker extends SequenceAction
    hidecategories(Object);

struct native AudioDuckerCommand
{
    var() name mSoundGroupName;
    var() float mTargetVolume;
    var() float mCurrVolume;
    var() float mFadeVolPerSec;

    structdefaultproperties
    {
        mSoundGroupName="None"
        mTargetVolume=0.0000000
        mCurrVolume=0.0000000
        mFadeVolPerSec=0.0000000
    }
};

var() name mDuckerName;
var() bool mRestoreVolumes;
var() float mFadeTime;
var() array mDuckerCommands;

event Activated()
{
    //return;    
}

defaultproperties
{
    mDuckerCommands=/* Array type was not detected. */
    ObjName="Audio Ducker"
    ObjCategory="Turok Audio"
}