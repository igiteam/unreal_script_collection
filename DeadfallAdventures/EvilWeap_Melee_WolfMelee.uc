class EvilWeap_Melee_WolfMelee extends EvilWeap_Melee_Base
    config(Weapon)
    hidecategories(Navigation);

simulated function DoMeleeDamage(float DamageScale, optional Actor Target = none, optional Vector HitLocaltion = vect(0.0000000, 0.0000000, 0.0000000))
{
    super.DoMeleeDamage(DamageScale, Target, HitLocaltion);
    //return;    
}

defaultproperties
{
    bSelectable=true
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Melee_WolfMelee.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__EvilWeap_Melee_WolfMelee.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Melee_WolfMelee.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__EvilWeap_Melee_WolfMelee.FirstPersonMesh'
    begin object name=FirstPersonMesh
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Melee_WolfMelee.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}