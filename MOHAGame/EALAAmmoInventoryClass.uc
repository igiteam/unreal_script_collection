class EALAAmmoInventoryClass extends Inventory
    abstract
    hidecategories(Navigation);

var int MaxAmmoCount;
var const localized string DisplayName;

defaultproperties
{
    DisplayName="Default"
    // Reference: StaticMeshComponent'Default__EALAAmmoInventoryClass.MeshComponentA'
    begin object name=MeshComponentA class=Class'Engine.StaticMeshComponent'
        StaticMesh=StaticMesh'Gcm_BG_Eqp_Pickups.Ammo_PickUp'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EALAAmmoInventoryClass.MyLightEnvironment'
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        RBChannel=5
        RBCollideWithChannels=(Default=true)
        bNotifyRigidBodyCollision=true
        bUseHardwareScene=true
        ScriptRigidBodyCollisionThreshold=2.0000000
    end object
    DroppedPickupMesh=MeshComponentA
    // Reference: SpriteComponent'Default__EALAAmmoInventoryClass.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    // Reference: DynamicLightEnvironmentComponent'Default__EALAAmmoInventoryClass.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    Components[1]=MyLightEnvironment
}