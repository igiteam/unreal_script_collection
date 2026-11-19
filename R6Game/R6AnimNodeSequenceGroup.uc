class R6AnimNodeSequenceGroup extends AnimNodeSequence
    native
    hidecategories(Object,Object,Actor,Object);

struct AnimInfo
{
    var() /*0x10000000-0x00000000*/ name m_AnimName;

    structdefaultproperties
    {
        m_AnimName="None"
    }
};

var() editinline array<editinline AnimInfo> m_AnimList;
var() bool m_bUseRootMotion;
var transient int m_iCurrAnim;
var transient Vector m_vRootOffset;
var transient Quat m_qRootOffset;
var transient bool m_bFirstRootFrame;
var transient Vector m_vFirstRootOffset;
var transient Vector m_vLastRootOffset;
var transient Quat m_qFirstRootOffset;
var transient Quat m_qLastRootOffset;
