class MOHATeamPlayerStart_DM extends MOHATeamPlayerStart
    hidecategories(Navigation,Lighting,LightColor,Force,Collision);

defaultproperties
{
    bLegacyPlayerStart=false
    // Reference: CylinderComponent'Default__MOHATeamPlayerStart_DM.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart_DM.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'GCm_Editor_MP.S_MTPS_DM'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart_DM.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHATeamPlayerStart_DM.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHATeamPlayerStart_DM.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}