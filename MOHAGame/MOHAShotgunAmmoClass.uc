class MOHAShotgunAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Shotgun"
    InventoryId=59
    DroppedPickupClass=Class'MOHAShotgunAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAShotgunAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_shotgun'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAShotgunAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAShotgunAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAShotgunAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}