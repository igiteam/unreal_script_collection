class MOHASteilHandGrenateAmmoClass extends MOHAGrenadeAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="Stick Grenade"
    // Reference: StaticMeshComponent'Default__MOHASteilHandGrenateAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHASteilHandGrenateAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHASteilHandGrenateAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHASteilHandGrenateAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}