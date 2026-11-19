class MOHALMGAmmoClass extends MOHAGunAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="LMG"
    // Reference: StaticMeshComponent'Default__MOHALMGAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHALMGAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHALMGAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHALMGAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}