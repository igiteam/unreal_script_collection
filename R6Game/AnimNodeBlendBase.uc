class AnimNodeBlendBase extends AnimNode
    abstract
    native
    hidecategories(Object,Object);

struct AnimBlendChild
{
    var() name Name;
    var export AnimNode Anim;
    var int m_iAnimLeafIndex;
    var float Weight;
    var int DrawY;
    var name m_AnimNodeName;
    var bool m_bAlwaysTick;
    var() const editconst class<AnimNode> m_BaseAnimClass;

    structdefaultproperties
    {
        Name="None"
        Anim=none
        m_iAnimLeafIndex=-1
        Weight=0.0000000
        DrawY=0
        m_AnimNodeName="None"
        m_bAlwaysTick=false
        m_BaseAnimClass=Class'AnimNode'
    }
};

var() export editinline array<export editinline AnimBlendChild> Children;
var() array<AnimLeaf> m_AnimLeafChildren;
var() bool m_bOnlyTickChildrenWithWeight;
var() bool m_bTickChildrenInOrder;
var bool bFixNumChildren;
var bool m_bPostEditChangeCalled;

defaultproperties
{
    m_bOnlyTickChildrenWithWeight=true
}