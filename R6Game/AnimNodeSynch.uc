class AnimNodeSynch extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

struct SynchGroup
{
    structcpptext
    {

    TArrayNoInit<struct FAnimLeaf*> m_AnimLeafs;
    struct FAnimLeaf* m_MasterLeaf;
    BYTE m_eChildrenToSyncType;

    /** Constructors */
    FSynchGroup() {}
    FSynchGroup(EEventParm)
    {
        appMemzero(this, sizeof(FSynchGroup));
    }

    }

    var noexport transient array<Pointer> m_AnimLeafs;
    var noexport transient Pointer m_MasterLeaf;
    var() noexport R6EngineEnums.EAnimSyncType m_eChildrenToSyncType;

    structdefaultproperties
    {
        m_AnimLeafs=none
        m_MasterLeaf=none
        m_eChildrenToSyncType=0
    }
};

var() array<SynchGroup> Groups;

defaultproperties
{
    Children[0]=(Name="Input",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}