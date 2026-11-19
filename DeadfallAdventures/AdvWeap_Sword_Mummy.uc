class AdvWeap_Sword_Mummy extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    bSelectable=true
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Sword_Mummy.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_Sword_Mummy.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Sword_Mummy.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Sword_Mummy.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Sword_Mummy.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}