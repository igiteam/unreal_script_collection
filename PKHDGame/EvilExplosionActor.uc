class EvilExplosionActor extends Actor
    notplaceable
    hidecategories(Navigation);

var protected transient bool bHasExploded;
var protected transient bool bExplosionEnableBloom;
var protected transient bool bExplosionEnableBleachBypass;
var protected export editinline transient PointLightComponent ExplosionLight;
var protected transient float LightFadeTime;
var protected transient float LightInitialBrightness;
var EvilExplosion ExplosionTemplate;
var protected export editinline transient RadialBlurComponent ExplosionRadialBlur;
var protected transient float RadialBlurFadeTime;
var protected transient float RadialBlurFadeTimeRemaining;
var protected transient float RadialBlurMaxBlurAmount;
var protected transient PPParameters BloomParams;
var protected transient float BloomFadeTime;
var protected transient float BloomFadeTimeRemaining;
var protected transient float ExplosionBloomRadius;
var protected transient float ExplosionBleachBypassMaxOpacity;
var protected export editinline RB_RadialImpulseComponent RadialImpulseComponent;
var Controller InstigatorController;
var Actor HitActorFromPhysMaterialTrace;
var Vector HitLocationFromPhysMaterialTrace;

event PreBeginPlay()
{
    super.PreBeginPlay();
    // End:0x52
    if((Instigator != none) && InstigatorController == none)
    {
        InstigatorController = Instigator.Controller;
    }
    //return;    
}

protected final simulated function HurtExplosion_Worker(Actor Victim, float BaseDamage, float DamageRadius, float DamageFalloffExp, class<DamageType> DamageType, float MomentumScale, Vector ExploOrigin, Controller InstigatedByController, bool bDoFullDamage, out array<Actor> VictimsList)
{
    local Actor HitActor;
    local Controller ModInstigator;
    local EvilPawn VictimPawn;
    local class<DamageType> ModDamageType;
    local bool bDamageBlocked;
    local Vector HitL, HitN, Dir;
    local float DamageScale, Dist, ColRadius, ColHeight;
    local Box BBox;
    local Vector BBoxCenter;

    bDamageBlocked = false;
    ModDamageType = DamageType;
    ModInstigator = InstigatedByController;
    VictimPawn = EvilPawn(Victim);
    // End:0x15D
    if((((ExplosionTemplate.AttacheeController != none) && VictimPawn != none) && !WorldInfo.GRI.IsCoopMultiplayerGame()) && !WorldInfo.GRI.OnSameTeam(ExplosionTemplate.AttacheeController, VictimPawn.Controller))
    {
        ModInstigator = ExplosionTemplate.AttacheeController;
    }
    // End:0x18E
    if(DoFullDamageToActor(Victim))
    {
        bDamageBlocked = false;
        bDoFullDamage = true;        
    }
    else
    {
        Victim.GetComponentsBoundingBox(BBox);
        BBoxCenter = (BBox.Min + BBox.Max) * 0.5000000;
        HitActor = Trace(HitL, HitN, BBoxCenter, ExploOrigin, false,,, 1);
        // End:0x280
        if((HitActor != none) && HitActor != Victim)
        {
            // End:0x280
            if(DoFullDamageToActor(HitActor))
            {
                bDamageBlocked = true;
            }
        }
    }
    // End:0x802
    if(!bDamageBlocked)
    {
        Victim.GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Victim.Location - ExploOrigin;
        Dist = VSize(Dir);
        Dist = FMax(Dist - ColRadius, 0.0000000);
        // End:0x34C
        if(bDoFullDamage)
        {
            DamageScale = 1.0000000;            
        }
        else
        {
            DamageScale = FClamp(1.0000000 - (Dist / DamageRadius), 0.0000000, 1.0000000);
            DamageScale = DamageScale ** DamageFalloffExp;
        }
        // End:0x407
        if(ExplosionTemplate.KnockDownRadius > float(0))
        {
            MomentumScale = FClamp(1.0000000 - (Dist / ExplosionTemplate.KnockDownRadius), 0.0000000, 1.0000000);
        }
        MomentumScale = MomentumScale ** DamageFalloffExp;
        Dir = Victim.Location - (ExploOrigin + ((vect(0.0000000, 0.0000000, -1.0000000) * ExplosionTemplate.ExplosionOriginShiftDown) * MomentumScale));
        Dist = VSize(Dir);
        Dir = Normal(Dir);
        // End:0x549
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Victim), EvilPlayer_interface(none)) && !WorldInfo.GRI.IsMultiplayerGame())
        {
            DamageScale *= ExplosionTemplate.PlayerDamageModifier;
        }
        // End:0x6CB
        if(DamageScale > 0.0000000)
        {
            // End:0x60A
            if((ModInstigator != none) && EvilWeap_Base(ModInstigator.Pawn.Weapon) != none)
            {
                EvilWeap_Base(ModInstigator.Pawn.Weapon).CheckAndUpdateHitEnemyIndicator(Victim);
            }
            Victim.TakeDamage(int(BaseDamage * DamageScale), ModInstigator, Victim.Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), MomentumScale * Dir, ModDamageType,, self);
            VictimsList[VictimsList.Length] = Victim;
        }
        // End:0x781
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Victim), EvilPlayer_interface(none)) && WorldInfo.GRI.IsMultiplayerGame())
        {
            Victim.Velocity += ((MomentumScale * Dir) * ExplosionTemplate.Momentum);
        }
        Dir = ExploOrigin + ((vect(0.0000000, 0.0000000, -1.0000000) * ExplosionTemplate.ExplosionOriginShiftDown) * MomentumScale);
        // End:0x802
        if(VictimPawn != none)
        {
            DoPawnKnockDown(VictimPawn, Dir, Dist);
        }
    }
    //return;    
}

