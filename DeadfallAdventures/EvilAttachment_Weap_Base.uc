class EvilAttachment_Weap_Base extends Actor
    abstract
    native(Weapon)
    notplaceable
    hidecategories(Navigation);

var class<Actor> SplashEffect;
var() export editinline SkeletalMeshComponent Mesh;
var protected export editinline SkeletalMeshComponent OverlayMesh;
var name MuzzleFlashSocket;
var export editinline ParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashPSCTemplate;
var ParticleSystem MuzzleFlashAltPSCTemplate;
var Color MuzzleFlashColor;
var bool bMuzzleFlashPSCLoops;
var bool bShowTracers;
var bool bAlignToSurfaceNormal;
var bool bSuppressSounds;
var bool bMakeSplash;
var bool bEnableIK;
var bool bEnableIKOnAim;
var class<UDKExplosionLight> MuzzleFlashLightClass;
var export editinline UDKExplosionLight MuzzleFlashLight;
var float MuzzleFlashDuration;
var() export editinline SkeletalMeshComponent OwnerMesh;
var name AttachmentSocket;
var array<MaterialImpactEffect> ImpactEffects;
var array<MaterialImpactEffect> AltImpactEffects;
var MaterialImpactEffect DefaultImpactEffect;
var MaterialImpactEffect DefaultAltImpactEffect;
var float TracerChance;
var class<Projectile> TracerClass;
var SoundCue BulletWhip;
var float MaxImpactEffectDistance;
var float MaxFireEffectDistance;
var class<EvilWeap_Base> WeaponClass;
var float MaxDecalRangeSq;
var float DistFactorForRefPose;
var name FireAnim;
var name AltFireAnim;
var UTPawn.EWeapAnimType WeapAnimType;
var EvilTypes.EEvilWeapAnimType EvilWeapAnimType;
var float BloodBlobChance;
var float ImpactSoundsQuantityLimit;
var int ImpactSoundsQuantity;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(1.0000000, true, 'CheckToForceRefPose');
    //return;    
}

simulated function CheckToForceRefPose()
{
    // End:0x11
    if(Mesh == none)
    {
        return;
    }
    // End:0xCE
    if(((WorldInfo.TimeSeconds - Mesh.LastRenderTime) > 1.0000000) || Mesh.MaxDistanceFactor < DistFactorForRefPose)
    {
        // End:0xCB
        if(Mesh.bForceRefpose == 0)
        {
            Mesh.SetForceRefPose(true);
        }        
    }
    else
    {
        // End:0x112
        if(Mesh.bForceRefpose != 0)
        {
            Mesh.SetForceRefPose(false);
        }
    }
    //return;    
}

simulated function CreateOverlayMesh()
{
    // End:0x227
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        OverlayMesh = new (self) Mesh.Class;
        OverlayMesh.SetScale(1.0000000);
        OverlayMesh.SetSkeletalMesh(Mesh.SkeletalMesh);
        OverlayMesh.SetOwnerNoSee(true);
        OverlayMesh.SetOnlyOwnerSee(false);
        OverlayMesh.AnimSets = Mesh.AnimSets;
        OverlayMesh.SetParentAnimComponent(Mesh);
        OverlayMesh.bUpdateSkelWhenNotRendered = false;
        OverlayMesh.bIgnoreControllersWhenNotRendered = true;
        OverlayMesh.bOverrideAttachmentOwnerVisibility = true;
        // End:0x227
        if(UDKSkeletalMeshComponent(OverlayMesh) != none)
        {
            UDKSkeletalMeshComponent(OverlayMesh).SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
        }
    }
    //return;    
}

