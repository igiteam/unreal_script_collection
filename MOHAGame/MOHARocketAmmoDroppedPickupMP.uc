class MOHARocketAmmoDroppedPickupMP extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=1
    AmmoClass=Class'MOHARocketAmmoClassMP'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHARocketAmmoDroppedPickupMP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHARocketAmmoDroppedPickupMP.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHARocketAmmoDroppedPickupMP.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}