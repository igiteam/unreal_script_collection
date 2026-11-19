class SkyWeapon extends SkyWeaponBase
    native
    config(Game);

enum ETargetState
{
    TargetState_None,               // 0
    TargetState_Teammate,           // 1
    TargetState_Enemy,              // 2
    TargetState_TargetingMode,      // 3
    TargetState_Idle,               // 4
    TargetState_MAX                 // 5
};

enum ECrosshairVisualState
{
    CVS_Visible,                    // 0
    CVS_Invisible,                  // 1
    CVS_FadingOut,                  // 2
    CVS_FadingIn,                   // 3
    CVS_MAX                         // 4
};

struct native SAntiGravParams
{
    var() float TotalDuration;
    var() float VertAccelRate;
    var() float VertAccelDuration;
    var() float VertDecelTime;
    var() float VertDecelRate;
    var() float HorizAccelRate;
    var() float HorizAccelDuration;
    var() float HorizDecelTime;
    var() float HorizDecelRate;
    var() float RotRateMin;
    var() float RotRateMax;

    structdefaultproperties
    {
        TotalDuration=0.0000000
        VertAccelRate=0.0000000
        VertAccelDuration=0.0000000
        VertDecelTime=0.0000000
        VertDecelRate=0.0000000
        HorizAccelRate=0.0000000
        HorizAccelDuration=0.0000000
        HorizDecelTime=0.0000000
        HorizDecelRate=0.0000000
        RotRateMin=0.0000000
        RotRateMax=0.0000000
    }
};

struct native SSpreadParams
{
    var() Rotator MinSpread;
    var() Rotator MaxSpread;
    var() float RateOfIncrease;
    var() float RateOfDecrease;
    var() float DelayIncreaseTime;
    var() float DelayDecreaseTime;
    var Rotator CurrSpread;

    structdefaultproperties
    {
        MinSpread=(Pitch=0,Yaw=0,Roll=0)
        MaxSpread=(Pitch=0,Yaw=0,Roll=0)
        RateOfIncrease=0.0000000
        RateOfDecrease=0.0000000
        DelayIncreaseTime=0.0000000
        DelayDecreaseTime=0.0000000
        CurrSpread=(Pitch=0,Yaw=0,Roll=0)
    }
};

struct native SSpecialBoneDamage
{
    var() Pawn.EBoneType BoneType;
    var() float DamageMultiplier;

    structdefaultproperties
    {
        BoneType=BoneType_Undefined
        DamageMultiplier=0.0000000
    }
};

struct native ImpulseScaleWeaponInfo
{
    var() class<Actor> ImpactedClass;
    var() float ImpulseScale;

    structdefaultproperties
    {
        ImpactedClass=none
        ImpulseScale=1.0000000
    }
};

struct native ShellDropSoundEntry
{
    var() name Material;
    var() SoundCue Sound;

    structdefaultproperties
    {
        Material="None"
        Sound=none
    }
};

struct native SPiercingHitInfo
{
    var Actor HitActor;
    var Vector EntryLoc;
    var Vector ExitLoc;
    var Vector EntryNormal;
    var Vector ExitNormal;

