class EvilNavMeshPlayerPawn extends EvilPlayerPawn
    config(Pawn)
    hidecategories(Navigation);

simulated exec function FeignDeath()
{
    //return;    
}

simulated function AddDefaultInventory()
{
    //return;    
}

simulated function MeleeKick()
{
    //return;    
}

simulated function EndMeleeKick()
{
    //return;    
}

function HandleStamina()
{
    //return;    
}

defaultproperties
{
    // Reference: EvilPawnBlockingComponent'Default__EvilNavMeshPlayerPawn.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilNavMeshPlayerPawn.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__EvilNavMeshPlayerPawn.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__EvilNavMeshPlayerPawn.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__EvilNavMeshPlayerPawn.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__EvilNavMeshPlayerPawn.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__EvilNavMeshPlayerPawn.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__EvilNavMeshPlayerPawn.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__EvilNavMeshPlayerPawn.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__EvilNavMeshPlayerPawn.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    WalkingPhysics=EPhysics.PHYS_Flying
    LandMovementState="PlayerFlying"
    // Reference: SkeletalMeshComponent'Default__EvilNavMeshPlayerPawn.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilNavMeshPlayerPawn.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__EvilNavMeshPlayerPawn.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__EvilNavMeshPlayerPawn.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=PawnBlocker0
    Components[7]=FaceAudioComponent
    bBlockActors=false
    CollisionComponent=CollisionCylinder
}