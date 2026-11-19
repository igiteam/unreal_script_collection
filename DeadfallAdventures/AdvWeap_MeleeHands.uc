class AdvWeap_MeleeHands extends EvilWeap_MeleeHands
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_MeleeHands.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    ArmsAnimSet=AnimSet'wp_all_hands.Anim.as_wp_all_hands'
    // Reference: AudioComponent'Default__AdvWeap_MeleeHands.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_MeleeHands.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_MeleeHands.FirstPersonMesh'
    begin object name=FirstPersonMesh
        // Reference: AnimNodeSequence'Default__AdvWeap_MeleeHands.FirstPersonMesh.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_MeleeHands.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}