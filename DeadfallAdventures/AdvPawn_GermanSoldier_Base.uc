class AdvPawn_GermanSoldier_Base extends AdvPawn_Armed_Base
    abstract
    config(Pawn)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_GermanSoldier_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanThrowGrenade=true
    bCanSlowDown=true
    PawnActionClasses=/* Array type was not detected. */
    LayAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_GermanSoldier_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_GermanSoldier_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_GermanSoldier_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_GermanSoldier_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_GermanSoldier_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_GermanSoldier_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_GermanSoldier_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_GermanSoldier_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_GermanSoldier_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_GermanSoldier_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_GermanSoldier_Base.FaceAudioComponent'
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
    Components[8]=SPawnSkeletalMeshComponent
    Components[9]=SizzleAudioComponent0
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=40000,Yaw=40000,Roll=40000)
}