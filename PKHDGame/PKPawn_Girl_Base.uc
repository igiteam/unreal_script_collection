class PKPawn_Girl_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var EvilExplosion FireExplosionArchetype;
var EvilExplosion FireExplosionTemplate;

function StartFullBodyHitEffect(PKPawn.EPainHitEffectType EffectType, optional bool bDontStopByTimer)
{
    // End:0x40
    if(!RepHitEffectParams.bStarted)
    {
        super.StartFullBodyHitEffect(EffectType, bDontStopByTimer);
    }
    //return;    
}

simulated function StopFullBodyHitEffect()
{
    // End:0x55
    if(RepHitEffectParams.bStarted && int(RepHitEffectParams.EffectType) == int(3))
    {
        bIsWalking = true;
    }
    super.StopFullBodyHitEffect();
    //return;    
}

simulated function OnScreamAttack()
{
    super.OnScreamAttack();
    // End:0x38
    if(!RepHitEffectParams.bStarted)
    {
        bIsWalking = false;
    }
    StartFullBodyHitEffect(3, true);
    //return;    
}

function StartMeleeAttack()
{
    // End:0x3B
    if(!IsTimerActive('OnScreamAttackEnd'))
    {
        SetTimer(RandRange(0.1000000, 0.5000000), false, 'OnScreamAttackEnd');
    }
    super.StartMeleeAttack();
    //return;    
}

simulated function OnScreamAttackEnd()
{
    // End:0x67
    if(RepHitEffectParams.bStarted && int(RepHitEffectParams.EffectType) == int(3))
    {
        super.OnScreamAttackEnd();
        FireExplode();
        StopFullBodyHitEffect();
    }
    //return;    
}

simulated function bool CanBeFrozen()
{
    return super.CanBeFrozen() && !RepHitEffectParams.bStarted || int(RepHitEffectParams.EffectType) != int(3);
    //return ReturnValue;    
}

simulated function FireExplode()
{
    local EvilExplosionActor ExplosionActor;

    // End:0x102
    if(FireExplosionArchetype != none)
    {
        ExplosionActor = Spawn(Class'EvilGame.EvilExplosionActor', self,, Location, MakeRotator(0, 0, 0));
        FireExplosionTemplate = new (self) FireExplosionArchetype.Class (FireExplosionArchetype);
        FireExplosionTemplate.HitNormal = Normal(Vector(Rotation));
        FireExplosionTemplate.HitActor = Instigator;
        ExplosionActor.Explode(FireExplosionTemplate);
        FireExplosionTemplate = none;
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x27
    if(ClassIsChildOf(DamageType, Class'PKDmgType_Flamer'))
    {
        OnScreamAttack();        
    }
    else
    {
        super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    }
    //return;    
}

defaultproperties
{
    EnableGibWhenHPBelowFactor=-45.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_Girl_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Girl_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    CharacterFootStepType=ECharacterFootStepType.CFST_Girl
    DefaultHealth=150.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Girl_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Girl_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Girl_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Girl_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Girl_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Girl_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Girl_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Girl_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Girl_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bIsWalking=true
    // Reference: SkeletalMeshComponent'Default__PKPawn_Girl_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Girl_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Girl_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Girl_Base.FaceAudioComponent'
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