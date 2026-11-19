class PKWeap_LabCommandoGun_Base extends EvilWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

var array<SoundCue> FallImpactBulletSound;

simulated function PlayFiringSound()
{
    super.PlayFiringSound();
    SetTimer(0.2500000, false, 'PlayFallImpactBulletSound');
    //return;    
}

simulated function PlayFallImpactBulletSound()
{
    // End:0x5E
    if(int(CurrentFireMode) < FallImpactBulletSound.Length)
    {
        // End:0x5E
        if(FallImpactBulletSound[int(CurrentFireMode)] != none)
        {
            MakeNoise(0.5000000);
            WeaponPlaySound(FallImpactBulletSound[int(CurrentFireMode)]);
        }
    }
    //return;    
}

simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
{
    return true;
    //return ReturnValue;    
}

state ReloadState
{
    simulated function BeginState(name PreviousStateName)
    {
        ReloadAmmo();
        NeedReload = false;
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        global.BeginFire(FireModeNum);
        // End:0x6D
        if(!HasAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
        {
            WeaponEmpty();
            return;
        }
        // End:0xC5
        if(((int(FireModeNum) == int(1)) || int(FireModeNum) != int(CurrentFireMode)) || MagazineAmmoCount < ShotCost[int(FireModeNum)])
        {
            return;
        }
        FireAmmunition();
        SetTimer(GetFireInterval(FireModeNum), true, 'RefireCheckTimer');
        //return;        
    }
    stop;    
}

defaultproperties
{
    SupportAlternateReload=true
    bFastRepeater=true
    MaxAmmoCount=200
    MagazineAmmoCount=20
    MagazineMaxAmmoCount=20
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    ShotCost=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_LabCommandoGun_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'EvilGame.Default__EvilWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ReloadTime=0.1000000
    InventoryGroup=1
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_LabCommandoGun_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'EvilGame.Default__EvilWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_LabCommandoGun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="LabCommandoGun"
    CurrentRating=0.3000000
    AmmoCount=200
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.1000000
    PutDownTime=0.1000000
    bInstantHit=true
    WeaponRange=16384.0000000
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_LabCommandoGun_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_LabCommandoGun_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'EvilGame.Default__EvilWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}