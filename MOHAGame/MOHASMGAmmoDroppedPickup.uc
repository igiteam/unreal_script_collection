class MOHASMGAmmoDroppedPickup extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=50
    AmmoClass=Class'MOHASMGAmmoClass'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHASMGAmmoDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHASMGAmmoDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHASMGAmmoDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}