protected final simulated function HurtExplosion(float BaseDamage, float DamageRadius, float DamageFalloffExp, class<DamageType> DamageType, float MomentumScale, Vector ExploOrigin, Actor IgnoredActor, class<Actor> ActorClassToIgnoreForDamage, Controller InstigatedByController, bool bDoFullDamage)
{
    local Actor Victim;
    local Vector Dir;
    local float ColRadius, ColHeight;
    local EvilPawn HitEvilPawn;
    local array<Actor> VictimsList;
    local int I;
    local EvilPlayerController PC;
    local array<EvilPawn> KilledPawns;

    HitEvilPawn = EvilPawn(ExplosionTemplate.HitActor);
    // End:0xB5
    if((HitEvilPawn != none) && HitEvilPawn != IgnoredActor)
    {
        HurtExplosion_Worker(HitEvilPawn, BaseDamage, DamageRadius, DamageFalloffExp, DamageType, MomentumScale, ExploOrigin, InstigatedByController, true, VictimsList);
    }
    // End:0x24A
    foreach CollidingActors(Class'Engine.Actor', Victim, DamageRadius, ExploOrigin, true)
    {
        // End:0x249
        if((((((Victim != self) && Victim != IgnoredActor) && Victim != HitEvilPawn) && (int(Victim.Role) == int(ROLE_Authority)) || Victim.bTearOff) && !Victim.bWorldGeometry || EvilDestructibleObject(Victim) != none) && ClassIsChildOf(Victim.Class, ActorClassToIgnoreForDamage) == false)
        {
            HurtExplosion_Worker(Victim, BaseDamage, DamageRadius, DamageFalloffExp, DamageType, MomentumScale, ExploOrigin, InstigatedByController, bDoFullDamage, VictimsList);
        }        
    }    
    // End:0x3D9
    if(ExplosionTemplate.bFullDamageToAttachee && VictimsList.Find(ExplosionTemplate.Attachee) < 0)
    {
        Victim = ExplosionTemplate.Attachee;
        Victim.GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Victim.Location - ExploOrigin;
        Dir = Normal(Dir);
        Victim.TakeDamage(int(BaseDamage), InstigatedByController, Victim.Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), MomentumScale * Dir, DamageType,, self);
    }
    I = 0;
    J0x3E4:

    // End:0x48E [Loop If]
    if(I < VictimsList.Length)
    {
        // End:0x480
        if((EvilPawn(VictimsList[I]) != none) && !EvilPawn(VictimsList[I]).IsAliveAndWell())
        {
            KilledPawns.AddItem(EvilPawn(VictimsList[I]));
        }
        I++;
        // [Loop Continue]
        goto J0x3E4;
    }
    // End:0x4FA
    if(KilledPawns.Length >= 1)
    {
        PC = EvilPlayerController(InstigatorController);
        // End:0x4FA
        if(PC != none)
        {
            PC.KilledSomeEnemiesByExplosion(KilledPawns, DamageType);
        }
    }
    //return;    
}

