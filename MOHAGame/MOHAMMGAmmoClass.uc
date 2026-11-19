class MOHAMMGAmmoClass extends EALAAmmoInventoryClass
    hidecategories(Navigation);

defaultproperties
{
    DisplayName="MG"
    InventoryId=6
    // Reference: StaticMeshComponent'Default__MOHAMMGAmmoClass.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAMMGAmmoClass.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAMMGAmmoClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMMGAmmoClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}