class AdvWeap_Melee_Machete_MP extends AdvWeap_Melee_Machete
    config(Weapon)
    hidecategories(Navigation);

simulated state SprintState
{
    simulated function BeginFire(byte FireModeNum)
    {
        global.BeginFire(FireModeNum);
        //return;        
    }
    stop;    
}

defaultproperties
{
    WeaponHitRange=85.0000000
    WeaponDamage=/* Array type was not detected. */
    WeaponFireInterval=/* Array type was not detected. */
    // Reference: ForceFeedbackWaveform'Default__AdvWeap_Melee_Machete_MP.ForceFeedbackWaveformShooting1'
    begin object name=ForceFeedbackWaveformShooting1
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    // Reference: AudioComponent'Default__AdvWeap_Melee_Machete_MP.ReloadSound'
    begin object name=ReloadSound
    end object
    ReloadSoundComp=ReloadSound
    // Reference: DynamicLightEnvironmentComponent'Default__AdvWeap_Melee_Machete_MP.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: EvilFirstPersonSkeletalMeshComponent'Default__AdvWeap_Melee_Machete_MP.FirstPersonMesh'
    begin object name=FirstPersonMesh
        // Reference: AnimNodeSequence'Default__AdvWeap_Melee_Machete_MP.FirstPersonMesh.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    Mesh=FirstPersonMesh
    // Reference: SkeletalMeshComponent'Default__AdvWeap_Melee_Machete_MP.PickupMesh'
    begin object name=PickupMesh
        ReplacementPrimitive=none
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
}