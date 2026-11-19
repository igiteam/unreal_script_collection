class PKWeap_Rifle_Base extends PainWeap_Base
    abstract
    config(Weapon)
    hidecategories(Navigation);

simulated function bool ShouldRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    StopFire(CurrentFireMode);
    super(EvilWeap_Base).HandleFinishedFiring();
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

defaultproperties
{
    MaxAmmoCount=200
    WeaponDamage=/* Array type was not detected. */
    WeaponMomentum=/* Array type was not detected. */
    WeaponSpread=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__PKWeap_Rifle_Base.ForceFeedbackWaveformShooting1'
    // Archetype: ForceFeedbackWaveform'Default__PainWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1"
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ReloadTime=0.1000000
    InventoryGroup=1
    GroupWeight=0.3000000
    // Reference: AudioComponent'Default__PKWeap_Rifle_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    // Archetype: AudioComponent'Default__PainWeap_Base.ReloadSound'
    begin object name="ReloadSound"
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__PKWeap_Rifle_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PainWeap_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Rifle"
    CurrentRating=0.3000000
    WeaponRangeMin=400.0000000
    AmmoCount=200
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.1000000
    PutDownTime=0.1000000
    bInstantHit=true
    WeaponRange=16384.0000000
    // Reference: UDKSkeletalMeshComponent'Default__PKWeap_Rifle_Base.FirstPersonMesh'
    // Archetype: UDKSkeletalMeshComponent'Default__PainWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh"
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    AIRating=0.3000000
    MaxDesireability=0.3000000
    // Reference: SkeletalMeshComponent'Default__PKWeap_Rifle_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    // Archetype: SkeletalMeshComponent'Default__PainWeap_Base.PickupMesh'
    begin object name="PickupMesh"
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}