simulated function bool DoFullDamageToActor(Actor Victim)
{
    return ((((((Victim.bStatic || Victim.IsA('KActor')) || Victim.IsA('InterpActor')) || Victim.IsA('EvilDestroyPack')) || Victim.IsA('EvilDynamicDestructibleObject')) || Victim.IsA('EvilDestructibleObject')) || Victim.IsA('FracturedStaticMeshPart')) || Victim.IsA('EvilProj_Grenade');
    //return ReturnValue;    
}

protected simulated function DoBreakFracturedMeshes(Vector ExploOrigin, float DamageRadius, float RBStrength, class<DamageType> dmgType)
{
    local FracturedStaticMeshActor FracActor;
    local byte bWantPhysChunksAndParticles;

    // End:0x10B
    foreach CollidingActors(Class'Engine.FracturedStaticMeshActor', FracActor, DamageRadius, ExploOrigin, true)
    {
        // End:0x10A
        if((int(FracActor.Physics) == int(0)) && FracActor.IsFracturedByDamageType(dmgType))
        {
            // End:0x10A
            if(FracActor.FractureEffectIsRelevant(false, Instigator, bWantPhysChunksAndParticles))
            {
                FracActor.BreakOffPartsInRadius(ExploOrigin, DamageRadius, RBStrength, ((int(bWantPhysChunksAndParticles) == int(1)) ? true : false));
            }
        }        
    }    
    //return;    
}

protected function bool AllowKnockDown(EvilPawn P, float DistFromExplosionCenterToPawn)
{
    // End:0x70
    if((!P.bRespondToExplosions || P.InGodMode()) || !P.CanBeKnockedDown())
    {
        return false;
    }
    // End:0xB7
    if(ClassIsChildOf(P.Class, ExplosionTemplate.ActorClassToIgnoreForKnockdownsAndCringes) == true)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

protected function DoPawnKnockDown(EvilPawn P, Vector ExplosionOrigin, float DistFromExplosionCenterToPawnLocation)
{
    // End:0xCE
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xCE
        if((AllowKnockDown(P, DistFromExplosionCenterToPawnLocation)) && DistFromExplosionCenterToPawnLocation < ExplosionTemplate.KnockDownRadius)
        {
            P.Knockdown(,,, ExplosionOrigin, ExplosionTemplate.KnockDownRadius * float(2), ExplosionTemplate.KnockDownStrength);
        }
    }
    //return;    
}

protected simulated function UpdateExplosionTemplateWithPerMaterialFX(PhysicalMaterial PhysMaterial)
{
    local DecalData DecalData;
    local ParticleSystem ExplosionPS;
    local SoundCue ExploSound;
    local FogVolumeSphericalDensityInfo FogVolumeArchetype;
    local class<EmitterCameraLensEffectBase> CameraEffect;
    local float CameraEffectRadius;
    local EvilGameReplicationInfo GRI;
    local float ParticleScale;

    GRI = EvilGameReplicationInfo(WorldInfo.GRI);
    // End:0x183
    if(GRI.IsEffectRelevant(Instigator, Location, 6000.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront))
    {
        // End:0x180
        if(ExplosionTemplate.bParticleSystemIsBeingOverriddenDontUsePhysMatVersion == false)
        {
            ExplosionPS = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactParticleSystem(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo, ((InstigatorController != none) ? InstigatorController.Pawn : none), ParticleScale);
            // End:0x180
            if(ExplosionPS != none)
            {
                ExplosionTemplate.ParticleEmitterTemplate = ExplosionPS;
            }
        }        
    }
    else
    {
        ExplosionTemplate.ParticleEmitterTemplate = none;
    }
    ExplosionTemplate.DecalData.bIsValid = true;
    // End:0x330
    if(GRI.IsEffectRelevant(Instigator, Location, 6000.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront))
    {
        // End:0x32D
        if(ExplosionTemplate.bDecalMaterialIsBeingOverriddenDontUsePhysMatVersion == false)
        {
            DecalData = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactDecalData(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo, ((InstigatorController != none) ? InstigatorController.Pawn : none));
            // End:0x32D
            if(DecalData.bIsValid)
            {
                ExplosionTemplate.DecalData = DecalData;
            }
        }        
    }
    else
    {
        ExplosionTemplate.DecalData = DecalData;
    }
    // End:0x470
    if(GRI.IsEffectRelevant(Instigator, Location, 100000.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistance))
    {
        // End:0x46D
        if(ExplosionTemplate.bSoundCueIsBeingOverridenDontUsePhysMatVersion == false)
        {
            ExploSound = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo);
            // End:0x46D
            if(ExploSound != none)
            {
                ExplosionTemplate.ExplosionSound = ExploSound;
            }
        }        
    }
    else
    {
        ExplosionTemplate.ExplosionSound = none;
    }
    // End:0x545
    if(ExplosionTemplate.bUsePerMaterialFogVolume == true)
    {
        FogVolumeArchetype = Class'EvilPhysicalMaterialProperty'.static.DetermineFogVolumeArchetype(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo);
        // End:0x545
        if(FogVolumeArchetype != none)
        {
            ExplosionTemplate.FogVolumeArchetype = FogVolumeArchetype;
        }
    }
    // End:0x669
    if(GRI.IsEffectRelevant(Instigator, Location, 2048.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront))
    {
        CameraEffect = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactCameraEffect(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo, CameraEffectRadius);
        // End:0x666
        if(CameraEffect != none)
        {
            ExplosionTemplate.CameraLensEffect = CameraEffect;
            ExplosionTemplate.CameraLensEffectRadius = CameraEffectRadius;
        }        
    }
    else
    {
        ExplosionTemplate.CameraLensEffect = none;
    }
    //return;    
}

