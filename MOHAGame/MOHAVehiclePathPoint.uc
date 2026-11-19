class MOHAVehiclePathPoint extends PathNode
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

var() bool bBrake;
var() bool bParkHereIfDestination;
var() float fBrakeTime;
var() float fMaxVehicleSpeed;

defaultproperties
{
    bParkHereIfDestination=true
    // Reference: CylinderComponent'Default__MOHAVehiclePathPoint.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__MOHAVehiclePathPoint.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__MOHAVehiclePathPoint.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__MOHAVehiclePathPoint.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__MOHAVehiclePathPoint.PathRenderer'
    begin object name=PathRenderer
    end object
    Components[4]=PathRenderer
    CollisionComponent=CollisionCylinder
}