class R6CivilController extends R6AIController
    native
    hidecategories(lighting);

const NBMAX_EMOTIONS = 3;

enum eFearLevel
{
    eFear_Relaxed,                  // 0
    eFear_Alert,                    // 1
    eFear_Afraid,                   // 2
    eFear_MAX                       // 3
};

enum eTask
{
    eAsleep,                        // 0
    eFollowingPatrol,               // 1
    eWaiting,                       // 2
    eRunningToCover,                // 3
    eRunningToExit,                 // 4
    eRunningToFriend,               // 5
    eHiding,                        // 6
    eTask_MAX                       // 7
};

enum eEMOTIONTYPE
{
    EMOTION_CURIOUS,                // 0
    EMOTION_HEROIC,                 // 1
    EMOTION_PANICKED,               // 2
    EMOTION_MAX                     // 3
};

enum ePROFILETYPE
{
    ePROFILE_COWARD,                // 0
    ePROFILE_CURIOUS,               // 1
    ePROFILE_HEROIC,                // 2
    ePROFILE_CUSTOM_MANAGER,        // 3
    ePROFILE_CUSTOM,                // 4
    ePROFILE_MAX                    // 5
};

struct sCivilStimuli
{
    var int m_iEventType;
    var float m_fEventTime;
    var int m_iDangerLevel;
    var Actor m_pTarget;
    var Vector m_vLocation;
    var float m_fTimeRecovered;

    structdefaultproperties
    {
        m_iEventType=0
        m_fEventTime=0.0000000
        m_iDangerLevel=0
        m_pTarget=none
        m_vLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_fTimeRecovered=0.0000000
    }
};

struct Emotion
{
    var float m_fDecayValue;
    var float m_fEmotionThreshold;
    var float m_fEmotionValue;
    var float m_fCurrentValue;
    var float m_fStimuliValue;
    var int m_iNbStimuli;
    var float m_EmotionsImpact[3];
    var Vector m_vLastLocation;
    var Actor m_pLastActor;
    var float m_fCurrentEmotionTimer;
    var float m_fCurrentEmotionTime;

    structdefaultproperties
    {
        m_fDecayValue=0.0000000
        m_fEmotionThreshold=0.0000000
        m_fEmotionValue=0.0000000
        m_fCurrentValue=0.0000000
        m_fStimuliValue=0.0000000
        m_iNbStimuli=0
        m_EmotionsImpact[0]=0.0000000
        m_EmotionsImpact[1]=0.0000000
        m_EmotionsImpact[2]=0.0000000
        m_vLastLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pLastActor=none
        m_fCurrentEmotionTimer=0.0000000
        m_fCurrentEmotionTime=0.0000000
    }
};

var R6CivilManager m_pCivilManager;
var Vector m_vCoverPoint;
var Vector m_vExitPoint;
var int m_iNextNode;
var bool m_bReverse;
var bool m_bIsHostage;
var bool m_bCanBeShocked;
var bool m_bSeenRainbow;
var bool m_bSeenTerrorist;
var R6CivilController.eFearLevel m_eFearLevel;
var R6CivilController.eTask m_eCurrentTask;
var R6CivilController.ePROFILETYPE m_eCurentProfile;
var sCivilStimuli m_LastSightReaction;
var sCivilStimuli m_LastSoundReaction;
var float m_fTimeStartedCurrentTask;
var int m_iCurrentEmotion;
var Emotion m_EmotionArray[3];
