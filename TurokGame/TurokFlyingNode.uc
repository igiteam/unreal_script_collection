class TurokFlyingNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokFlyingNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokFlyingNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    bNotBased=true
    bFlyingPreferred=true
    // Reference: CylinderComponent'Default__TurokFlyingNode.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokFlyingNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'EngineResources.VolumePath'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokFlyingNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokFlyingNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokFlyingNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}