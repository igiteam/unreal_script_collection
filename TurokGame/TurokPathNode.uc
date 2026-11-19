class TurokPathNode extends PathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

var() bool bBlockDifferent;
var bool bCheckReachspec;
var(Pathing) bool bSkipAhead;
var(Pathing) bool bAutoConnectClosest;
var bool mbRequiresAnchorFenceCheck;
var export editinline @NULL mGoalRadiusComponent;
var() int mGoalRadius;
var const export editinline @NULL NoSkipSprite;
var const export editinline @NULL BrokenSprite;

// Export UTurokPathNode::execIsAvailableTo(FFrame&, void* const)
native function bool IsAvailableTo(@NULL chkActor);

// Export UTurokPathNode::execDrawPathDebug3D(FFrame&, void* const)
native final function DrawPathDebug3D(@NULL HUD);

defaultproperties
{
    bSkipAhead=true
    // Reference: SpriteComponent'Default__TurokPathNode.Sprite4'
    begin object name=Sprite4 class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokPathNode_NoSkip'
        HiddenGame=true
        HiddenEditor=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Scale=1.2500000
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokPathNode.Sprite3'
    begin object name=Sprite3 class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokPathNode_Broken'
        HiddenGame=true
        HiddenEditor=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    BrokenSprite=Sprite3
    // Reference: CylinderComponent'Default__TurokPathNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokPathNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokPathNode'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokPathNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokPathNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokPathNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}