    structdefaultproperties
    {
        HitActor=none
        EntryLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ExitLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        EntryNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ExitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SPiercingParams
{
    var() bool bIsPiercing;
    var() float AllowedThickness;
    var() int NumAllowedPiercings;
    var() protectedwrite array<protectedwrite string> OnlySpecificArchetypes;

    structdefaultproperties
    {
        bIsPiercing=false
        AllowedThickness=0.0000000
        NumAllowedPiercings=0
        OnlySpecificArchetypes=none
    }
};

struct native SUpgradeSkelControls
{
    var() name ControlName;
    var() float ControlStrength;

    structdefaultproperties
    {
        ControlName="None"
        ControlStrength=0.0000000
    }
};

var bool bWasFiring;
var bool bIsBackWeapon;
var bool bTwoHanded;
var(Weapon) bool bIsAutomatic;
var bool bFired;
var(Ammo) bool bForceRefillOnTouch;
var(Aiming) bool m_bGuaranteeAutoAimHit;
var transient bool AnimFireFlag;
var transient bool AnimFireFlagChecked;
var(Weapon) bool bUseRapidRecoilAnim;
var(Effects) bool bAlignToSurfaceNormal;
var(Effects) bool bCauseLocalEffectOnDamage;
var(Projectiles) bool bTracerEffectsOnly;
var transient bool bRecoilInProgress;
var(Weapon) bool bGuaranteeShot;
var(Aiming) array<bool> bAutoAim;
var deprecated array<float> SpreadYaw;
var deprecated array<float> SpreadPitch;
var deprecated array<SSpreadParams> SpreadParams;
var deprecated Rotator m_rCurrentSpread;
var(Weapon) int NumProjectilesPerShot;
var(Pickup_and_HUD) string DisplayName;
var(Pickup_and_HUD) string DisplayIcon;
var(Weapon) name FireSocket;
var(Weapon) name FireSocketTest;
var(Weapon) Vector TraceExtents;
var(Weapon) array<SSpecialBoneDamage> SpecialBoneDamages;
var(Weapon) float ShortReloadTime;
var(Weapon) float FullReloadTime;
var deprecated SAntiGravParams AntiGravParams;
var(Ammo) int AdditionalAmmo;
var(Ammo) int MaxAdditionalAmmo;
var int AmmoToReload;
var(Aiming) array<float> MagnetismRange;
var(Aiming) array<float> MagnetismRangeHover;
var name TracerTargetClassName;
var(Performance) int NumShotsBetweenTraces;
var transient int ShotsSinceLastTrace;
var(Performance) int NumTracersBetweenBlanks;
var transient int TracersSinceLastBlank;
var(Performance) int NumDecalsBetweenBlanks;
var transient int DecalsSinceLastBlank;
var(Performance) int NumImpactsBetweenBlanks;
var transient int ImpactsSinceLastBlank;
var(Pickup_and_HUD) int RepCost;
var(Pickup_and_HUD) int GlimmerMaterialIndex;
var deprecated float MaxTargetingDistance;
var(Aiming) array<Vector2D> ReticleSpeeds;
var deprecated float PawnImpulseMultipler;
var(Physics) array<ImpulseScaleWeaponInfo> ImpulseScalers;
var(Physics) float DefaultImpulse;
var(Physics) array<ImpulseScaleWeaponInfo> DeathImpulses;
var(Physics) float DefaultDeathImpulse;
var(Physics) float FloatingImpulse;
var(Physics) float LaunchingImpulse;
var transient SkyWeapon.ETargetState TargetState;
var transient SkyWeapon.ECrosshairVisualState CrosshairVisualState;
var transient float LastTargetState;
var(AI) float BotWeaponUseRange;
var(AI) float BotWeaponUseMinRange;
var(AI) Vector2D AI_AccCone_Min;
var(AI) Vector2D AI_AccCone_Max;
var float CrosshairSizeChangeTime;
var float CrosshairTargetStateMinTime;
var float CrosshairSizeChange;
var float CrosshairFadeInTime;
var float CrosshairFadeOutTime;
var float CrosshairFadeStartTime;
var float CrosshairCurrAlphaPercent;
var Color CrossHairColor_Normal;
var Color CrossHairColor_Team;
var Color CrossHairColor_Enemy;
var Vector CrossHairPreviousScreenLoc;
var(Effects) array<MaterialImpactEffect> ImpactEffects;
var(Effects) MaterialImpactEffect DefaultImpactEffect;
var(Effects) float MaxImpactEffectDistance;
var(Effects) float MaxFireEffectDistance;
var(Effects) float MaxImpactDecalDistance;
var deprecated SkyLocalEffect DamageLocalEffect;
var(Effects) editinline SkyLocalEffectSettings DamageLocalEffectSettings;
var(Sounds) SoundCue BulletWhizz;
var deprecated ParticleSystem ProjFlightTemplate;
var deprecated float Speed;
var deprecated float MaxSpeed;
var deprecated float AccelRate;
var(Projectiles) SkyProjectile TracerArchetype;
var deprecated class<Projectile> TracerClass;
var(Projectiles) SkyTracer TracerEffectArchetype;
var(Sounds) SoundCue DropImpactSound;
var(Sounds) float DropImpactSoundMinRepeat;
var(Sounds) float DropImpactSoundMinVel;
var(Sounds) SoundCue ReloadSound;
var(Sounds) SoundCue PickupAmmoSound;
var(Sounds) array<ShellDropSoundEntry> ShellDropSounds;
var export editinline AudioComponent ShellDropAC;
var(Projectiles) SkyProjectile ProjectileArchetype;
var class<SkyWeaponAttachment> AttachClass;
var(PawnAttachment) name HolsterSocket;
var(PawnAttachment) name DefaultSocket;
var(PawnAttachment) name AlternateSocket;
var(PawnAttachment) name DefaultIKControl;
var(PawnAttachment) name AlternateIKControl;
var(PawnAttachment) name DefaultIKRefBone;
var(PawnAttachment) name AlternateIKRefBone;
var deprecated class<SkyExplosionLight> SkyMuzzleFlashLightClass;
var(Upgrade) int UpgradeStage;
var transient AnimNodeSequence LastRecoilSeq;
var(Weapon) SkyWSMTimeouts ReadyExpirationTimeouts;
var(Weapon) SPiercingParams PiercingParams;
var(Weapon) array<SUpgradeSkelControls> UpgradeSkelControls;
var(Pickup_and_HUD) const editconst export editinline LightEnvironmentComponent LightEnvironment;
var(Weapon) float HideOwnerOnZoomTime;
var(Weapon) name HideWeaponSkelControlName;
var SkelControlSingleBone HideWeaponSkelControl;

// Export USkyWeapon::execDebugGetWeaponImpactLocation(FFrame&, void* const)
native simulated function Vector DebugGetWeaponImpactLocation();

// Export USkyWeapon::execSetUpgradeSkelControls(FFrame&, void* const)
native static function SetUpgradeSkelControls(array<SUpgradeSkelControls> Controls, SkeletalMeshComponent MeshComp);

// Export USkyWeapon::execGetPiercingHitInfo(FFrame&, void* const)
native function GetPiercingHitInfo(Vector TraceStart, Vector TraceEnd, out array<SPiercingHitInfo> PiercingHitInfo);

simulated function PostBeginPlay()
{
    local int I;

    SetUpgradeSkelControls(UpgradeSkelControls, SkeletalMeshComponent(Mesh));
    ValidateSpread();
    // End:0x66
    if(NumShotsBetweenTraces > 0)
    {
        I = 0;
        J0x35:

        // End:0x66 [Loop If]
        if(I < InstantHitDamage.Length)
        {
            InstantHitDamage[I] *= float(NumShotsBetweenTraces + 1);
            ++I;
            // [Loop Continue]
            goto J0x35;
        }
    }
    UpdateHideWeaponSkelControl();
    super.PostBeginPlay();
    //return;    
}

function UpdateHideWeaponSkelControl()
{
    local SkyWeaponAttachment SWA;
    local editinline SkeletalMeshComponent SkelMesh;

    SWA = GetWeaponAttachment();
    // End:0x60
    if(SWA != none)
    {
        SkelMesh = SkeletalMeshComponent(SWA.Mesh);
        // End:0x60
        if(SkelMesh != none)
        {
            HideWeaponSkelControl = SkelControlSingleBone(SkelMesh.FindSkelControl(HideWeaponSkelControlName));
        }
    }
    //return;    
}

function ValidateSpread()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x29B [Loop If]
    if(I < SpreadParameters.Length)
    {
        // End:0xCA
        if((SpreadParameters[I].AbsoluteMax.Pitch >= 0) && SpreadParameters[I].AbsoluteMax.Pitch < SpreadParameters[I].BaseOffset.Pitch)
        {
            SpreadParameters[I].AbsoluteMax.Pitch = SpreadParameters[I].BaseOffset.Pitch;
        }
        // End:0x17D
        if((SpreadParameters[I].AbsoluteMax.Yaw >= 0) && SpreadParameters[I].AbsoluteMax.Yaw < SpreadParameters[I].BaseOffset.Yaw)
        {
            SpreadParameters[I].AbsoluteMax.Yaw = SpreadParameters[I].BaseOffset.Yaw;
        }
        // End:0x207
        if(SpreadParameters[I].MaxAmount.Pitch < SpreadParameters[I].MinAmount.Pitch)
        {
            SpreadParameters[I].MaxAmount.Pitch = SpreadParameters[I].MinAmount.Pitch;
        }
        // End:0x291
        if(SpreadParameters[I].MaxAmount.Yaw < SpreadParameters[I].MinAmount.Yaw)
        {
            SpreadParameters[I].MaxAmount.Yaw = SpreadParameters[I].MinAmount.Yaw;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function Tick(float DeltaTime)
{
    //return;    
}

function bool IsMeleeWeapon()
{
    return false;
    //return ReturnValue;    
}

function DoMeleeDamage(Actor Target, Vector HitLocation, int AttackIdx, float DamageScale)
{
    //return;    
}

simulated function TimeWeaponPutDown()
{
    // End:0x6E
    if((SkyPawn(Owner).IsMelee() || SkyInteractor(Owner).IsInteracting()) || SkyPawn(Owner).IsGripping())
    {
        SetTimer(0.0100000, false, 'WeaponIsDown');        
    }
    else
    {
        SetTimer(((PutDownTime > float(0)) ? PutDownTime : 0.0100000), false, 'WeaponIsDown');
    }
    //return;    
}

function ItemRemovedFromInvManager()
{
    // End:0x1E
    if(IsActiveWeapon())
    {
        Instigator.Weapon = none;
    }
    // End:0x41
    if(IsActiveSecondaryWeapon())
    {
        SkyPawn(Instigator).SecondaryWeapon = none;
    }
    super(Weapon).ItemRemovedFromInvManager();
    //return;    
}

simulated function bool IsActiveSecondaryWeapon()
{
    // End:0x2B
    if(SkyInventoryManager(InvManager) != none)
    {
        return SkyInventoryManager(InvManager).IsActiveSecondaryWeapon(self);
    }
    return false;
    //return ReturnValue;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    local SkyWeapon SW;
    local int I;

    SetHidden(true);
    // End:0xE0
    if(SkyPawn(Instigator) != none)
    {
        // End:0x6E
        if(bIsSecondaryWeapon && SkyPawn(Instigator) != none)
        {
            SkyPawn(Instigator).CurrSecondaryWeaponArchetype = SkyWeapon(ObjectArchetype);
            SkyPawn(Instigator).SecondaryWeaponAttachmentChanged();            
        }
        else
        {
            // End:0xE0
            if(!bIsBackWeapon)
            {
                SkyPawn(Instigator).CurrWeaponArchetype = SkyWeapon(ObjectArchetype);
                // End:0xE0
                if(Instigator.IsLocallyControlled() || int(WorldInfo.NetMode) == int(NM_ListenServer))
                {
                    SkyPawn(Instigator).WeaponAttachmentChanged();
                }
            }
        }
    }
    // End:0x118
    if(SkyPawn(Instigator).ReplicatedBodyMaterial != none)
    {
        SetSkin(SkyPawn(Instigator).ReplicatedBodyMaterial);
    }
    // End:0x1EC
    if(SkyPawn(Instigator) != none)
    {
        // End:0x173
        if(SkyAIController(Instigator.Controller) != none)
        {
            I = 0;
            J0x149:

            // End:0x170 [Loop If]
            if(I < bAutoAim.Length)
            {
                bAutoAim[I] = false;
                ++I;
                // [Loop Continue]
                goto J0x149;
            }            
        }
        else
        {
            SW = SkyWeapon(ObjectArchetype);
            // End:0x1EC
            if(SW != none)
            {
                I = 0;
                J0x195:

                // End:0x1EC [Loop If]
                if((I < bAutoAim.Length) && I < SW.bAutoAim.Length)
                {
                    bAutoAim[I] = SW.bAutoAim[I];
                    ++I;
                    // [Loop Continue]
                    goto J0x195;
                }
            }
        }
    }
    //return;    
}

simulated function DetachAuxWeapon(optional int auxIndex)
{
    local editinline SkeletalMeshComponent SKMesh;
    local SkyPawn SP;

    SetSkin(none);
    SetHidden(true);
    SP = SkyPawn(Instigator);
    // End:0xBA
    if(SP != none)
    {
        // End:0xBA
        if(SP.AuxWeapons[auxIndex].Attachment != none)
        {
            SP.AuxWeapons[auxIndex].Attachment.DetachFrom(SP.Mesh);
            SP.AuxWeapons[auxIndex].Attachment.Destroy();
        }
    }
    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x115
    if(SKMesh != none)
    {
        // End:0xF5
        if(MuzzleFlashMesh != none)
        {
            SKMesh.DetachComponent(MuzzleFlashMesh);
        }
        // End:0x115
        if(MuzzleFlashPSC != none)
        {
            SKMesh.DetachComponent(MuzzleFlashPSC);
        }
    }
    //return;    
}

simulated function DetachWeapon()
{
    local editinline SkeletalMeshComponent SKMesh;

    SetSkin(none);
    // End:0x7D
    if(!bIsSecondaryWeapon)
    {
        // End:0x7A
        if((int(Role) == int(ROLE_Authority)) && SkyPawn(Instigator) != none)
        {
            SkyPawn(Instigator).CurrWeaponArchetype = none;
            // End:0x7A
            if(Instigator.IsLocallyControlled())
            {
                SkyPawn(Instigator).WeaponAttachmentChanged();
            }
        }        
    }
    else
    {
        // End:0xE1
        if((int(Role) == int(ROLE_Authority)) && SkyPawn(Instigator) != none)
        {
            SkyPawn(Instigator).CurrSecondaryWeaponArchetype = none;
            // End:0xE1
            if(Instigator.IsLocallyControlled())
            {
                SkyPawn(Instigator).SecondaryWeaponAttachmentChanged();
            }
        }
    }
    SetHidden(true);
    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x143
    if(SKMesh != none)
    {
        // End:0x123
        if(MuzzleFlashMesh != none)
        {
            SKMesh.DetachComponent(MuzzleFlashMesh);
        }
        // End:0x143
        if(MuzzleFlashPSC != none)
        {
            SKMesh.DetachComponent(MuzzleFlashPSC);
        }
    }
    //return;    
}

simulated event GetMagnetismTraceInfo(out Vector vStart, out Vector vEnd)
{
    local SkyPawn SP;
    local float MagRange;

    SP = SkyPawn(Instigator);
    // End:0x46
    if((SP != none) && SP.bGliding)
    {
        MagRange = MagnetismRangeHover[int(CurrentFireMode)];        
    }
    else
    {
        MagRange = MagnetismRange[int(CurrentFireMode)];
    }
    vStart = Instigator.GetWeaponStartTraceLocation();
    vEnd = vStart + (Vector(Instigator.GetAdjustedAimFor(self, vStart)) * MagRange);
    //return;    
}

simulated function float GetMagnetismReticleSize()
{
    local SkyPawn pSP;
    local SkyPlayerController pSPC;
    local float fResult;

    fResult = 0.0000000;
    pSP = SkyPawn(Owner);
    // End:0x60
    if(pSP != none)
    {
        pSPC = SkyPlayerController(pSP.Controller);
        // End:0x60
        if(pSPC != none)
        {
            fResult = pSPC.m_fMagnetismReticleSize;
        }
    }
    return fResult;
    //return ReturnValue;    
}

event ForceAdjustLockTarget(Actor NewLockTarget)
{
    bForceLock = NewLockTarget != none;
    AdjustLockTarget(NewLockTarget);
    //return;    
}

// Export USkyWeapon::execCanLockOnTo(FFrame&, void* const)
native function bool CanLockOnTo(Actor TA);

// Export USkyWeapon::execCanProjectileFire(FFrame&, void* const)
native simulated function bool CanProjectileFire(Vector ImpactLoc, Vector TraceDir);

function FireProjectile()
{
    //return;    
}

// Export USkyWeapon::execShouldUseAutoAimTarget(FFrame&, void* const)
native simulated function bool ShouldUseAutoAimTarget();

// Export USkyWeapon::execGetInstantFireTraceInfo(FFrame&, void* const)
native simulated function GetInstantFireTraceInfo(bool bUseAutoAimTarget, out Vector StartTrace, out Vector EndTrace);

// Export USkyWeapon::execInstantFire(FFrame&, void* const)
native simulated function InstantFire();

// Export USkyWeapon::execProcessInstantHit(FFrame&, void* const)
native simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact);

simulated event float GetSpecialDamageBoneMultiplier(Pawn.EBoneType BoneType)
{
    local int I;

    // End:0x6C
    if(int(BoneType) != int(0))
    {
        I = 0;
        J0x17:

        // End:0x6C [Loop If]
        if(I < SpecialBoneDamages.Length)
        {
            // End:0x62
            if(int(SpecialBoneDamages[I].BoneType) == int(BoneType))
            {
                return SpecialBoneDamages[I].DamageMultiplier;
            }
            ++I;
            // [Loop Continue]
            goto J0x17;
        }
    }
    return 1.0000000;
    //return ReturnValue;    
}

// Export USkyWeapon::execGetProjectileClass(FFrame&, void* const)
native simulated function class<Projectile> GetProjectileClass();

// Export USkyWeapon::execGetProjectileArchetype(FFrame&, void* const)
native simulated function SkyProjectile GetProjectileArchetype();

// Export USkyWeapon::execProjectileFire(FFrame&, void* const)
native simulated function Projectile ProjectileFire();

// Export USkyWeapon::execLaunchTracer(FFrame&, void* const)
native simulated function bool LaunchTracer(Vector Start, Vector End);

// Export USkyWeapon::execSkyWeaponProjectileFire(FFrame&, void* const)
native final simulated function Projectile SkyWeaponProjectileFire();

simulated function float MaxRange()
{
    local float FurthestRange;

    FurthestRange = super(Weapon).MaxRange();
    // End:0x44
    if(ProjectileArchetype != none)
    {
        FurthestRange = FMax(FurthestRange, ProjectileArchetype.MaxSpeed * ProjectileArchetype.LifeSpan);
    }
    return FurthestRange;
    //return ReturnValue;    
}

// Export USkyWeapon::execAddMovingLevelVelToProjectile(FFrame&, void* const)
native function AddMovingLevelVelToProjectile(Projectile Proj, Level myLevel);

// Export USkyWeapon::execCalcWeaponFire(FFrame&, void* const)
native simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList);

// Export USkyWeapon::execGetPhysicalFireStartLoc(FFrame&, void* const)
native simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir);

// Export USkyWeapon::execCreateProjectile(FFrame&, void* const)
native simulated function Projectile CreateProjectile(class<Projectile> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail);

// Export USkyWeapon::execCreateTracer(FFrame&, void* const)
native simulated function SkyTracer CreateTracer(SkyTracer ClassArchetype, Actor SpawnOwner, optional Vector SpawnLocation, optional Vector ImpactLocation);

// Export USkyWeapon::execFireAmmunition(FFrame&, void* const)
native simulated function FireAmmunition();

function bool CanAttackExtraChecks(Actor Other)
{
    local float Dist, CheckDist, OtherRadius, OtherHeight;
    local Vector HitLocation, HitNormal, projStart;
    local Actor HitActor;
    local class<Projectile> ProjClass;
    local Vector startTraceLoc;

    // End:0x24
    if((Instigator == none) || Instigator.Controller == none)
    {
        return false;
    }
    Dist = VSize(Instigator.Location - Other.Location);
    // End:0x62
    if(Dist > (MaxRange()))
    {
        return false;
    }
    // End:0x121
    if((SkyPawnCoverUser(Owner) != none) && SkyPawnCoverUser(Owner).IsInCover() == true)
    {
        // End:0xFE
        if(SkyPawnCoverUser(Owner).CurrentLink != none)
        {
            startTraceLoc = SkyPawnCoverUser(Owner).CurrentLink.GetSlotViewPoint(SkyPawnCoverUser(Owner).CurrentSlotIdx,, SkyPawnCoverUser(Owner).CoverAction);            
        }
        else
        {
            startTraceLoc = Pawn(Owner).GetWeaponStartTraceLocation();
        }        
    }
    else
    {
        startTraceLoc = (Pawn(Owner).Location + (vect(0.0000000, 0.0000000, 1.0000000) * (Pawn(Owner).BaseEyeHeight * 0.7500000))) + (Normal(Other.Location - Pawn(Owner).Location) * Pawn(Owner).GetCollisionRadius());
    }
    // End:0x1D4
    if(!Instigator.Controller.LineOfSightTo(Other, startTraceLoc))
    {
        return false;
    }
    // End:0x278
    if(!bInstantHit)
    {
        ProjClass = GetProjectileClass();
        // End:0x205
        if(ProjClass == none)
        {
            ProjClass = WeaponProjectiles;
        }
        // End:0x21E
        if(ProjClass == none)
        {
            CheckDist = 300.0000000;            
        }
        else
        {
            CheckDist = FMax(CheckDist, 0.5000000 * ProjClass.default.Speed);
            CheckDist = FMax(CheckDist, 300.0000000);
            CheckDist = FMin(CheckDist, VSize(Other.Location - Location));
        }
    }
    projStart = Instigator.GetWeaponStartTraceLocation(self);
    Other.GetBoundingCylinder(OtherRadius, OtherHeight);
    // End:0x308
    if(bInstantHit)
    {
        HitActor = TraceOwner.Trace(HitLocation, HitNormal, Other.Location + (OtherHeight * vect(0.0000000, 0.0000000, 0.8000000)), projStart, true);        
    }
    else
    {
        HitActor = TraceOwner.Trace(HitLocation, HitNormal, projStart + (CheckDist * Normal((Other.Location + (OtherHeight * vect(0.0000000, 0.0000000, 0.8000000))) - Location)), projStart, true);
    }
    // End:0x3E5
    if(((((HitActor == none) || HitActor == Other) || Pawn(HitActor) == none) || Pawn(HitActor).Controller == none) || !WorldInfo.GRI.OnSameTeam(Instigator, HitActor))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool CanAttackNative(Actor Other)
{
    return CanAttack(Other);
    //return ReturnValue;    
}

function bool CanAttack(Actor Other)
{
    local bool bCanAttack;
    local Pawn OwnerPawn, OtherPawn;
    local SkyPawnCoverUser OwnerCU;

    // End:0x68
    if((Other != none) && Pawn(Other) != none)
    {
        // End:0x68
        if((SkyPlayerController(Pawn(Other).Controller) != none) && SkyAirVehicle(Other) != none)
        {
            // End:0x68
            if(SkyAirVehicle(Other).bTakeoff)
            {
                return false;
            }
        }
    }
    OwnerPawn = Pawn(Owner);
    OtherPawn = Pawn(Other);
    // End:0x1A2
    if(((OtherPawn != none) && OwnerPawn != none) && SkyBot(OwnerPawn.Controller) != none)
    {
        OwnerCU = SkyPawnCoverUser(OwnerPawn);
        // End:0x164
        if(((OwnerCU != none) && OwnerCU.IsInCover()) && (OwnerPawn.Controller.IsMoveInputLocked() || !OwnerCU.PrimaryWSM.IsTargeting()) || int(OwnerCU.GetCoverMacroState()) != int(2))
        {
            bCanAttack = false;            
        }
        else
        {
            bCanAttack = SkyBot(OwnerPawn.Controller).BotMemory.CanSee(OtherPawn, 0.0000000);
        }        
    }
    else
    {
        bCanAttack = CanAttackExtraChecks(Other);
    }
    return bCanAttack;
    //return ReturnValue;    
}

// Export USkyWeapon::execGenerateParametricSpread(FFrame&, void* const)
native function Rotator GenerateParametricSpread(Rotator BaseAim, float YawParam, float PitchParam);

// Export USkyWeapon::execAddSpread(FFrame&, void* const)
native simulated function Rotator AddSpread(Rotator BaseAim);

simulated function bool PendingFire(int FireMode)
{
    // End:0x38
    if(bIsSecondaryWeapon && SkyInventoryManager(InvManager) != none)
    {
        return bool(SkyInventoryManager(InvManager).PendingSecondaryFire[FireMode]);
    }
    return super(Weapon).PendingFire(FireMode);
    //return ReturnValue;    
}

simulated function SetPendingFire(int FireMode)
{
    // End:0x3A
    if(bIsSecondaryWeapon && SkyInventoryManager(InvManager) != none)
    {
        SkyInventoryManager(InvManager).PendingSecondaryFire[FireMode] = 1;        
    }
    else
    {
        super(Weapon).SetPendingFire(FireMode);
    }
    //return;    
}

simulated function ClearPendingFire(int FireMode)
{
    // End:0x3A
    if(bIsSecondaryWeapon && SkyInventoryManager(InvManager) != none)
    {
        SkyInventoryManager(InvManager).PendingSecondaryFire[FireMode] = 0;        
    }
    else
    {
        super(Weapon).ClearPendingFire(FireMode);
    }
    //return;    
}

simulated function ForceEndFire()
{
    local int I;

    // End:0x71
    if(bIsSecondaryWeapon && SkyInventoryManager(InvManager) != none)
    {
        I = 0;
        J0x22:

        // End:0x6E [Loop If]
        if(I < SkyInventoryManager(InvManager).PendingSecondaryFire.Length)
        {
            // End:0x64
            if(PendingFire(I))
            {
                EndFire(byte(I));
            }
            I++;
            // [Loop Continue]
            goto J0x22;
        }        
    }
    else
    {
        super(Weapon).ForceEndFire();
    }
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    bFired = false;
    super.EndFire(FireModeNum);
    // End:0x36
    if(ShellDropAC.bWasPlaying)
    {
        ShellDropAC.Stop();
    }
    //return;    
}

event name GetWeaponStateName()
{
    return GetStateName();
    //return ReturnValue;    
}

// Export USkyWeapon::execAddAmmo(FFrame&, void* const)
native function int AddAmmo(int Amount, optional bool bAddToStorageOnly);

function bool HasFullAmmo()
{
    return AmmoCount >= MaxAmmoCount;
    //return ReturnValue;    
}

simulated event WeaponEmpty()
{
    // End:0x1B
    if(IsFiring())
    {
        GotoState('Active');
    }
    // End:0x3D
    if((AdditionalAmmo > 0) && !bIsSecondaryWeapon)
    {
        Reload();
    }
    //return;    
}

// Export USkyWeapon::execReload(FFrame&, void* const)
native simulated function Reload();

// Export USkyWeapon::execCanReload(FFrame&, void* const)
native function bool CanReload();

simulated function PlaySoundAt(SoundCue ASound, Vector SourceLocation)
{
    local editinline AudioComponent AC;

    // End:0x0D
    if(ASound == none)
    {
        return;
    }
    AC = WorldInfo.CreateAudioComponent(ASound, false, true);
    AC.bUseOwnerLocation = false;
    AC.Location = SourceLocation;
    AC.bAutoDestroy = true;
    AC.Play();
    //return;    
}

// Export USkyWeapon::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount();

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    //return;    
}

// Export USkyWeapon::execStopFireEffects(FFrame&, void* const)
native simulated function StopFireEffects(byte FireModeNum);

function float GetAutoAimTraceOffsetLength()
{
    local SkyPawn pSP;
    local float Result;

    Result = 0.0000000;
    pSP = SkyPawn(Instigator);
    // End:0xAD
    if((pSP != none) && pSP.PrimaryWSM != none)
    {
        // End:0x6F
        if(pSP.PrimaryWSM.IsZooming())
        {
            Result = AutoAimTraceOffset[2];            
        }
        else
        {
            // End:0xA0
            if(pSP.PrimaryWSM.IsTargeting())
            {
                Result = AutoAimTraceOffset[1];                
            }
            else
            {
                Result = AutoAimTraceOffset[0];
            }
        }
    }
    return (Result * LastClipY) * 0.5000000;
    //return ReturnValue;    
}

// Export USkyWeapon::execDrawWeaponCrosshair(FFrame&, void* const)
native function DrawWeaponCrosshair(HUD HUD);

// Export USkyWeapon::execGetCrosshairAlphaPercent(FFrame&, void* const)
native simulated function float GetCrosshairAlphaPercent(bool bShouldShow);

// Export USkyWeapon::execShouldShowReticle(FFrame&, void* const)
native simulated function bool ShouldShowReticle();

simulated function DrawAmmoCount(HUD H)
{
    local SkyHUD SH;
    local Texture2D texSecondary, texPrimary;
    local SkyWeapon CurrentSecondary, CurrentPrimary;
    local WeaponHUDParam WHP;

    SH = SkyHUD(H);
    CurrentPrimary = SkyWeapon(SkyPawn(Instigator).Weapon);
    CurrentSecondary = SkyWeapon(SkyPawn(Instigator).SecondaryWeapon);
    // End:0x1A9
    if((SH != none) && SH.HideHUDRefCount == 0)
    {
        // End:0xC1
        if(CurrentPrimary != none)
        {
            // End:0xC1
            if(SH.GetWeaponParam(CurrentPrimary.WeaponName, WHP))
            {
                texPrimary = Texture2D(WHP.DisplayTexture);
            }
        }
        // End:0x112
        if(CurrentSecondary != none)
        {
            // End:0x112
            if(SH.GetWeaponParam(CurrentSecondary.WeaponName, WHP))
            {
                texSecondary = Texture2D(WHP.DisplayTexture);
            }
        }
        // End:0x1A9
        if(SkyPlayerController(SkyPawn(Instigator).Controller) != none)
        {
            // End:0x175
            if((CurrentSecondary != self) && texPrimary != none)
            {
                SH.DrawPrimary(texPrimary, GetAmmoCount(), AdditionalAmmo);                
            }
            else
            {
                // End:0x1A9
                if(texSecondary != none)
                {
                    SH.DrawSecondary(texSecondary, GetAmmoCount(), -1);
                }
            }
        }
    }
    //return;    
}

reliable client simulated function ClientStartZoom()
{
    local SkyPlayerController pSPC;

    SkyPawn(Instigator).SetZooming(true);
    SkyPawn(Instigator).SetTargeting(true);
    HideOwnerOnZoom();
    pSPC = SkyPlayerController(Instigator.Controller);
    // End:0xAE
    if(pSPC != none)
    {
        pSPC.SetRotation(pSPC.Rotation + pSPC.m_rReticleRotation);
        pSPC.m_rReticleRotation = rot(0, 0, 0);
    }
    //return;    
}

event HideOwnerOnZoom()
{
    SetTimer(HideOwnerOnZoomTime, false, 'DelayHidingOwnerOnZoom');
    //return;    
}

function DelayHidingOwnerOnZoom()
{
    ZoomSetOwnerNoSee(true);
    //return;    
}

reliable client simulated function ClientStopZoom(optional bool bSupressFade)
{
    local SkyPlayerController pSPC;

    SkyPawn(Instigator).SetZooming(false);
    SkyPawn(Instigator).SetTargeting(false);
    ZoomSetOwnerNoSee(false);
    pSPC = SkyPlayerController(Instigator.Controller);
    // End:0xB4
    if(pSPC != none)
    {
        pSPC.m_rReticleRotation = pSPC.m_ReticleOffsetValues[0];
        pSPC.SetRotation(pSPC.Rotation - pSPC.m_rReticleRotation);
    }
    //return;    
}

event ZoomSetOwnerNoSee(bool noSee)
{
    local SkyPawn SP;

    SP = SkyPawn(Instigator);
    ClearTimer('DelayHidingOwnerOnZoom');
    // End:0x1DC
    if(SP != none)
    {
        // End:0x75
        if(((noSee == true) && SP.PrimaryWSM != none) && !SP.PrimaryWSM.IsZooming())
        {
            return;
        }
        // End:0xD5
        if((SP.RocketPack != none) && SP.RocketPack.Mesh != none)
        {
            SP.RocketPack.Mesh.SetOwnerNoSee(noSee);
        }
        SkeletalMeshComponent(SP.CurrWeaponAttachment.Mesh).SetOwnerNoSee(noSee);
        SP.Mesh.SetOwnerNoSee(noSee);
        SP.LegMesh.SetOwnerNoSee(noSee);
        SP.HeadMesh.SetOwnerNoSee(noSee);
        SP.HairMesh.SetOwnerNoSee(noSee);
        // End:0x1B9
        if(SkyPawn_Dweller(SP) != none)
        {
            SkyPawn_Dweller(SP).WingMesh.SetOwnerNoSee(noSee);
        }
        SP.Mesh.bIgnoreControllersWhenNotRendered = !noSee;
    }
    //return;    
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetCurrentFireMode(FiringModeNum);
    }
    super(Weapon).SetCurrentFireMode(FiringModeNum);
    //return;    
}

