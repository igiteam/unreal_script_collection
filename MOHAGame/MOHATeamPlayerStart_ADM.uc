class MOHATeamPlayerStart_ADM extends MOHATeamPlayerStart
    hidecategories(Navigation,Lighting,LightColor,Force,Collision);

defaultproperties
{
    bLegacyPlayerStart=false
    // Reference: CylinderComponent'Default__MOHATeamPlayerStart_ADM.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart_ADM.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'GCm_Editor_MP.S_MTPS_ADM'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart_ADM.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHATeamPlayerStart_ADM.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHATeamPlayerStart_ADM.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}