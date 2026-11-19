class MOHAPanzershreckAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Panzerschreck"
    InventoryId=159
    // Reference: StaticMeshComponent'Default__MOHAPanzershreckAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_rockets'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAPanzershreckAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAPanzershreckAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAPanzershreckAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}