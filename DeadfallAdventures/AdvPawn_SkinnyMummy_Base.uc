class AdvPawn_SkinnyMummy_Base extends AdvPawn_AztecMummy_Weak_Base
    config(Pawn)
    hidecategories(Navigation);

var float FrozenDissolveAmount;
var float FrozenDissolveStep;
var float FrozenDissolveTimeStep;
var MaterialInstanceConstant FrozenMIC;
var ParticleSystem FrozenHitParticle;
var float BeforeUnfreezeAmount;
var float BeforeUnfreezeStepPerHit;
var export editinline ParticleSystemComponent UnfreezeEffectComp;
var export editinline AudioComponent SizzleFrozenAudioComponent;
var array<MaterialInstanceConstant> IceBlockMICArray;

simulated function SetFrozenEffect(bool bShow, optional MaterialInterface FrozenMaterial)
{
    // End:0xC4
    if(bShow && FrozenMaterial != none)
    {
        FrozenDissolveAmount = 1.0000000;
        LightDissolveAccumRate = 0.0000000;
        Mesh.SetMaterial(0, FrozenMaterial);
        FrozenMIC = Mesh.CreateAndSetMaterialInstanceConstant(0);
        FrozenMIC.SetScalarParameterValue('DissolveAmount', FrozenDissolveAmount);        
    }
    else
    {
        // End:0x151
        if(!bShow)
        {
            // End:0x113
            if(FrozenDissolveAmount > 0.0000000)
            {
                SizzleFrozenAudioComponent.Play();
                FadeOutFrozenEffect(false);                
            }
            else
            {
                LightDissolveAccumRate = default.LightDissolveAccumRate;
                Mesh.SetMaterial(0, DissolveMICs[0]);
            }
        }
    }
    //return;    
}

