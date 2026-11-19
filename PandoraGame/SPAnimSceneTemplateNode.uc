class SPAnimSceneTemplateNode extends SPAnimBaseNode
    native;

struct native SceneAnimStruct
{
    var name sceneAnimName;
    var int playCount;

    structdefaultproperties
    {
        sceneAnimName="None"
        playCount=0
    }
};

var bool m_bPlayNewScene;
var SceneAnimStruct m_newScene;
var SceneAnimStruct m_currentScene;
var SeqAct_PlaySceneAnimation m_seqAct;
var float m_delayedStartTime;
var AnimNodeSequence.ERootBoneAxis m_rootBoneOption;

// Export USPAnimSceneTemplateNode::execPlayNewScene(FFrame&, void* const)
native function PlayNewScene(name AnimName, int playCount, SeqAct_PlaySceneAnimation pSeqAct, float DesiredBlendTime, optional float StartTime, optional AnimNodeSequence.ERootBoneAxis RootBoneOption = 2);

// Export USPAnimSceneTemplateNode::execGetActiveChild(FFrame&, void* const)
native function AnimNodeSequence GetActiveChild();

// Export USPAnimSceneTemplateNode::execPlayQueuedScene(FFrame&, void* const)
native function PlayQueuedScene();

event OnInit()
{
    NodeName = 'SceneTemplateNode';
    super(AnimNode).OnInit();
    //return;    
}