event SetCurrentFireModeFromNative(byte FiringModeNum)
{
    SetCurrentFireMode(FiringModeNum);
    //return;    
}

reliable server function ServerSetCurrentFireMode(byte FiringModeNum)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        SetCurrentFireMode(FiringModeNum);
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector vAutoAimProjectedLoc;
    local SkyPawn SP;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    SP = SkyPawn(Owner);
    // End:0x1D1
    if((SP != none) && SP.AutoAimHitDist <= AutoAimRange[int(CurrentFireMode)])
    {
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        HUD.Canvas.DrawText((("Auto aim: " @ string(SP.AutoAimImpact.HitActor)) @ ": ") @ string(SP.AutoAimImpact.HitLocation));
        out_YPos += out_YL;
        DrawDebugSphere(SP.AutoAimImpact.HitLocation, 300.0000000, 5, 0, 255, 0, false);
        vAutoAimProjectedLoc = HUD.Canvas.Project(SP.AutoAimImpact.HitLocation);
        HUD.Canvas.SetDrawColor(255, 255, 255);
        HUD.Canvas.SetPos(vAutoAimProjectedLoc.X, vAutoAimProjectedLoc.Y);
        HUD.Canvas.DrawCircle(6.0000000);
    }
    //return;    
}

simulated event Vector GetAimDir()
{
    return Vector(Instigator.GetAdjustedAimFor(self, Instigator.GetWeaponStartTraceLocation())) * AutoAimRange[int(CurrentFireMode)];
    //return ReturnValue;    
}

