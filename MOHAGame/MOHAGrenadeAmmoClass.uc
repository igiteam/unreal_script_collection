class MOHAGrenadeAmmoClass extends EALAAmmoInventoryClass
    abstract
    hidecategories(Navigation);

defaultproperties
{
    MaxAmmoCount=50
    DroppedPickupClass=Class'MOHAAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAGrenadeAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_grenades'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAGrenadeAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAGrenadeAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAGrenadeAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}