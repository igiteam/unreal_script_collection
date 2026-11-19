class PKPawn_KrustyClown_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var transient Vector DeathLocation;
var transient int UpdateCounter;

function bool CanEngageCharge()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc)
{
    local RB_ConstraintInstance RootConstraint;

    super.PlayDying(DamageType, HitLoc);
    // End:0x127
    if(bGibbed)
    {
        RootConstraint = Mesh.PhysicsAssetInstance.FindConstraintInstance('Root', Mesh.PhysicsAsset);
        // End:0xBC
        if(RootConstraint != none)
        {
            RootConstraint.TermConstraint();
        }
        Mesh.GetRootBodyInstance().SetFixed(true);
        Mesh.GetRootBodyInstance().FreezeBody();
    }
    // End:0x166
    if(((bGibbed || bPinned) || bIsFrozen) || PinningStakes.Length > 0)
    {
        return;
    }
    bCanBePinned = false;
    Mesh.GetRootBodyInstance().SetFixed(true);
    Mesh.GetRootBodyInstance().FreezeBody();
    DeathLocation = Location + vect(0.0000000, 0.0000000, 50.0000000);
    Mesh.SetRBPosition(DeathLocation, 'ROOOT');
    SetTimer(0.5000000, true, 'UpdateConstraintLoc_T');
    //return;    
}

simulated function UpdateConstraintLoc_T()
{
    // End:0x33
    if(bPinned || PinningStakes.Length > 0)
    {
        ClearTimer('UpdateConstraintLoc_T');
    }
    DeathLocation = DeathLocation + (vect(0.0000000, 0.0000000, 1.0000000) * RandRange(30.0000000, 50.0000000));
    Mesh.SetRBPosition(DeathLocation, 'ROOOT');
    // End:0xC2
    if(++UpdateCounter > 2)
    {
        ClearTimer('UpdateConstraintLoc_T');
    }
    //return;    
}

defaultproperties
{
    EnableGibWhenHPBelowFactor=-45.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_KrustyClown_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_KrustyClown_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    CharacterFootStepType=ECharacterFootStepType.CFST_KrustyClown
    DefaultHealth=90.0000000
    HipsBoneName="Root"
    LeftFootBoneName="s_l_kostka"
    RightFootBoneName="s_p_kostkas"
    HitZones=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_KrustyClown_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_KrustyClown_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="k_glowa"
    // Reference: UTAmbientSoundComponent'Default__PKPawn_KrustyClown_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_KrustyClown_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_KrustyClown_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_KrustyClown_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_KrustyClown_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_KrustyClown_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_KrustyClown_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKPawn_KrustyClown_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_KrustyClown_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_KrustyClown_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_KrustyClown_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn.FaceAudioComponent'
    begin object name="FaceAudioComponent"
    end object
    FacialAudioComp=FaceAudioComponent
    Components[0]=CollisionCylinder
    Components[1]=none
    Components[2]=MyLightEnvironment
    Components[3]=WPawnSkeletalMeshComponent
    Components[4]=AmbientSoundComponent
    Components[5]=AmbientSoundComponent2
    Components[6]=FaceAudioComponent
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
}