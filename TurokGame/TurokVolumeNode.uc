class TurokVolumeNode extends TurokPathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: SpriteComponent'Default__TurokVolumeNode.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokVolumeNode.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    bNotBased=true
    bFlyingPreferred=true
    bVehicleDestination=true
    bBuildLongPaths=false
    // Reference: CylinderComponent'Default__TurokVolumeNode.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=2000.0000000
        CollisionRadius=2000.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokVolumeNode.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'EngineResources.VolumePath'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokVolumeNode.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokVolumeNode.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokVolumeNode.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    Components[5]=Sprite3
    Components[6]=Sprite4
    CollisionComponent=CollisionCylinder
}