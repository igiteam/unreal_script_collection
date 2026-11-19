class R6RandomAnim extends R6AnimContainerBase
    native
    hidecategories(Object);

struct R6RandomAnimInfo
{
    var() /*0x10000000-0x00000000*/ name m_AnimSeqName;
    var() float m_fProbability;

    structdefaultproperties
    {
        m_AnimSeqName="None"
        m_fProbability=0.0000000
    }
};

var() array<R6RandomAnimInfo> m_RandomAnims;
var() string m_Description;
