class MOHAMedkitClass extends EALAHealthInventoryClass
    hidecategories(Navigation);

defaultproperties
{
    InventoryId=3
    DroppedPickupClass=Class'MOHAHealthDroppedPickup'
    // Reference: StaticMeshComponent'Default__MOHAMedkitClass.MeshComponentA'
    begin object name=MeshComponentA
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.Pickup_Health_Generic'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__MOHAMedkitClass.MyLightEnvironment'
        bCastDynamicShadow=false
        bNotifyRigidBodyCollision=true
        bUseHardwareScene=true
        ScriptRigidBodyCollisionThreshold=2.0000000
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__MOHAMedkitClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__MOHAMedkitClass.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    Components[1]=MyLightEnvironment
}