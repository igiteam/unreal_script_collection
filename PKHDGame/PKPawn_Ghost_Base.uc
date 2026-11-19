class PKPawn_Ghost_Base extends PKPawn
    config(Pawn)
    hidecategories(Navigation);

var config float TimeToLive;
var float DisapearTime;
var float DisapearValue;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x52
    if(TimeToLive > 0.0000000)
    {
        LifeSpan = TimeToLive + DisapearTime;
        SetTimer(TimeToLive, false, 'BeginDisapear');
    }
    OnAttachProjectile();
    //return;    
}

simulated function bool CanAttachProjectile()
{
    return true;
    //return ReturnValue;    
}

function BeginDisapear()
{
    // End:0x2B
    if(IsTimerActive('BeginRollbackDisapear'))
    {
        ClearTimer('BeginRollbackDisapear');
    }
    // End:0x56
    if(IsTimerActive('RollbackDisapear_T'))
    {
        ClearTimer('RollbackDisapear_T');
    }
    // End:0x82
    if(!IsTimerActive('Disapear_T'))
    {
        SetTimer(0.0100000, true, 'Disapear_T');
    }
    //return;    
}

function BeginRollbackDisapear()
{
    // End:0xDF
    if(LifeSpan > DisapearTime)
    {
        // End:0xB3
        if(IsTimerActive('Disapear_T'))
        {
            // End:0x91
            if(IsTimerActive(GetFuncName()))
            {
                // End:0x8E
                if(GetRemainingTimeForTimer(GetFuncName()) < 0.1000000)
                {
                    ClearTimer(GetFuncName());
                    SetTimer(0.1000000, false, GetFuncName());
                }                
            }
            else
            {
                SetTimer(DisapearTime + 0.1000000, false, GetFuncName());
            }            
        }
        else
        {
            // End:0xDF
            if(!IsTimerActive('RollbackDisapear_T'))
            {
                SetTimer(0.0100000, true, 'RollbackDisapear_T');
            }
        }
    }
    //return;    
}

function RollbackDisapear_T()
{
    DisapearValue = DisapearValue + (GetTimerRate(GetFuncName()) / DisapearTime);
    // End:0x6C
    if(DisapearValue >= 1.0000000)
    {
        DisapearValue = 1.0000000;
        ClearTimer(GetFuncName());
    }
    SetParameterForAllMaterials('DissolveAmount', DisapearValue);
    //return;    
}

function Disapear_T()
{
    DisapearValue = DisapearValue - (GetTimerRate(GetFuncName()) / DisapearTime);
    // End:0x6C
    if(DisapearValue <= 0.0000000)
    {
        DisapearValue = 0.0000000;
        ClearTimer(GetFuncName());
    }
    SetParameterForAllMaterials('DissolveAmount', DisapearValue);
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    BeginDisapear();
    BeginRollbackDisapear();
    //return;    
}

function bool ShouldIgnoreProjectiles()
{
    return !bBlockActors;
    //return ReturnValue;    
}

function DirectHitByProjectile()
{
    super(EvilPawn).DirectHitByProjectile();
    BeginDisapear();
    BeginRollbackDisapear();
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    //return;    
}

defaultproperties
{
    TimeToLive=20.0000000
    DisapearTime=0.5000000
    DisapearValue=1.0000000
    bNotCountable=true
    bCanBeFrozen=false
    bCanBePinned=false
    // Reference: StaticMeshComponent'Default__PKPawn_Ghost_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_Ghost_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bCanPinToThisActor=false
    CharacterFootStepType=ECharacterFootStepType.CFST_Ghost
    bIsInvulnerable=true
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_Ghost_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_Ghost_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    HeadBone="k_szyja"
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Ghost_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_Ghost_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_Ghost_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_Ghost_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_Ghost_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_Ghost_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_Ghost_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bIsWalking=true
    WalkingPhysics=EPhysics.PHYS_Flying
    // Reference: SkeletalMeshComponent'Default__PKPawn_Ghost_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_Ghost_Base.MyLightEnvironment'
        BlockNonZeroExtent=false
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_Ghost_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
        RBChannel=ERBCollisionChannel.RBCC_Nothing
        CollideActors=false
        BlockActors=false
        BlockNonZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_Ghost_Base.FaceAudioComponent'
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
    Physics=EPhysics.PHYS_Flying
    bBlockActors=false
    bNoEncroachCheck=true
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=50000,Yaw=50000,Roll=50000)
}