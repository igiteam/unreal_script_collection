class MOHAShotgun extends MOHASingleShotReloadWeapon
    abstract
    config(Weapon)
    hidecategories(Navigation);

var(Config_Shotgun) config int PelletsPerShot;

function InformAttachmentOfRechamber()
{
    local ShotgunAttachment Attachment;

    Attachment = ShotgunAttachment(GetWeaponAttachment());
    Attachment.Rechamber();
    //return;    
}

simulated function InstantFire()
{
    local int PelletIdx;
    local Vector StartTrace;

    StartTrace = Instigator.GetWeaponStartTraceLocation(self);
    PelletIdx = 0;
    J0x21:

    // End:0x49 [Loop If]
    if(PelletIdx < PelletsPerShot)
    {
        PerformWeaponTrace(StartTrace);
        PelletIdx++;
        // [Loop Continue]
        goto J0x21;
    }
    //return;    
}

simulated function FireAmmunition()
{
    // End:0x60
    if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
    {
        MOHAPlayerController(Instigator.Controller).playerStats.OnWeaponFire(WeaponType, WeaponClass, PelletsPerShot - 1);
    }
    super(EALASmallArms).FireAmmunition();
    //return;    
}

simulated function InitWeaponAttachment()
{
    super(EALAWeapon).InitWeaponAttachment();
    ShotgunAttachment(GetWeaponAttachment()).SetPelletsPerShot(PelletsPerShot);
    //return;    
}

state WeaponRechamber
{
    simulated function BeginState(name PreviousStateName)
    {
        InformAttachmentOfRechamber();
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: WeaponAccuracyComponent'Default__MOHAShotgun.WeaponAccuracy'
    begin object name=WeaponAccuracy
    end object
    AccuracyComponent=WeaponAccuracy
    // Reference: WeaponAccuracyComponent'Default__MOHAShotgun.IronsightsWeaponAccuracy'
    begin object name=IronsightsWeaponAccuracy
    end object
    IronsightsAccuracyComponent=IronsightsWeaponAccuracy
    CanRechamberInIronsight=true
    // Reference: WeaponKickComponent'Default__MOHAShotgun.WeaponKick'
    begin object name=WeaponKick
    end object
    KickComponent=WeaponKick
    // Reference: WeaponKickComponent'Default__MOHAShotgun.IronsightsWeaponKick'
    begin object name=IronsightsWeaponKick
    end object
    IronsightsKickComponent=IronsightsWeaponKick
    // Reference: WhizSenderComponent'Default__MOHAShotgun.whiz'
    begin object name=whiz
    end object
    WhizComponent=whiz
    AmmoClass[0]=Class'MOHAShotgunAmmoClass'
    AmmoClass[1]=Class'MOHAShotgunAmmoClass'
    WeaponType=1
    AttachmentClass=Class'ShotgunAttachment'
    FiringStatesArray=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitMomentum=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    InventoryId=50
    // Reference: MOHASkeletalMeshComponent'Default__MOHAShotgun.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=WeaponAccuracy
    Components[1]=IronsightsWeaponAccuracy
    Components[2]=WeaponKick
    Components[3]=IronsightsWeaponKick
}