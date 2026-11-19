class PKPawn_Boss_Base extends PKPawn
    abstract
    config(Pawn)
    hidecategories(Navigation);

var int HealthPercentage;
var bool bUsePostTIPYaw;
var bool bIsReallyBoss;
var int PostTIPYaw;

replication
{
    // Pos:0x000
    if(bNetDirty)
        HealthPercentage;
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x5A
    if((DamageType == Class'PKDmgType_PainkillerBladesRotating') || DamageType == Class'PKDmgType_PainkillerBlades')
    {
        PKProjectile_PainkillerBlades_Base(DamageCauser).ReturnToInstigator();
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    RefreshHealthPercentage();
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x26
    if(TimeToBodyDisappear <= 0.0000000)
    {
        SetTimer(0.0100000, false, 'Destroy');
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

function RefreshHealthPercentage()
{
    HealthPercentage = (Health * 100) / HealthMax;
    //return;    
}

simulated event Tick(float DeltaTime)
{
    // End:0x177
    if(MoveModeNode != none)
    {
        // End:0x2C
        if(!bUsePostTIPYaw)
        {
            MeshYawOffset = 0;            
        }
        else
        {
            // End:0xC2
            if((MoveModeNode.Children[0].Weight < 0.0000100) || FullBodyAnimSlot.Children[0].Weight < 0.0000100)
            {
                bUsePostTIPYaw = false;
                MeshYawOffset = 0;                
            }
            else
            {
                MeshYawOffset = int(-FMin(MoveModeNode.Children[0].Weight, FullBodyAnimSlot.Children[0].Weight) * float(NormalizeRotAxis(PostTIPYaw - NormalizeRotAxis(Rotation.Yaw))));
            }
        }
    }
    super.Tick(DeltaTime);
    //return;    
}

simulated state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x29
        if(TimeToBodyDisappear <= 0.0000000)
        {
            Destroy();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    HealthPercentage=100
    bIsReallyBoss=true
    // Reference: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bPlayHitSoundInPlayHit=true
    TimeToBodyDisappear=0.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Boss_Base.FaceAudioComponent'
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
}