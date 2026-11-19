class MOHASMGAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="SMG"
    InventoryId=109
    DroppedPickupClass=Class'MOHASMGAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHASMGAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_smg'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHASMGAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHASMGAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHASMGAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}