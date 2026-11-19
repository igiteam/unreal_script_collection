class R6AnimNodeSubTrees extends AnimNode
    native
    hidecategories(Object,Object);

struct AnimTreeInfo
{
    var() AnimTree m_AnimTreeTemplate;
    var transient AnimTree m_AnimTree;

    structdefaultproperties
    {
        m_AnimTreeTemplate=none
        m_AnimTree=none
    }
};

var() AnimTreeInfo m_NormalAnimTreeInfo;
var() AnimTreeInfo m_TakeCoverAnimTreeInfo;
var() AnimTreeInfo m_RappelAnimTreeInfo;
var() AnimTreeInfo m_FastRopeAnimTreeInfo;
var() AnimTreeInfo m_ClimbingAnimTreeInfo;
var() AnimTreeInfo m_LadderAnimTreeInfo;
var() AnimTreeInfo m_TurretingAnimTreeInfo;
var() AnimTreeInfo m_HelicopterAnimTreeInfo;
var() AnimTreeInfo m_TerroMentalStateTreeInfo;
var AnimTree m_ActiveAnimTree;
var AnimTree m_LastActiveAnimTree;
var float m_fBlendTimeToGo;
var float m_fBlendDuration;
