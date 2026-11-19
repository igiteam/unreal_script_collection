class AdvMirrorComponent extends EvilActorComponent
    config(Weapon);

enum MirrorType
{
    MirrorReflecting,               // 0
    MirrorWithLight,                // 1
    Receiver,                       // 2
    MirrorType_MAX                  // 3
};

enum CustomMaterialType
{
    CustomMesh,                     // 0
    MirrorMesh,                     // 1
    CustomMaterialType_MAX          // 2
};

var() float Range;
var() AdvMirrorComponent.MirrorType Purpose;
var(MaterialVariables) AdvMirrorComponent.CustomMaterialType MaterialType;
var() float LightPowerThreshold;
var() float LightGainer;
var() float LightIntensity;
var() export editinline StaticMeshComponent LightMesh;
var(Flare) export editinline LensFlareComponent MirrorLensFlare;
var(Flare) float DistanceFromMesh;
var(Receiver) bool ToggleMode;
var(Debug) bool bShowDebugLine;
var bool bIsUnderFocusedBeamEffect;
var bool bIsUnderFocusedBeam;
var bool bWasUnderFocusedBeam;
var bool bIsLit;
var bool bWasLit;
var bool bToggleEventFired;
var(Sound) bool bShouldMakeChargeSoundWhileWearingOff;
var(DamageUndead) bool bDamageUndead;
var bool bChargingParticleActive;
var(Decal) bool bNoClip;
var(SpotLight) bool bUseSpotlightComponent;
var(SpotLight) bool bHideSpotlightWhenTargetingThisMirror;
var(Debug) float LightMeshScaleFactor;
var MaterialInstanceConstant MirrorReflectingMaterial;
var(MaterialVariables) Material ParentMaterial;
var MaterialInstanceConstant LightMeshIntenseMaterial;
var float TimeInterval;
var float TimeIntervalBeamLocation;
var float TimeIntervalUpdateUndead;
var Rotator PreviousRotation;
var Vector PreviousLocation;
var float LightPower;
var float LastHitLightPower;
var Vector WhereLightTraceEnds;
var Vector WhereLightEnds;
var Actor ActorHitByReflectedLight;
var array<Actor> TakingLightFromActors;
var(Explosion) EvilExplosion ExplosionTemplate;
var(Explosion) Vector ExplosionOffset;
var(Explosion) Rotator ExplosionRotation;
var Vector LightMeshV;
var(Sound) SoundCue AlightSound;
var(Sound) SoundCue FadeOutSound;
var(Sound) export editinline AudioComponent ChargeSound;
var(DamageUndead) array<EvilPawn> OldLightTargets;
var(DamageUndead) array<EvilPawn> LightTargets;
var(DamageUndead) ParticleSystem HitEffect;
var(DamageUndead) ParticleSystem HitEffectWhenBurned;
var(DamageUndead) config int PerBoneHitEffectInterval;
var transient int PerBoneHitEffectCounter;
var ParticleSystem ShieldedHitEffect;
var ParticleSystem FrozenHitEffect;
var export editinline ParticleSystemComponent HitEffectComp;
var export editinline ParticleSystemComponent BeamHitEffectComp;
var(DamageUndead) float BonusLightDamage;
var(DamageUndead) float CrushDamageAfterBerserkerMode;
var(DamageUndead) Vector TraceExtent;
var name BeamAtachedBoneName;
var(Particle) ParticleSystem ChargingParticleTemplate;
var export editinline ParticleSystemComponent ChargingParticle;
var(Particle) float ChargingParticleScale;
var(Particle) Vector ChargingParticleOffset;
var array<AdvDecalActorSpawnable> MirrorSpotlights;
var(Decal) MaterialInterface SpotlightDecalMaterial;
var MaterialInstanceConstant DecalMaterialInstanceConstant;
var Rotator DecalOrientation;
var(Decal) float DecalWidth;
var(Decal) float DecalHeight;
var(Decal) float DecalThickness;
var(Decal) float TraceDeviance;
var TraceHitInfo DecalHitInfo[9];
var(SpotLight) export editinline SpotLightComponent SLC;
var SoundCue SizzleSoundCue;

