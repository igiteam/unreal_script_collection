class FHSeekerMonsterPawn extends FHMonster
	placeable;

//var() ParticleSystemComponent testParticle;


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__FHSeekerMonsterPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__FHMonster.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__FHSeekerMonsterPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__FHMonster.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__FHSeekerMonsterPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__FHMonster.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__FHSeekerMonsterPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__FHMonster.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__FHSeekerMonsterPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__FHSeekerMonsterPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__FHMonster.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__FHSeekerMonsterPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__FHMonster.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__FHSeekerMonsterPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__FHMonster.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__FHSeekerMonsterPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__FHMonster.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    ControllerClass=Class'FHSeekerMonsterAIController'
    // Reference: SkeletalMeshComponent'Default__FHSeekerMonsterPawn.SkeletalMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SkeletalMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.SkeletalMeshComponent0'
    begin object name="SkeletalMeshComponent0"
        ReplacementPrimitive=none
    end object
    Mesh=SkeletalMeshComponent0
    // Reference: CylinderComponent'Default__FHSeekerMonsterPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__FHMonster.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__FHSeekerMonsterPawn.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'Arrow'
    // Archetype: ArrowComponent'Default__FHMonster.Arrow'
    begin object name="Arrow"
        ReplacementPrimitive=none
    end object
    Components[1]=Arrow
    Components[2]=MyLightEnvironment
    // Reference: SkeletalMeshComponent'Default__FHSeekerMonsterPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__FHMonster.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__FHSeekerMonsterPawn.MyLightEnvironment'
    end object
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=SkeletalMeshComponent0
    CollisionComponent=CollisionCylinder
}