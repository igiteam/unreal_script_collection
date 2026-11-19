class MOHAGammonGrenadeAmmoClass extends MOHAGrenadeAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Gammon Grenade"
    DroppedPickupClass=Class'MOHAGammonDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAGammonGrenadeAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAGammonGrenadeAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAGammonGrenadeAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAGammonGrenadeAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}