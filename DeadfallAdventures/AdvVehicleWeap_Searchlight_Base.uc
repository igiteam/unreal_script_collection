class AdvVehicleWeap_Searchlight_Base extends EvilVehicleWeap_Base
    config(Weapon)
    hidecategories(Navigation);

simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
    return none;
    //return ReturnValue;    
}

defaultproperties
{
    bFastRepeater=true
    // Reference: ForceFeedbackWaveform'Default__AdvVehicleWeap_Searchlight_Base.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvVehicleWeap_Searchlight_Base.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvVehicleWeap_Searchlight_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    WeaponName="Searchlight"
    WeaponFireTypes=/* Array type was not detected. */
    bInstantHit=true
    WeaponRange=5000.0000000
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvVehicleWeap_Searchlight_Base.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvVehicleWeap_Searchlight_Base.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}