simulated event Explode(EvilExplosion NewExplosionTemplate)
{
    local float HowLongToLive;
    local PhysicalMaterial PhysMaterial;
    local Actor TraceActor;
    local Vector out_HitLocation, out_HitNormal, TraceExtent;
    local TraceHitInfo HitInfo;

    // End:0x9A
    if(ExplosionTemplate == none)
    {
        ExplosionTemplate = new (self) NewExplosionTemplate.Class (NewExplosionTemplate);
        // End:0x9A
        if(ExplosionTemplate.ExploDelay > 0.0000000)
        {
            SetTimer(ExplosionTemplate.ExploDelay, false, 'Explode');
            return;
        }
    }
    bExplosionEnableBloom = false;
    TraceActor = Trace(out_HitLocation, out_HitNormal, Location + (-ExplosionTemplate.HitNormal * ExplosionTemplate.DecalTraceDistance), Location, false, TraceExtent, HitInfo, 1);
    HowLongToLive = ExplosionTemplate.DamageDelay + 0.0100000;
    // End:0x809
    if(!bHasExploded)
    {
        PhysMaterial = Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo);
        // End:0x1BF
        if(PhysMaterial != none)
        {
            UpdateExplosionTemplateWithPerMaterialFX(PhysMaterial);
        }
        // End:0x74C
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            // End:0x234
            if(ExplosionTemplate.ParticleEmitterTemplate != none)
            {
                SpawnExplosionParticleSystem(ExplosionTemplate.ParticleEmitterTemplate);
            }
            SpawnPostProcessEffects(HowLongToLive);
            // End:0x2E3
            if(ExplosionTemplate.DecalData.bIsValid && ExplosionTemplate.DecalData.DecalMaterial != none)
            {
                SpawnExplosionDecal(TraceActor, out_HitLocation, out_HitNormal, HitInfo);
            }
            // End:0x4AC
            if((ExplosionTemplate.ExploLight != none) && !WorldInfo.IsConsoleBuild())
            {
                ExplosionLight = new (self) ExplosionTemplate.ExploLight.Class (ExplosionTemplate.ExploLight);
                // End:0x4AC
                if(ExplosionLight != none)
                {
                    ExplosionLight.SetTranslation(20.0000000 * out_HitNormal);
                    AttachComponent(ExplosionLight);
                    ExplosionLight.SetEnabled(true);
                    SetTimer(ExplosionTemplate.ExploLightFadeOutTime);
                    LightFadeTime = ExplosionTemplate.ExploLightFadeOutTime;
                    HowLongToLive = FMax(LightFadeTime + 0.2000000, HowLongToLive);
                    LightInitialBrightness = ExplosionTemplate.ExploLight.Brightness;
                }
            }
            // End:0x52B
            if((ExplosionTemplate.ExplosionSound != none) && !ExplosionTemplate.bSuppressAudio)
            {
                PlaySound(ExplosionTemplate.ExplosionSound, true, true, false, Location, true);
            }
            // End:0x5E8
            if(ExplosionTemplate.MyDamageType != none)
            {
                ApplyRadialImpulse();
                // End:0x5E8
                if(ExplosionTemplate.bCausesFracture)
                {
                    DoBreakFracturedMeshes(Location, ExplosionTemplate.FractureMeshRadius, ExplosionTemplate.FracturePartVel, ExplosionTemplate.MyDamageType);
                }
            }
            // End:0x63D
            if((ExplosionTemplate.bUsePerMaterialFogVolume == true) && ExplosionTemplate.FogVolumeArchetype != none)
            {
                SpawnExplosionFogVolume();
            }
            DoExplosionCameraEffects();
            // End:0x74C
            if(EvilGameReplicationInfo(WorldInfo.GRI).IsEffectRelevant(Instigator, HitLocationFromPhysMaterialTrace, 1024.0000000, false, EvilGameReplicationInfo(WorldInfo.GRI).CheckEffectDistance_SpawnWithinCullDistance))
            {
                // End:0x74C
                if(FluidSurfaceActor(HitActorFromPhysMaterialTrace) != none)
                {
                    FluidSurfaceActor(HitActorFromPhysMaterialTrace).FluidComponent.ApplyForce(HitLocationFromPhysMaterialTrace, 1024.0000000, 20.0000000, false);
                }
            }
        }
        // End:0x7A3
        if(ExplosionTemplate.DamageDelay > 0.0000000)
        {
            SetTimer(ExplosionTemplate.DamageDelay, false, 'DoExplosionDamage');            
        }
        else
        {
            DoExplosionDamage();
        }
        // End:0x7CA
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(1.0000000);
        }
        bHasExploded = true;
        // End:0x809
        if(!bPendingDelete && !bDeleteMe)
        {
            LifeSpan = HowLongToLive;
        }
    }
    //return;    
}

