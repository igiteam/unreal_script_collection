class MOHARifle extends EALASmallArms
    abstract
    config(Weapon)
    hidecategories(Navigation);

function int GetRandDesiredPosture()
{
    return 0;
    //return ReturnValue;    
}

function int GetDesiredPosture()
{
    return 0;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: WeaponAccuracyComponent'Default__MOHARifle.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHARifle.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    // Reference: WeaponKickComponent'Default__MOHARifle.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHARifle.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHARifle.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    AmmoCount=7
    AmmoClass[0]=Class'MOHARifleAmmoClass'
    AmmoClass[1]=Class'MOHARifleAmmoClass'
    BulletImpactStimulusThreat=4.0000000
    WeaponType=1
    NPCWeaponTypeIndex=0
    FiringStatesArray=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitMomentum=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    // Reference: MOHASkeletalMeshComponent'Default__MOHARifle.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}