class TurokLurkerCoverNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokLurkerCoverNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokLurkerCoverNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    // Reference: CylinderComponent'Default__TurokLurkerCoverNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokLurkerCoverNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokBreakOff'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokLurkerCoverNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokLurkerCoverNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokLurkerCoverNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}