class AdvPawn_NPCZimmerman_Base extends AdvPawn_NPC_Base
    config(Pawn)
    hidecategories(Navigation);

defaultproperties
{
    bFaceFXHeadTrackEyesHack=true
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    FaceFXHeadTrackWeightScale=(X=1.6500000,Y=2.0000000)
    FaceFXHeadTrackWeightBias=(X=0.0000000,Y=0.0000000)
    // Reference: AudioComponent'Default__AdvPawn_NPCZimmerman_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_NPCZimmerman_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_NPCZimmerman_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_NPCZimmerman_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_NPCZimmerman_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_NPCZimmerman_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_NPCZimmerman_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_NPCZimmerman_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_NPCZimmerman_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_NPCZimmerman_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_NPCZimmerman_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_NPCZimmerman_Base.FaceAudioComponent'
    begin object name=FaceAudioComponent
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    Components[7]=SPawnSkeletalMeshComponent
    Components[8]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
}