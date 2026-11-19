class TurokStrategicPathNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

var float mSpacingDistance;

defaultproperties
{
    mSpacingDistance=80.0000000
    bAutoConnectClosest=true
    // Reference: SpriteComponent'Default__TurokStrategicPathNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokStrategicPathNode.Sprite3'
    begin object name=Sprite3
        Sprite=Texture2D'TurokEditorResources.TurokStrategicNode_Broken'
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    // Reference: CylinderComponent'Default__TurokStrategicPathNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokStrategicPathNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokStrategicNode'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokStrategicPathNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokStrategicPathNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokStrategicPathNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}