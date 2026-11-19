class TurokMPNavPoint extends NavigationPoint
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    bNoAutoConnect=true
    bDestinationOnly=true
    bSourceOnly=true
    // Reference: CylinderComponent'Default__TurokMPNavPoint.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPNavPoint.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPNavPoint.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bMovable=false
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPNavPoint.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPNavPoint.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}