function SetSkin(Material NewMaterial)
{
    local int I, Cnt;

    // End:0x18A
    if(NewMaterial == none)
    {
        // End:0xE0
        if(default.Mesh.Materials.Length > 0)
        {
            Cnt = default.Mesh.Materials.Length;
            I = 0;
            J0x68:

            // End:0xDD [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, default.Mesh.GetMaterial(I));
                I++;
                // [Loop Continue]
                goto J0x68;
            }            
        }
        else
        {
            // End:0x187
            if(Mesh.Materials.Length > 0)
            {
                Cnt = Mesh.Materials.Length;
                I = 0;
                J0x139:

                // End:0x187 [Loop If]
                if(I < Cnt)
                {
                    Mesh.SetMaterial(I, none);
                    I++;
                    // [Loop Continue]
                    goto J0x139;
                }
            }
        }        
    }
    else
    {
        // End:0x2A6
        if((default.Mesh.Materials.Length > 0) || Mesh.GetNumElements() > 0)
        {
            Cnt = ((default.Mesh.Materials.Length > 0) ? default.Mesh.Materials.Length : Mesh.GetNumElements());
            I = 0;
            J0x250:

            // End:0x2A6 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0x250;
            }
        }
    }
    //return;    
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
    PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
    //return;    
}

simulated function AttachTo(UTPawn OwnerPawn, optional bool bLeftHand)
{
    SetWeaponOverlayFlags(OwnerPawn);
    // End:0x25E
    if(OwnerPawn.Mesh != none)
    {
        // End:0x9E
        if(bLeftHand && OwnerPawn.WeaponSocket2 != 'None')
        {
            AttachmentSocket = OwnerPawn.WeaponSocket2;            
        }
        else
        {
            AttachmentSocket = OwnerPawn.WeaponSocket;
        }
        // End:0x209
        if(Mesh != none)
        {
            OwnerMesh = OwnerPawn.Mesh;
            Mesh.SetShadowParent(OwnerPawn.Mesh);
            Mesh.SetLightEnvironment(OwnerPawn.LightEnvironment);
            // End:0x1C3
            if(OwnerPawn.ReplicatedBodyMaterial != none)
            {
                SetSkin(OwnerPawn.ReplicatedBodyMaterial);
            }
            OwnerPawn.Mesh.AttachComponentToSocket(Mesh, AttachmentSocket);
        }
        // End:0x25E
        if(OverlayMesh != none)
        {
            OwnerPawn.Mesh.AttachComponentToSocket(OverlayMesh, AttachmentSocket);
        }
    }
    // End:0x3B8
    if(MuzzleFlashSocket != 'None')
    {
        // End:0x3B8
        if((MuzzleFlashPSCTemplate != none) || MuzzleFlashAltPSCTemplate != none)
        {
            MuzzleFlashPSC = new (self) Class'UTParticleSystemComponent';
            MuzzleFlashPSC.bAutoActivate = false;
            MuzzleFlashPSC.SetOwnerNoSee(true);
            // End:0x387
            if(((Mesh != none) && Mesh.SkeletalMesh != none) && Mesh.GetSocketByName(MuzzleFlashSocket) != none)
            {
                Mesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);                
            }
            else
            {
                OwnerMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket);
            }
        }
    }
    // End:0x44A
    if((EvilPawn(OwnerPawn) != none) && !EvilPawn(Owner).bDisableEvilAnimWeaponAnims)
    {
        EvilPawn(OwnerPawn).SetEvilWeapAnimTypeByWeaponName(name(WeaponClass.default.WeaponName));        
    }
    else
    {
        OwnerPawn.SetWeapAnimType(WeapAnimType);
    }
    GotoState('CurrentlyAttached');
    //return;    
}

simulated function SetPuttingDownWeapon(bool bNowPuttingDown)
{
    //return;    
}

simulated function DetachFrom(SkeletalMeshComponent MeshCpnt)
{
    SetSkin(none);
    // End:0xC8
    if(Mesh != none)
    {
        Mesh.SetShadowParent(none);
        Mesh.SetLightEnvironment(none);
        // End:0x91
        if(MuzzleFlashPSC != none)
        {
            Mesh.DetachComponent(MuzzleFlashPSC);
        }
        // End:0xC8
        if(MuzzleFlashLight != none)
        {
            Mesh.DetachComponent(MuzzleFlashLight);
        }
    }
    // End:0x145
    if(MeshCpnt != none)
    {
        // End:0x10E
        if(Mesh != none)
        {
            MeshCpnt.DetachComponent(Mesh);
        }
        // End:0x145
        if(OverlayMesh != none)
        {
            MeshCpnt.DetachComponent(OverlayMesh);
        }
    }
    GotoState('None');
    //return;    
}

