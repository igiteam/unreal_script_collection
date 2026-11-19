class TurokIdleNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

enum EIdleNodeAction
{
    IDLENODE_RandomIdle,            // 0
    IDLENODE_NamedGraph,            // 1
    IDLENODE_MAX                    // 2
};

enum EIdleNodeType
{
    IDLENODETYPE_Oriented,          // 0
    IDLENODETYPE_NoOrientation,     // 1
    IDLENODETYPE_MAX                // 2
};

enum EIdleNodePreset
{
    IDLENODEPRESET_Default,         // 0
    IDLENODEPRESET_HumanTyping,     // 1
    IDLENODEPRESET_HumanAlert,      // 2
    IDLENODEPRESET_HumanRadio,      // 3
    IDLENODEPRESET_HumanInvestigateLow0,// 4
    IDLENODEPRESET_HumanInvestigateLow1,// 5
    IDLENODEPRESET_HumanInvestigateHigh0,// 6
    IDLENODEPRESET_HumanInvestigateHigh1,// 7
    IDLENODEPRESET_HumanBored0,     // 8
    IDLENODEPRESET_RaptorEating,    // 9
    IDLENODEPRESET_RaptorAlert,     // 10
    IDLENODEPRESET_RaptorFrantic,   // 11
    IDLENODEPRESET_RaptorGrazing,   // 12
    IDLENODEPRESET_RaptorEating2,   // 13
    IDLENODEPRESET_RaptorMiniAlert, // 14
    IDLENODEPRESET_RaptorMiniEating,// 15
    IDLENODEPRESET_RaptorMiniBored, // 16
    IDLENODEPRESET_RaptorMiniCurious,// 17
    IDLENODEPRESET_GigaEating,      // 18
    IDLENODEPRESET_GigaRoar,        // 19
    IDLENODEPRESET_GigaInvestigate, // 20
    IDLENODEPRESET_GigaBreath,      // 21
    IDLENODEPRESET_GigaSneeze,      // 22
    IDLENODEPRESET_HadroEat0,       // 23
    IDLENODEPRESET_HadroEat1,       // 24
    IDLENODEPRESET_HadroAlert0,     // 25
    IDLENODEPRESET_HadroAlert1,     // 26
    IDLENODEPRESET_HadroAlt0,       // 27
    IDLENODEPRESET_DiloEating,      // 28
    IDLENODEPRESET_DiloGesturing,   // 29
    IDLENODEPRESET_RaptorMiniEating2,// 30
    IDLENODEPRESET_MAX              // 31
};

struct native TurokIdleNodePreset
{
    var byte mIdleNodePreset;
    var byte mAction;
    var byte mType;
    var name mGraphName;
    var name mExitGraphName;
    var float mMinTime;
    var float mMaxTime;
    var float mTriggerRadius;
    var int mMaxUsers;

    structdefaultproperties
    {
        mIdleNodePreset=0
        mAction=0
        mType=0
        mGraphName="None"
        mExitGraphName="None"
        mMinTime=0.0000000
        mMaxTime=0.0000000
        mTriggerRadius=0.0000000
        mMaxUsers=0
    }
};

var(Debug) byte mAction;
var(Debug) byte mType;
var(Debug) byte mPresetType;
var(Preset) byte mControllerType;
var(Preset) array mPresetList;
var(Debug) @NULL mGraphSet;
var(Debug) name mGraphName;
var(Debug) name mExitGraphName;
var(Debug) float mTriggerRadius;
var(Debug) int mMaxUsers;
var(Preset) @NULL mIdlePreset[31];
var(Preset) bool mUseOverrideTime;
var(Preset) float mMinTime;
var(Preset) float mMaxTime;
var int mNumUsers;
var float mTime;

// Export UTurokIdleNode::execSetDefaultParameters(FFrame&, void* const)
native function SetDefaultParameters();