simulated function DoExplosionDamage()
{
    // End:0x219
    if((ExplosionTemplate != none) && ExplosionTemplate.MyDamageType != none)
    {
        // End:0x219
        if((ExplosionTemplate.Damage > 0.0000000) && ExplosionTemplate.DamageRadius > 0.0000000)
        {
            // End:0x116
            if(!ExplosionTemplate.bDoOwnerDamage)
            {
                ExplosionTemplate.ActorToIgnoreForDamage = ((Owner.IsA('Projectile')) ? Owner.Instigator : Owner);
            }
            // End:0x219
            if(int(Role) == int(ROLE_Authority))
            {
                HurtExplosion(ExplosionTemplate.Damage, ExplosionTemplate.DamageRadius, ExplosionTemplate.DamageFalloffExponent, ExplosionTemplate.MyDamageType, ExplosionTemplate.MomentumTransferScale, Location, ExplosionTemplate.ActorToIgnoreForDamage, ExplosionTemplate.ActorClassToIgnoreForDamage, InstigatorController, false);
            }
        }
    }
    //return;    
}

function ApplyRadialImpulse()
{
    RadialImpulseComponent.ImpulseRadius = FMax(ExplosionTemplate.DamageRadius, ExplosionTemplate.KnockDownRadius);
    RadialImpulseComponent.ImpulseStrength = ExplosionTemplate.MyDamageType.default.RadialDamageImpulse;
    RadialImpulseComponent.bVelChange = ExplosionTemplate.MyDamageType.default.bRadialDamageVelChange;
    RadialImpulseComponent.ImpulseFalloff = 0;
    RadialImpulseComponent.FireImpulse(Location);
    //return;    
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
    local Emitter ExplosionEmitter;

    ExplosionEmitter = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetImpactEmitter(ExplosionTemplate.ParticleEmitterTemplate, Location, Rotator(ExplosionTemplate.HitNormal));
    // End:0x1A5
    if(ExplosionEmitter != none)
    {
        // End:0x133
        if((ExplosionTemplate.Attachee != none) && ExplosionTemplate.bAttachExplosionEmitterToAttachee)
        {
            ExplosionEmitter.SetBase(ExplosionTemplate.Attachee);
        }
        ExplosionEmitter.SetDrawScale(ExplosionTemplate.ExplosionEmitterScale);
        ExplosionEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

simulated function SpawnExplosionDecal(Actor DecalDestActor, const out Vector HitLocatiom, const out Vector HitNormal, const out TraceHitInfo HitInfo)
{
    local float RandomScale;
    local editinline EvilDecal GD;
    local bool bIsSplitScreen;
    local float DecalLifeSpan;

    // End:0x11
    if(DecalDestActor == none)
    {
        return;
    }
    RandomScale = GetRangeValueByPct(ExplosionTemplate.DecalData.RandomScalingRange, FRand());
    ExplosionTemplate.DecalData.Width *= RandomScale;
    ExplosionTemplate.DecalData.Height *= RandomScale;
    GD = EvilGameReplicationInfo(WorldInfo.GRI).GOP.GetDecal_Explosion(HitLocatiom);
    // End:0x4D8
    if(GD != none)
    {
        bIsSplitScreen = Class'Engine.Engine'.static.IsSplitScreen();
        DecalLifeSpan = ExplosionTemplate.DecalData.LifeSpan;
        GD.MITV_Decal.SetParent(ExplosionTemplate.DecalData.DecalMaterial);
        WorldInfo.MyDecalManager.SetDecalParameters(GD, GD.MITV_Decal, HitLocatiom, Rotator(-HitNormal), ExplosionTemplate.DecalData.Width, ExplosionTemplate.DecalData.Height, float(Max(int(ExplosionTemplate.DecalData.Thickness), int(Class'EvilDecal'.default.MinExplosionThickness))), ((bIsSplitScreen) ? false : !ExplosionTemplate.DecalData.ClipDecalsUsingFastPath), FRand() * 360.0000000, ((ExplosionTemplate.DecalData.ClipDecalsUsingFastPath) ? HitInfo.HitComponent : none), true, false, HitInfo.BoneName, -1, -1, -1, Class'EvilDecal'.default.DepthBias, ExplosionTemplate.DecalData.BlendRange);
        DecalDestActor.AttachComponent(GD);
        GD.MITV_Decal.SetScalarStartTime(ExplosionTemplate.DecalDissolveParamName, DecalLifeSpan);
    }
    //return;    
}

simulated function SpawnExplosionFogVolume()
{
    //return;    
}

simulated function SpawnPostProcessEffects(out float HowLongToLive)
{
    local PlayerController PC;
    local float Distance;

    // End:0x196
    if(ExplosionTemplate.ExploRadialBlur != none)
    {
        // End:0x196
        if((ExplosionTemplate.bPerformRadialBlurRelevanceCheck == false) || EffectIsRelevant(Location + vect(0.0000000, 0.0000000, 1.0000000), false))
        {
            ExplosionRadialBlur = new (self) ExplosionTemplate.ExploRadialBlur.Class (ExplosionTemplate.ExploRadialBlur);
            // End:0x196
            if(ExplosionRadialBlur != none)
            {
                AttachComponent(ExplosionRadialBlur);
                RadialBlurFadeTime = ExplosionTemplate.ExploRadialBlurFadeOutTime;
                RadialBlurFadeTimeRemaining = RadialBlurFadeTime;
                RadialBlurMaxBlurAmount = ExplosionTemplate.ExploRadialBlurMaxBlur;
                SetTimer(FMax(RadialBlurFadeTime, LightFadeTime));
                HowLongToLive = FMax(RadialBlurFadeTime + 0.2000000, HowLongToLive);
            }
        }
    }
    // End:0x458
    if(ExplosionTemplate.bExploEnableBloom)
    {
        bExplosionEnableBloom = true;
        BloomParams.BloomThreshold = ExplosionTemplate.ExploBloomThreshold;
        BloomParams.BloomTint = ExplosionTemplate.ExploBloomTint;
        BloomFadeTime = ExplosionTemplate.ExploBloomFadeOutTime;
        BloomFadeTimeRemaining = BloomFadeTime;
        ExplosionBloomRadius = ExplosionTemplate.ExploBloomRadius;
        // End:0x457
        foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x2F9
            if(PC.Pawn == none)
            {
                continue;                
            }
            Distance = VSize(PC.Pawn.Location - Location);
            // End:0x456
            if((Distance < ExplosionTemplate.ExploBloomRadius) && PC.IsAimingAt(self, 0.1000000))
            {
                BloomParams.BloomScale = ExplosionTemplate.ExploBloomScale * (1.0000000 - (Distance / ExplosionTemplate.ExploBloomRadius));
                EvilPlayerController(PC).GetPPManager().Update('ExploBloom', BloomParams);
            }            
        }        
    }
    bExplosionEnableBleachBypass = ExplosionTemplate.bExploEnableBleachBypass;
    ExplosionBleachBypassMaxOpacity = ExplosionTemplate.ExploBleachBypassMaxOpacity;
    // End:0x64F
    if(ExplosionTemplate.bEnableBlueWarp)
    {
        // End:0x64E
        foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x64D
            if(((PC.Pawn != none) && VSize(PC.Pawn.Location - Location) < ExplosionTemplate.BlueWarpRadius) && PC.IsAimingAt(self, 0.1500000))
            {
                EvilPlayerController(PC).GetPPManager().EnableBlueWarp(ExplosionTemplate.BlueWarpDuration, ExplosionTemplate.BlueWarpColor, ExplosionTemplate.BlueWarpDistortScale);
            }            
        }        
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local float TimerCount, Pct, Pct2;
    local PlayerController PC;

    // End:0xC7
    if(ExplosionLight != none)
    {
        TimerCount = GetTimerCount();
        // End:0xA7
        if(TimerCount >= float(0))
        {
            Pct = 1.0000000 - (TimerCount / LightFadeTime);
            Pct *= Pct;
            ExplosionLight.SetLightProperties(LightInitialBrightness * Pct);            
        }
        else
        {
            ExplosionLight.SetEnabled(false);
        }
    }
    // End:0x189
    if(ExplosionRadialBlur != none)
    {
        // End:0x165
        if(RadialBlurFadeTimeRemaining > 0.0000000)
        {
            Pct = RadialBlurFadeTimeRemaining / RadialBlurFadeTime;
            Pct *= Pct;
            ExplosionRadialBlur.SetBlurScale(Pct * RadialBlurMaxBlurAmount);
            RadialBlurFadeTimeRemaining -= DeltaTime;            
        }
        else
        {
            ExplosionRadialBlur.SetBlurScale(0.0000000);
        }
    }
    // End:0x5E2
    if((bExplosionEnableBloom || bExplosionEnableBleachBypass) || ExplosionTemplate.bExploEnableChromatic)
    {
        // End:0x4E5
        if(BloomFadeTimeRemaining > 0.0000000)
        {
            Pct = BloomFadeTimeRemaining / BloomFadeTime;
            Pct2 = Pct;
            Pct *= Pct;
            BloomFadeTimeRemaining -= DeltaTime;
            BloomParams.BloomScale *= Pct;
            BloomParams.BloomThreshold *= Pct;
            // End:0x4E1
            foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                // End:0x4E0
                if(((PC.Pawn != none) && VSize(PC.Pawn.Location - Location) < ExplosionBloomRadius) && PC.IsAimingAt(self, 0.1000000))
                {
                    // End:0x3F6
                    if(bExplosionEnableBloom && Left(string(WorldInfo.GRI.GameClass), 2) != "PK")
                    {
                        EvilPlayerController(PC).GetPPManager().Update('ExploBloom', BloomParams);
                    }
                    // End:0x456
                    if(bExplosionEnableBleachBypass)
                    {
                        EvilPlayerController(PC).GetPPManager().EnableBleachBypass(true, ExplosionBleachBypassMaxOpacity * Pct2);
                    }
                    // End:0x4E0
                    if(ExplosionTemplate.bExploEnableChromatic)
                    {
                        EvilPlayerController(PC).GetPPManager().EnableChromatic(true, ExplosionTemplate.ExploMaxChromaticScale * Pct2);
                    }
                }                
            }                        
        }
        else
        {
            // End:0x5E1
            foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                EvilPlayerController(PC).GetPPManager().Deactivate('ExploBloom');
                EvilPlayerController(PC).GetPPManager().EnableBleachBypass(false);
                EvilPlayerController(PC).GetPPManager().EnableChromatic(false);                
            }            
        }
    }
    //return;    
}

