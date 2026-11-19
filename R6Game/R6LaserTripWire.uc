class R6LaserTripWire extends Actor
    native
    notplaceable
    hidecategories(lighting);

var R6MotionSensor m_Explosive;
var export editinline R6LaserSightComponent m_LaserSight;

defaultproperties
{
    // Reference: R6LaserSightComponent'Default__R6LaserTripWire.LaserSightComponent'
    begin object name="LaserSightComponent" class=Class'Engine.R6LaserSightComponent'
        m_DotMaterial=Material'RS5Weapons.Misc.LaserMaterial'
        StaticMesh=StaticMesh'RS5Weapons.Misc.LaserRayCylinder'
        BlockRigidBody=false
    end object
    m_LaserSight=LaserSightComponent
    bCollideActors=true
    // Reference: SpriteComponent'Default__R6LaserTripWire.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=LaserSightComponent
    CollisionComponent=LaserSightComponent
    m_fBulletGoThrough=1.0000000
}