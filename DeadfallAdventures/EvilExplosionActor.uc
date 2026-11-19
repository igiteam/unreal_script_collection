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
var protected transient PostProcessSettings BloomPPSettings;
var protected transient float BloomFadeTime;
var protected transient float BloomFadeTimeRemaining;
var protected transient float ExplosionBloomRadius;
var protected transient float ExplosionBleachBypassMaxOpacity;
var protected export editinline EvilRB_RadialImpulseActor RadialImpulseComponent;
var Controller InstigatorController;
var Actor HitActorFromPhysMaterialTrace;
var Vector HitLocationFromPhysMaterialTrace;

simulated function SetInstigatorController(Controller PC)
{
    // End:0x22
    if(PC != none)
    {
        InstigatorController = PC;
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
    local bool bCanKnockdown;

    bDamageBlocked = false;
    ModDamageType = DamageType;
    ModInstigator = InstigatedByController;
    VictimPawn = EvilPawn(Victim);
    // End:0x15D
    if((((ExplosionTemplate.AttacheeController != none) && VictimPawn != none) && !WorldInfo.GRI.IsCoopMultiplayerGame()) && !WorldInfo.GRI.OnSameTeam(ExplosionTemplate.AttacheeController, VictimPawn.Controller))
    {
        ModInstigator = ExplosionTemplate.AttacheeController;
    }
    // End:0x1B2
    if((DoFullDamageToActor(Victim)) || ExplosionTemplate.bAlwaysDoFullDamage)
    {
        bDamageBlocked = false;
        bDoFullDamage = true;        
    }
    else
    {
        Victim.GetComponentsBoundingBox(BBox);
        BBoxCenter = (BBox.Min + BBox.Max) * 0.5000000;
        HitActor = Trace(HitL, HitN, BBoxCenter, ExploOrigin, false,,, 1);
        // End:0x2A4
        if((HitActor != none) && HitActor != Victim)
        {
            // End:0x2A4
            if(DoFullDamageToActor(HitActor))
            {
                bDamageBlocked = true;
            }
        }
    }
    // End:0x796
    if(!bDamageBlocked)
    {
        Victim.GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Victim.Location - ExploOrigin;
        Dist = VSize(Dir);
        Dist = FMax(Dist - ColRadius, 0.0000000);
        // End:0x370
        if(bDoFullDamage)
        {
            DamageScale = 1.0000000;            
        }
        else
        {
            DamageScale = FClamp(1.0000000 - (Dist / DamageRadius), 0.0000000, 1.0000000);
            DamageScale = DamageScale ** DamageFalloffExp;
        }
        // End:0x42B
        if(ExplosionTemplate.KnockDownRadius > float(0))
        {
            MomentumScale = FClamp(1.0000000 - (Dist / ExplosionTemplate.KnockDownRadius), 0.0000000, 1.0000000);
        }
        MomentumScale = MomentumScale ** DamageFalloffExp;
        Dir = Victim.Location - (ExploOrigin + ((vect(0.0000000, 0.0000000, -1.0000000) * ExplosionTemplate.ExplosionOriginShiftDown) * MomentumScale));
        Dist = VSize(Dir);
        Dir = Normal(Dir);
        // End:0x56D
        if(NotEqual_InterfaceInterface(EvilPlayer_interface(Victim), EvilPlayer_interface(none)) && !WorldInfo.GRI.IsMultiplayerGame())
        {
            DamageScale *= ExplosionTemplate.PlayerDamageModifier;
        }
        // End:0x751
        if(DamageScale > 0.0000000)
        {
            // End:0x62E
            if((ModInstigator != none) && EvilWeap_Base(ModInstigator.Pawn.Weapon) != none)
            {
                EvilWeap_Base(ModInstigator.Pawn.Weapon).CheckAndUpdateHitEnemyIndicator(Victim);
            }
            bCanKnockdown = false;
            // End:0x690
            if(VictimPawn != none)
            {
                bCanKnockdown = (AllowKnockDown(VictimPawn, 0.0000000)) && VictimPawn.IsAliveAndWell();
            }
            Victim.TakeDamage(int(BaseDamage * DamageScale), ModInstigator, Victim.Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), MomentumScale * Dir, ModDamageType,, self);
            VictimsList[VictimsList.Length] = Victim;
        }
        // End:0x796
        if(bCanKnockdown)
        {
            Dir = ExploOrigin;
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
    if(ExplosionTemplate.bFullDamageToAttachee && VictimsList.Find(ExplosionTemplate.Attachee) < )
    {        
        Victim = ExplosionTemplate.Attachee;
        Victim.GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Victim.Location - ExploOrigin;
        Dir = Normal(Dir);
        Victim.TakeDamage(int(BaseDamage), InstigatedByController, Victim.Location - ((0.5000000 * (ColHeight + ColRadius)) * Dir), MomentumScale * Dir, DamageType,, self);
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
    // End:0xB4
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xB4
        if(DistFromExplosionCenterToPawnLocation < ExplosionTemplate.KnockDownRadius)
        {
            P.Knockdown(,,, ExplosionOrigin, ExplosionTemplate.KnockDownRadius * float(2), ExplosionTemplate.KnockDownStrength * 0.2000000);
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
    // End:0x496
    if(GRI.IsEffectRelevant(Instigator, Location, 100000.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistance))
    {
        // End:0x493
        if(ExplosionTemplate.bSoundCueIsBeingOverridenDontUsePhysMatVersion == false)
        {
            ExploSound = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo, NotEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)));
            // End:0x493
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
    // End:0x56B
    if(ExplosionTemplate.bUsePerMaterialFogVolume == true)
    {
        FogVolumeArchetype = Class'EvilPhysicalMaterialProperty'.static.DetermineFogVolumeArchetype(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo);
        // End:0x56B
        if(FogVolumeArchetype != none)
        {
            ExplosionTemplate.FogVolumeArchetype = FogVolumeArchetype;
        }
    }
    // End:0x68F
    if(GRI.IsEffectRelevant(Instigator, Location, 2048.0000000, false, GRI.CheckEffectDistance_SpawnWithinCullDistanceAndInFront))
    {
        CameraEffect = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactCameraEffect(PhysMaterial, ExplosionTemplate.MyDamageType, WorldInfo, CameraEffectRadius);
        // End:0x68C
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
    // End:0x813
    if(!bHasExploded)
    {
        PhysMaterial = Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo);
        // End:0x1BF
        if(PhysMaterial != none)
        {
            UpdateExplosionTemplateWithPerMaterialFX(PhysMaterial);
        }
        // End:0x756
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
            DoExplosionStunFX();
            // End:0x5F2
            if(ExplosionTemplate.MyDamageType != none)
            {
                ApplyRadialImpulse();
                // End:0x5F2
                if(ExplosionTemplate.bCausesFracture)
                {
                    DoBreakFracturedMeshes(Location, ExplosionTemplate.FractureMeshRadius, ExplosionTemplate.FracturePartVel, ExplosionTemplate.MyDamageType);
                }
            }
            // End:0x647
            if((ExplosionTemplate.bUsePerMaterialFogVolume == true) && ExplosionTemplate.FogVolumeArchetype != none)
            {
                SpawnExplosionFogVolume();
            }
            DoExplosionCameraEffects();
            // End:0x756
            if(EvilGameReplicationInfo(WorldInfo.GRI).IsEffectRelevant(Instigator, HitLocationFromPhysMaterialTrace, 1024.0000000, false, EvilGameReplicationInfo(WorldInfo.GRI).CheckEffectDistance_SpawnWithinCullDistance))
            {
                // End:0x756
                if(FluidSurfaceActor(HitActorFromPhysMaterialTrace) != none)
                {
                    FluidSurfaceActor(HitActorFromPhysMaterialTrace).FluidComponent.ApplyForce(HitLocationFromPhysMaterialTrace, 1024.0000000, 20.0000000, false);
                }
            }
        }
        // End:0x7AD
        if(ExplosionTemplate.DamageDelay > 0.0000000)
        {
            SetTimer(ExplosionTemplate.DamageDelay, false, 'DoExplosionDamage');            
        }
        else
        {
            DoExplosionDamage();
        }
        // End:0x7D4
        if(int(Role) == int(ROLE_Authority))
        {
            MakeNoise(1.0000000);
        }
        bHasExploded = true;
        // End:0x813
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

    // End:0x6A2
    foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x6A1
        if(((PC.Pawn != none) && PC.IsAimingAt(Owner, 0.1000000)) && PC.CanSee(Pawn(Owner)))
        {
            // End:0x24F
            if(ExplosionTemplate.ExploRadialBlur != none)
            {
                // End:0x24F
                if((ExplosionTemplate.bPerformRadialBlurRelevanceCheck == false) || EffectIsRelevant(Location + vect(0.0000000, 0.0000000, 1.0000000), false))
                {
                    ExplosionRadialBlur = new (self) ExplosionTemplate.ExploRadialBlur.Class (ExplosionTemplate.ExploRadialBlur);
                    // End:0x24F
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
            // End:0x50A
            if(ExplosionTemplate.bExploEnableBloom)
            {
                bExplosionEnableBloom = true;
                BloomPPSettings.Bloom_Threshold = ExplosionTemplate.ExploBloomThreshold;
                BloomPPSettings.Bloom_Tint = ExplosionTemplate.ExploBloomTint;
                BloomFadeTime = ExplosionTemplate.ExploBloomFadeOutTime;
                BloomFadeTimeRemaining = BloomFadeTime;
                HowLongToLive = FMax(HowLongToLive, BloomFadeTime);
                ExplosionBloomRadius = ExplosionTemplate.ExploBloomRadius;
                Distance = VSize(PC.Pawn.Location - Location);
                // End:0x50A
                if(Distance < ExplosionTemplate.ExploBloomRadius)
                {
                    BloomPPSettings.Bloom_Scale = ExplosionTemplate.ExploBloomScale * (1.0000000 - FClamp(Distance / ExplosionTemplate.ExploBloomRadius, 0.0000000, 1.0000000));
                    EvilPlayerController(PC).GetELP().AddPostProcessSettingsOverride('ExploBloom', BloomPPSettings, 0.0000000);
                    EvilPlayerController(PC).GetELP().RemovePostProcessSettingsOverride('ExploBloom', BloomFadeTimeRemaining);
                }
            }
            bExplosionEnableBleachBypass = ExplosionTemplate.bExploEnableBleachBypass;
            ExplosionBleachBypassMaxOpacity = ExplosionTemplate.ExploBleachBypassMaxOpacity;
            // End:0x6A1
            if(ExplosionTemplate.bEnableBlueWarp)
            {
                // End:0x6A1
                if((PC.Pawn != none) && VSize(PC.Pawn.Location - Location) < ExplosionTemplate.BlueWarpRadius)
                {
                    EvilPlayerController(PC).GetPPManager().EnableBlueWarp(ExplosionTemplate.BlueWarpDuration, ExplosionTemplate.BlueWarpColor, ExplosionTemplate.BlueWarpDistortScale);
                }
            }
        }        
    }    
    //return;    
}

simulated function DoExplosionStunFX()
{
    local PlayerController PC;
    local float Distance;

    // End:0x199
    foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x65
        if(EvilPawn(PC.Pawn) == none)
        {
            continue;            
        }
        Distance = VSize(PC.Pawn.Location - Location);
        // End:0x198
        if(Distance < ExplosionTemplate.ExplosionStunFXRadius)
        {
            // End:0x198
            if(!ExplosionTemplate.bSuppressAudio)
            {
                EvilPawn(PC.Pawn).StartExplosionStun(ExplosionTemplate.ExplosionStunFXStrengthMoodifier * (1.0000000 - FClamp(Distance / ExplosionTemplate.ExplosionStunFXRadius, 0.0000000, 1.0000000)));
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
    // End:0x4AC
    if((bExplosionEnableBloom || bExplosionEnableBleachBypass) || ExplosionTemplate.bExploEnableChromatic)
    {
        // End:0x3F6
        if(BloomFadeTimeRemaining > 0.0000000)
        {
            Pct = BloomFadeTimeRemaining / BloomFadeTime;
            Pct2 = Pct;
            Pct *= Pct;
            BloomFadeTimeRemaining -= DeltaTime;
            // End:0x3F2
            foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
                // End:0x3F1
                if(((PC.Pawn != none) && VSize(PC.Pawn.Location - Location) < ExplosionBloomRadius) && PC.IsAimingAt(self, 0.1000000))
                {
                    // End:0x367
                    if(bExplosionEnableBleachBypass)
                    {
                        EvilPlayerController(PC).GetPPManager().EnableBleachBypass(true, ExplosionBleachBypassMaxOpacity * Pct2);
                    }
                    // End:0x3F1
                    if(ExplosionTemplate.bExploEnableChromatic)
                    {
                        EvilPlayerController(PC).GetPPManager().EnableChromatic(true, ExplosionTemplate.ExploMaxChromaticScale * Pct2);
                    }
                }                
            }                        
        }
        else
        {
            // End:0x4AB
            foreach WorldInfo.LocalPlayerControllers(Class'Engine.PlayerController', PC)
            {
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

event Destroyed()
{
    local EvilPlayerController PC;

    super.Destroyed();
    // End:0xEE
    if((bExplosionEnableBloom || bExplosionEnableBleachBypass) || ExplosionTemplate.bExploEnableChromatic)
    {
        // End:0xED
        foreach WorldInfo.LocalPlayerControllers(Class'EvilPlayerController', PC)
        {
            PC.GetPPManager().EnableBleachBypass(false);
            PC.GetPPManager().EnableChromatic(false);            
        }        
    }
    //return;    
}

defaultproperties
{
    BloomPPSettings=(bOverride_EnableBloom=true,bOverride_EnableDOF=true,bOverride_EnableMotionBlur=true,bOverride_EnableSceneEffect=true,bOverride_AllowAmbientOcclusion=true,bOverride_OverrideRimShaderColor=true,bOverride_Bloom_Scale=true,bOverride_Bloom_Threshold=true,bOverride_Bloom_Tint=true,bOverride_Bloom_ScreenBlendThreshold=true,bOverride_Bloom_InterpolationDuration=true,bOverride_DOF_FalloffExponent=true,bOverride_DOF_BlurKernelSize=true,bOverride_DOF_BlurBloomKernelSize=true,bOverride_DOF_MaxNearBlurAmount=true,bOverride_DOF_MinBlurAmount=false,bOverride_DOF_MaxFarBlurAmount=true,bOverride_DOF_FocusType=true,bOverride_DOF_FocusInnerRadius=true,bOverride_DOF_FocusDistance=true,bOverride_DOF_FocusPosition=true,bOverride_DOF_InterpolationDuration=true,bOverride_DOF_BokehTexture=false,bOverride_MotionBlur_MaxVelocity=false,bOverride_MotionBlur_Amount=false,bOverride_MotionBlur_FullMotionBlur=false,bOverride_MotionBlur_CameraRotationThreshold=false,bOverride_MotionBlur_CameraTranslationThreshold=false,bOverride_MotionBlur_InterpolationDuration=false,bOverride_Scene_Desaturation=true,bOverride_Scene_Colorize=false,bOverride_Scene_TonemapperScale=false,bOverride_Scene_ImageGrainScale=false,bOverride_Scene_HighLights=true,bOverride_Scene_MidTones=true,bOverride_Scene_Shadows=true,bOverride_Scene_InterpolationDuration=true,bOverride_Scene_ColorGradingLUT=false,bOverride_RimShader_Color=true,bOverride_RimShader_InterpolationDuration=true,bOverride_MobileColorGrading=false,bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bOverrideRimShaderColor=false,Bloom_Scale=1.0000000,Bloom_Threshold=1.0000000,Bloom_Tint=(R=255,G=255,B=255,A=0),Bloom_ScreenBlendThreshold=10.0000000,Bloom_InterpolationDuration=0.0000000,DOF_BlurBloomKernelSize=16.0000000,DOF_FalloffExponent=4.0000000,DOF_BlurKernelSize=16.0000000,DOF_MaxNearBlurAmount=1.0000000,DOF_MinBlurAmount=0.0000000,DOF_MaxFarBlurAmount=1.0000000,DOF_FocusType=EFocusType.FOCUS_Distance,DOF_FocusInnerRadius=2000.0000000,DOF_FocusDistance=0.0000000,DOF_FocusPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000),DOF_InterpolationDuration=1.0000000,DOF_BokehTexture=none,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,Scene_Desaturation=0.0000000,Scene_Colorize=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_TonemapperScale=1.0000000,Scene_ImageGrainScale=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000,RimShader_Color=(R=0.4704400,G=0.5859730,B=0.8277260,A=1.0000000),RimShader_InterpolationDuration=1.0000000,ColorGrading_LookupTable=none,ColorGradingLUT=(LUTTextures=none,LUTWeights=none),MobileColorGrading=(TransitionTime=1.0000000,Blend=0.0000000,Desaturation=0.0000000,HighLights=(R=0.7000000,G=0.7000000,B=0.7000000,A=1.0000000),MidTones=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000),Shadows=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)),MobilePostProcess=(bOverride_Mobile_BlurAmount=false,bOverride_Mobile_TransitionTime=false,bOverride_Mobile_Bloom_Scale=false,bOverride_Mobile_Bloom_Threshold=false,bOverride_Mobile_Bloom_Tint=false,bOverride_Mobile_DOF_Distance=false,bOverride_Mobile_DOF_MinRange=false,bOverride_Mobile_DOF_MaxRange=false,bOverride_Mobile_DOF_NearBlurFactor=false,bOverride_Mobile_DOF_FarBlurFactor=false,Mobile_BlurAmount=16.0000000,Mobile_TransitionTime=1.0000000,Mobile_Bloom_Scale=6.0000000,Mobile_Bloom_Threshold=0.5000000,Mobile_Bloom_Tint=(R=1.0000000,G=1.0000000,B=1.0000000,A=1.0000000),Mobile_DOF_Distance=1500.0000000,Mobile_DOF_MinRange=600.0000000,Mobile_DOF_MaxRange=1200.0000000,Mobile_DOF_NearBlurFactor=1.0000000,Mobile_DOF_FarBlurFactor=1.0000000))
    // Reference: EvilRB_RadialImpulseActor'Default__EvilExplosionActor.ImpulseComponent0'
    begin object name=ImpulseComponent0 class=Class'EvilRB_RadialImpulseActor'
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    Components[0]=ImpulseComponent0
    CollisionType=ECollisionType.COLLIDE_CustomDefault
}