simulated function DoExplosionCameraEffects()
{
    local CameraShake Shake;
    local float ShakeScale;
    local PlayerController PC;

    // End:0x256
    foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x255
        if(PC.PlayerCamera != none)
        {
            Shake = ChooseCameraShake(Location, PC);
            // End:0x255
            if(Shake != none)
            {
                ShakeScale = PC.PlayerCamera.CalcRadialShakeScale(PC.PlayerCamera, Location, ExplosionTemplate.CamShakeInnerRadius, ExplosionTemplate.CamShakeOuterRadius, ExplosionTemplate.CamShakeFalloff);
                // End:0x203
                if(ExplosionTemplate.bOrientCameraShakeTowardsEpicenter)
                {
                    PC.ClientPlayCameraShake(Shake, ShakeScale, ExplosionTemplate.bAutoControllerVibration, 2, Rotator(Location - PC.ViewTarget.Location));
                    // End:0x255
                    continue;
                }
                PC.ClientPlayCameraShake(Shake, ShakeScale, ExplosionTemplate.bAutoControllerVibration);
            }
        }        
    }    
    SpawnCameraLensEffects();
    //return;    
}

simulated function SpawnCameraLensEffects()
{
    local PlayerController PC;

    // End:0x14A
    if(ExplosionTemplate.CameraLensEffect != none)
    {
        // End:0x149
        foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x148
            if(((PC.Pawn != none) && VSize(PC.Pawn.Location - Location) < ExplosionTemplate.CameraLensEffectRadius) && PC.IsAimingAt(self, 0.1000000))
            {
                PC.ClientSpawnCameraLensEffect(ExplosionTemplate.CameraLensEffect);
            }            
        }        
    }
    //return;    
}

