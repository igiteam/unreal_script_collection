class MOHARocketAmmoClassMP extends MOHARocketAmmoClass
    hidecategories(Navigation);

defaultproperties
{
    MaxAmmoCount=4
    DroppedPickupClass=Class'MOHARocketAmmoDroppedPickupMP'
    // Reference: StaticMeshComponent'Default__MOHARocketAmmoClassMP.MeshComponentA'
    begin object name=MeshComponentA
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHARocketAmmoClassMP.MyLightEnvironment'
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHARocketAmmoClassMP.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHARocketAmmoClassMP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}