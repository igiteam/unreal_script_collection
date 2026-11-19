class MOHAAutoRifleAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Automatic Rifle"
    DroppedPickupClass=Class'MOHAAutoRifleAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAAutoRifleAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_autorifle'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAAutoRifleAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAAutoRifleAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAAutoRifleAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}