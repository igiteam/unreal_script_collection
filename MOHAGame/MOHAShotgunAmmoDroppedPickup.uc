class MOHAShotgunAmmoDroppedPickup extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=24
    AmmoClass=Class'MOHAShotgunAmmoClass'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAShotgunAmmoDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAShotgunAmmoDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAShotgunAmmoDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}