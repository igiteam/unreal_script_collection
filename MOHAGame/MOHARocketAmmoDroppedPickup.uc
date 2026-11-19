class MOHARocketAmmoDroppedPickup extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=10
    AmmoClass=Class'MOHARocketAmmoClass'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHARocketAmmoDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHARocketAmmoDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHARocketAmmoDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}