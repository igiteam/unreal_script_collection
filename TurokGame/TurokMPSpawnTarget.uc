class TurokMPSpawnTarget extends TurokMPNavPoint
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

defaultproperties
{
    // Reference: CylinderComponent'Default__TurokMPSpawnTarget.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokMPSpawnTarget.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'TurokEditorResources.TurokGoal'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokMPSpawnTarget.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    bHidden=true
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokMPSpawnTarget.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__TurokMPSpawnTarget.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}