protected simulated function CameraShake ChooseCameraShake(Vector Epicenter, PlayerController PC)
{
    local Vector CamX, CamY, CamZ, ToEpicenter;
    local float FwdDot, RtDot;
    local CameraShake ChosenShake;
    local Rotator NoPitchRot;

    // End:0x44
    if(ExplosionTemplate.bOrientCameraShakeTowardsEpicenter)
    {
        return ExplosionTemplate.CamShake;        
    }
    else
    {
        // End:0x2C7
        if(((ExplosionTemplate.CamShake_Left != none) || ExplosionTemplate.CamShake_Right != none) || ExplosionTemplate.CamShake_Rear != none)
        {
            ToEpicenter = Epicenter - PC.PlayerCamera.Location;
            ToEpicenter.Z = 0.0000000;
            ToEpicenter = Normal(ToEpicenter);
            NoPitchRot = PC.PlayerCamera.Rotation;
            NoPitchRot.Pitch = 0;
            GetAxes(NoPitchRot, CamX, CamY, CamZ);
            FwdDot = CamX Dot ToEpicenter;
            // End:0x210
            if(FwdDot > 0.7070000)
            {
                ChosenShake = ExplosionTemplate.CamShake;                
            }
            else
            {
                // End:0x29F
                if(FwdDot > -0.7070000)
                {
                    RtDot = CamY Dot ToEpicenter;
                    ChosenShake = ((RtDot > 0.0000000) ? ExplosionTemplate.CamShake_Right : ExplosionTemplate.CamShake_Left);                    
                }
                else
                {
                    ChosenShake = ExplosionTemplate.CamShake_Rear;
                }
            }
        }
    }
    // End:0x2FE
    if(ChosenShake == none)
    {
        ChosenShake = ExplosionTemplate.CamShake;
    }
    return ChosenShake;
    //return ReturnValue;    
}

defaultproperties
{
    BloomParams=(BloomScale=0.0000000,BloomThreshold=1.0000000,BloomTint=(R=255,G=255,B=255,A=0),DofEnabled=false,DofFocusType=EFocusType.FOCUS_Distance,DofBlurKernelSize=8.0000000,DofFalloffExponent=4.0000000,DofMinBlurAmount=1.0000000,DofMaxFarBlurAmount=1.0000000,DofMaxNearBlurAmount=0.0000000,DofFocusInnerRadius=300.0000000,DofFocusDistance=550.0000000,DofFocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),SceneDesaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000))
    // Reference: RB_RadialImpulseComponent'Default__EvilExplosionActor.ImpulseComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ImpulseComponent0'
    begin object name="ImpulseComponent0" class=Class'Engine.RB_RadialImpulseComponent'
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    Components[0]=ImpulseComponent0
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}