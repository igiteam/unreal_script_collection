class MOHAParatrooperSpawnPoint extends SpawnerSpawnPoint
    hidecategories(Navigation,Lighting,LightColor,Force);

var() MOHAParadropTarget DropTarget;
var() float DescendSpeed;
var() float LateralSpeed;

defaultproperties
{
    DescendSpeed=900.0000000
    LateralSpeed=800.0000000
    // Reference: CylinderComponent'Default__MOHAParatrooperSpawnPoint.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAParatrooperSpawnPoint.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAParatrooperSpawnPoint.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAParatrooperSpawnPoint.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAParatrooperSpawnPoint.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}