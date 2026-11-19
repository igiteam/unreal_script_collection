class MOHAStickGrenadeDroppedPickup extends MOHAAmmoDroppedPickup
    hidecategories(Navigation);

defaultproperties
{
    AmmoAmount=3
    AmmoClass=Class'MOHAStickGrenadeAmmoClass'
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAStickGrenadeDroppedPickup.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvComponent=MyLightEnvironment
    // Reference: SpriteComponent'Default__MOHAStickGrenadeDroppedPickup.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__MOHAStickGrenadeDroppedPickup.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    Components[1]=CollisionCylinder
    Components[2]=MyLightEnvironment
}