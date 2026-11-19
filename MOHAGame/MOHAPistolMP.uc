class MOHAPistolMP extends MOHAPistol
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: WeaponAccuracyComponent'Default__MOHAPistolMP.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHAPistolMP.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHAPistolMP.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHAPistolMP.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHAPistolMP.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    // Reference: MOHASkeletalMeshComponent'Default__MOHAPistolMP.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}