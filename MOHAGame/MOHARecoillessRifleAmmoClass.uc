class MOHARecoillessRifleAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Recoilless Rifle"
    DroppedPickupClass=Class'MOHARifleRecoillessAmmoDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHARecoillessRifleAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.DE_pickup_highcaliber'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHARecoillessRifleAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHARecoillessRifleAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHARecoillessRifleAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}