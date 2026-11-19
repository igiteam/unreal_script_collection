class PKDualStickPlayerPawn extends PKPlayerPawn
    config(Pawn)
    hidecategories(Navigation);

var transient Vector LastCameraLocation;
var() float CameraFollowingDistance;
var() float CameraFollowingInterpSpeed;

simulated event PostBeginPlay()
{
    local Rotator Rot;
    local float FOV;

    super.PostBeginPlay();
    CalcRawCamera(0.0000000, LastCameraLocation, Rot, FOV);
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    CalcRawCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
    out_CamLoc = VInterpTo(LastCameraLocation, out_CamLoc, fDeltaTime, CameraFollowingInterpSpeed);
    LastCameraLocation = out_CamLoc;
    return true;
    //return ReturnValue;    
}

simulated function CalcRawCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector Axis;

    Axis = Normal(vect(-1.0000000, 0.0000000, 2.0000000));
    out_CamLoc = Location + (Axis * CameraFollowingDistance);
    out_CamRot = Rotator(-Axis);
    out_FOV = ((PlayerController(Controller) != none) ? PlayerController(Controller).GetFOVAngle() : WorldInfo.GRI.GameClass.default.PlayerControllerClass.default.DefaultFOV);
    //return;    
}

singular simulated event Rotator GetBaseAimRotation()
{
    return Rotation;
    //return ReturnValue;    
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector WSTL;

    WSTL = super.GetWeaponStartTraceLocation(CurrentWeapon);
    WSTL.Z = Location.Z;
    return WSTL;
    //return ReturnValue;    
}

defaultproperties
{
    CameraFollowingDistance=550.0000000
    CameraFollowingInterpSpeed=4.0000000
    // Reference: StaticMeshComponent'Default__PKDualStickPlayerPawn.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPlayerPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKDualStickPlayerPawn.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPlayerPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    // Reference: DynamicLightEnvironmentComponent'Default__PKDualStickPlayerPawn.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPlayerPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKDualStickPlayerPawn.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKDualStickPlayerPawn.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKDualStickPlayerPawn.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPlayerPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKDualStickPlayerPawn.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPlayerPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKDualStickPlayerPawn.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKDualStickPlayerPawn.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKDualStickPlayerPawn.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPlayerPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKDualStickPlayerPawn.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPlayerPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKDualStickPlayerPawn.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPlayerPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKDualStickPlayerPawn.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKDualStickPlayerPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKDualStickPlayerPawn.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPlayerPawn.FaceAudioComponent'
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
    // Reference: SpotLightComponent'Default__PKDualStickPlayerPawn.SpotLight0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SpotLight0'
    begin object name="SpotLight0" class=Class'Engine.SpotLightComponent'
        Translation=(X=20.0000000,Y=0.0000000,Z=0.0000000)
        Brightness=10.0000000
    end object
    Components[7]=SpotLight0
    CollisionComponent=CollisionCylinder
}