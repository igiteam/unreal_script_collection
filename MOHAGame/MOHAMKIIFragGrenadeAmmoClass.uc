class MOHAMKIIFragGrenadeAmmoClass extends MOHAGrenadeAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="MKII Frag Grenade"
    InventoryId=8
    DroppedPickupClass=Class'MOHAMKIIFragGrenadeDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAMKIIFragGrenadeAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAMKIIFragGrenadeAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAMKIIFragGrenadeAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMKIIFragGrenadeAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}