simulated function bool AmmoFullyMaxed(int Mode)
{
    return (AmmoMaxed(Mode)) && AdditionalAmmo == MaxAdditionalAmmo;
    //return ReturnValue;    
}

function DroppedPickup DropFromEx(Vector StartLocation, Rotator StartRotation, Vector StartVelocity, Vector StartAngularVelocity, optional bool bAuxiliary, optional int auxIndex)
{
    local DroppedPickup P;
    local editinline SkeletalMeshComponent CheckSkelComp;
    local SkyWeapon BaseWeapon;

    // End:0x13
    if(!CanThrow())
    {
        return none;
    }
    ForceEndFire();
    // End:0x38
    if(bAuxiliary)
    {
        DetachAuxWeapon(auxIndex);        
    }
    else
    {
        InvManager.RemoveFromInventory(self);
    }
    // End:0x6A
    if((DroppedPickupClass == none) || DroppedPickupMesh == none)
    {
        Destroy();
        return none;
    }
    P = Spawn(DroppedPickupClass,,, StartLocation,,, true);
    // End:0x95
    if(P == none)
    {
        Destroy();
        return none;
    }
    // End:0xC6
    if(SkyWeaponPickup(P) != none)
    {
        SkyWeaponPickup(P).ContainedAmmo = AmmoCount + AdditionalAmmo;
    }
    P.SetPhysics(2);
    P.Inventory = self;
    P.InventoryClass = Class;
    P.Velocity = StartVelocity;
    P.SetRotation(StartRotation);
    P.Instigator = Instigator;
    // End:0x276
    if(SkyPickup(P) != none)
    {
        SkyPickup(P).DroppedItemArchetype = Inventory(ObjectArchetype);
        SkyPickup(P).InvMaterialIndex = GlimmerMaterialIndex;
        BaseWeapon = SkyWeapon(SkyPickup(P).DroppedItemArchetype);
        // End:0x213
        if((SkySecondaryItem(self) == none) && SkyWeapon(SkyPickup(P).DroppedItemArchetype.ObjectArchetype.ObjectArchetype.ObjectArchetype) != none)
        {
            BaseWeapon = SkyWeapon(SkyPickup(P).DroppedItemArchetype.ObjectArchetype);
        }
        P.SetPickupMesh(BaseWeapon.DroppedPickupMesh);
        // End:0x272
        foreach P.AllOwnedComponents(Class'Engine.SkeletalMeshComponent', CheckSkelComp)
        {
            SetUpgradeSkelControls(BaseWeapon.UpgradeSkelControls, CheckSkelComp);            
        }                
    }
    else
    {
        P.SetPickupMesh(DroppedPickupMesh);
    }
    P.CollisionComponent.SetRBAngularVelocity(StartAngularVelocity, true);
    Instigator = none;
    GotoState('None');
    GotoState('Inactive');
    return P;
    //return ReturnValue;    
}