simulated function MuzzleFlashTimer()
{
    // End:0x2F
    if(MuzzleFlashLight != none)
    {
        MuzzleFlashLight.SetEnabled(false);
    }
    // End:0x6E
    if((MuzzleFlashPSC != none) && !bMuzzleFlashPSCLoops)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
    //return;    
}

simulated function CauseMuzzleFlash()
{
    local ParticleSystem MuzzleTemplate;

    // End:0x15D
    if(!Class'Engine.Engine'.static.IsSplitScreen() || WorldInfo.IsConsoleBuild(3))
    {
        // End:0x13E
        if(MuzzleFlashLight == none)
        {
            // End:0x13B
            if(MuzzleFlashLightClass != none)
            {
                MuzzleFlashLight = new (Outer) MuzzleFlashLightClass;
                // End:0xFB
                if((Mesh != none) && Mesh.GetSocketByName(MuzzleFlashSocket) != none)
                {
                    Mesh.AttachComponentToSocket(MuzzleFlashLight, MuzzleFlashSocket);                    
                }
                else
                {
                    // End:0x13B
                    if(OwnerMesh != none)
                    {
                        OwnerMesh.AttachComponentToSocket(MuzzleFlashLight, AttachmentSocket);
                    }
                }
            }            
        }
        else
        {
            MuzzleFlashLight.ResetLight();
        }
    }
    // End:0x29C
    if(MuzzleFlashPSC != none)
    {
        // End:0x29C
        if(!bMuzzleFlashPSCLoops || !MuzzleFlashPSC.bIsActive)
        {
            // End:0x202
            if(((Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
            {
                MuzzleTemplate = MuzzleFlashAltPSCTemplate;                
            }
            else
            {
                MuzzleTemplate = MuzzleFlashPSCTemplate;
            }
            // End:0x269
            if(MuzzleTemplate != MuzzleFlashPSC.Template)
            {
                MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
            }
            SetMuzzleFlashParams(MuzzleFlashPSC);
            MuzzleFlashPSC.ActivateSystem();
        }
    }
    SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    //return;    
}

simulated function StopMuzzleFlash()
{
    ClearTimer('MuzzleFlashTimer');
    MuzzleFlashTimer();
    // End:0x4C
    if(MuzzleFlashPSC != none)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
    //return;    
}

simulated function FirstPersonFireEffects(Weapon PawnWeapon, Vector HitLocation)
{
    // End:0x5E
    if(PawnWeapon != none)
    {
        PawnWeapon.PlayFireEffects(Pawn(Owner).FiringMode, HitLocation);
    }
    //return;    
}

simulated function StopFirstPersonFireEffects(Weapon PawnWeapon)
{
    // End:0x55
    if(PawnWeapon != none)
    {
        PawnWeapon.StopFireEffects(Pawn(Owner).FiringMode);
    }
    //return;    
}

simulated function ThirdPersonFireEffects(Vector HitLocation)
{
    local EvilPawn P;

    // End:0x52
    if(EffectIsRelevant(Instigator.Location, false, MaxFireEffectDistance, MaxFireEffectDistance * 0.7500000))
    {
        CauseMuzzleFlash();        
    }
    P = EvilPawn(Instigator);
    // End:0xD9
    if((P != none) && P.GunRecoilNode != none)
    {
        P.GunRecoilNode.bPlayRecoil = true;
    }
    // End:0x14B
    if((int(Instigator.FiringMode) == int(1)) && AltFireAnim != 'None')
    {
        Mesh.PlayAnim(AltFireAnim,,, false);        
    }
    else
    {
        // End:0x1BA
        if((int(Instigator.FiringMode) == int(0)) && FireAnim != 'None')
        {
            Mesh.PlayAnim(FireAnim,,, false);
        }
    }
    //return;    
}

simulated event StopThirdPersonFireEffects()
{
    StopMuzzleFlash();
    //return;    
}

simulated function MaterialImpactEffect GetImpactEffect(PhysicalMaterial HitMaterial)
{
    local int I;
    local UTPhysicalMaterialProperty PhysicalProperty;

    // End:0x4A
    if(HitMaterial != none)
    {
        PhysicalProperty = UTPhysicalMaterialProperty(HitMaterial.GetPhysicalMaterialProperty(Class'UTPhysicalMaterialProperty'));
    }
    // End:0x12B
    if(int(Pawn(Owner).FiringMode) > int(0))
    {
        // End:0x11E
        if((PhysicalProperty != none) && PhysicalProperty.MaterialType != 'None')
        {
            I = AltImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);            
            // End:0x11E
            if(I != -1)
            {
                return AltImpactEffects[I];
            }
        }
        return DefaultAltImpactEffect;        
    }
    else
    {
        // End:0x1CD
        if((PhysicalProperty != none) && PhysicalProperty.MaterialType != 'None')
        {
            I = ImpactEffects.Find('MaterialType', PhysicalProperty.MaterialType);            
            // End:0x1CD
            if(I != -1)
            {
                return ImpactEffects[I];
            }
        }
        return DefaultImpactEffect;
    }
    //return ReturnValue;    
}

simulated function bool AllowImpactEffects(Actor HitActor, Vector HitLocation, Vector HitNormal)
{
    return PortalTeleporter(HitActor) == none;
    //return ReturnValue;    
}

simulated function SetImpactedActor(Actor HitActor, Vector HitLocation, Vector HitNormal, TraceHitInfo HitInfo)
{
    //return;    
}

simulated function CheckHitInfo(out TraceHitInfo HitInfo, PrimitiveComponent FallBackComponent, Vector Dir, out Vector out_HitLocation)
{
    local Vector out_NewHitLocation, out_HitNormal, TraceEnd, TraceStart;
    local TraceHitInfo newHitInfo;

    // End:0x59
    if((SkeletalMeshComponent(HitInfo.HitComponent) != none) && HitInfo.BoneName != 'None')
    {
        return;
    }
    // End:0x22B
    if((SkeletalMeshComponent(HitInfo.HitComponent) != none) && HitInfo.BoneName == 'None')
    {
        // End:0xD4
        if(IsZero(Dir))
        {
            Dir = Vector(Rotation);
        }
        // End:0xF6
        if(IsZero(out_HitLocation))
        {
            out_HitLocation = Location;
        }
        TraceStart = out_HitLocation - (float(128) * Normal(Dir));
        TraceEnd = out_HitLocation + (float(128) * Normal(Dir));
        // End:0x22B
        if(TraceComponent(out_NewHitLocation, out_HitNormal, HitInfo.HitComponent, TraceEnd, TraceStart, vect(0.0000000, 0.0000000, 0.0000000), newHitInfo))
        {
            HitInfo.BoneName = newHitInfo.BoneName;
            HitInfo.PhysMaterial = newHitInfo.PhysMaterial;
            out_HitLocation = out_NewHitLocation;
        }
    }
    //return;    
}

simulated function PlayImpactSounds(Actor HitActor, Vector SoundLocation, Vector FireDir, PhysicalMaterial PhysMaterial, class<EvilDmgType_Base> EvilBaseDamageType, bool bPlayerIsInstigator)
{
    local SoundCue ImpactSound;
    local Vehicle V;

    ImpactSound = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, EvilBaseDamageType, WorldInfo, bPlayerIsInstigator);
    V = Vehicle(HitActor);
    // End:0x1DE
    if((ImpactSound != none) && !bSuppressSounds)
    {
        // End:0x12B
        if(((V != none) && V.IsLocallyControlled()) && V.IsHumanControlled())
        {
            PlayerController(V.Controller).ClientPlaySound(ImpactSound);            
        }
        else
        {
            // End:0x156
            if(BulletWhip != none)
            {
                CheckBulletWhip(FireDir, SoundLocation);
            }
            // End:0x1BE
            if((EvilPawn(HitActor) != none) && EvilPawn(HitActor).CanPlayHitSounds())
            {
                PlaySound(ImpactSound, true,,, SoundLocation);                
            }
            else
            {
                PlaySound(ImpactSound, true,,, SoundLocation);
            }
        }
    }
    //return;    
}

simulated function PlayImpactEffects(Vector HitLocation, optional bool bIsLeft = false)
{
    local Vector NewHitLoc, HitNormal, FireDir, WaterHitNormal;
    local Actor HitActor;
    local EvilPawn HitActorEvilPawn;
    local TraceHitInfo HitInfo;
    local MaterialImpactEffect ImpactEffect;
    local MaterialInterface MI;
    local MaterialInstanceTimeVarying MITV_Decal;
    local EvilVehicle_Base V;
    local EvilPawn PawnOwner;
    local ParticleSystem ImpactParticle, overridePS;
    local class<EvilDmgType_Base> EvilBaseDamageType;
    local DecalData DecalData;
    local PhysicalMaterial PhysMaterial;
    local float DecalRandomScaling;
    local Vector TracerStartLoc;
    local Projectile Tracer;
    local editinline ParticleSystemComponent PartComp;
    local float ParticleScale;
    local bool bActorCanPlayHitEffects;
    local class<EvilProjectile_Base> BlobClass;
    local EvilProjectile_Base Blob;

    PawnOwner = EvilPawn(Owner);
    // End:0xDA6
    if((PawnOwner != none) && EffectIsRelevant(HitLocation, false, MaxImpactEffectDistance))
    {
        // End:0xAD
        if(WeaponClass.default.bMeleeWeapon)
        {
            HitNormal = Normal(PawnOwner.Location - HitLocation);            
        }
        else
        {
            HitNormal = Normal(PawnOwner.GetWeaponStartTraceLocation() - HitLocation);
        }
        FireDir = float(-1) * HitNormal;
        // End:0x269
        if(((bMakeSplash && !WorldInfo.bDropDetail) && PawnOwner.IsPlayerPawn()) && PawnOwner.IsLocallyControlled())
        {
            HitActor = Trace(NewHitLoc, WaterHitNormal, HitLocation, PawnOwner.Location + (PawnOwner.EyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), true,, HitInfo, 2 | 1);
            // End:0x269
            if(UTWaterVolume(HitActor) != none)
            {
                WorldInfo.MyEmitterPool.SpawnEmitter(none, NewHitLoc, Rotator(vect(0.0000000, 0.0000000, 1.0000000)));
            }
        }
        HitActor = Trace(NewHitLoc, HitNormal, HitLocation - (HitNormal * float(32)), HitLocation + (HitNormal * float(32)), true,, HitInfo, 1);
        // End:0xDA3
        if(HitActor != none)
        {
            HitActorEvilPawn = EvilPawn(HitActor);
            // End:0x347
            if(HitActorEvilPawn != none)
            {
                CheckHitInfo(HitInfo, HitActorEvilPawn.Mesh, -HitNormal, NewHitLoc);
            }
            // End:0x3A1
            if((HitActorEvilPawn != none) && int(Owner.GetTeamNum()) == int(HitActorEvilPawn.GetTeamNum()))
            {
                return;
            }
            SetImpactedActor(HitActor, HitLocation, HitNormal, HitInfo);
            ImpactEffect = GetImpactEffect(HitInfo.PhysMaterial);
            PhysMaterial = Class'EvilPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo(HitInfo);
            EvilBaseDamageType = class<EvilDmgType_Base>(WeaponClass.default.InstantHitDamageTypes[int(PawnOwner.FiringMode)]);
            DecalData = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactDecalData(PhysMaterial, EvilBaseDamageType, WorldInfo, Instigator);
            // End:0x55C
            if((HitActorEvilPawn == none) || !HitActorEvilPawn.IsFirstPerson())
            {
                ImpactParticle = Class'EvilPhysicalMaterialProperty'.static.DetermineImpactParticleSystem(PhysMaterial, EvilBaseDamageType, WorldInfo, Instigator, ParticleScale);
            }
            PlayImpactSounds(HitActor, HitLocation, FireDir, PhysMaterial, EvilBaseDamageType, NotEqual_InterfaceInterface(EvilPlayer_interface(Owner), EvilPlayer_interface(none)));
            V = EvilVehicle_Base(HitActor);
            // End:0x70C
            if(((V != none) && int(Role) < int(ROLE_Authority)) && !WorldInfo.GRI.OnSameTeam(Owner, V))
            {
                V.ApplyMorphDamage(HitLocation, int(WeaponClass.default.InstantHitDamage[int(EvilPawn(Owner).FiringMode)]), WeaponClass.default.InstantHitMomentum[int(EvilPawn(Owner).FiringMode)] * FireDir);
            }
            // End:0xADB
            if(((HitActorEvilPawn == none) && VSizeSq(Owner.Location - HitLocation) < MaxDecalRangeSq) && ((int(WorldInfo.GetDetailMode()) != int(0)) && !Class'Engine.Engine'.static.IsSplitScreen()) || PawnOwner.IsLocallyControlled() && PawnOwner.IsHumanControlled())
            {
                MI = DecalData.DecalMaterial;
                // End:0xADB
                if(MI != none)
                {
                    DecalRandomScaling = GetRangeValueByPct(DecalData.RandomScalingRange, FRand());
                    // End:0xA07
                    if(MaterialInstanceTimeVarying(MI) != none)
                    {
                        // End:0xA04
                        if(Terrain(HitActor) == none)
                        {
                            MITV_Decal = new (self) Class'Engine.MaterialInstanceTimeVarying';
                            MITV_Decal.SetParent(MI);
                            WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, HitLocation, Rotator(-HitNormal), DecalData.Width * DecalRandomScaling, DecalData.Height * DecalRandomScaling, DecalData.Thickness, DecalData.ClipDecalsUsingFastPath);
                            MITV_Decal.SetScalarStartTime(ImpactEffect.DecalDissolveParamName, DecalData.LifeSpan);
                        }                        
                    }
                    else
                    {
                        WorldInfo.MyDecalManager.SpawnDecal(MI, HitLocation, Rotator(-HitNormal), DecalData.Width * DecalRandomScaling, DecalData.Height * DecalRandomScaling, DecalData.LifeSpan * DecalRandomScaling, false);
                    }
                }
            }
            bActorCanPlayHitEffects = ImpactParticle != none;
            // End:0xB33
            if((HitActorEvilPawn != none) && !HitActorEvilPawn.CanPlayHitImpactEffects())
            {
                bActorCanPlayHitEffects = false;
            }
            // End:0xCA3
            if(bActorCanPlayHitEffects)
            {
                // End:0xB8B
                if(!bAlignToSurfaceNormal)
                {
                    HitNormal = Normal(FireDir - ((float(2) * HitNormal) * (FireDir Dot HitNormal)));
                }
                // End:0xBE5
                if(HitActorEvilPawn != none)
                {
                    overridePS = HitActorEvilPawn.OverrideHitImpactEffect();
                    // End:0xBE5
                    if(overridePS != none)
                    {
                        ImpactParticle = overridePS;
                    }
                }
                PartComp = WorldInfo.MyEmitterPool.SpawnEmitter(ImpactParticle, HitLocation, Rotator(HitNormal));
                PartComp.SetScale(ParticleScale);
                // End:0xCA3
                if(HitActorEvilPawn != none)
                {
                    HitActorEvilPawn.SetupHitImpactEffect(PartComp);
                }
            }
            // End:0xDA3
            if(((HitActorEvilPawn != none) && !HitActorEvilPawn.IsLocallyControlled()) && FRand() < BloodBlobChance)
            {
                BlobClass = HitActorEvilPawn.GetBloodGlobClass(EvilBaseDamageType);
                // End:0xDA3
                if(BlobClass != none)
                {
                    Blob = Spawn(BlobClass, HitActorEvilPawn,, HitLocation, Rotator(-HitNormal));
                    // End:0xDA3
                    if(Blob != none)
                    {
                        Blob.Init(-HitNormal);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0xDD1
        if(BulletWhip != none)
        {
            CheckBulletWhip(FireDir, HitLocation);
        }
    }
    // End:0x112F
    if(bShowTracers && FRand() < TracerChance)
    {
        // End:0x1094
        if(PawnOwner.IsFirstPerson())
        {
            // End:0xF17
            if(bIsLeft && PawnOwner.WeaponLeft != none)
            {
                SkeletalMeshComponent(PawnOwner.WeaponLeft.Mesh).GetSocketWorldLocationAndRotation(EvilWeap_Base(PawnOwner.WeaponLeft).MuzzleFlashSocket[int(PawnOwner.WeaponLeft.CurrentFireMode)], TracerStartLoc);                
            }
            else
            {
                // End:0x100A
                if(PawnOwner.Weapon != none)
                {
                    SkeletalMeshComponent(PawnOwner.Weapon.Mesh).GetSocketWorldLocationAndRotation(EvilWeap_Base(PawnOwner.Weapon).MuzzleFlashSocket[int(PawnOwner.Weapon.CurrentFireMode)], TracerStartLoc);
                }
            }
            Tracer = GetTracer(TracerStartLoc);
            // End:0x1091
            if((Tracer != none) && !Tracer.bDeleteMe)
            {
                Tracer.Init(Normal(HitLocation - TracerStartLoc));
            }            
        }
        else
        {
            TracerStartLoc = GetEffectLocation();
            Tracer = GetTracer(TracerStartLoc);
            // End:0x112F
            if((Tracer != none) && !Tracer.bDeleteMe)
            {
                Tracer.Init(Normal(HitLocation - TracerStartLoc));
            }
        }
    }
    //return;    
}

reliable client simulated function drawCone(Vector SocLoc, Rotator SocRot, float ConeRadAngle, float Scale)
{
    // End:0x89
    if(VSize(SocLoc - vect(0.0000000, 0.0000000, 0.0000000)) < float(200))
    {
        SocLoc.X = -33195.0000000;
        SocLoc.Y = -25169.0000000;
        SocLoc.Z = -6955.0000000;
    }
    DrawDebugCone(SocLoc, Vector(SocRot), 1000.0000000, ConeRadAngle * Scale, ConeRadAngle * Scale, 30, MakeColor(50, 255, 0, 255), false);
    //return;    
}

simulated function Projectile GetTracer(Vector TracerStartLoc)
{
    return EvilGameReplicationInfo(WorldInfo.GRI).GOP.super(EvilAttachment_Weap_Base).GetTracer(0, 0, TracerStartLoc);
    //return ReturnValue;    
}

simulated function CheckBulletWhip(Vector FireDir, Vector HitLocation)
{
    local UTPlayerController PC;

    // End:0xC3
    foreach LocalPlayerControllers(Class'UTPlayerController', PC)
    {
        // End:0xC2
        if(!WorldInfo.GRI.OnSameTeam(Owner, PC))
        {
            PC.CheckBulletWhip(BulletWhip, Owner.Location, FireDir, HitLocation);
        }        
    }    
    //return;    
}

simulated function SetWeaponOverlayFlags(UTPawn OwnerPawn)
{
    local MaterialInterface InstanceToUse;
    local byte Flags;
    local int I;
    local UTGameReplicationInfo GRI;

    GRI = UTGameReplicationInfo(WorldInfo.GRI);
    // End:0x131
    if(GRI != none)
    {
        Flags = OwnerPawn.WeaponOverlayFlags;
        I = 0;
        J0x73:

        // End:0x131 [Loop If]
        if(I < GRI.WeaponOverlays.Length)
        {
            // End:0x123
            if((GRI.WeaponOverlays[I] != none) && bool(int(Flags) & (1 << I)))
            {
                InstanceToUse = GRI.WeaponOverlays[I];
                // [Explicit Break]
                goto J0x131;
            }
            I++;
            // [Loop Continue]
            goto J0x73;
        }
    }
    J0x131:

    // End:0x281
    if(InstanceToUse != none)
    {
        // End:0x159
        if(OverlayMesh == none)
        {
            CreateOverlayMesh();
        }
        // End:0x27E
        if(OverlayMesh != none)
        {
            I = 0;
            J0x173:

            // End:0x1DF [Loop If]
            if(I < OverlayMesh.GetNumElements())
            {
                OverlayMesh.SetMaterial(I, InstanceToUse);
                I++;
                // [Loop Continue]
                goto J0x173;
            }
            OverlayMesh.SetHidden(false);
            // End:0x27E
            if(!OverlayMesh.bAttached)
            {
                OwnerPawn.Mesh.AttachComponentToSocket(OverlayMesh, OwnerPawn.WeaponSocket);
            }
        }        
    }
    else
    {
        // End:0x2ED
        if(OverlayMesh != none)
        {
            OverlayMesh.SetHidden(true);
            OwnerPawn.Mesh.DetachComponent(OverlayMesh);
        }
    }
    //return;    
}

simulated function ChangeVisibility(bool bIsVisible)
{
    // End:0x3A
    if(Mesh != none)
    {
        Mesh.SetHidden(!bIsVisible);
    }
    // End:0x74
    if(OverlayMesh != none)
    {
        OverlayMesh.SetHidden(!bIsVisible);
    }
    //return;    
}

simulated function DoQuickHide()
{
    //return;    
}

simulated function EndQuickHide()
{
    ChangeVisibility(true);
    //return;    
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
    //return;    
}

simulated function Vector GetEffectLocation()
{
    local Vector SocketLocation;
    local editinline SkeletalMeshComponent SkelMeshComp;

    // End:0x4B
    if((Mesh != none) && Mesh.SkeletalMesh != none)
    {
        SkelMeshComp = Mesh;        
    }
    else
    {
        // End:0xC3
        if((EvilPawn(Owner) != none) && EvilPawn(Owner).Mesh != none)
        {
            SkelMeshComp = EvilPawn(Owner).Mesh;
        }
    }
    // End:0x11A
    if(MuzzleFlashSocket != 'None')
    {
        SkelMeshComp.GetSocketWorldLocationAndRotation(MuzzleFlashSocket, SocketLocation);
        return SocketLocation;        
    }
    else
    {
        return SkelMeshComp.Bounds.Origin + (vect(45.0000000, 0.0000000, 0.0000000) >> Instigator.Rotation);
    }
    //return ReturnValue;    
}

simulated function GetSocketWorldLocationAndRotation(name InSocketName, out Vector SocLoc, out Rotator SocRot)
{
    local editinline SkeletalMeshComponent SkelMeshComp;

    // End:0x4B
    if((Mesh != none) && Mesh.SkeletalMesh != none)
    {
        SkelMeshComp = Mesh;        
    }
    else
    {
        // End:0xC3
        if((EvilPawn(Owner) != none) && EvilPawn(Owner).Mesh != none)
        {
            SkelMeshComp = EvilPawn(Owner).Mesh;
        }
    }
    // End:0x12F
    if(SkelMeshComp.GetSocketByName(InSocketName) != none)
    {
        SkelMeshComp.super(EvilAttachment_Weap_Base).GetSocketWorldLocationAndRotation(InSocketName, SocLoc, SocRot);        
    }
    //return;    
}

state CurrentlyAttached
{    stop;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__EvilAttachment_Weap_Base.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0 class=Class'Engine.SkeletalMeshComponent'
        Animations=UDKAnimNodeSequence'Default__EvilAttachment_Weap_Base.MeshSequenceA'
        bForceRefpose=1
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        bPerBoneMotionBlur=true
        bOverrideAttachmentOwnerVisibility=true
        ReplacementPrimitive=none
        MaxDrawDistance=10000.0000000
        CachedMaxDrawDistance=10000.0000000
        bOwnerNoSee=true
    end object
    Mesh=SkeletalMeshComponent0
    MuzzleFlashColor=(R=255,G=255,B=255,A=255)
    bAlignToSurfaceNormal=true
    bEnableIK=true
    bEnableIKOnAim=true
    MuzzleFlashDuration=0.3000000
    DefaultImpactEffect=(MaterialType="None",Sound=none,DecalMaterials=none,DurationOfDecal=24.0000000,DecalDissolveParamName="DissolveAmount",DecalWidth=0.0000000,DecalHeight=0.0000000,ParticleTemplate=none)
    DefaultAltImpactEffect=(MaterialType="None",Sound=none,DecalMaterials=none,DurationOfDecal=24.0000000,DecalDissolveParamName="DissolveAmount",DecalWidth=0.0000000,DecalHeight=0.0000000,ParticleTemplate=none)
    TracerChance=0.2000000
    TracerClass=Class'EvilProjectile_Tracer_Base'
    MaxImpactEffectDistance=4000.0000000
    MaxFireEffectDistance=10000.0000000
    MaxDecalRangeSq=16000000.0000000
    DistFactorForRefPose=0.1400000
    BloodBlobChance=1.0000000
    ImpactSoundsQuantityLimit=5.0000000
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    TickGroup=ETickingGroup.TG_DuringAsyncWork
    bReplicateInstigator=true
    NetUpdateFrequency=10.0000000
}