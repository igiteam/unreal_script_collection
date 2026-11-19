class MOHAStickGrenadeAmmoClass extends MOHAGrenadeAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Stick Grenade"
    DroppedPickupClass=Class'MOHAStickGrenadeDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAStickGrenadeAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAStickGrenadeAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAStickGrenadeAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAStickGrenadeAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}