simulated function SetupChargingParticle()
{
    // End:0x15F
    if(int(Owner.WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        ChargingParticle = new (Outer) Class'EvilGame.UTParticleSystemComponent';
        Owner.AttachComponent(ChargingParticle);
        ChargingParticle.SetTemplate(ChargingParticleTemplate);
        ChargingParticle.SetTickGroup(3);
        ChargingParticle.bUpdateComponentInTick = true;
        ChargingParticle.SetScale(ChargingParticleScale);
        ChargingParticle.SetTranslation(ChargingParticleOffset);
        ChargingParticle.DeactivateSystem();
    }
    //return;    
}

function TestLight_T(float DeltaTime)
{
    local EvilPawn PTarget;
    local Vector TraceStart, HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local AdvTurret_Mirror_Base TurretOwner;
    local PlayerController PC;

    PC = PlayerController(Owner.Instigator.Controller);
    LightTargets.Remove(0, LightTargets.Length);    
    TurretOwner = AdvTurret_Mirror_Base(Owner);
    // End:0xB3
    if(TurretOwner != none)
    {
        TraceStart = TurretOwner.GetTraceStartLocation();        
    }
    else
    {
        TraceStart = Owner.Location;
    }
    // End:0x27A
    foreach Owner.TraceActors(Class'EvilGame.EvilPawn', PTarget, HitLocation, HitNormal, WhereLightTraceEnds, TraceStart,, HitInfo, 1)
    {
        // End:0x153
        if(AdvPlayerPawn(PTarget) != none)
        {
            continue;            
        }
        // End:0x279
        if(PTarget.IsAliveAndWell() && LightTargets.Find(PTarget) == )
        {            
            LightTargets.AddItem(PTarget);            
            // End:0x276
            if((PerBoneHitEffectCounter == 0) && (AdvPawn_Mummy_Base(PTarget) != none) || AdvPawn_Conquistador_Base(PTarget) != none)
            {
                // End:0x276
                if(((PTarget != none) && PTarget.IsAliveAndWell()) && PTarget.bLightInfluenceEnabled)
                {
                    SpawnHitEffect(PTarget, HitLocation, HitNormal, TraceStart);
                }
            }
            // End:0x27A
            break;
        }        
    }    
    // End:0x359
    foreach Owner.TraceActors(Class'EvilGame.EvilPawn', PTarget, HitLocation, HitNormal, WhereLightTraceEnds, TraceStart, TraceExtent, HitInfo, 1)
    {
        // End:0x2FB
        if(AdvPlayerPawn(PTarget) != none)
        {
            continue;            
        }
        // End:0x358
        if(PTarget.IsAliveAndWell() && LightTargets.Find(PTarget) == )
        {            
            LightTargets.AddItem(PTarget);            
            // End:0x359
            break;
        }        
    }    
    // End:0x3D7
    if(bShowDebugLine)
    {
        Owner.DrawDebugLine(TraceStart, HitLocation, 255, 105, 180, false);
        Owner.DrawDebugBox(HitLocation, TraceExtent, 255, 105, 180, false);
    }
    // End:0x71C
    foreach LightTargets(PTarget)
    {
        PTarget.ChangeSizzleSound(SizzleSoundCue);
        // End:0x50D
        if(PTarget.HasShield())
        {
            PTarget.SetLightAffectionFromFlashLight(true, true);
            // End:0x50A
            if((!PTarget.bStrafing && PTarget.bCanBeAffectedByLight) && FRand() < 0.1000000)
            {
                PTarget.TakeDamage(0, PC, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light', HitInfo, Owner);
            }            
        }
        else
        {
            PTarget.SetLightAffectionFromFlashLight(true, true, TraceStart);
            // End:0x5C2
            if((PTarget.MyEvilAI != none) && PTarget.bCanBeAffectedByLight)
            {
                PTarget.MyEvilAI.NotifyStartBurn(0.0000000, 0.0000000, 0.0000000);
            }
        }
        // End:0x71B
        if(PTarget.IsAliveAndWell() && (AdvPawn_Mummy_Base(PTarget) != none) || AdvPawn_Conquistador_Base(PTarget) != none)
        {
            // End:0x6AC
            if(PTarget.IsInBerserkerMode())
            {
                PTarget.TakeDamage(int(CrushDamageAfterBerserkerMode * DeltaTime), PC, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'AdvDmgType_TrapCrushed', HitInfo, Owner);                
            }
            else
            {
                PTarget.TakeDamage(int(BonusLightDamage * DeltaTime), PC, HitLocation, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilGame.EvilDmgType_Light', HitInfo, Owner);
            }
        }        
    }    
    // End:0x737
    if(LightTargets.Length < 1)
    {
        StopBeamHitEffect();
    }
    ClearLightTargets();
    OldLightTargets = LightTargets;
    // End:0x783
    if(PerBoneHitEffectInterval != 0)
    {
        PerBoneHitEffectCounter = ++PerBoneHitEffectCounter % PerBoneHitEffectInterval;
    }
    //return;    
}

simulated function SpawnHitEffect(EvilPawn P, Vector HitLocation, Vector HitNormal, Vector HitTraceOrigin, optional name BoneName = 'None')
{
    local float FrozenAmount;

    HitLocation -= ((Normal(HitTraceOrigin - HitLocation) * P.GetCollisionExtent().X) * 0.2000000);
    // End:0x318
    if(P.HasShield() || P.IsFrozen())
    {
        // End:0x23B
        if(HitEffectComp == none)
        {
            HitEffectComp = EvilGameReplicationInfo(Owner.WorldInfo.GRI).GOP.GetImpactParticleSystemComponent(((P.IsFrozen(FrozenAmount) && FrozenAmount > 0.2000000) ? FrozenHitEffect : ShieldedHitEffect));
            P.AttachComponent(HitEffectComp);
            HitEffectComp.SetActorParameter('BoneSocketActor', P);
            HitEffectComp.ActivateSystem(true);
            // End:0x238
            if(FrozenAmount > 0.2000000)
            {
                P.SetUnfreezeEffectComponent(HitEffectComp);
            }            
        }
        else
        {
            // End:0x2E2
            if(HitEffectComp.bIsActive)
            {
                // End:0x29D
                if(FrozenAmount <= 0.2000000)
                {
                    HitEffectComp.DeactivateSystem();
                    HitEffectComp = none;                    
                }
                else
                {
                    // End:0x2DF
                    if(HitEffectComp.bWasCompleted)
                    {
                        HitEffectComp.ActivateSystem();
                    }
                }                
            }
            else
            {
                // End:0x315
                if(FrozenAmount > 0.2000000)
                {
                    HitEffectComp.ActivateSystem();
                }
            }
        }        
    }
    else
    {
        // End:0x3E9
        if(BoneName == 'None')
        {
            BoneName = 'Spine';
            // End:0x35B
            if(BoneName == 'None')
            {
                return;
            }
            HitLocation = InverseTransformVector(P.Mesh.GetBoneMatrix(P.Mesh.MatchRefBone(BoneName)), HitLocation);
        }
        // End:0x651
        if((BeamHitEffectComp == none) || P.bCanBeAffectedByLight && BeamHitEffectComp.Template != HitEffect)
        {
            // End:0x4C0
            if(BeamHitEffectComp != none)
            {
                BeamHitEffectComp.DeactivateSystem();
                P.Mesh.DetachComponent(BeamHitEffectComp);
                BeamHitEffectComp = none;
            }
            BeamHitEffectComp = new (self) Class'Engine.ParticleSystemComponent';
            // End:0x525
            if(P.bCanBeAffectedByLight)
            {
                BeamHitEffectComp.SetTemplate(HitEffect);                
            }
            else
            {
                BeamHitEffectComp.SetTemplate(HitEffectWhenBurned);
            }
            BeamHitEffectComp.SetAbsolute(false, false, true);
            BeamHitEffectComp.SetRotation(Rotator(Normal(HitTraceOrigin - HitLocation)));
            BeamHitEffectComp.SetScale(1.0000000);
            P.Mesh.AttachComponent(BeamHitEffectComp, BoneName, HitLocation);
            BeamHitEffectComp.ActivateSystem(true);
            BeamAtachedBoneName = BoneName;            
        }
        else
        {
            P.Mesh.AttachComponent(BeamHitEffectComp, BoneName, HitLocation);
        }
    }
    //return;    
}

function StopBeamHitEffect()
{
    // End:0x39
    if(BeamHitEffectComp != none)
    {
        BeamHitEffectComp.DeactivateSystem();
        BeamHitEffectComp = none;
    }
    //return;    
}

function ForceClearLightTargets()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x5D [Loop If]
    if(I < LightTargets.Length)
    {
        LightTargets[I].SetLightAffectionFromFlashLight(false, false);
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    LightTargets.Length = 0;
    OldLightTargets.Length = 0;
    //return;    
}

function ClearLightTargets()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x87 [Loop If]
    if(I < OldLightTargets.Length)
    {
        // End:0x79
        if(LightTargets.Find(OldLightTargets[I]) == )
        {            
            OldLightTargets[I].SetLightAffectionFromFlashLight(false, false);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function UpdateUndeadInTrace(float DeltaTime)
{
    // End:0x20
    if(bDamageUndead)
    {
        TestLight_T(DeltaTime);
    }
    //return;    
}

function StopUpdateUndeadInTrace()
{
    // End:0x17
    if(bDamageUndead)
    {
        StopBeamHitEffect();
    }
    //return;    
}

function UpdatePurpose(int NewPurpose)
{
    Purpose = byte(NewPurpose);
    //return;    
}

function ActivateBeam()
{
    local Vector tmpScale, LocalTranslation;
    local Rotator OwnerRot;

    // End:0xB4
    if(Owner.IsA('AdvTurret_Base'))
    {
        AdvTurret_Base(Owner).Mesh.GetSocketWorldLocationAndRotation(AdvTurret_Base(Owner).Seats[0].GunSocket[0], LocalTranslation, OwnerRot);        
    }
    else
    {
        OwnerRot = Owner.Rotation;
    }
    // End:0x216
    if(MirrorLensFlare != none)
    {
        MirrorLensFlare.SetIsActive(true);
        // End:0x195
        if(AdvMirror_base(Owner) != none)
        {
            LocalTranslation = Vector(AdvMirror_base(Owner).StaticMeshComponent.Rotation);
            LocalTranslation.Z += DistanceFromMesh;            
        }
        else
        {
            // End:0x1EE
            if(AdvTurret_Mirror_Base(Owner) != none)
            {
                LocalTranslation = Vector(Owner.Rotation + OwnerRot) * DistanceFromMesh;
            }
        }
        MirrorLensFlare.SetTranslation(LocalTranslation);
    }
    // End:0x32D
    if(int(Purpose) != int(2))
    {
        tmpScale.Z = VSize(WhereLightEnds - Owner.Location) / (Owner.DrawScale * 128.0000000);
        tmpScale.X = LightMeshScaleFactor;
        tmpScale.Y = LightMeshScaleFactor;
        LightMesh.SetScale3D(tmpScale);
        LightMesh.SetHidden(false);
    }
    // End:0x37F
    if((ChargeSound != none) && ChargeSound.IsPlaying())
    {
        ChargeSound.Stop();
    }
    // End:0x3AD
    if(ChargingParticle != none)
    {
        ChargingParticle.DeactivateSystem();
    }
    bIsLit = true;
    // End:0x4D0
    if(bUseSpotlightComponent && SLC != none)
    {
        // End:0x4B0
        if(((AdvTurret_Mirror_Base(ActorHitByReflectedLight) != none) && AdvTurret_Mirror_Base(ActorHitByReflectedLight).MirrorComponent.bHideSpotlightWhenTargetingThisMirror) || (AdvMirror_base(ActorHitByReflectedLight) != none) && AdvMirror_base(ActorHitByReflectedLight).MirrorComponent.bHideSpotlightWhenTargetingThisMirror)
        {
            SLC.SetEnabled(false);            
        }
        else
        {
            SLC.SetEnabled(true);
        }
    }
    //return;    
}

function DeactivateBeam()
{
    local int I;

    // End:0x49
    if((ChargingParticle != none) && bChargingParticleActive)
    {
        ChargingParticle.DeactivateSystem();
        bChargingParticleActive = false;
    }
    // End:0x78
    if(MirrorLensFlare != none)
    {
        MirrorLensFlare.SetIsActive(false);
    }
    I = 0;
    J0x83:

    // End:0xD3 [Loop If]
    if(I < MirrorSpotlights.Length)
    {
        MirrorSpotlights[I].SetHidden(true);
        ++I;
        // [Loop Continue]
        goto J0x83;
    }
    // End:0x102
    if(LightMesh != none)
    {
        LightMesh.SetHidden(true);
    }
    bIsLit = false;
    StopUpdateUndeadInTrace();
    // End:0x156
    if(bUseSpotlightComponent && SLC != none)
    {
        SLC.SetEnabled(false);
    }
    //return;    
}

function CalculateNormal()
{
    local Vector HitNormal;
    local Rotator OwnerRot;

    // End:0x11E
    if(Owner.IsA('AdvTurret_Base'))
    {
        AdvTurret_Base(Owner).Mesh.GetSocketWorldLocationAndRotation(AdvTurret_Base(Owner).Seats[0].GunSocket[0], HitNormal, OwnerRot);
        HitNormal.X = Range;
        HitNormal.Y = 0.0000000;
        HitNormal.Z = 0.0000000;        
    }
    else
    {
        OwnerRot = Owner.Rotation;
        HitNormal.X = 0.0000000;
        HitNormal.Y = 0.0000000;
        HitNormal.Z = Range;
    }
    PreviousRotation = OwnerRot;
    PreviousLocation = Owner.Location;
    HitNormal = Owner.TransformVectorByRotation(OwnerRot, HitNormal);
    HitNormal = Normal(HitNormal);
    DecalOrientation = Rotator(HitNormal);
    WhereLightTraceEnds = Owner.Location + (HitNormal * Range);
    //return;    
}

simulated function Init()
{
    local float tmpScale;
    local Box ba;

    // End:0x57
    if(MirrorLensFlare != none)
    {
        Owner.AttachComponent(MirrorLensFlare);
        MirrorLensFlare.SetHidden(false);
    }
    tmpScale = Owner.DrawScale;
    Owner.SetDrawScale(1.0000000);
    Owner.GetComponentsBoundingBox(ba);
    LightMeshV = ba.Max - ba.Min;
    Owner.SetDrawScale(tmpScale);
    // End:0x1FA
    if(LightMesh != none)
    {
        LightMesh.SetActorCollision(false, false, false);
        LightMeshIntenseMaterial = LightMesh.CreateAndSetMaterialInstanceConstant(0);
        // End:0x1FA
        if(LightMeshIntenseMaterial != none)
        {
            LightMeshIntenseMaterial.SetParent(MaterialInstanceConstant'adv_ps_env_Sahara.Materials.mi_LightBeam01_sahara_03BeamNoEnd');
            LightMeshIntenseMaterial.SetScalarParameterValue('NoEnd', LightIntensity);
        }
    }
    // End:0x355
    if(DynamicSMActor(Owner) != none)
    {
        MirrorReflectingMaterial = DynamicSMActor(Owner).StaticMeshComponent.CreateAndSetMaterialInstanceConstant(int(MaterialType));
        MirrorReflectingMaterial.SetParent(ParentMaterial);
        // End:0x2D0
        if(int(MaterialType) == int(1))
        {
            MirrorReflectingMaterial.SetScalarParameterValue('LightPower', 0.0000000);            
        }
        else
        {
            MirrorReflectingMaterial.SetScalarParameterValue('State', 0.0000000);
            MirrorReflectingMaterial.SetScalarParameterValue('Power', 0.0000000);
        }
        Owner.AttachComponent(LightMesh);        
    }
    else
    {
        // End:0x559
        if(Owner.IsA('AdvTurret_Base'))
        {
            // End:0x40B
            if(LightMesh != none)
            {
                AdvTurret_Base(Owner).Mesh.AttachComponentToSocket(LightMesh, AdvTurret_Base(Owner).Seats[0].GunSocket[0]);
            }
            // End:0x49E
            if(MirrorLensFlare != none)
            {
                AdvTurret_Base(Owner).Mesh.AttachComponentToSocket(MirrorLensFlare, AdvTurret_Base(Owner).Seats[0].GunSocket[0]);
            }
            MirrorReflectingMaterial = AdvTurret_Base(Owner).Mesh.CreateAndSetMaterialInstanceConstant(int(MaterialType));
            MirrorReflectingMaterial.SetParent(ParentMaterial);
            // End:0x559
            if(int(MaterialType) == int(1))
            {
                MirrorReflectingMaterial.SetScalarParameterValue('LightPower', 0.0000000);
            }
        }
    }
    CalculateNormal();
    DestroyDecals();
    SetupSpotlight();
    // End:0x595
    if(int(Purpose) == int(2))
    {
        SetupChargingParticle();
    }
    // End:0x5B3
    if(int(Purpose) != int(1))
    {
        DeactivateBeam();
    }
    // End:0x5EA
    if(ChargeSound != none)
    {
        Owner.AttachComponent(ChargeSound);
    }
    //return;    
}

function DestroyDecals()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x53 [Loop If]
    if(I < MirrorSpotlights.Length)
    {
        MirrorSpotlights[I].Destroy();
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    MirrorSpotlights.Remove(0, MirrorSpotlights.Length);    
    //return;    
}

function SetupSpotlight()
{
    local int I;

    // End:0xED
    if(bUseSpotlightComponent)
    {
        SpotlightDecalMaterial = none;
        // End:0xC2
        if(Owner.IsA('AdvTurret_Base'))
        {
            AdvTurret_Base(Owner).Mesh.AttachComponentToSocket(SLC, AdvTurret_Base(Owner).Seats[0].GunSocket[0]);            
        }
        else
        {
            Owner.AttachComponent(SLC);
        }        
    }
    else
    {
        // End:0x3BB
        if(((int(Purpose) != int(2)) && SpotlightDecalMaterial != none) && MirrorSpotlights.Length == 0)
        {
            MirrorSpotlights.Add(9);            
            I = 0;
            J0x13C:

            // End:0x3BB [Loop If]
            if(I < MirrorSpotlights.Length)
            {
                MirrorSpotlights[I] = Owner.Spawn(Class'AdvDecalActorSpawnable', Owner);
                // End:0x3AD
                if(MirrorSpotlights[I].Decal != none)
                {
                    DecalMaterialInstanceConstant = new Class'Engine.MaterialInstanceConstant';
                    // End:0x322
                    if(DecalMaterialInstanceConstant != none)
                    {
                        DecalMaterialInstanceConstant.SetParent(SpotlightDecalMaterial);
                        MirrorSpotlights[I].Decal.SetDecalMaterial(DecalMaterialInstanceConstant);
                        MirrorSpotlights[I].Decal.bProjectOnSkeletalMeshes = true;
                        MirrorSpotlights[I].Decal.bProjectOnTerrain = true;
                        MirrorSpotlights[I].Decal.bProjectOnStaticMeshes = true;
                    }
                    MirrorSpotlights[I].SetRotation(DecalOrientation);
                    MirrorSpotlights[I].SetLocation(WhereLightEnds);
                    MirrorSpotlights[I].SetHidden(true);
                    DecalMaterialInstanceConstant = none;
                }
                ++I;
                // [Loop Continue]
                goto J0x13C;
            }
        }
    }
    //return;    
}

function SetLightAffectionFromFlashLight(bool bInLightCone, optional bool bBeamActive, optional Vector FlashSourceLocation)
{
    // End:0x28
    if(bBeamActive && bInLightCone)
    {
        StartInLightEffects();
    }
    //return;    
}

function StartInLightEffects()
{
    bIsUnderFocusedBeam = true;
    TimeIntervalBeamLocation = 0.0000000;
    bToggleEventFired = false;
    // End:0x42
    if(!bIsUnderFocusedBeamEffect)
    {
        bIsUnderFocusedBeamEffect = true;
    }
    //return;    
}

function StopInLightEffects()
{
    //return;    
}

function SetTraceParameters(Actor HitActor, Vector HitLocation, Vector HitNormal, Vector SourceLocation)
{
    //return;    
}

function SetLightAffectionFromVolume(bool bInLightVolume)
{
    //return;    
}

function UpdateLightInfluence_T()
{
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local int I;

    super.Tick(DeltaTime);
    TimeInterval += DeltaTime;
    TimeIntervalBeamLocation += DeltaTime;
    TimeIntervalUpdateUndead += DeltaTime;
    // End:0xCC
    if((int(Purpose) != int(2)) && (PreviousLocation != Owner.Location) || PreviousRotation != Owner.Rotation)
    {
        CalculateNormal();        
    }
    else
    {
        // End:0xEE
        if(AdvTurret_Mirror_Base(Owner) != none)
        {
            CalculateNormal();
        }
    }
    // End:0x605
    if((int(Purpose) != int(2)) && bIsLit)
    {
        CheckFurtherLightCollision();
        I = 0;
        J0x126:

        // End:0x605 [Loop If]
        if(I < MirrorSpotlights.Length)
        {
            // End:0x19D
            if((AdvTurret_Mirror_Base(ActorHitByReflectedLight) != none) || AdvMirror_base(ActorHitByReflectedLight) != none)
            {
                MirrorSpotlights[I].SetHidden(true);                
            }
            else
            {
                // End:0x3AE
                if(I == 0)
                {
                    MirrorSpotlights[I].SetHidden(false);
                    MirrorSpotlights[I].SetLocation(WhereLightEnds);
                    MirrorSpotlights[I].SetRotation(DecalOrientation);
                    Owner.WorldInfo.MyDecalManager.SetSomeDecalParameters(MirrorSpotlights[I].Decal, WhereLightEnds, DecalOrientation, DecalWidth, DecalHeight, DecalThickness, bNoClip, 0.0000000,, true, true,, -1, DecalHitInfo[I].LevelIndex, -1, Owner.WorldInfo.MyDecalManager.DecalDepthBias, Multiply_Vector2DFloat(Owner.WorldInfo.MyDecalManager.DecalBlendRange, float(5)));                    
                }
                else
                {
                    MirrorSpotlights[I].SetHidden(false);
                    MirrorSpotlights[I].SetLocation(WhereLightEnds);
                    MirrorSpotlights[I].SetRotation(DecalOrientation);
                    Owner.WorldInfo.MyDecalManager.SetSomeDecalParameters(MirrorSpotlights[I].Decal, WhereLightEnds, DecalOrientation, DecalWidth, DecalHeight, DecalThickness, bNoClip, 0.0000000, DecalHitInfo[I].HitComponent, true, true, DecalHitInfo[I].BoneName, -1, DecalHitInfo[I].LevelIndex, -1, Owner.WorldInfo.MyDecalManager.DecalDepthBias, Multiply_Vector2DFloat(Owner.WorldInfo.MyDecalManager.DecalBlendRange, float(5)));
                }
            }
            ++I;
            // [Loop Continue]
            goto J0x126;
        }
    }
    // End:0x63A
    if(TimeIntervalUpdateUndead >= 0.2000000)
    {
        UpdateUndeadInTrace(TimeIntervalUpdateUndead);
        TimeIntervalUpdateUndead = 0.0000000;
    }
    // End:0xA8D
    if(TimeInterval > 0.0400000)
    {
        TimeInterval = 0.0000000;
        // End:0x690
        if(int(Purpose) == int(1))
        {
            LightPower = LightPowerThreshold;
            ActivateBeam();            
        }
        else
        {
            // End:0x74A
            if(bIsUnderFocusedBeamEffect)
            {
                FireFocusingEvent(bIsUnderFocusedBeamEffect);
                LightPower += (LightGainer * DeltaTime);
                // End:0x747
                if(LightPower > (LightPowerThreshold / float(2)))
                {
                    // End:0x706
                    if(!ToggleMode)
                    {
                        ActivateBeam();
                    }
                    // End:0x747
                    if(LightPower >= LightPowerThreshold)
                    {
                        LightPower = LightPowerThreshold;
                        // End:0x747
                        if(ToggleMode)
                        {
                            ActivateBeam();
                        }
                    }
                }                
            }
            else
            {
                FireFocusingEvent(bIsUnderFocusedBeamEffect);
                LightPower -= (LightGainer * DeltaTime);
                // End:0x7EF
                if(LightPower < float(0))
                {
                    LightPower = 0.0000000;
                    // End:0x7EF
                    if((ChargeSound != none) && ChargeSound.IsPlaying())
                    {
                        ChargeSound.Stop();
                    }
                }
                DeactivateBeam();
            }
        }
        // End:0x917
        if(!bIsLit && LightPower > float(0))
        {
            // End:0x876
            if(((ChargingParticle != none) && !bChargingParticleActive) && bIsUnderFocusedBeamEffect)
            {
                ChargingParticle.ActivateSystem();
                bChargingParticleActive = true;
            }
            // End:0x917
            if(ChargeSound != none)
            {
                // End:0x8E4
                if(bShouldMakeChargeSoundWhileWearingOff || bIsUnderFocusedBeamEffect)
                {
                    // End:0x8E4
                    if(!ChargeSound.IsPlaying())
                    {
                        ChargeSound.Play();
                    }
                }
                ChargeSound.VolumeMultiplier = LightPower / LightPowerThreshold;
            }
        }
        // End:0x9DB
        if(MirrorReflectingMaterial != none)
        {
            // End:0x96E
            if(int(MaterialType) == int(1))
            {
                MirrorReflectingMaterial.SetScalarParameterValue('LightPower', LightPower);                
            }
            else
            {
                MirrorReflectingMaterial.SetScalarParameterValue('State', float(((bIsLit) ? 2 : 1)));
                MirrorReflectingMaterial.SetScalarParameterValue('Power', LightPower);
            }
        }
        // End:0x9FE
        if(bIsLit != bWasLit)
        {
            InvokeActivatedEvent();
        }
        // End:0xA52
        if(((ToggleMode && !bIsUnderFocusedBeam) && bIsLit) && !bToggleEventFired)
        {
            bToggleEventFired = true;
            InvokeActivatedEvent();
        }
        // End:0xA8D
        if(!ToggleMode || ToggleMode && !bIsLit)
        {
            bIsUnderFocusedBeamEffect = false;
        }
    }
    // End:0xAD1
    if(TimeIntervalBeamLocation > 0.3000000)
    {
        TakingLightFromActors.Remove(0, TakingLightFromActors.Length);        
        TimeIntervalBeamLocation = 0.0000000;
        bIsUnderFocusedBeam = false;
    }
    //return;    
}

function CheckFurtherLightCollision()
{
    local Vector TraceStart, HitLocation, HitNormal;
    local AdvTurret_Mirror_Base TurretOwner;
    local Vector LocalHitNormal;
    local bool bValidCheck;
    local int I, J;
    local Vector tmpWhereLightTraceEnds;
    local Rotator tmpWhereLightTraceEndsRotation;
    local Actor P;

    bValidCheck = false;
    TurretOwner = AdvTurret_Mirror_Base(Owner);
    // End:0x63
    if(TurretOwner != none)
    {
        TraceStart = TurretOwner.GetTraceStartLocation();        
    }
    else
    {
        TraceStart = Owner.Location;
    }
    // End:0x925
    if(SpotlightDecalMaterial != none)
    {
        tmpWhereLightTraceEndsRotation.Pitch = int(TraceDeviance * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = int(TraceDeviance * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[1], 1);
        // End:0x1AE
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = int(-TraceDeviance * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = int(TraceDeviance * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[2], 1);
        // End:0x2C5
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = int(-TraceDeviance * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = int(-TraceDeviance * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[3], 1);
        // End:0x3DE
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = int(TraceDeviance * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = int(-TraceDeviance * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[4], 1);
        // End:0x4F5
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = int((TraceDeviance * 1.2000000) * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = 0;
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[5], 1);
        // End:0x600
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = int((-TraceDeviance * 1.2000000) * 182.0444000);
        tmpWhereLightTraceEndsRotation.Yaw = 0;
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[6], 1);
        // End:0x70D
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = 0;
        tmpWhereLightTraceEndsRotation.Yaw = int((TraceDeviance * 1.2000000) * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[7], 1);
        // End:0x818
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
        tmpWhereLightTraceEndsRotation.Pitch = 0;
        tmpWhereLightTraceEndsRotation.Yaw = int((-TraceDeviance * 1.2000000) * 182.0444000);
        tmpWhereLightTraceEnds = TransformVectorByRotation(tmpWhereLightTraceEndsRotation, WhereLightTraceEnds);
        Owner.Trace(HitLocation, HitNormal, tmpWhereLightTraceEnds, TraceStart, true,, DecalHitInfo[8], 1);
        // End:0x925
        if(bShowDebugLine)
        {
            Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        }
    }
    ActorHitByReflectedLight = Owner.Trace(HitLocation, HitNormal, WhereLightTraceEnds, TraceStart, true,, DecalHitInfo[0], 1);
    // End:0x99E
    if(ActorHitByReflectedLight == none)
    {
        WhereLightEnds = WhereLightTraceEnds;        
    }
    else
    {
        // End:0xAA9
        if(AdvPlayerPawn(ActorHitByReflectedLight) != none)
        {
            // End:0xAA5
            foreach Owner.TraceActors(Class'Engine.Actor', P, HitLocation, HitNormal, WhereLightTraceEnds, TraceStart,, DecalHitInfo[0], 1)
            {
                // End:0xA30
                if(AdvPlayerPawn(P) != none)
                {
                    continue;                    
                }
                // End:0xA8E
                if((AdvMirror_base(P) != none) || AdvTurret_Mirror_Base(P) != none)
                {
                    ActorHitByReflectedLight = P;
                    WhereLightEnds = HitLocation;
                    // End:0xAA5
                    break;
                    // End:0xAA4
                    continue;
                }
                WhereLightEnds = WhereLightTraceEnds;
                // End:0xAA5
                break;                
            }                        
        }
        else
        {
            WhereLightEnds = HitLocation;
        }
    }
    // End:0xFDC
    if((AdvMirror_base(ActorHitByReflectedLight) != none) && bIsLit)
    {
        // End:0xBB9
        if(int(AdvMirror_base(ActorHitByReflectedLight).MirrorComponent.MaterialType) != int(1))
        {
            AdvMirror_base(ActorHitByReflectedLight).SetTraceParameters(ActorHitByReflectedLight, HitLocation, HitNormal, Owner.Location);
            AdvMirror_base(ActorHitByReflectedLight).SetLightAffectionFromFlashLight(true, true);            
        }
        else
        {
            // End:0xDAB
            if(AdvMirror_base(ActorHitByReflectedLight).MirrorComponent.ActorHitByReflectedLight == Owner)
            {
                I = 0;
                J0xC0E:

                // End:0xDA8 [Loop If]
                if(I < TakingLightFromActors.Length)
                {
                    // End:0xC83
                    if(int(AdvMirror_base(TakingLightFromActors[I]).MirrorComponent.Purpose) == int(1))
                    {
                        bValidCheck = true;
                    }
                    // End:0xD9A
                    if(!bValidCheck)
                    {
                        J = 0;
                        J0xC9D:

                        // End:0xD9A [Loop If]
                        if(J < AdvMirror_base(TakingLightFromActors[I]).MirrorComponent.TakingLightFromActors.Length)
                        {
                            // End:0xD8C
                            if(int(AdvMirror_base(AdvMirror_base(TakingLightFromActors[I]).MirrorComponent.TakingLightFromActors[J]).MirrorComponent.Purpose) == int(1))
                            {
                                bValidCheck = true;
                            }
                            ++J;
                            // [Loop Continue]
                            goto J0xC9D;
                        }
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0xC0E;
                }                
            }
            else
            {
                bValidCheck = true;
            }
            // End:0xFD9
            if(bValidCheck || int(AdvMirror_base(Owner).MirrorComponent.Purpose) == int(1))
            {
                LocalHitNormal = HitNormal << ActorHitByReflectedLight.Rotation;
                // End:0xFD9
                if(((Round(LocalHitNormal.X) == 0) && Round(LocalHitNormal.Y) == 0) && Round(LocalHitNormal.Z) == 1)
                {
                    AdvMirror_base(ActorHitByReflectedLight).SetTraceParameters(ActorHitByReflectedLight, HitLocation, HitNormal, Owner.Location);
                    AdvMirror_base(ActorHitByReflectedLight).SetLightAffectionFromFlashLight(true, true);
                    // End:0xFD9
                    if(AdvMirror_base(ActorHitByReflectedLight).MirrorComponent.TakingLightFromActors.Find(Owner) == )
                    {                        
                        AdvMirror_base(ActorHitByReflectedLight).MirrorComponent.TakingLightFromActors.AddItem(Owner);                        
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x12C8
        if((AdvTurret_Mirror_Base(ActorHitByReflectedLight) != none) && bIsLit)
        {
            // End:0x108D
            if(AdvTurret_Mirror_Base(ActorHitByReflectedLight).MirrorComponent.ActorHitByReflectedLight == Owner)
            {
                bValidCheck = FindLightSource(TakingLightFromActors, Owner);
                TakingLightFromActors.Remove(0, TakingLightFromActors.Length);                                
            }
            else
            {
                bValidCheck = true;
            }
            LocalHitNormal = HitNormal << AdvTurret_Mirror_Base(ActorHitByReflectedLight).SeatWeaponRotation(0,, true);
            // End:0x12C8
            if(bValidCheck || int(AdvTurret_Mirror_Base(Owner).MirrorComponent.Purpose) == int(1))
            {
                // End:0x12C8
                if(((Round(LocalHitNormal.X) == 1) && Round(LocalHitNormal.Y) == 0) && Round(LocalHitNormal.Z) == 0)
                {
                    AdvTurret_Mirror_Base(ActorHitByReflectedLight).SetTraceParameters(ActorHitByReflectedLight, HitLocation, HitNormal, Owner.Location);
                    AdvTurret_Mirror_Base(ActorHitByReflectedLight).SetLightAffectionFromFlashLight(true, true);
                    // End:0x12C8
                    if(AdvTurret_Mirror_Base(ActorHitByReflectedLight).MirrorComponent.TakingLightFromActors.Find(Owner) == )
                    {                        
                        AdvTurret_Mirror_Base(ActorHitByReflectedLight).MirrorComponent.TakingLightFromActors.AddItem(Owner);                        
                    }
                }
            }
        }
    }
    // End:0x1595
    if(bShowDebugLine)
    {
        Owner.DrawDebugLine(TraceStart, HitLocation, 255, 0, 0, false);
        Owner.DrawDebugLine(HitLocation, HitLocation + (HitNormal * float(30)), 0, 255, 0, false);
        Owner.WorldInfo.GetALocalPlayerController().AddDebugText(((((((((((((((((((((((((("bIsLit:'" $ string(bIsLit)) $ "'") $ "\n") $ "ActorHitByReflectedLight:'") $ string(ActorHitByReflectedLight)) $ "'") $ "\n") $ "LightMesh.HiddenGame:'") $ string(LightMesh.HiddenGame)) $ "'") $ "\n") $ "LightMesh.Owner:'") $ string(LightMesh.Owner)) $ "'") $ "\n") $ "AdvTurret_Mirror_Base(Owner).WeaponRotation:'") $ string(AdvTurret_Mirror_Base(Owner).WeaponRotation)) $ "'") $ "\n") $ "AdvTurret_Mirror_Base(Owner).RotationViewDiff:'") $ string(AdvTurret_Mirror_Base(Owner).RotationViewDiff)) $ "'") $ "\n") $ "LocalHitNormal:'") $ string(LocalHitNormal)) $ "'", Owner,,,, MakeColor(255, 0, 0, 255));
    }
    // End:0x1617
    if(((TurretOwner != none) && TurretOwner.TargetActor != none) && TurretOwner.TargetActor == ActorHitByReflectedLight)
    {
        TurretOwner.KickPlayerOutAndLock();
    }
    //return;    
}

function bool FindLightSource(array<Actor> TakingLightsFromA, Actor except)
{
    local bool Result;
    local int I;

    // End:0x30
    if(int(self.Purpose) == int(1))
    {
        Result = true;        
    }
    else
    {
        I = 0;
        J0x3B:

        // End:0xC1 [Loop If]
        if(I < TakingLightsFromA.Length)
        {
            // End:0xB3
            if(int(AdvTurret_Mirror_Base(TakingLightsFromA[I]).MirrorComponent.Purpose) == int(1))
            {
                Result = true;
                // [Explicit Break]
                goto J0xC1;
            }
            ++I;
            // [Loop Continue]
            goto J0x3B;
        }
        J0xC1:

        // End:0x196
        if(!Result)
        {
            I = 0;
            J0xDB:

            // End:0x196 [Loop If]
            if(I < TakingLightsFromA.Length)
            {
                // End:0x178
                if(except != TakingLightsFromA[I])
                {
                    Result = FindLightSource(AdvTurret_Mirror_Base(TakingLightsFromA[I]).MirrorComponent.TakingLightFromActors, Owner);
                }
                // End:0x188
                if(Result)
                {
                    // [Explicit Break]
                    goto J0x196;
                }
                ++I;
                // [Loop Continue]
                goto J0xDB;
            }
        }
    }
    J0x196:

    return Result;
    //return ReturnValue;    
}

function InvokeActivatedEvent()
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_Activated FireEvent;
    local array<int> ActivateIndices;
    local EvilExplosionActor ExplosionActor;
    local EvilExplosion ExplosionObject;
    local Rotator OwnerRotation;
    local Vector OwnerLocation, ExplosionLocation;
    local Rotator ExplosionFinalRotation;

    GameSeq = Owner.WorldInfo.GetGameSequence();
    bWasLit = bIsLit;
    // End:0x4C5
    if(GameSeq != none)
    {
        // End:0x3B5
        if(bIsLit)
        {
            // End:0x9D
            if(ToggleMode && !bIsUnderFocusedBeam)
            {
                ActivateIndices[0] = 1;                
            }
            else
            {
                ActivateIndices[0] = 0;
                // End:0xE6
                if(AlightSound != none)
                {
                    Owner.PlaySound(AlightSound);
                }
                // End:0x3B2
                if(ExplosionTemplate != none)
                {
                    ExplosionObject = new ExplosionTemplate.Class (ExplosionTemplate);
                    // End:0x25A
                    if(Owner.IsA('AdvTurret_Base'))
                    {
                        AdvTurret_Base(Owner).Mesh.GetSocketWorldLocationAndRotation(AdvTurret_Base(Owner).Seats[0].GunSocket[0], OwnerLocation, OwnerRotation);
                        ExplosionLocation = TransformVectorByRotation(Owner.Rotation + OwnerRotation, ExplosionOffset);
                        ExplosionFinalRotation = Owner.Rotation + OwnerRotation;                        
                    }
                    else
                    {
                        OwnerLocation = Owner.Location;
                        OwnerRotation = Owner.Rotation;
                        ExplosionLocation = TransformVectorByRotation(Owner.Rotation, ExplosionOffset);
                        ExplosionFinalRotation = OwnerRotation;
                    }
                    ExplosionActor = Owner.Spawn(Class'EvilGame.EvilExplosionActor', Owner,, OwnerLocation + ExplosionLocation, ExplosionFinalRotation + ExplosionRotation);
                    ExplosionObject.HitNormal = Vector(OwnerRotation);
                    ExplosionActor.Explode(ExplosionObject);
                }
            }            
        }
        else
        {
            ActivateIndices[0] = 1;
            // End:0x3FE
            if(FadeOutSound != none)
            {
                Owner.PlaySound(FadeOutSound);
            }
        }
        GameSeq.FindSeqObjectsByClass(Class'EvilGame.SeqEvent_Activated', true, ExecutionEvents);
        // End:0x4C4
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_Activated(ExecutionEvent);
            // End:0x4C3
            if(FireEvent.Originator == Owner)
            {
                FireEvent.CheckActivate(Owner, none, false, ActivateIndices);
            }            
        }        
    }
    //return;    
}

function FireFocusingEvent(bool bFocusedByLight)
{
    local Sequence GameSeq;
    local array<SequenceObject> ExecutionEvents;
    local SequenceObject ExecutionEvent;
    local SeqEvent_LightFocus FireEvent;
    local array<int> ActivateIndices;

    GameSeq = Owner.WorldInfo.GetGameSequence();
    // End:0x159
    if((GameSeq != none) && bWasUnderFocusedBeam != bFocusedByLight)
    {
        // End:0x85
        if(bFocusedByLight)
        {
            ActivateIndices[0] = 0;            
        }
        else
        {
            ActivateIndices[0] = 1;
        }
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_LightFocus', true, ExecutionEvents);
        // End:0x158
        foreach ExecutionEvents(ExecutionEvent)
        {
            FireEvent = SeqEvent_LightFocus(ExecutionEvent);
            // End:0x157
            if(FireEvent.Originator == Owner)
            {
                FireEvent.CheckActivate(Owner, none, false, ActivateIndices);
            }            
        }        
    }
    bWasUnderFocusedBeam = bFocusedByLight;
    //return;    
}

defaultproperties
{
    Range=10000.0000000
    MaterialType=CustomMaterialType.MirrorMesh
    LightPowerThreshold=1.0000000
    LightGainer=2.5000000
    // Reference: LensFlareComponent'Default__AdvMirrorComponent.LensFlare0'
    begin object name=LensFlare0 class=Class'Engine.LensFlareComponent'
        Template=LensFlare'adv_ps_env_Sahara.flares.lf_en_mirror'
        NextTraceTime=-0.8926969
        ReplacementPrimitive=none
        Scale=0.1500000
    end object
    MirrorLensFlare=LensFlare0
    DistanceFromMesh=2.0000000
    bShouldMakeChargeSoundWhileWearingOff=true
    bNoClip=true
    bHideSpotlightWhenTargetingThisMirror=true
    LightMeshScaleFactor=3.0000000
    ParentMaterial=Material'adv_en_egypt_architecture_03.Materials.m_en_EgyptMirror_01_01'
    // Reference: AudioComponent'Default__AdvMirrorComponent.ChargeAudioComponent0'
    begin object name=ChargeAudioComponent0 class=Class'Engine.AudioComponent'
    end object
    ChargeSound=ChargeAudioComponent0
    HitEffect=ParticleSystem'ps_Mummy.Effects.ps_LightHitConeConst'
    HitEffectWhenBurned=ParticleSystem'ps_Mummy.Effects.ps_LightHitConeConstTest'
    PerBoneHitEffectInterval=2
    ShieldedHitEffect=ParticleSystem'ps_Mummy.Effects.ps_Flashlight_ShieldSparkles'
    FrozenHitEffect=ParticleSystem'ps_Mummy.Effects.ps_ch_MummyUnFreeze'
    BonusLightDamage=5.0000000
    CrushDamageAfterBerserkerMode=5.0000000
    TraceExtent=(X=5.0000000,Y=5.0000000,Z=5.0000000)
    ChargingParticleTemplate=ParticleSystem'adv_lf_flares_01.Effects.ps_SparkCrystal'
    ChargingParticleScale=0.5000000
    ChargingParticleOffset=(X=0.0000000,Y=0.0000000,Z=40.0000000)
    SpotlightDecalMaterial=DecalMaterial'adv_lf_flares_01.Materials.m_MirrorLightOnWall'
    DecalWidth=150.0000000
    DecalHeight=150.0000000
    DecalThickness=2000.0000000
    TraceDeviance=1.5000000
    // Reference: SpotLightComponent'Default__AdvMirrorComponent.SpotLightComponent0'
    begin object name=SpotLightComponent0 class=Class'Engine.SpotLightComponent'
        InnerConeAngle=2.5000000
        OuterConeAngle=5.0000000
        Radius=5000.0000000
        FalloffExponent=3.3400000
        LightmassSettings=(LightSourceRadius=32.0000000)
        Brightness=3.0000000
        bEnabled=false
        CastShadows=false
        CastStaticShadows=false
        CastDynamicShadows=false
        UseDirectLightMap=true
    end object
    SLC=SpotLightComponent0
    bTickScript=true
}