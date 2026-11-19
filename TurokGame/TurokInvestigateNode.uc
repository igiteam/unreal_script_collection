class TurokInvestigateNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

enum EInvestigateNodeAction
{
    INVESTIGATENODE_RandomGraph,    // 0
    INVESTIGATENODE_NamedGraph,     // 1
    INVESTIGATENODE_MAX             // 2
};

enum EInvestigateNodeType
{
    INVESTIGATENODETYPE_Oriented,   // 0
    INVESTIGATENODETYPE_NoOrientation,// 1
    INVESTIGATENODETYPE_MAX         // 2
};

enum EInvestigateNodePreset
{
    INVESTIGATENODEPRESET_Default,  // 0
    INVESTIGATENODEPRESET_InvestigateLow0,// 1
    INVESTIGATENODEPRESET_InvestigateLow1,// 2
    INVESTIGATENODEPRESET_InvestigateHigh0,// 3
    INVESTIGATENODEPRESET_InvestigateHigh1,// 4
    INVESTIGATENODEPRESET_MAX       // 5
};

struct native TurokInvestigateNodePreset
{
    var byte mAction;
    var byte mType;
    var name mGraphName;
    var name mExitGraphName;
    var float mMinTime;
    var float mMaxTime;
    var float mTriggerRadius;
    var int mMaxUsers;
    var float mProximity;

    structdefaultproperties
    {
        mAction=0
        mType=0
        mGraphName="None"
        mExitGraphName="None"
        mMinTime=0.0000000
        mMaxTime=0.0000000
        mTriggerRadius=0.0000000
        mMaxUsers=0
        mProximity=0.0000000
    }
};

var(Debug) byte mAction;
var(Debug) byte mType;
var(Debug) byte mPresetType;
var(Preset) array mPresetList;
var(Debug) @NULL mGraphSet;
var(Debug) name mGraphName;
var(Debug) name mExitGraphName;
var(Debug) float mTriggerRadius;
var(Debug) int mMaxUsers;
var(Debug) float mProximity;
var(Preset) @NULL mInvestigatePreset[5];
var(Preset) bool mUseOverrideTime;
var(Preset) float mMinTime;
var(Preset) float mMaxTime;
var int mNumUsers;

// Export UTurokInvestigateNode::execSetDefaultParameters(FFrame&, void* const)
native function SetDefaultParameters();

defaultproperties
{
    mType=1
    mPresetList=/* Array type was not detected. */
    mTriggerRadius=150.0000000
    mMaxUsers=10
    mProximity=2000.0000000
    mInvestigatePreset[0]=(mAction=0,mType=0,mGraphName="None",mExitGraphName="None",mMinTime=2.0000000,mMaxTime=10.0000000,mTriggerRadius=150.0000000,mMaxUsers=10,mProximity=100000.0000000)
    mInvestigatePreset[1]=(mAction=1,mType=0,mGraphName="LowIn",mExitGraphName="LowOut",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=50.0000000,mMaxUsers=1,mProximity=100000.0000000)
    mInvestigatePreset[2]=(mAction=1,mType=0,mGraphName="LowIn2",mExitGraphName="LowOut2",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=50.0000000,mMaxUsers=1,mProximity=100000.0000000)
    mInvestigatePreset[3]=(mAction=1,mType=0,mGraphName="HighIn",mExitGraphName="HighOut",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=50.0000000,mMaxUsers=1,mProximity=100000.0000000)
    mInvestigatePreset[4]=(mAction=1,mType=0,mGraphName="HighIn2",mExitGraphName="HighOut2",mMinTime=5.0000000,mMaxTime=10.0000000,mTriggerRadius=50.0000000,mMaxUsers=1,mProximity=100000.0000000)
    mMinTime=-1.0000000
    mMaxTime=-1.0000000
    // Reference: SpriteComponent'Default__TurokInvestigateNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokInvestigateNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    // Reference: CylinderComponent'Default__TurokInvestigateNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokInvestigateNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokInvestigateNode'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokInvestigateNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokInvestigateNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokInvestigateNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}