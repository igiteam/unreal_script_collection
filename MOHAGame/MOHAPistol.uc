class MOHAPistol extends EALASmallArms
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function MOHAPhysicalMaterialProperty.EImpactType GetMeleeImpactType()
{
    return 24;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: WeaponAccuracyComponent'Default__MOHAPistol.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHAPistol.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHAPistol.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHAPistol.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHAPistol.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    AmmoCount=7
    MaxAmmoCount[0]=7
    MaxAmmoCount[1]=7
    AmmoClass[0]=Class'MOHAPistolAmmoClass'
    AmmoClass[1]=Class'MOHAPistolAmmoClass'
    FiringStatesArray=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitMomentum=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: MOHASkeletalMeshComponent'Default__MOHAPistol.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}