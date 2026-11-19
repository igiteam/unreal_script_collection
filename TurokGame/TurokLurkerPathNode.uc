class TurokLurkerPathNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokLurkerPathNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokLurkerPathNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    // Reference: CylinderComponent'Default__TurokLurkerPathNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokLurkerPathNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokPathNode_NoSkip'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokLurkerPathNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokLurkerPathNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokLurkerPathNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}