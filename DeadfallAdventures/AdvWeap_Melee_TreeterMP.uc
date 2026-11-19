class AdvWeap_Melee_TreeterMP extends AdvWeap_Melee_Mummy
    config(Weapon)
    hidecategories(Navigation);

defaultproperties
{
    WeaponDamage=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Melee_TreeterMP.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    PickupArchetype=AdvMultiplayerTreasure'ar_PickUps.Treasure'
    // Reference: AudioComponent'Default__AdvWeap_Melee_TreeterMP.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Melee_TreeterMP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    bCanThrow=true
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Melee_TreeterMP.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Melee_TreeterMP.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}