simulated event StopFire(byte FireModeNum)
{
    super.StopFire(FireModeNum);
    //return;    
}

reliable server function ServerStopFire(byte FireModeNum)
{
    super(Weapon).ServerStopFire(FireModeNum);
    //return;    
}

simulated event StartFireNative(byte FireModeNum)
{
    StartFire(FireModeNum);
    //return;    
}

function StartHeatingTimer(float delay)
{
    local SkyPawn pSP;

    pSP = SkyPawn(Owner);
    // End:0x55
    if((pSP != none) && pSP.CurrWeaponAttachment != none)
    {
        pSP.CurrWeaponAttachment.StartHeatingTimer(HeatingDelay);
    }
    //return;    
}

simulated function StopAllEffects()
{
    local SkyWeaponAttachment SWA;

    SWA = GetWeaponAttachment();
    // End:0x2F
    if(SWA != none)
    {
        SWA.StopAllEffects();
    }
    super.StopAllEffects();
    //return;    
}

simulated function Loaded(optional bool bUseWeaponMax)
{
    super.Loaded(bUseWeaponMax);
    // End:0x30
    if(bUseWeaponMax)
    {
        AdditionalAmmo = SkyWeapon(ObjectArchetype).AdditionalAmmo;
    }
    //return;    
}

auto state Inactive
{
    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x4C
        if((SkyPawn(Instigator) != none) && SkyPawn(Instigator).SecondaryWeapon == self)
        {
            GotoState('Active');
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            // End:0x8C
            if((SkyInventoryManager(InvManager) != none) && SkyInventoryManager(InvManager).PendingSecondaryWeapon == self)
            {
                SetPendingFire(int(FireModeNum));                
            }
            else
            {
                super.ServerStartFire(FireModeNum);
            }
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x3E
        if((SkyPawn(Instigator) != none) && SkyPawn(Instigator).SecondaryWeapon == self)
        {
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            super.ServerStartFire(FireModeNum);
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        local float ReloadTime;
        local SkyPawn SP;
        local int TempAmmoCount;

        SP = SkyPawn(Owner);
        AmmoToReload = AmmoCount;
        // End:0x5E
        if(AmmoCount != 0)
        {
            // End:0x50
            if(SP != none)
            {
                SP.PrimaryWSM.StartReload(true);
            }
            ReloadTime = ShortReloadTime;            
        }
        else
        {
            // End:0x88
            if(SP != none)
            {
                SP.PrimaryWSM.StartReload();
            }
            ReloadTime = FullReloadTime;
        }
        // End:0xB8
        if(ReloadSound != none)
        {
            SP.PlaySound(ReloadSound);
        }
        // End:0x13E
        if(!bInfiniteAmmo && (SP == none) || !SP.bHasInfiniteExtraAmmo)
        {
            TempAmmoCount = AmmoCount + AdditionalAmmo;
            // End:0x129
            if(TempAmmoCount > MaxAmmoCount)
            {
                AdditionalAmmo -= (MaxAmmoCount - AmmoCount);
                AmmoToReload = MaxAmmoCount;                
            }
            else
            {
                AmmoToReload = TempAmmoCount;
                AdditionalAmmo = 0;
            }            
        }
        else
        {
            AmmoToReload = MaxAmmoCount;
        }
        SetTimer(ReloadTime, false, 'FinishedReload');
        //return;        
    }

    simulated function FinishedReload()
    {
        // End:0x78
        if(AdditionalAmmo == 0)
        {
            // End:0x78
            if((SkyPawn(Owner) != none) && SkyPawnSoundGroup(SkyPawn(Owner).SoundGroup) != none)
            {
                SkyPawn(Owner).PlayVoiceOver(SkyPawnSoundGroup(SkyPawn(Owner).SoundGroup).VO_NoAmmo);
            }
        }
        GotoState('Active');
        //return;        
    }

    function bool ReadyToFire(bool bFinished)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        AmmoCount = AmmoToReload;
        // End:0x3E
        if(SkyPawn(Owner) != none)
        {
            SkyPawn(Owner).PrimaryWSM.StopReload();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PrevStateName)
    {
        ShotsSinceLastTrace = 0;
        TracersSinceLastBlank = 0;
        DecalsSinceLastBlank = 0;
        ImpactsSinceLastBlank = 0;
        super.BeginState(PrevStateName);
        //return;        
    }
    stop;    
}