simulated function SetupIceBlockMICArray(StaticMeshActor IceBlock)
{
    local int I;

    // End:0xDA
    if((IceBlock != none) && IceBlock.StaticMeshComponent != none)
    {
        I = 0;
        J0x40:

        // End:0xDA [Loop If]
        if(I < IceBlock.StaticMeshComponent.GetNumElements())
        {
            IceBlockMICArray.AddItem(IceBlock.StaticMeshComponent.CreateAndSetMaterialInstanceConstant(I));            
            I++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

simulated function FadeOutFrozenEffect(optional bool bNoTimer)
{
    local MaterialInstanceConstant MIC;
    local float FrozenIceBlockDissolveAmount;

    FrozenDissolveAmount -= FrozenDissolveStep;
    // End:0x181
    if(FrozenDissolveAmount > 0.0000000)
    {
        FrozenIceBlockDissolveAmount = FClamp(FrozenDissolveAmount - 0.4000000, 0.0000000, 0.6000000);
        // End:0x97
        foreach IceBlockMICArray(MIC)
        {
            MIC.SetScalarParameterValue('DissolveAmount', FrozenIceBlockDissolveAmount);            
        }        
        FrozenMIC.SetScalarParameterValue('DissolveAmount', FrozenDissolveAmount);
        // End:0x17E
        if(!bNoTimer)
        {
            // End:0x167
            if((UnfreezeEffectComp != none) && UnfreezeEffectComp.bWasCompleted)
            {
                AttachComponent(UnfreezeEffectComp);
                UnfreezeEffectComp.SetActorParameter('BoneSocketActor', self);
                UnfreezeEffectComp.ActivateSystem();
            }
            SetTimer(FrozenDissolveTimeStep, false, 'FadeOutFrozenEffect');
        }        
    }
    else
    {
        // End:0x1BA
        if(UnfreezeEffectComp != none)
        {
            UnfreezeEffectComp.DeactivateSystem();
            UnfreezeEffectComp = none;
        }
        SetFrozenEffect(false);
    }
    //return;    
}

function SetUnfreezeEffectComponent(ParticleSystemComponent InUnfreezeEffectComp)
{
    UnfreezeEffectComp = InUnfreezeEffectComp;
    //return;    
}

function AdjustDamage(out int InDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, TraceHitInfo HitInfo, Actor DamageCauser)
{
    local class<EvilDmgType_Base> EvilDamageType;

    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0xA5
    if(FrozenDissolveAmount > 0.2500000)
    {
        // End:0x97
        if((EvilDamageType != none) && EvilDamageType.default.bIsLightDmgType)
        {
            // End:0x8C
            if(BeforeUnfreezeAmount > 0.0000000)
            {
                BeforeUnfreezeAmount -= BeforeUnfreezeStepPerHit;                
            }
            else
            {
                FadeOutFrozenEffect(true);
            }
        }
        InDamage = 0;        
    }
    else
    {
        // End:0x115
        if(!IsFrozen() && int(PawnAction) != 14)
        {
            super(AdvPawn_Mummy_Base).AdjustDamage(InDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo, DamageCauser);            
        }
        else
        {
            InDamage = 0;
        }
    }
    //return;    
}

function bool IsFrozen(optional out float FrozenAmount)
{
    FrozenAmount = FrozenDissolveAmount;
    return FrozenAmount > 0.0000000;
    //return ReturnValue;    
}

function bool ShouldPlayFullBodyHit(class<DamageType> DamageType, optional Controller EventInstigator)
{
    return super(AdvPawn_Mummy_Base).ShouldPlayFullBodyHit(DamageType, EventInstigator) && int(PawnAction) != 14;
    //return ReturnValue;    
}

simulated function ParticleSystem OverrideHitImpactEffect()
{
    // End:0x20
    if(FrozenDissolveAmount > 0.3000000)
    {
        return FrozenHitParticle;        
    }
    else
    {
        return super(AdvPawn_Mummy_Base).OverrideHitImpactEffect();
    }
    //return ReturnValue;    
}

simulated function SetupHitImpactEffect(ParticleSystemComponent PartComp)
{
    // End:0x58
    if(PartComp.Template == FrozenHitParticle)
    {
        PartComp.SetActorParameter('BoneSocketActor', self);        
    }
    else
    {
        super(AdvPawn_Mummy_Base).SetupHitImpactEffect(PartComp);
    }
    //return;    
}

defaultproperties
{
    FrozenDissolveStep=0.0100000
    FrozenDissolveTimeStep=0.0500000
    FrozenHitParticle=ParticleSystem'ps_Mummy.Effects.ps_wp_HitEffectFrozen'
    BeforeUnfreezeAmount=1.0000000
    BeforeUnfreezeStepPerHit=0.0500000
    // Reference: AudioComponent'Default__AdvPawn_SkinnyMummy_Base.SizzleFrozenAudioComponent0'
    begin object name=SizzleFrozenAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    SizzleFrozenAudioComponent=SizzleFrozenAudioComponent0
    // Reference: SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.WPawnSkeletalMeshComponent_Skeleton'
    begin object name=WPawnSkeletalMeshComponent_Skeleton
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_SkinnyMummy_Base.MyLightEnvironment'
    end object
    SkeletonMesh=WPawnSkeletalMeshComponent_Skeleton
    // Reference: SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.SPawnSkeletalMeshComponent'
    begin object name=SPawnSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.WPawnSkeletalMeshComponent'
        ShadowParent=SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.WPawnSkeletalMeshComponent'
        ReplacementPrimitive=none
    end object
    WallseeMesh=SPawnSkeletalMeshComponent
    // Reference: AudioComponent'Default__AdvPawn_SkinnyMummy_Base.SizzleAudioComponent0'
    begin object name=SizzleAudioComponent0
    end object
    SizzleSoundComponent=SizzleAudioComponent0
    bCanBeKnockedDown=false
    PawnActionClasses=/* Array type was not detected. */
    LayAnims=/* Array type was not detected. */
    WakeAnims=/* Array type was not detected. */
    // Reference: EvilPawnBlockingComponent'Default__AdvPawn_SkinnyMummy_Base.PawnBlocker0'
    begin object name=PawnBlocker0
        ReplacementPrimitive=none
    end object
    PawnBlocker=PawnBlocker0
    // Reference: DynamicLightEnvironmentComponent'Default__AdvPawn_SkinnyMummy_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: ForceFeedbackWaveform'Default__AdvPawn_SkinnyMummy_Base.ForceFeedbackWaveformFall'
    begin object name=ForceFeedbackWaveformFall
    end object
    FallingDamageWaveForm=ForceFeedbackWaveformFall
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_SkinnyMummy_Base.AmbientSoundComponent'
    begin object name=AmbientSoundComponent
    end object
    PawnAmbientSound=AmbientSoundComponent
    // Reference: UTAmbientSoundComponent'Default__AdvPawn_SkinnyMummy_Base.AmbientSoundComponent2'
    begin object name=AmbientSoundComponent2
    end object
    WeaponAmbientSound=AmbientSoundComponent2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.OverlayMeshComponent0'
    begin object name=OverlayMeshComponent0
        ReplacementPrimitive=none
    end object
    OverlayMesh=OverlayMeshComponent0
    // Refer[0]ence: UDKSkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.FirstPersonArms'
    begin object name=FirstPersonArms
        // Reference: AnimNodeSequence'Default__AdvPawn_SkinnyMummy_Base.FirstPersonArms.MeshSequenceA'
        begin object name=MeshSequenceA
        end object
        Animations=MeshSequenceA
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms
    // Reference: UDKSkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.FirstPersonArms2'
    begin object name=FirstPersonArms2
        // Reference: AnimNodeSequence'Default__AdvPawn_SkinnyMummy_Base.FirstPersonArms2.MeshSequenceB'
        begin object name=MeshSequenceB
        end object
        Animations=MeshSequenceB
        ReplacementPrimitive=none
    end object
    ArmsMesh=FirstPersonArms2
    // Reference: SkeletalMeshComponent'Default__AdvPawn_SkinnyMummy_Base.WPawnSkeletalMeshComponent'
    begin object name=WPawnSkeletalMeshComponent
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvPawn_SkinnyMummy_Base.MyLightEnvironment'
    end object
    Mesh=WPawnSkeletalMeshComponent
    // Reference: CylinderComponent'Default__AdvPawn_SkinnyMummy_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    // Reference: EvilAudioComponent'Default__AdvPawn_SkinnyMummy_Base.FaceAudioComponent'
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
    Components[10]=WPawnSkeletalMeshComponent_Skeleton
    Components[11]=SizzleFrozenAudioComponent0
    CollisionComponent=CollisionCylinder
}