class PKPawn_Nun_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var transient byte bReplicatedDropHat;
var repnotify bool bHasDropableHat;
var int MaterialHatIndex;
var StaticMesh HatStaticMesh;
var SoundCue HitTheHatSound;

replication
{
    // Pos:0x000
    if(bNetDirty)
        bHasDropableHat;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x24
    if(VarName == 'bHasDropableHat')
    {
        HideHatAndSpawnKActor();        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

protected simulated function HideHatAndSpawnKActor()
{
    local KActorSpawnable ret;
    local Vector SpawnLocation, AngularRotation;
    local Rotator SpawnRotation;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    ShowMaterialSectionOnAllLods(MaterialHatIndex, false);
    SpawnRotation = QuatToRotator(Mesh.GetBoneQuaternion(HeadBone));
    SpawnLocation = Mesh.GetBoneLocation(HeadBone);
    ret = Spawn(Class'Engine.KActorSpawnable', self,, SpawnLocation, SpawnRotation);
    ret.LifeSpan = 6.0000000;
    ret.SetDrawScale(6.0000000);
    ret.SetStaticMesh(HatStaticMesh);
    ret.SetCollision(true, false, true);
    ret.StaticMeshComponent.SetTraceBlocking(false, false);
    ret.StaticMeshComponent.WakeRigidBody();
    AngularRotation = Mesh.GetBoneAxis(HeadBone, 1);
    ret.StaticMeshComponent.SetRBAngularVelocity(AngularRotation * RandRange(0.0000000, 20.0000000), false);
    ret.StaticMeshComponent.AddImpulse(vect(0.0000000, 0.0000000, 1.0000000) * RandRange(30.0000000, 40.0000000));
    ret.RemoteRole = ROLE_None;
    // End:0x30D
    if(HitTheHatSound != none)
    {
        PlaySound(HitTheHatSound, true,,, SpawnLocation);
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x6B
    if(bHasDropableHat)
    {
        // End:0x6B
        if((float(HealthMax) * 0.4000000) > float(Health - Damage))
        {
            bCanThrowGrenade = false;
            bReplicatedDropHat += 1;
            bHasDropableHat = false;
            HideHatAndSpawnKActor();
        }
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

defaultproperties
{
    bGetAdjustedAimFromSocket=false
    EnableGibWhenHPBelowFactor=-69.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_Nun_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Nun_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    CharacterFootStepType=ECharacterFootStepType.CFST_Nun
    DefaultHealth=129.0000000
    HipsBoneName="Root"
    HitZones=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Nun_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Nun_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="k_glowa"
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Nun_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Nun_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Nun_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Nun_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Nun_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Nun_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Nun_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Nun_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Nun_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Nun_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Nun_Base.FaceAudioComponent'
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