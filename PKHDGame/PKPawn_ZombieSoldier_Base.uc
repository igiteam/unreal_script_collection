class PKPawn_ZombieSoldier_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var SoundCue MissingHead;
var StaticMesh HeadStaticMesh;
var int HeadMaterialIndex;
var repnotify bool bHeadLess;
var ParticleSystem DetachingHeadPS;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bHeadLess;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bHeadLess')
    {
        SpawnZombieHeadKActorAndPlaySound();        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

simulated function SpawnZombieHeadKActorAndPlaySound()
{
    local Vector HeadLocation;
    local Rotator HeadRotation;
    local KActorSpawnable headKactor;

    ShowMaterialSectionOnAllLods(HeadMaterialIndex, false);
    HeadLocation = Mesh.GetBoneLocation(HeadBone);
    HeadRotation = QuatToRotator(Mesh.GetBoneQuaternion(HeadBone));
    headKactor = Spawn(Class'Engine.KActorSpawnable', self,, HeadLocation, HeadRotation);
    headKactor.LifeSpan = 5.0000000;
    headKactor.SetDrawScale(Mesh.default.Scale);
    headKactor.SetStaticMesh(HeadStaticMesh);
    headKactor.SetCollision(true, false, true);
    headKactor.StaticMeshComponent.SetTraceBlocking(false, false);
    headKactor.StaticMeshComponent.WakeRigidBody();
    headKactor.StaticMeshComponent.SetRBAngularVelocity(VRand() * RandRange(2.0000000, 10.0000000), false);
    headKactor.StaticMeshComponent.AddImpulse(Normal(VRandCone(vect(0.0000000, 0.0000000, 1.0000000), 30.0000000 * 0.0174533)) * RandRange(10.0000000, 30.0000000));
    headKactor.RemoteRole = ROLE_None;
    // End:0x30A
    if(DetachingHeadPS != none)
    {
        WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(DetachingHeadPS, Mesh, 'MissingHead', true);
    }
    // End:0x339
    if(MissingHead != none)
    {
        PlaySound(MissingHead, true,,, HeadLocation);
    }
    //return;    
}

function DetachHead()
{
    // End:0x1E
    if(bHeadLess || bIsFrozen)
    {
        return;
    }
    bHeadLess = true;
    SpawnZombieHeadKActorAndPlaySound();
    // End:0x4E
    if(Health > 0)
    {
        Health = 1;
    }
    //return;    
}

defaultproperties
{
    EnableGibWhenHPBelowFactor=-69.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_ZombieSoldier_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_ZombieSoldier_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    CharacterFootStepType=ECharacterFootStepType.CFST_ZombieSoldier
    DefaultHealth=63.0000000
    SpawnAnims=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_ZombieSoldier_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_ZombieSoldier_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_ZombieSoldier_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_ZombieSoldier_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_ZombieSoldier_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_ZombieSoldier_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_ZombieSoldier_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_ZombieSoldier_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_ZombieSoldier_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKPawn_ZombieSoldier_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_ZombieSoldier_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_ZombieSoldier_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_ZombieSoldier_Base.FaceAudioComponent'
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
    RotationRate=(Pitch=90000,Yaw=90000,Roll=90000)
}