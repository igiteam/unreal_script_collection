class R6HostageController extends R6AIController
    native
    hidecategories(lighting);

enum eHostageTask
{
    eHostageFollowingPatrol,        // 0
    eHostageWaiting,                // 1
    eHostageRunningToExit,          // 2
    eHostageHiding,                 // 3
    eHostageTask_MAX                // 4
};

struct sHostageStimuli
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

var Vector m_vExitPoint;
var sHostageStimuli m_LastStimuli;
var R6HostageController.eHostageTask m_eCurrentTask;
var float m_fTimeStartedCurrentTask;