defaultproperties
{
    mType=1
    mControllerType=4
    mTriggerRadius=150.0000000
    mMaxUsers=10
    mIdlePreset[0]=(mIdleNodePreset=0,mAction=0,mType=1,mGraphName="None",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=10)
    mIdlePreset[1]=(mIdleNodePreset=1,mAction=1,mType=0,mGraphName="humanTyping0",mExitGraphName="humanTypingEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=50.0000000,mMaxUsers=1)
    mIdlePreset[2]=(mIdleNodePreset=2,mAction=1,mType=0,mGraphName="humanAlert0",mExitGraphName="humanAlertEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[3]=(mIdleNodePreset=3,mAction=1,mType=0,mGraphName="humanRadio0",mExitGraphName="humanRadioEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[4]=(mIdleNodePreset=4,mAction=1,mType=0,mGraphName="humanInvestigateLow0",mExitGraphName="humanInvestigateLowEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[5]=(mIdleNodePreset=5,mAction=1,mType=0,mGraphName="humanInvestigateLow1",mExitGraphName="humanInvestigateLowEnd1",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[6]=(mIdleNodePreset=6,mAction=1,mType=0,mGraphName="humanInvestigateHigh0",mExitGraphName="humanInvestigateHighEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[7]=(mIdleNodePreset=7,mAction=1,mType=0,mGraphName="humanInvestigateHigh1",mExitGraphName="humanInvestigateHighEnd1",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[8]=(mIdleNodePreset=8,mAction=1,mType=0,mGraphName="humanBored0",mExitGraphName="humanBoredEnd0",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=1)
    mIdlePreset[9]=(mIdleNodePreset=9,mAction=1,mType=1,mGraphName="Eating",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[10]=(mIdleNodePreset=10,mAction=1,mType=1,mGraphName="alert",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[11]=(mIdleNodePreset=11,mAction=1,mType=1,mGraphName="Frantic",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[12]=(mIdleNodePreset=12,mAction=1,mType=1,mGraphName="Frantic",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[13]=(mIdleNodePreset=13,mAction=1,mType=1,mGraphName="Eating02In",mExitGraphName="eating02out",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[14]=(mIdleNodePreset=14,mAction=1,mType=1,mGraphName="alert01",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[15]=(mIdleNodePreset=15,mAction=1,mType=1,mGraphName="intoeat01",mExitGraphName="outofeat01",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[16]=(mIdleNodePreset=16,mAction=1,mType=1,mGraphName="bored01",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[17]=(mIdleNodePreset=17,mAction=1,mType=1,mGraphName="curious",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[18]=(mIdleNodePreset=18,mAction=1,mType=1,mGraphName="eatingidle",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[19]=(mIdleNodePreset=19,mAction=1,mType=1,mGraphName="roaridle",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[20]=(mIdleNodePreset=20,mAction=1,mType=1,mGraphName="InvestigateIn",mExitGraphName="InvestigateOut",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[21]=(mIdleNodePreset=21,mAction=1,mType=1,mGraphName="breathIdle",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[22]=(mIdleNodePreset=22,mAction=1,mType=1,mGraphName="sneezeidle",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mIdlePreset[23]=(mIdleNodePreset=23,mAction=1,mType=1,mGraphName="EatIdleIn1",mExitGraphName="EatIdleOut1",mMinTime=5.0000000,mMaxTime=15.0000000,mTriggerRadius=250.0000000,mMaxUsers=4)
    mIdlePreset[24]=(mIdleNodePreset=24,mAction=1,mType=1,mGraphName="EatIdleIn2",mExitGraphName="EatIdleOut2",mMinTime=5.0000000,mMaxTime=15.0000000,mTriggerRadius=250.0000000,mMaxUsers=4)
    mIdlePreset[25]=(mIdleNodePreset=25,mAction=1,mType=1,mGraphName="HadroAlert1Into",mExitGraphName="HadroAlert1Out",mMinTime=5.0000000,mMaxTime=15.0000000,mTriggerRadius=250.0000000,mMaxUsers=4)
    mIdlePreset[26]=(mIdleNodePreset=26,mAction=1,mType=1,mGraphName="HadroAlert2Into",mExitGraphName="HadroAlert2Out",mMinTime=5.0000000,mMaxTime=15.0000000,mTriggerRadius=250.0000000,mMaxUsers=4)
    mIdlePreset[27]=(mIdleNodePreset=27,mAction=1,mType=1,mGraphName="HadroAltInto",mExitGraphName="HadroAltOut",mMinTime=5.0000000,mMaxTime=15.0000000,mTriggerRadius=250.0000000,mMaxUsers=4)
    mIdlePreset[28]=(mIdleNodePreset=28,mAction=1,mType=1,mGraphName="Eating",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=1)
    mIdlePreset[29]=(mIdleNodePreset=29,mAction=1,mType=1,mGraphName="ShakeGesture",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=1)
    mIdlePreset[30]=(mIdleNodePreset=30,mAction=1,mType=1,mGraphName="intoeat02",mExitGraphName="outofeat01",mMinTime=2.0000000,mMaxTime=5.0000000,mTriggerRadius=50.0000000,mMaxUsers=5)
    mMinTime=-1.0000000
    mMaxTime=-1.0000000
    // Reference: SpriteComponent'Default__TurokIdleNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokIdleNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    // Reference: CylinderComponent'Default__TurokIdleNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokIdleNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokIdleNode'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokIdleNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokIdleNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokIdleNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}