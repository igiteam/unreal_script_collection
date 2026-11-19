class AnimSequence extends Object
    native
    hidecategories(Object);

struct AnimNotifyEvent
{
    var() float Time;
    var() editinline AnimNotify Notify;
    var() name Comment;
    var() bool PlayOnReverse;
    var() bool m_bAlwaysPlay;

    structdefaultproperties
    {
        Time=0.0000000
        Notify=none
        Comment="None"
        PlayOnReverse=false
        m_bAlwaysPlay=false
    }
};

struct RawBoneAtom
{
    var Vector Translation;
    var Quat Rotation;

    structdefaultproperties
    {
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
    }
};

struct RawAnimPose
{
    var array<RawBoneAtom> RawBoneAtoms;

    structdefaultproperties
    {
        RawBoneAtoms=none
    }
};

var name SequenceName;
var() editinline array<editinline AnimNotifyEvent> Notifies;
var float SequenceLength;
var int NumFrames;
var() float RateScale;
var() string m_Comment;
var() bool m_bForce15FPS;
var() bool m_bQuatCompression;
var() bool m_bTranslationCompression;
var() bool m_bDuplicateKeyRemoval;
var bool m_bIsAdditive;
var bool m_bSuperCompressedQuat;
var bool m_bCompressedQuat;
var bool m_bCompressKeytimes;
var bool m_bNoCompression;
var bool m_bSkipFirstFrame;
var bool m_bIgnoreLastFrame;
var() float m_fDuplicateTresholdMultiplier;
var string m_SourceFBXPath;
var transient AnimSequence m_AdditiveRef;
var int m_iOriginalNbFrames;
var native const LazyArray_Mirror m_CameraInfo;
var native const LazyArray_Mirror RawAnimData;
var native const array<Quat> RawRootRotKeys;
var native const array<Vector> RawRootPosKeys;
var native const LazyArray_Mirror RawAnimDataFull;

defaultproperties
{
    RateScale=1.0000000
    m_bQuatCompression=true
    m_bTranslationCompression=true
    m_fDuplicateTresholdMultiplier=1.0000000
}