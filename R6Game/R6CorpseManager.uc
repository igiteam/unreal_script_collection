class R6CorpseManager extends Object
    native;

struct CorpseDesc
{
    var Actor m_pActor;
    var int m_iTriangleHintAtDeath;
    var int m_iZoneHintAtDeath;
    var Vector m_vPositionAtDeath;
    var int m_iLastShow;
    var float m_fVisibilityParam;
    var ENavMesh m_pCurrentNavMesh;

    structdefaultproperties
    {
        m_pActor=none
        m_iTriangleHintAtDeath=0
        m_iZoneHintAtDeath=0
        m_vPositionAtDeath=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iLastShow=0
        m_fVisibilityParam=0.0000000
        m_pCurrentNavMesh=none
    }
};

var private native const noexport Pointer VfTable_FTickableObject;
var array<CorpseDesc> m_aCorpse;
var array<R6AIController> m_aNotifyController;
var int m_iCurrentCorpseToShow;
var R6AIServiceManager m_pAIServiceManager;
