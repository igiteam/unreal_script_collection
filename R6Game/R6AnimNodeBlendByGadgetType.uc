class R6AnimNodeBlendByGadgetType extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

enum EGadgetBlendType
{
    GADGETBLENDTYPE_ALL,            // 0
    GADGETBLENDTYPE_LEFTARM,        // 1
    GADGETBLENDTYPE_LEFTARM_AND_HEAD,// 2
    GADGETBLENDTYPE_UPPERBODY,      // 3
    GADGETBLENDTYPE_MAX             // 4
};

var() R6GameEnums.EAnimTreeType m_eType;
var transient R6AnimNodeBlendByGadgetType.EGadgetBlendType m_eBlendType;
var transient bool m_bUsePosture;
var transient bool m_bSeqAdditive;
var transient int m_iSeqPlaying;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}