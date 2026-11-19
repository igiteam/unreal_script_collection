class MOHATeamPlayerStart extends PlayerStart
    hidecategories(Navigation,Lighting,LightColor,Force,Collision);

var() int OwnerTeam;
var() bool ControlledByObjectiveSpawnPoint;
var() bool bInAirSpawnPoint;
var bool bLegacyPlayerStart;
var() int ITPSpawnScore;
var transient bool bUsedAsStartPoint;

defaultproperties
{
    OwnerTeam=255
    bLegacyPlayerStart=true
    // Reference: CylinderComponent'Default__MOHATeamPlayerStart.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=100.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart.Sprite'
    begin object name=Sprite
        Sprite=Texture2D'GCm_Editor_MP.S_MTPS_Old'
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHATeamPlayerStart.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHATeamPlayerStart.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHATeamPlayerStart.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}