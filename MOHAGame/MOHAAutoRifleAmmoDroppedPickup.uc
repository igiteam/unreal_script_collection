class MOHAAutoRifleAmmoDroppedPickup extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=50
    AmmoClass=Class'MOHAAutoRifleAmmoClass'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAutoRifleAmmoDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAAutoRifleAmmoDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAAutoRifleAmmoDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}