class MOHARocketAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Rocket"
    InventoryId=161
    DroppedPickupClass=Class'MOHARocketAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHARocketAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_rockets'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHARocketAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHARocketAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHARocketAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}