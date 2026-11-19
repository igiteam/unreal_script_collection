class MOHAPistolAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Pistol"
    InventoryId=2
    DroppedPickupClass=Class'MOHADroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAPistolAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPistolAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAPistolAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPistolAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}