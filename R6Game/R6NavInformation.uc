class R6NavInformation extends Object
    native;

enum EWaitPointsTopBottom
{
    WAITPOINTS_TB_BOTTOM,           // 0
    WAITPOINTS_TB_TOP,              // 1
    WAITPOINTS_TB_MAX               // 2
};

enum EWaitPointsLeftRight
{
    WAITPOINTS_LR_LEFT,             // 0
    WAITPOINTS_LR_RIGHT,            // 1
    WAITPOINTS_LR_MAX               // 2
};

enum EWaitListToUseCriteria
{
    WAITLIST_CRITERIA_AskNavObject, // 0
    WAITLIST_CRITERIA_ZCloseness,   // 1
    WAITLIST_CRITERIA_MAX           // 2
};

struct WaitPoint
{
    var Vector m_vWaitLocation;
    var Pawn m_pCurrentOwner;
    var bool m_bCoverPos;

    structdefaultproperties
    {
        m_vWaitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_pCurrentOwner=none
        m_bCoverPos=false
    }
};

struct ExtraWaitPointArray
{
    var array<WaitPoint> m_aWaitPoints;

    structdefaultproperties
    {
        m_aWaitPoints=none
    }
};

var array<WaitPoint> m_aWaitPoints0;
var array<WaitPoint> m_aWaitPoints1;
var array<ExtraWaitPointArray> m_aExtraWaitPoints;
var R6InteractiveActor m_pInteractiveActor;
var R6Geo m_pGeo;
var int m_iWaitListToUseCriteria;
