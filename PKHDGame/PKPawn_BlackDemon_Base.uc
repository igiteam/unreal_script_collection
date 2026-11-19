class PKPawn_BlackDemon_Base extends PKPawn_Boss_Base
    config(Pawn)
    hidecategories(Navigation);

var float CumulatedFullBodyHitDamage;
var float LastFullBodyHitHealth;
var EvilExplosion StompEffectArchetype;
var EvilExplosion HitGroundEffectArchetype;
var EvilExplosion HitGroundEffectArchetype_EarthQ;
var bool bShouldEarthQuakeAttack;

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    local float LastTimeDamage;

    LastTimeDamage = FMax(0.0000000, LastFullBodyHitHealth - float(Health));
    CumulatedFullBodyHitDamage += LastTimeDamage;
    LastFullBodyHitHealth = float(Health);
    // End:0xC5
    if(super(PKPawn).ShouldPlayFullBodyHit(DamageType, EventInstigator) && (CumulatedFullBodyHitDamage > (float(HealthMax) / 4.0000000)) || LastTimeDamage > (float(HealthMax) / 6.0000000))
    {
        CumulatedFullBodyHitDamage = 0.0000000;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetMeleeAnimIndex()
{
    local EvilTypesNative.EAnimationSetType AST;

    // End:0x1C
    if(bShouldEarthQuakeAttack)
    {
        AST = 39;        
    }
    else
    {
        AST = 38;
    }
    return PackRandomAnimInfo(AST);
    //return ReturnValue;    
}

simulated function bool SetCapturedEnemy(float TimeToLive, Pawn CaptInstigator)
{
    return false;
    //return ReturnValue;    
}

function StompRightFootEffect()
{
    local Vector Loc;
    local Rotator Rot;

    Mesh.GetSocketWorldLocationAndRotation('RightFoot', Loc, Rot);
    PlayArchetypeEffect(StompEffectArchetype, Loc, Rot);
    //return;    
}

function StompLeftFootEffect()
{
    local Vector Loc;
    local Rotator Rot;

    Mesh.GetSocketWorldLocationAndRotation('LeftFoot', Loc, Rot);
    PlayArchetypeEffect(StompEffectArchetype, Loc, Rot);
    //return;    
}

function HitGroundHandEffect()
{
    local Vector Loc;
    local Rotator Rot;

    Mesh.GetSocketWorldLocationAndRotation(WeaponSocket, Loc, Rot);
    // End:0x72
    if(!bShouldEarthQuakeAttack)
    {
        PlayArchetypeEffect(HitGroundEffectArchetype, Loc, Rot);        
    }
    else
    {
        PlayArchetypeEffect(HitGroundEffectArchetype_EarthQ, Loc, Rot);
    }
    //return;    
}

function InitDefaultHealth()
{
    super(PKPawn).InitDefaultHealth();
    LastFullBodyHitHealth = float(Health);
    //return;    
}

simulated function OnAttachRock()
{
    OnAttachProjectile();
    //return;    
}

simulated function OnDetachRock()
{
    OnDetachProjectile();
    //return;    
}

defaultproperties
{
    bIsReallyBoss=false
    bIsBoss=true
    bThrowRedSoul=true
    bCanBeFrozen=false
    bHasTIPAnims90Deg=true
    KillScoreSV=3.0000000
    // Reference: StaticMeshComponent'Default__PKPawn_BlackDemon_Base.ProjectileStaticMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileStaticMesh'
    // Archetype: StaticMeshComponent'Default__PKPawn_Boss_Base.ProjectileStaticMesh'
    begin object name="ProjectileStaticMesh"
        ReplacementPrimitive=none
    end object
    ProjectileSM=ProjectileStaticMesh
    // Reference: ParticleSystemComponent'Default__PKPawn_BlackDemon_Base.ProjectileEffect'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ProjectileEffect'
    // Archetype: ParticleSystemComponent'Default__PKPawn_Boss_Base.ProjectileEffect'
    begin object name="ProjectileEffect"
        ReplacementPrimitive=none
    end object
    ProjectilePSC=ProjectileEffect
    bForcePlayDeathAnimation=true
    bCanBeKnockedDown=false
    CharacterFootStepType=ECharacterFootStepType.CFST_BlackDemon
    DefaultHealth=1500.0000000
    MinTimeBetweenHits=3.0000000
    TimeToBodyDisappear=7.0000000
    PawnActionClasses=/* Array type was not detected. */
    // Reference: DynamicLightEnvironmentComponent'Default__PKPawn_BlackDemon_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__PKPawn_Boss_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__PKPawn_BlackDemon_Base.ForceFeedbackWaveformFall'
    // Archetype: ForceFeedbackWaveform'Default__PKPawn_Boss_Base.ForceFeedbackWaveformFall'
    begin object name="ForceFeedbackWaveformFall"
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__PKPawn_BlackDemon_Base.AmbientSoundComponent'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent'
    begin object name="AmbientSoundComponent"
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__PKPawn_BlackDemon_Base.AmbientSoundComponent2'
    // Archetype: UTAmbientSoundComponent'Default__PKPawn_Boss_Base.AmbientSoundComponent2'
    begin object name="AmbientSoundComponent2"
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__PKPawn_BlackDemon_Base.OverlayMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'OverlayMeshComponent0'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.OverlayMeshComponent0'
    begin object name="OverlayMeshComponent0"
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__PKPawn_BlackDemon_Base.FirstPersonArms'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms'
    begin object name="FirstPersonArms"
        // Reference: AnimNodeSequence'Default__PKPawn_BlackDemon_Base.FirstPersonArms.MeshSequenceA'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms.MeshSequenceA'
        begin object name="MeshSequenceA"
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__PKPawn_BlackDemon_Base.FirstPersonArms2'
    // Archetype: UDKSkeletalMeshComponent'Default__PKPawn_Boss_Base.FirstPersonArms2'
    begin object name="FirstPersonArms2"
        // Reference: AnimNodeSequence'Default__PKPawn_BlackDemon_Base.FirstPersonArms2.MeshSequenceB'
        // Archetype: AnimNodeSequence'Default__PKPawn_Boss_Base.FirstPersonArms2.MeshSequenceB'
        begin object name="MeshSequenceB"
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    bIsWalking=true
    Mass=500.0000000
    // Reference: SkeletalMeshComponent'Default__PKPawn_BlackDemon_Base.WPawnSkeletalMeshComponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'WPawnSkeletalMeshComponent'
    // Archetype: SkeletalMeshComponent'Default__PKPawn_Boss_Base.WPawnSkeletalMeshComponent'
    begin object name="WPawnSkeletalMeshComponent"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKPawn_BlackDemon_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__PKPawn_BlackDemon_Base.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPawn_Boss_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__PKPawn_BlackDemon_Base.FaceAudioComponent'
    // Archetype: EvilAudioComponent'Default__PKPawn_Boss_Base.FaceAudioComponent'
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