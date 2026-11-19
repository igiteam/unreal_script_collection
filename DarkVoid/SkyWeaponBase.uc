class SkyWeaponBase extends Weapon
    abstract
    native
    nativereplication
    config(Game);

enum ESpreadState
{
    ESS_Decreasing,                 // 0
    ESS_WaitForIncrease,            // 1
    ESS_Increasing,                 // 2
    ESS_WaitForDecrease,            // 3
    ESS_MAX                         // 4
};

enum ERecoilState
{
    ERES_Idle,                      // 0
    ERES_Recoiling,                 // 1
    ERES_WaitForReset,              // 2
    ERES_Resetting,                 // 3
    ERES_MAX                        // 4
};

enum EOverheatState
{
    EOS_Idle,                       // 0
    EOS_WaitForHeating,             // 1
    EOS_Heating,                    // 2
    EOS_Overheated,                 // 3
    EOS_WaitForCoolDown,            // 4
    EOS_CoolDown,                   // 5
    EOS_MAX                         // 6
};

enum ESkyZoomState
{
    SKY_ZST_NotZoomed,              // 0
    SKY_ZST_ZoomingOut,             // 1
    SKY_ZST_ZoomingIn,              // 2
    SKY_ZST_Zoomed,                 // 3
    SKY_ZST_MAX                     // 4
};

enum ESkyAutoLock
{
    SKY_WEAPLOCK_None,              // 0
    SKY_WEAPLOCK_Default,           // 1
    SKY_WEAPLOCK_Constant,          // 2
    SKY_WEAPLOCK_MAX                // 3
};

enum ERecoilOrSpread
{
    EROS_Recoil,                    // 0
    EROS_Spread,                    // 1
    EROS_SpreadVisual,              // 2
    EROS_MAX                        // 3
};

struct native LoopingWeaponSound
{
    var() SoundCue Sound;
    var export editinline AudioComponent Component;

    structdefaultproperties
    {
        Sound=none
        Component=none
    }
};

struct native SEffectInfo
{
    var() ParticleSystem Template;
    var() name Socket;
    var SkyEmitter Emitter;

    structdefaultproperties
    {
        Template=none
        Socket="None"
        Emitter=none
    }
};

struct native SAntiGravParamsNew
{
    var() float TotalDuration;
    var() float CustomGravityScale;
    var() float InitialUpwardImpulse;
    var() float InitialImpulse;
    var() float LaunchImpulse;

    structdefaultproperties
    {
        TotalDuration=0.0000000
        CustomGravityScale=0.0000000
        InitialUpwardImpulse=0.0000000
        InitialImpulse=0.0000000
        LaunchImpulse=0.0000000
    }
};

struct native SDisableRocketpackParams
{
    var() float TotalDuration;

    structdefaultproperties
    {
        TotalDuration=0.0000000
    }
};

struct native SPoisonParams
{
    var() float TotalDuration;
    var() float DamageInterval;
    var() int DamageAmount;

    structdefaultproperties
    {
        TotalDuration=0.0000000
        DamageInterval=0.0000000
        DamageAmount=0
    }
};

struct native SExplosionParams
{
    var() float InnerDamageRadius;
    var() float DamageRadius;
    var() int DamageAmount;

    structdefaultproperties
    {
        InnerDamageRadius=0.0000000
        DamageRadius=0.0000000
        DamageAmount=0
    }
};

struct native SChargeUpParams
{
    var() bool bHoldUntilReleased;
    var() float Duration;
    var float DurationTimer;
    var() SEffectInfo Effect;
    var() LoopingWeaponSound ChargeUpSound;
    var deprecated int Damage;
    var deprecated int MinDamage;
    var deprecated float TaperStartDistance;
    var deprecated float TaperEndDistance;
    var() int AmmoCost;
    var() float CoolDownTime;
    var float CoolDownTimer;
    var() SkyProjectile ProjectileArchetype;
    var() editinline ForceFeedbackWaveform Rumble;

    structdefaultproperties
    {
        bHoldUntilReleased=false
        Duration=0.0000000
        DurationTimer=0.0000000
        Effect=(Template=none,Socket="None",Emitter=none)
        ChargeUpSound=(Sound=none,Component=none)
        AmmoCost=0
        CoolDownTime=0.0000000
        CoolDownTimer=0.0000000
        ProjectileArchetype=none
        Rumble=none
    }
};

struct native SSwayParams
{
    var() float RotationRateMin;
    var() float RotationRateMax;
    var() float GrowTimeMin;
    var() float GrowTimeMax;
    var() float MaxOffset;
    var() int NumSwayVectors;
    var() float SmoothPercent;

    structdefaultproperties
    {
        RotationRateMin=0.0000000
        RotationRateMax=0.0000000
        GrowTimeMin=0.0000000
        GrowTimeMax=0.0000000
        MaxOffset=0.0000000
        NumSwayVectors=0
        SmoothPercent=0.0000000
    }
};

struct native SRecoilParams
{
    var() Rotator MinAmount;
    var() Rotator MaxAmount;
    var() float SpeedOut;
    var() float ResetTime;
    var float ResetSpeed;
    var() float DelayBeforeReset;
    var() Rotator AbsoluteMax;
    var Rotator CurrOffset;
    var Rotator TargetOffset;
    var() Rotator BaseOffset;
    var() bool bIgnoreReset;
    var() float WaitTime;

    structdefaultproperties
    {
        MinAmount=(Pitch=0,Yaw=0,Roll=0)
        MaxAmount=(Pitch=0,Yaw=0,Roll=0)
        SpeedOut=0.0000000
        ResetTime=0.0000000
        ResetSpeed=0.0000000
        DelayBeforeReset=0.0000000
        AbsoluteMax=(Pitch=0,Yaw=0,Roll=0)
        CurrOffset=(Pitch=0,Yaw=0,Roll=0)
        TargetOffset=(Pitch=0,Yaw=0,Roll=0)
        BaseOffset=(Pitch=0,Yaw=0,Roll=0)
        bIgnoreReset=false
        WaitTime=0.0000000
    }
};

struct native SInternalRecoilData
{
    var SkyWeaponBase.ERecoilState CurrState;
    var float DelayResetTimer;
    var Vector ChangeAmount;

    structdefaultproperties
    {
        CurrState=ERES_Idle
        DelayResetTimer=0.0000000
        ChangeAmount=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var SkyWeaponBase.EOverheatState OverheatState;
var byte ZoomedFireModeNum;
var(Pickup_and_HUD) databinding byte InventoryGroup;
var SkyWeaponBase.ESkyAutoLock WeaponLockType;
var byte PreviousFireMode;
var(Heat) bool bCanOverheat;
var(Ammo) bool bInfiniteAmmo;
var(Ammo) bool bShowAmmoInHUD;
var bool bFadeOnZoomEnd;
var(Effects) bool bMuzzleFlashPSCLoops;
var bool bLockedOnTarget;
var bool bDebugWeapon;
var transient bool bForceLock;
var(Aiming) deprecated bool m_bUseDebugReticle;
var deprecated bool m_bUseAutoAim;
var bool bIsSecondaryWeapon;
var(Sounds) bool bPlayerPlaysSingleShot;
var(Sounds) bool bChargeUpDelaysLoopingSound;
var(Weapon) bool bIsLargeWeapon;
var bool bDisabled;
var deprecated bool bMustSpinUpBeforeFiring;
var(Beam) bool bBeamStopAtFirstHit;
var transient bool bBeamLastVisualEndLocNeedsInit;
var transient bool bBeamFiring;
var bool bDoRecoilAndSpread;
var bool bEndFireImmediately;
var bool bShouldPlayProlongedFiringEffect;
var deprecated bool ProlongedFiringPSCLoops;
var float OverheatPercent;
var(Heat) float WaitForHeatingTime;
var float WaitForHeatingTimer;
var(Heat) float HeatingTime;
var float HeatingTimer;
var(Heat) float WaitForCoolDownTime;
var float WaitForCoolDownTimer;
var(Heat) float CoolDownTime;
var float CoolDownTimer;
var(Sounds) LoopingWeaponSound OverheatSound;
var(Ammo) repnotify databinding int AmmoCount;
var(Ammo) databinding int MaxAmmoCount;
var(Ammo) int ShotCost;
var array<float> MinReloadPct;
var array<name> EffectSockets;
var float SwitchAbortTime;
var array<byte> bZoomedFireMode;
var float ZoomedTargetFOV;
var float ZoomedRate;
var float ZoomFadeTime;
var float FadeTime;
var(Sounds) SoundCue ZoomInSound;
var(Sounds) SoundCue ZoomOutSound;
var protected export editinline MeshComponent OverlayMesh;
var(Pickup_and_HUD) name WeaponName;
var(Pickup_and_HUD) float GroupWeight;
var(Pickup_and_HUD) array<float> AutoAimTraceOffset;
var transient float LastClipY;
var float InventoryWeight;
var name WeaponPutDownAnim;
var name WeaponEquipAnim;
var array<name> WeaponIdleAnims;
var(Sounds) array<SoundCue> WeaponFireSnd;
var(Sounds) SoundCue WeaponPutDownSnd;
var(Sounds) SoundCue WeaponEquipSnd;
var name MuzzleFlashSocket;
var export editinline StaticMeshComponent MuzzleFlashMesh;
var export editinline ParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashAltPSCTemplate;
var deprecated Color MuzzleFlashColor;
var export editinline deprecated SkyExplosionLight MuzzleFlashLight;
var deprecated class<SkyExplosionLight> MuzzleFlashLightClass;
var(Effects) ParticleSystem MuzzleFlashPSCTemplate;
var(Effects) float MuzzleFlashDuration;
var(WeaponRumble) editinline ForceFeedbackWaveform WeaponRumble;
var(WeaponRumble) editinline ForceFeedbackWaveform WeaponSingleShotRumble;
var(WeaponRumble) float SingleShotRumbleDelay;
var(WeaponViewShake) editinline ViewShakeInfo WeaponViewShake;
var float CurrentRating;
var int OwnerStatsID;
var int WeaponStatsID;
var class<Pawn> LockablePawnClass;
var float LockCheckTime;
var int LockRange;
var float LockAcquireTime;
var float LockTolerance;
var Actor LockedTarget;
var Actor PendingLockedTarget;
var float LastLockedOnTime;
var float PendingLockedTargetTime;
var float LastValidTargetTime;
var SoundCue LockAcquiredSound;
var SoundCue LockLostSound;
var(Aiming) array<float> AutoAimRange;
var(Aiming) array<float> AutoAimRangeHover;
var deprecated ImpactInfo m_AutoAimImpact;
var transient Vector LockLastPaintLocation;
var transient Vector LockLastPaintHitLocation;
var(Aiming) deprecated float m_fAutoAimNumTraces;
var deprecated array<Vector2D> m_AutoAimOffsets;
var transient Vector TracerBestHitLocation;
var transient Actor TracerBestHitActor;
var float CrosshairSizeDefault;
var float CrosshairWidth;
var float CrosshairHeight;
var transient int ActiveFireMode;
var(Sounds) array<LoopingWeaponSound> LoopingWeaponFire;
var(Sounds) SoundCue EmptyFireSound;
var(Sounds) float EmptyFiringRate;
var(Weapon) int ImpactDelay;
var transient ImpactInfo ImpactDelayInfo;
var(Weapon) float InstantHitExplosionDamage;
var(Weapon) float InstantHitExplosionDamageRadius;
var(Weapon) float InstantHitExplosionImpulse;
var(Weapon) float EquippedMoveSpeed;
var deprecated float MinSpinPctToFire;
var deprecated float SecondsToSpinUp;
var deprecated float SecondsToSpinDown;
var deprecated SEffectInfo ChargeUp;
var deprecated SEffectInfo OutOfAmmo;
var deprecated array<name> ChargeUpSockets;
var deprecated array<LoopingWeaponSound> WeaponChargeUpSnd;
var deprecated float ChargeUpTime;
var deprecated float ChargeDownTime;
var(Beam) SEffectInfo BeamEffect;
var(Beam) SEffectInfo BeamEndEffect;
var(Beam) float BeamRadiusStart;
var(Beam) float BeamRadiusEnd;
var(Beam) float BeamRangeMin;
var(Beam) float BeamRangeMax;
var(Beam) float BeamGrowTime;
var deprecated float BeamHoldTime;
var(Beam) float BeamShrinkTime;
var(Beam) float BeamDamage;
var(Beam) float BeamLagPct;
var(Beam) float BeamAmmoConsumeRate;
var deprecated float BeamCameraShakeInterval;
var(Beam) float BeamRecoilTimeMin;
var(Beam) float BeamRecoilTimeMax;
var transient float BeamRecoilTimer;
var transient float BeamGrowTimer;
var transient float BeamShrinkTimer;
var transient float BeamCurrLength;
var transient float BeamDamageSaved;
var transient float BeamAmmoSaved;
var transient Vector BeamLastVisualEndLoc;
var(WeaponEffects) array<SkyPawn.EWeaponEffect> WeaponEffects;
var(WeaponEffects) SAntiGravParamsNew AntiGravParamsNew;
var(WeaponEffects) SDisableRocketpackParams DisableRocketpackParams;
var(WeaponEffects) SPoisonParams PoisonParams;
var(WeaponEffects) array<SVisualEffectParams> VisualEffectParams;
var(WeaponEffects) SExplosionParams ExplosionParams;
var(Weapon) array<SChargeUpParams> ChargeUpParams;
var(Aiming) array<SSwayParams> SwayParams;
var transient int CurrChargeUpStage;
var(Effects) array<SEffectInfo> ProlongedFiringEffect;
var(Effects) float ProlongedFiringDelay;
var export editinline array<export editinline ParticleSystemComponent> ProlongedFiringPSC;
var(Effects) array<SEffectInfo> OverheatedEffect;
var export editinline array<export editinline ParticleSystemComponent> OverheatedPSC;
var(Effects) float HeatingDelay;
var(ViewShake) float ExplodeShakeRadius;
var(ViewShake) ViewShakeInfo ExplodeViewShake;
var(Rumble) float ExplodeRumbleRadius;
var(Rumble) editinline ForceFeedbackWaveform ExplodeRumble;
var(Aiming) array<SRecoilParams> RecoilParams;
var(Aiming) array<SRecoilParams> SpreadParameters;
var(Aiming) array<SRecoilParams> SpreadParametersVisual;
var float StartFireTime;
var SInternalRecoilData RecoilData[3];
var(Effects) export editinline SkyMaterialEffectManager MaterialEffectManager;
var(Effects) int WeaponMaterialIndex;
var(Effects) array<BloodEffectInfo> WeaponLevelSpecificBloodEmitterTemplates;
var(Group) SkyWeaponGroup WeaponGroup;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsRadial> ImpactForceRadial;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsCylindrical> ImpactForceCylindrical;
var(Effects) notforconsole editinline array<editinline ForceFieldSettingsGeneric> ImpactForceGeneric;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        AmmoCount, LockedTarget, 
        bLockedOnTarget;

    // Pos:0x00D
    if(bNetOwner
        LockLastPaintHitLocation, LockLastPaintLocation;
}

// Export USkyWeaponBase::execGetWeaponAttachment(FFrame&, void* const)
native function SkyWeaponAttachment GetWeaponAttachment();

// Export USkyWeaponBase::execCreateLoopingAudio(FFrame&, void* const)
native simulated function CreateLoopingAudio();

// Export USkyWeaponBase::execGetCurrentChargeUpPercent(FFrame&, void* const)
native function float GetCurrentChargeUpPercent();

// Export USkyWeaponBase::execIsAuxiliary(FFrame&, void* const)
native function bool IsAuxiliary();

// Export USkyWeaponBase::execChangeOverheatState(FFrame&, void* const)
native function ChangeOverheatState(SkyWeaponBase.EOverheatState NewState);

// Export USkyWeaponBase::execIsOverheated(FFrame&, void* const)
native function bool IsOverheated();

simulated event StartFireEvent(byte FireModeNum)
{
    StartFire(FireModeNum);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    CalcInventoryWeight();
    CreateLoopingAudio();
    //return;    
}

simulated function CreateOverlayMesh()
{
    local editinline SkeletalMeshComponent SKM_Source, SKM_Target;
    local editinline StaticMeshComponent STM;

    // End:0x24D
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
    {
        OverlayMesh = new (Outer) Mesh.Class;
        // End:0x24D
        if(OverlayMesh != none)
        {
            OverlayMesh.SetScale(1.0000000);
            OverlayMesh.SetOwnerNoSee(Mesh.bOwnerNoSee);
            OverlayMesh.SetDepthPriorityGroup(2);
            OverlayMesh.CastShadow = false;
            // End:0x178
            if(SkeletalMeshComponent(OverlayMesh) != none)
            {
                SKM_Target = SkeletalMeshComponent(OverlayMesh);
                SKM_Source = SkeletalMeshComponent(Mesh);
                SKM_Target.SetSkeletalMesh(SKM_Source.SkeletalMesh);
                SKM_Target.AnimSets = SKM_Source.AnimSets;
                SKM_Target.SetAnimTreeTemplate(SKM_Source.AnimTreeTemplate);
                SKM_Target.SetParentAnimComponent(SKM_Source);
                SKM_Target.bUpdateSkelWhenNotRendered = false;
                SKM_Target.bIgnoreControllersWhenNotRendered = true;                
            }
            else
            {
                // End:0x22A
                if(StaticMeshComponent(OverlayMesh) != none)
                {
                    STM = StaticMeshComponent(OverlayMesh);
                    STM.SetStaticMesh(StaticMeshComponent(Mesh).StaticMesh);
                    STM.SetScale3D(Mesh.Scale3D);
                    STM.SetTranslation(Mesh.Translation);
                    STM.SetRotation(Mesh.Rotation);
                }
            }
            OverlayMesh.SetHidden(Mesh.HiddenGame);            
        }
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2E
    if((VarName == 'AmmoCount') && !HasAnyAmmo())
    {
        WeaponEmpty();
    }
    super(Actor).ReplicatedEvent(VarName);
    //return;    
}

simulated function CalcInventoryWeight()
{
    local int I;

    InventoryWeight = float((int(InventoryGroup) + int(1)) * 1000) + (GroupWeight * float(100));
    I = 0;
    J0x30:

    // End:0x6C [Loop If]
    if(I < Len(ItemName))
    {
        InventoryWeight += (float(Asc(Mid(ItemName, I, 1))) / float(1000));
        I++;
        // [Loop Continue]
        goto J0x30;
    }
    // End:0x84
    if(Priority < float(0))
    {
        Priority = InventoryWeight;
    }
    //return;    
}

simulated function SetSkin(Material NewMaterial)
{
    local int I, Cnt;

    // End:0x10F
    if(NewMaterial == none)
    {
        // End:0x99
        if((default.Mesh != none) && default.Mesh.Materials.Length > 0)
        {
            Cnt = default.Mesh.Materials.Length;
            I = 0;
            J0x4B:

            // End:0x96 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, default.Mesh.GetMaterial(I));
                I++;
                // [Loop Continue]
                goto J0x4B;
            }            
        }
        else
        {
            // End:0x10C
            if((Mesh != none) && Mesh.Materials.Length > 0)
            {
                Cnt = Mesh.Materials.Length;
                I = 0;
                J0xD9:

                // End:0x10C [Loop If]
                if(I < Cnt)
                {
                    Mesh.SetMaterial(I, none);
                    I++;
                    // [Loop Continue]
                    goto J0xD9;
                }
            }
        }        
    }
    else
    {
        // End:0x1E8
        if(((default.Mesh != none) && default.Mesh.Materials.Length > 0) || (Mesh != none) && Mesh.GetNumElements() > 0)
        {
            Cnt = (((default.Mesh != none) && default.Mesh.Materials.Length > 0) ? default.Mesh.Materials.Length : Mesh.GetNumElements());
            I = 0;
            J0x1B1:

            // End:0x1E8 [Loop If]
            if(I < Cnt)
            {
                Mesh.SetMaterial(I, NewMaterial);
                I++;
                // [Loop Continue]
                goto J0x1B1;
            }
        }
    }
    //return;    
}

// Export USkyWeaponBase::execDrawWeaponCrosshair(FFrame&, void* const)
native function DrawWeaponCrosshair(HUD HUD);

simulated function int GetAmmoCount()
{
    return AmmoCount;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local SkyWeaponAttachment SWA;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    SWA = GetWeaponAttachment();
    // End:0x1C3
    if(SkyPawn(Instigator) != none)
    {
        // End:0xDA
        if(HUD.ShouldDisplayDebug('Anim') || HUD.ShouldDisplayDebug('AnimTree'))
        {
            // End:0xDA
            if((SWA != none) && SkeletalMeshComponent(SWA.Mesh) != none)
            {
                SkyPawn(Instigator).ShowAnimDebug(SkeletalMeshComponent(SWA.Mesh), HUD.Canvas);
            }
        }
        // End:0x15D
        if(HUD.ShouldDisplayDebug('Transition'))
        {
            // End:0x15D
            if((SWA != none) && SkeletalMeshComponent(SWA.Mesh) != none)
            {
                SkyPawn(Instigator).ShowTransitionDebug(SkeletalMeshComponent(SWA.Mesh), HUD.Canvas);
            }
        }
        HUD.Canvas.DrawText((("Eyeheight " $ string(Instigator.EyeHeight)) $ " base ") $ string(Instigator.BaseEyeHeight), false);
        out_YPos += out_YL;
    }
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    HUD.Canvas.DrawText((((("Zoom State:" @ string(GetZoomedState())) @ "ZoomedRate:") @ string(ZoomedRate)) @ "Target FOV:") @ string(ZoomedTargetFOV));
    out_YPos += out_YL;
    // End:0x2F5
    if(bCanOverheat)
    {
        HUD.Canvas.SetPos(HUD.Canvas.CurX, out_YPos);
        HUD.Canvas.DrawText(((("OverheatState: " $ string(OverheatState)) $ " (") $ string(OverheatPercent)) $ ")");
        out_YPos += out_YL;
    }
    //return;    
}

simulated function GetWeaponDebug(out array<string> DebugInfo)
{
    super.GetWeaponDebug(DebugInfo);
    // End:0xA4
    if(int(WeaponLockType) != int(0))
    {
        DebugInfo[DebugInfo.Length] = ((("Locked: " @ string(bLockedOnTarget)) @ string(LockedTarget)) @ string(LastLockedOnTime)) @ string(WorldInfo.TimeSeconds - LastLockedOnTime);
        DebugInfo[DebugInfo.Length] = (("Pending:" @ string(PendingLockedTarget)) @ string(PendingLockedTargetTime)) @ string(WorldInfo.TimeSeconds);
    }
    //return;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    return FireInterval[int(FireModeNum)];
    //return ReturnValue;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    //return;    
}

// Export USkyWeaponBase::execStopFireEffects(FFrame&, void* const)
native simulated function StopFireEffects(byte FireModeNum);

// Export USkyWeaponBase::execPlayFiringSound(FFrame&, void* const)
native simulated function PlayFiringSound();

// Export USkyWeaponBase::execMuzzleFlashTimer(FFrame&, void* const)
native simulated function MuzzleFlashTimer();

// Export USkyWeaponBase::execStopMuzzleFlash(FFrame&, void* const)
native simulated function StopMuzzleFlash();

simulated event CauseMuzzleFlash()
{
    // End:0xA8
    if(MuzzleFlashPSC != none)
    {
        // End:0xA8
        if(!bMuzzleFlashPSCLoops || MuzzleFlashPSC.bWasDeactivated)
        {
            // End:0x77
            if(((Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
            {
                MuzzleFlashPSC.SetTemplate(MuzzleFlashAltPSCTemplate);                
            }
            else
            {
                // End:0x97
                if(MuzzleFlashPSCTemplate != none)
                {
                    MuzzleFlashPSC.SetTemplate(MuzzleFlashPSCTemplate);
                }
            }
            MuzzleFlashPSC.ActivateSystem();
        }
    }
    // End:0xC4
    if(MuzzleFlashMesh != none)
    {
        MuzzleFlashMesh.SetHidden(false);
    }
    SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    //return;    
}

simulated event CauseRumble(ForceFeedbackWaveform Rumble)
{
    // End:0x97
    if((((Instigator != none) && Instigator.Controller != none) && PlayerController(Instigator.Controller) != none) && Rumble != none)
    {
        PlayerController(Instigator.Controller).ClientStopForceFeedbackWaveform(Rumble);
        PlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(Rumble);
    }
    //return;    
}

simulated function StopRumble(ForceFeedbackWaveform Rumble)
{
    // End:0x6F
    if((((Instigator != none) && Instigator.Controller != none) && PlayerController(Instigator.Controller) != none) && Rumble != none)
    {
        PlayerController(Instigator.Controller).ClientStopForceFeedbackWaveform(Rumble);
    }
    //return;    
}

simulated event CauseViewShake()
{
    // End:0x66
    if(((Instigator != none) && Instigator.Controller != none) && SkyPlayerController(Instigator.Controller) != none)
    {
        SkyPlayerController(Instigator.Controller).ShakeView(WeaponViewShake);
    }
    //return;    
}

simulated function PlayWeaponPutDown()
{
    // End:0x29
    if(WeaponPutDownAnim != 'None')
    {
        PlayWeaponAnimation(WeaponPutDownAnim, PutDownTime);
    }
    // End:0x44
    if(WeaponPutDownSnd != none)
    {
        WeaponPlaySound(WeaponPutDownSnd);
    }
    //return;    
}

simulated function TimeWeaponEquipping()
{
    AttachWeaponTo(Instigator.Mesh);
    SetTimer(GetEquipTime(), false, 'WeaponEquipped');
    //return;    
}

simulated function float GetEquipTime()
{
    return ((EquipTime > float(0)) ? EquipTime : 0.0100000);
    //return ReturnValue;    
}

simulated function PlayWeaponEquip()
{
    // End:0x29
    if(WeaponEquipAnim != 'None')
    {
        PlayWeaponAnimation(WeaponEquipAnim, EquipTime);
    }
    // End:0x44
    if(WeaponEquipSnd != none)
    {
        WeaponPlaySound(WeaponEquipSnd);
    }
    //return;    
}

simulated function ChangeVisibility(bool bIsVisible)
{
    // End:0x23
    if(Mesh != none)
    {
        Mesh.SetHidden(!bIsVisible);
    }
    // End:0x46
    if(OverlayMesh != none)
    {
        OverlayMesh.SetHidden(!bIsVisible);
    }
    //return;    
}

simulated function float GetWeaponRating()
{
    // End:0x46
    if(((Instigator == none) || SkyBotControllerBase(Instigator.Controller) == none) || !HasAnyAmmo())
    {
        CurrentRating = Priority;        
    }
    else
    {
        CurrentRating = SkyBotControllerBase(Instigator.Controller).RateWeapon(self);
    }
    return CurrentRating;
    //return ReturnValue;    
}

function bool CanAttack(Actor Other)
{
    local float Dist, CheckDist;
    local class<Projectile> ProjClass;

    // End:0x24
    if((Instigator == none) || Instigator.Controller == none)
    {
        return false;
    }
    // End:0x32
    if(bDisabled == true)
    {
        return false;
    }
    Dist = VSize(Instigator.Location - Other.Location);
    // End:0x70
    if(Dist > (MaxRange()))
    {
        return false;
    }
    // End:0x114
    if(!bInstantHit)
    {
        ProjClass = GetProjectileClass();
        // End:0xA1
        if(ProjClass == none)
        {
            ProjClass = WeaponProjectiles;
        }
        // End:0xBA
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
    return true;
    //return ReturnValue;    
}

function bool FireOnRelease()
{
    return int(ShouldFireOnRelease[int(CurrentFireMode)]) != int(0);
    //return ReturnValue;    
}

function byte BestMode()
{
    local byte Best;

    // End:0x13
    if(IsFiring())
    {
        return CurrentFireMode;
    }
    // End:0x27
    if(FRand() < 0.5000000)
    {
        Best = 1;
    }
    // End:0x59
    if((int(Best) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(Best)]) != int(0))
    {
        return 0;        
    }
    else
    {
        return Best;
    }
    //return ReturnValue;    
}

function bool ReadyToFire(bool bFinished)
{
    return false;
    //return ReturnValue;    
}

// Export USkyWeaponBase::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

// Export USkyWeaponBase::execAddAmmo(FFrame&, void* const)
native function int AddAmmo(int Amount, optional bool bAddToStorageOnly);

simulated function FillToInitialAmmo()
{
    AmmoCount = Max(AmmoCount, default.AmmoCount);
    //return;    
}

simulated function bool AmmoMaxed(int Mode)
{
    return AmmoCount >= MaxAmmoCount;
    //return ReturnValue;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    // End:0x1C
    if(Amount == 0)
    {
        return AmmoCount >= ShotCost;        
    }
    else
    {
        return AmmoCount >= Amount;
    }
    //return ReturnValue;    
}

// Export USkyWeaponBase::execHasAnyAmmo(FFrame&, void* const)
native simulated event bool HasAnyAmmo();

simulated function Loaded(optional bool bUseWeaponMax)
{
    // End:0x18
    if(bUseWeaponMax)
    {
        AmmoCount = MaxAmmoCount;        
    }
    else
    {
        AmmoCount = 999;
    }
    //return;    
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local DroppedPickup DP;

    // End:0xF7
    if(ItemClass == Class)
    {
        DP = DroppedPickup(Pickup);
        // End:0x99
        if(DP != none)
        {
            // End:0x45
            if(DP.Instigator == Instigator)
            {
                return true;
            }
            AddAmmo(SkyWeaponBase(DP.Inventory).AmmoCount);
            DP.PickedUpBy(Instigator);
            AnnouncePickup(Instigator);            
        }
        else
        {
            // End:0xF5
            if(!SkyGame(WorldInfo.Game).bWeaponStay)
            {
                AddAmmo(default.AmmoCount);
                Pickup.PickedUpBy(Instigator);
                AnnouncePickup(Instigator);
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event WeaponEmpty()
{
    // End:0x0F
    if(bDebugWeapon)
    {
        ScriptTrace();
    }
    // End:0x2F
    if(IsFiring())
    {
        SetTimer(0.0100000, false, 'WeaponEmptyHelper');
    }
    // End:0x6E
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        Instigator.InvManager.SwitchToBestWeapon(true);
    }
    //return;    
}

function WeaponEmptyHelper()
{
    GotoState('Active');
    //return;    
}

simulated function bool bReadyToFire()
{
    return true;
    //return ReturnValue;    
}

// Export USkyWeaponBase::execInstantFireStartTrace(FFrame&, void* const)
native simulated function Vector InstantFireStartTrace();

// Export USkyWeaponBase::execInstantFireEndTrace(FFrame&, void* const)
native simulated function Vector InstantFireEndTrace(Vector StartTrace);

simulated event Vector BeamFireStartTrace(out Vector VisualStartLocation)
{
    VisualStartLocation = FindEmitterSocketLoc(BeamEffect.Socket);
    return Instigator.GetWeaponStartTraceLocation();
    //return ReturnValue;    
}

simulated event Vector BeamFireEndTrace(Vector StartTrace, Vector VisualStartLocation)
{
    local Vector DamageDir, VisualEnd;
    local float FinalLength;

    DamageDir = Vector(GetAdjustedAim(StartTrace));
    VisualEnd = DamageDir * (DamageDir Dot (VisualStartLocation - StartTrace));
    FinalLength = FMax(BeamCurrLength, VSize(VisualEnd));
    return StartTrace + (DamageDir * FinalLength);
    //return ReturnValue;    
}

// Export USkyWeaponBase::execInstantFire(FFrame&, void* const)
native simulated function InstantFire();

// Export USkyWeaponBase::execCustomFire(FFrame&, void* const)
native simulated function CustomFire();

// Export USkyWeaponBase::execGetBeamImpacts(FFrame&, void* const)
native function ImpactInfo GetBeamImpacts(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList);

// Export USkyWeaponBase::execUpdateBeamEmitter(FFrame&, void* const)
native function UpdateBeamEmitter(Vector StartLoc, Vector EndLoc);

// Export USkyWeaponBase::execHideBeamEmitter(FFrame&, void* const)
native function HideBeamEmitter();

// Export USkyWeaponBase::execProcessInstantHit(FFrame&, void* const)
native simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact);

// Export USkyWeaponBase::execUpdateFiredStats(FFrame&, void* const)
native function UpdateFiredStats(int NoShots);

// Export USkyWeaponBase::execUpdateHitStats(FFrame&, void* const)
native function UpdateHitStats(bool bDirectHit);

// Export USkyWeaponBase::execGetZoomedState(FFrame&, void* const)
native function SkyWeaponBase.ESkyZoomState GetZoomedState();

simulated function bool CheckZoom(byte FireModeNum)
{
    local SkyPlayerController PC;

    PC = SkyPlayerController(Instigator.Controller);
    // End:0xFE
    if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
    {
        // End:0xB6
        if(int(GetZoomedState()) == int(3))
        {
            PC.EndZoom();
            ZoomEnded();
            EndFire(FireModeNum);
            return true;            
        }
        else
        {
            // End:0xFE
            if(int(GetZoomedState()) == int(0))
            {
                PC.StartZoom(ZoomedTargetFOV, ZoomedRate);
                ZoomStarted();
                ZoomedFireModeNum = FireModeNum;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event ZoomStarted()
{
    PlaySound(ZoomInSound, true);
    //return;    
}

simulated event ZoomEnded()
{
    PlaySound(ZoomOutSound, true);
    //return;    
}

reliable client simulated function ClientEndFire(byte FireModeNum)
{
    // End:0x30
    if(int(Role) != int(ROLE_Authority))
    {
        ClearPendingFire(int(FireModeNum));
        EndFire(FireModeNum);
    }
    //return;    
}

simulated function BeginFire(byte FireModeNum)
{
    ActiveFireMode = int(FireModeNum);
    // End:0xCD
    if((((UseLoopingFireSound()) && GetStateName() != 'WeaponFiring') && HasAnyAmmo()) && !bChargeUpDelaysLoopingSound)
    {
        // End:0x8F
        if((LoopingWeaponFire.Length == 1) && LoopingWeaponFire[0].Component != none)
        {
            LoopingWeaponFire[0].Component.Play();            
        }
        else
        {
            LoopingWeaponFire[int(CurrentFireMode)].Component.Play();
        }
        Owner.MakeNoise(1.0000000, 'WeaponFire');
    }
    SetPendingFire(int(FireModeNum));
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    local SkyPlayerController PC;
    local SkyWeaponAttachment SWA;

    // End:0x9D
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        PC = SkyPlayerController(Instigator.Controller);
        // End:0x9D
        if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
        {
            PC.ClientStopZoom();
        }
    }
    SWA = GetWeaponAttachment();
    // End:0xCC
    if(SWA != none)
    {
        SWA.StopMuzzleFlash();
    }
    super.EndFire(FireModeNum);
    //return;    
}

simulated event StopLoopingFireAudio()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x84 [Loop If]
    if(I < LoopingWeaponFire.Length)
    {
        // End:0x7A
        if((LoopingWeaponFire[I].Component != none) && LoopingWeaponFire[I].Component.bWasPlaying)
        {
            LoopingWeaponFire[I].Component.Stop();
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function SendToFiringState(byte FireModeNum)
{
    // End:0x0F
    if(bDebugWeapon)
    {
        ScriptTrace();
    }
    // End:0x5B
    if((Instigator.IsLocallyControlled() && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
    {
        // End:0x59
        if(bDebugWeapon)
        {
        }
        return;
    }
    super.SendToFiringState(FireModeNum);
    //return;    
}

reliable client simulated function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
    local PlayerController PC;

    // End:0x0A
    if(bDebugWeapon)
    {
    }
    // End:0x75
    if(Instigator != none)
    {
        PC = PlayerController(Instigator.Controller);
        // End:0x75
        if((PC != none) && LocalPlayer(PC.Player) != none)
        {
            PC.FOVAngle = PC.DefaultFOV;
        }
    }
    super.ClientWeaponSet(bOptionalSet);
    //return;    
}

// Export USkyWeaponBase::execFireAmmunition(FFrame&, void* const)
native simulated function FireAmmunition();

event BeamEndFire()
{
    local SkyPawn SP;

    SP = SkyPawn(Owner);
    ClearFlashCount();
    ClearFlashLocation();
    // End:0x45
    if(SP != none)
    {
        SP.WeaponStoppedFiring(false, self);
    }
    ClearTimer('RefireCheckTimer');
    bIsFiring = false;
    //return;    
}

simulated function bool TryPutDown()
{
    local float MinTimerTarget, TimerCount;

    bWeaponPutDown = true;
    MinTimerTarget = GetTimerRate('RefireCheckTimer') * MinReloadPct[int(CurrentFireMode)];
    TimerCount = GetTimerCount('RefireCheckTimer');
    // End:0x52
    if(bDebugWeapon)
    {
        ScriptTrace();
    }
    // End:0x70
    if(TimerCount > MinTimerTarget)
    {
        PutDownWeapon();
        return true;        
    }
    else
    {
        SetTimer(TimerCount + (MinTimerTarget - TimerCount), false, 'RefireCheckTimer');
        return true;
    }
    return false;
    //return ReturnValue;    
}

// Export USkyWeaponBase::execGetEffectLocation(FFrame&, void* const)
native simulated function Vector GetEffectLocation();

function GivenTo(Pawn NewOwner, optional bool bDoNotActivate)
{
    local SkyGame GI;
    local int I;
    local SkyPawn Spawn;

    super(Inventory).GivenTo(NewOwner, bDoNotActivate);
    // End:0x1B
    if(bDebugWeapon)
    {
    }
    GI = SkyGame(WorldInfo.Game);
    // End:0x93
    if((GI != none) && GI.GameStats != none)
    {
        GI.GameStats.PickupWeaponEvent(Class, NewOwner.PlayerReplicationInfo, OwnerStatsID, WeaponStatsID);
    }
    CreateLoopingAudio();
    I = 0;
    J0xA4:

    // End:0xFF [Loop If]
    if(I < LoopingWeaponFire.Length)
    {
        // End:0xF5
        if(LoopingWeaponFire[I].Component != none)
        {
            AttachLoopingWeaponSound(NewOwner, LoopingWeaponFire[I].Component);
        }
        ++I;
        // [Loop Continue]
        goto J0xA4;
    }
    I = 0;
    J0x106:

    // End:0x177 [Loop If]
    if(I < ChargeUpParams.Length)
    {
        // End:0x16D
        if(ChargeUpParams[I].ChargeUpSound.Component != none)
        {
            AttachLoopingWeaponSound(NewOwner, ChargeUpParams[I].ChargeUpSound.Component);
        }
        ++I;
        // [Loop Continue]
        goto J0x106;
    }
    AttachLoopingWeaponSound(NewOwner, OverheatSound.Component);
    Spawn = SkyPawn(NewOwner);
    // End:0x1D5
    if(Spawn != none)
    {
        Spawn.GroundSpeed = Spawn.GetPawnGroundSpeed();
    }
    //return;    
}

function AttachLoopingWeaponSound(Pawn NewOwner, AudioComponent LoopComponent)
{
    NewOwner.AttachComponent(LoopComponent);
    //return;    
}

// Export USkyWeaponBase::execAdjustLockTarget(FFrame&, void* const)
native function AdjustLockTarget(Actor NewLockTarget);

// Export USkyWeaponBase::execCanLockOnTo(FFrame&, void* const)
native function bool CanLockOnTo(Actor TA);

simulated event Destroyed()
{
    AdjustLockTarget(none);
    super.Destroyed();
    //return;    
}

simulated function ThrottleLook(out float aTurn, out float aLookUp)
{
    //return;    
}

// Export USkyWeaponBase::execWeaponAdjustDamage(FFrame&, void* const)
native function WeaponAdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

simulated function string GetOwnerName()
{
    return ((Instigator == none) ? "None" : Instigator.PlayerReplicationInfo.PlayerName);
    //return ReturnValue;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local SkyPawn Spawn;

    Spawn = SkyPawn(Owner);
    // End:0x3F
    if(Spawn != none)
    {
        Spawn.GroundSpeed = Spawn.GetPawnGroundSpeed();
    }
    super.DropFrom(StartLocation, StartVelocity);
    //return;    
}

reliable client simulated function ClientWeaponThrown()
{
    // End:0x4A
    if((Instigator != none) && SkyPlayerController(Instigator.Controller) != none)
    {
        SkyPlayerController(Instigator.Controller).EndZoom();
    }
    super.ClientWeaponThrown();
    //return;    
}

simulated function bool ShouldRefire()
{
    return ((StillFiring(byte(ActiveFireMode))) && !ChargeFireWhenReleased()) && !IsOverheated();
    //return ReturnValue;    
}

// Export USkyWeaponBase::execUseLoopingFireSound(FFrame&, void* const)
native simulated function bool UseLoopingFireSound();

// Export USkyWeaponBase::execPlayDelayedImpact(FFrame&, void* const)
native simulated function PlayDelayedImpact();

simulated function StopLoopingChargeUpAudio()
{
    // End:0x1F
    if((CurrChargeUpStage < 0) || CurrChargeUpStage >= ChargeUpParams.Length)
    {
        return;
    }
    // End:0xA3
    if((ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component != none) && ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component.bWasPlaying)
    {
        ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component.Stop();
    }
    //return;    
}

simulated event DisableWeaponFromNative()
{
    DisableWeapon();
    //return;    
}

simulated function DisableWeapon()
{
    local SkyWeaponAttachment SWA;
    local int I;

    StopLoopingChargeUpAudio();
    // End:0xFE
    if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
    {
        SWA = GetWeaponAttachment();
        // End:0x59
        if(SWA != none)
        {
            SWA.StopAllEffects();            
        }
        else
        {
            I = 0;
            J0x60:

            // End:0xFE [Loop If]
            if(I < ChargeUpParams.Length)
            {
                // End:0xF4
                if(ChargeUpParams[I].Effect.Emitter != none)
                {
                    ChargeUpParams[I].Effect.Emitter.Reset();
                    ChargeUpParams[I].Effect.Emitter.SetBase(none);
                }
                ++I;
                // [Loop Continue]
                goto J0x60;
            }
        }
    }
    //return;    
}

simulated event AddEmitter(out SEffectInfo EffectInfo, optional bool bAttach)
{
    local Vector SocketLoc;
    local editinline SkeletalMeshComponent AttachMesh;

    // End:0x1B0
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x1B0
        if(EffectInfo.Emitter == none)
        {
            // End:0x1B0
            if(EffectInfo.Template != none)
            {
                SocketLoc = FindEmitterSocketLoc(EffectInfo.Socket,, AttachMesh);
                EffectInfo.Emitter = Spawn(Class'SkyEmitter',,, SocketLoc);
                // End:0x1B0
                if(EffectInfo.Emitter != none)
                {
                    EffectInfo.Emitter.SetTemplate(EffectInfo.Template);
                    EffectInfo.Emitter.ParticleSystemComponent.SetHidden(false);
                    EffectInfo.Emitter.ParticleSystemComponent.SetActive(true);
                    // End:0x1B0
                    if(bAttach && AttachMesh != none)
                    {
                        EffectInfo.Emitter.SetBase(none);
                        EffectInfo.Emitter.SetHardAttach(true);
                        EffectInfo.Emitter.SetBase(AttachMesh.Owner,, AttachMesh, EffectInfo.Socket);
                    }
                }
            }
        }
    }
    //return;    
}

simulated event Vector FindEmitterSocketLoc(name SocketName, optional out Rotator outRot, optional out SkeletalMeshComponent AttachMesh)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local Vector Result;
    local bool bValidSocket;
    local SkyWeaponAttachment SWA;

    Result = vect(0.0000000, 0.0000000, 0.0000000);
    SWA = GetWeaponAttachment();
    // End:0x8F
    if(((SWA != none) && SkeletalMeshComponent(SWA.Mesh) != none) && SkeletalMeshComponent(SWA.Mesh).SkeletalMesh != none)
    {
        SkelMesh = SkeletalMeshComponent(SWA.Mesh);        
    }
    else
    {
        // End:0xCE
        if((SkeletalMeshComponent(Mesh) != none) && SkeletalMeshComponent(Mesh).SkeletalMesh != none)
        {
            SkelMesh = SkeletalMeshComponent(Mesh);            
        }
        else
        {
            // End:0xF8
            if(Pawn(Owner) != none)
            {
                SkelMesh = Pawn(Owner).Mesh;
            }
        }
    }
    // End:0x137
    if(SkelMesh != none)
    {
        // End:0x118
        if(SkelMesh.SkeletalMesh == none)
        {
        }
        bValidSocket = SkelMesh.GetSocketByName(SocketName) != none;
    }
    // End:0x16D
    if(bValidSocket)
    {
        SkelMesh.GetSocketWorldLocationAndRotation(SocketName, Result, outRot);
        AttachMesh = SkelMesh;        
    }
    else
    {
        // End:0x1CF
        if(SkyPawn(Owner).Mesh != none)
        {
            SkyPawn(Owner).Mesh.GetSocketWorldLocationAndRotation(SocketName, Result, outRot);
            AttachMesh = SkyPawn(Owner).Mesh;
        }
    }
    return Result;
    //return ReturnValue;    
}

// Export USkyWeaponBase::execIsChargingUp(FFrame&, void* const)
native function bool IsChargingUp();

// Export USkyWeaponBase::execIsCoolingDown(FFrame&, void* const)
native function bool IsCoolingDown();

function bool ChargeFireWhenReleased()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3D [Loop If]
    if(I < ChargeUpParams.Length)
    {
        // End:0x33
        if(ChargeUpParams[I].bHoldUntilReleased)
        {
            return true;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

simulated function StopEffect(ParticleSystemComponent PSC, bool Loops)
{
    // End:0x28
    if((PSC != none) && !Loops)
    {
        PSC.DeactivateSystem();
    }
    //return;    
}

function StartProlongedFiringTimer(float delay)
{
    StopProlongedFiringEffect();
    SetTimer(delay, false, 'SetShouldPlayProlongedFiringEffect');
    bShouldPlayProlongedFiringEffect = false;
    //return;    
}

function StartHeatingTimer(float delay)
{
    //return;    
}

function SetShouldPlayProlongedFiringEffect()
{
    bShouldPlayProlongedFiringEffect = true;
    //return;    
}

simulated function CauseProlongedFiringEffect()
{
    local int I;
    local SkyWeaponAttachment SWA;

    SWA = GetWeaponAttachment();
    // End:0x3B
    if(ProlongedFiringEffect.Length > 0)
    {
        ProlongedFiringPSC[ProlongedFiringEffect.Length - 1] = ProlongedFiringPSC[ProlongedFiringEffect.Length - 1];
    }
    I = 0;
    J0x42:

    // End:0x127 [Loop If]
    if(I < ProlongedFiringEffect.Length)
    {
        // End:0xB8
        if(SWA != none)
        {
            ProlongedFiringPSC[I] = SWA.CauseEffect(ProlongedFiringEffect[I].Socket, ProlongedFiringEffect[I].Template, ProlongedFiringPSC[I], false);
            // [Explicit Continue]
            goto J0x11D;
        }
        // End:0x11D
        if(SkyVWeap(self) != none)
        {
            ProlongedFiringPSC[I] = SkyVWeap(self).CauseEffect(ProlongedFiringEffect[I].Socket, ProlongedFiringEffect[I].Template, ProlongedFiringPSC[I], false);
        }
        J0x11D:

        I++;
        // [Loop Continue]
        goto J0x42;
    }
    //return;    
}

simulated event StopProlongedFiringEffect()
{
    local int I;
    local SkyWeaponAttachment SWA;

    SWA = GetWeaponAttachment();
    I = 0;
    J0x17:

    // End:0x75 [Loop If]
    if(I < ProlongedFiringPSC.Length)
    {
        // End:0x55
        if(SWA != none)
        {
            SWA.StopEffect(ProlongedFiringPSC[I], false);
            // [Explicit Continue]
            goto J0x6B;
        }
        StopEffect(ProlongedFiringPSC[I], false);
        J0x6B:

        I++;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

simulated event StopFire(byte FireModeNum)
{
    // End:0x13
    if(bShouldPlayProlongedFiringEffect)
    {
        CauseProlongedFiringEffect();
    }
    ClearTimer('SetShouldPlayProlongedFiringEffect');
    super.StopFire(FireModeNum);
    //return;    
}

event CauseOverheatedEffect()
{
    local int I;
    local SkyWeaponAttachment SWA;

    // End:0x2B
    if(OverheatedEffect.Length > 0)
    {
        OverheatedPSC[OverheatedEffect.Length - 1] = OverheatedPSC[OverheatedEffect.Length - 1];
    }
    SWA = GetWeaponAttachment();
    I = 0;
    J0x42:

    // End:0x127 [Loop If]
    if(I < OverheatedEffect.Length)
    {
        // End:0xB8
        if(SWA != none)
        {
            OverheatedPSC[I] = SWA.CauseEffect(OverheatedEffect[I].Socket, OverheatedEffect[I].Template, OverheatedPSC[I], false);
            // [Explicit Continue]
            goto J0x11D;
        }
        // End:0x11D
        if(SkyVWeap(self) != none)
        {
            OverheatedPSC[I] = SkyVWeap(self).CauseEffect(OverheatedEffect[I].Socket, OverheatedEffect[I].Template, OverheatedPSC[I], false);
        }
        J0x11D:

        I++;
        // [Loop Continue]
        goto J0x42;
    }
    //return;    
}

simulated function StopOverheatedEffects()
{
    local int I;
    local SkyWeaponAttachment SWA;

    SWA = GetWeaponAttachment();
    I = 0;
    J0x17:

    // End:0x75 [Loop If]
    if(I < OverheatedPSC.Length)
    {
        // End:0x55
        if(SWA != none)
        {
            SWA.StopEffect(OverheatedPSC[I], false);
            // [Explicit Continue]
            goto J0x6B;
        }
        StopEffect(OverheatedPSC[I], false);
        J0x6B:

        I++;
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

simulated function StopAllEffects()
{
    //return;    
}

// Export USkyWeaponBase::execClearRecoilData(FFrame&, void* const)
native function ClearRecoilData();

auto simulated state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        local PlayerController PC;

        // End:0x09
        if(bDebugWeapon)
        {
        }
        // End:0x74
        if(Instigator != none)
        {
            PC = PlayerController(Instigator.Controller);
            // End:0x74
            if((PC != none) && LocalPlayer(PC.Player) != none)
            {
                PC.FOVAngle = PC.DefaultFOV;
            }
        }
        super.BeginState(PreviousStateName);
        // End:0x9A
        if(int(Role) == int(ROLE_Authority))
        {
            AdjustLockTarget(none);
        }
        //return;        
    }

    simulated function bool bReadyToFire()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function EndState(name NextStateName)
    {
        local SkyPawn pSP;

        pSP = SkyPawn(Owner);
        StopAllEffects();
        // End:0x23
        if(bDebugWeapon)
        {
        }
        // End:0xB6
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            // End:0x8E
            if(ChargeUpParams[CurrChargeUpStage].CoolDownTime > float(0))
            {
                ChargeUpParams[CurrChargeUpStage].CoolDownTimer = ChargeUpParams[CurrChargeUpStage].CoolDownTime;                
            }
            else
            {
                // End:0xB6
                if(ChargeUpParams[CurrChargeUpStage].DurationTimer <= float(0))
                {
                    StopLoopingFireAudio();
                }
            }
        }
        // End:0x134
        if(int(WeaponFireTypes) == int(3))
        {
            // End:0xEB
            if(BeamShrinkTime == 0.0000000)
            {
                bBeamFiring = false;
                super.EndState(NextStateName);                
            }
            else
            {
                // End:0x11B
                if(BeamGrowTimer > float(0))
                {
                    BeamShrinkTimer = BeamShrinkTime * (1.0000000 - (BeamGrowTimer / BeamGrowTime));                    
                }
                else
                {
                    BeamShrinkTimer = BeamShrinkTime;
                }
            }
            BeamGrowTimer = 0.0000000;            
        }
        else
        {
            ClearFlashCount();
            ClearFlashLocation();
            // End:0x169
            if(pSP != none)
            {
                pSP.WeaponStoppedFiring(false, self);
            }
            ClearTimer('RefireCheckTimer');
            NotifyWeaponFinishedFiring(CurrentFireMode);
        }
        //return;        
    }

    simulated function BeginState(name PrevStateName)
    {
        local SkyWeaponBase Arch;

        Arch = SkyWeaponBase(ObjectArchetype);
        // End:0x30
        if(Arch != none)
        {
            ShotCost = Arch.ShotCost;
        }
        // End:0x39
        if(bDebugWeapon)
        {
        }
        // End:0x5E
        if(!HasAnyAmmo())
        {
            SetTimer(EmptyFiringRate, true, 'RefireCheckTimer');            
        }
        else
        {
            StartHeatingTimer(HeatingDelay);
            StartProlongedFiringTimer(ProlongedFiringDelay);
            // End:0x149
            if(int(WeaponFireTypes) == int(3))
            {
                bBeamFiring = true;
                AddEmitter(BeamEffect);
                AddEmitter(BeamEndEffect);
                // End:0xD1
                if(BeamGrowTime == 0.0000000)
                {
                    BeamCurrLength = BeamRangeMax;                    
                }
                else
                {
                    // End:0x101
                    if(BeamShrinkTimer > float(0))
                    {
                        BeamGrowTimer = BeamGrowTime * (1.0000000 - (BeamShrinkTimer / BeamShrinkTime));                        
                    }
                    else
                    {
                        BeamCurrLength = BeamRangeMin;
                        BeamGrowTimer = BeamGrowTime;
                    }
                }
                // End:0x12E
                if(BeamShrinkTimer <= 0.0000000)
                {
                    bBeamLastVisualEndLocNeedsInit = true;
                }
                BeamShrinkTimer = 0.0000000;
                ClearTimer('RefireCheckTimer');
            }
        }
        super.BeginState(PrevStateName);
        // End:0x174
        if(bEndFireImmediately)
        {
            bEndFireImmediately = false;
            EndFire(CurrentFireMode);
        }
        //return;        
    }

    simulated event ReplicatedEvent(name VarName)
    {
        // End:0x26
        if((VarName == 'AmmoCount') && !HasAnyAmmo())
        {
            return;
        }
        super(Actor).ReplicatedEvent(VarName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x14
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        global.BeginFire(FireModeNum);
        // End:0x44
        if(!HasAmmo(FireModeNum))
        {
            WeaponEmpty();
            return;
        }
        //return;        
    }

    simulated function bool DenyClientWeaponSet()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x4A
        if(Instigator.IsLocallyControlled() && SkyPawnBase(Instigator) != none)
        {
            SkyPawnBase(Instigator).WeaponChanged(self);
        }
        //return;        
    }

    simulated function bool TryPutDown()
    {
        SwitchAbortTime = (PutDownTime * GetTimerCount('WeaponEquipped')) / GetTimerRate('WeaponEquipped');
        GotoState('WeaponAbortEquip');
        return true;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x09
        if(bDebugWeapon)
        {
        }
        // End:0x5E
        if(((Mesh != none) && SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
        {
            Mesh.SetRotation(default.Mesh.Rotation);
        }
        ClearTimer('WeaponEquipped');
        //return;        
    }
    stop;    
}

simulated state WeaponAbortEquip
{
    simulated function BeginState(name PrevStateName)
    {
        local AnimNodeSequence AnimNode;
        local float Rate;

        // End:0x09
        if(bDebugWeapon)
        {
        }
        SetTimer(FMax(SwitchAbortTime, 0.0100000),, 'WeaponEquipAborted');
        // End:0xE8
        if(WeaponEquipAnim != 'None')
        {
            AnimNode = GetWeaponAnimNodeSeq();
            // End:0xE8
            if((AnimNode != none) && AnimNode.AnimSeq != none)
            {
                AnimNode.SetAnim(WeaponPutDownAnim);
                Rate = AnimNode.AnimSeq.SequenceLength / PutDownTime;
                AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
            }
        }
        //return;        
    }

    simulated function WeaponEquipAborted()
    {
        DetachWeapon();
        InvManager.ChangedWeapon();
        GotoState('Inactive');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x09
        if(bDebugWeapon)
        {
        }
        ClearTimer('WeaponEquipAborted');
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        local SkyPlayerController PC;

        // End:0x09
        if(bDebugWeapon)
        {
        }
        PC = SkyPlayerController(Instigator.Controller);
        // End:0x5E
        if((PC != none) && LocalPlayer(PC.Player) != none)
        {
            PC.EndZoom();
        }
        TimeWeaponPutDown();
        bWeaponPutDown = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x09
        if(bDebugWeapon)
        {
        }
        super.EndState(NextStateName);
        // End:0x69
        if(((Mesh != none) && SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
        {
            Mesh.SetRotation(default.Mesh.Rotation);
        }
        //return;        
    }

    simulated function Activate()
    {
        SwitchAbortTime = (EquipTime * GetTimerCount('WeaponIsDown')) / GetTimerRate('WeaponIsDown');
        GotoState('WeaponAbortPutDown');
        //return;        
    }

    simulated function bool bReadyToFire()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponAbortPutDown
{
    simulated function BeginState(name PrevStateName)
    {
        local AnimNodeSequence AnimNode;
        local float Rate;

        // End:0x09
        if(bDebugWeapon)
        {
        }
        SetTimer(FMax(SwitchAbortTime, 0.0100000),, 'WeaponPutDownAborted');
        // End:0xD1
        if(WeaponEquipAnim != 'None')
        {
            AnimNode = GetWeaponAnimNodeSeq();
            // End:0xD1
            if(AnimNode != none)
            {
                AnimNode.SetAnim(WeaponEquipAnim);
                Rate = AnimNode.AnimSeq.SequenceLength / EquipTime;
                AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
            }
        }
        //return;        
    }

    simulated function WeaponPutDownAborted()
    {
        GotoState('Active');
        //return;        
    }

    simulated function bool bReadyToFire()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x09
        if(bDebugWeapon)
        {
        }
        ClearTimer('WeaponPutDownAborted');
        super(Object).EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local bool bShouldCoolDown;

        ForceEndFire();
        // End:0x8B
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            bShouldCoolDown = ((PreviousStateName == 'WeaponCooling') && IsTimerActive('CoolCheckTimer')) || (ChargeUpParams[CurrChargeUpStage].CoolDownTime > float(0)) && PreviousStateName == 'WeaponFiring';            
        }
        else
        {
            bShouldCoolDown = false;
        }
        // End:0xBC
        if((HasAnyAmmo()) && bShouldCoolDown)
        {
            GotoState('WeaponCooling');            
        }
        else
        {
            // End:0xC5
            if(bDebugWeapon)
            {
            }
            super.BeginState(PreviousStateName);
            // End:0x123
            if((InvManager != none) && InvManager.LastAttemptedSwitchToWeapon != none)
            {
                InvManager.LastAttemptedSwitchToWeapon.ClientWeaponSet(true);
                InvManager.LastAttemptedSwitchToWeapon = none;
            }
            OnAnimEnd(none, 0.0000000, 0.0000000);
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x1B
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
            return;
        }
        // End:0x49
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            // End:0x49
            if(CheckZoom(FireModeNum))
            {
                return;
            }
        }
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated event OnAnimEnd(optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
    {
        local int IdleIndex;
        local AnimSet ASet;
        local editinline SkeletalMeshComponent SkelMesh;
        local AnimSequence AS;
        local float Length;
        local int I, J;

        // End:0x198
        if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && WeaponIdleAnims.Length > 0)
        {
            Length = 0.0000000;
            SkelMesh = SkeletalMeshComponent(Mesh);
            IdleIndex = Rand(WeaponIdleAnims.Length);
            // End:0x171
            if(SkelMesh != none)
            {
                I = 0;
                J0x66:

                // End:0x16E [Loop If]
                if(I < SkelMesh.AnimSets.Length)
                {
                    ASet = SkelMesh.AnimSets[I];
                    // End:0x144
                    if(ASet != none)
                    {
                        J = 0;
                        J0xAD:

                        // End:0x141 [Loop If]
                        if(J < ASet.Sequences.Length)
                        {
                            AS = ASet.Sequences[J];
                            // End:0x137
                            if((AS != none) && AS.SequenceName == WeaponIdleAnims[IdleIndex])
                            {
                                Length = AS.SequenceLength * AS.RateScale;
                                // [Explicit Break]
                                goto J0x141;
                            }
                            ++J;
                            // [Loop Continue]
                            goto J0xAD;
                        }
                        J0x141:
                        
                    }
                    else
                    {
                        Length = 1.0000000;
                        // [Explicit Break]
                        goto J0x16E;
                    }
                    // End:0x164
                    if(Length != 0.0000000)
                    {
                        // [Explicit Break]
                        goto J0x16E;
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x66;
                }
                J0x16E:
                
            }
            else
            {
                Length = 1.0000000;
            }
            PlayWeaponAnimation(WeaponIdleAnims[IdleIndex], Length);
        }
        //return;        
    }

    simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
    {
        super(Weapon).PlayWeaponAnimation(Sequence, fDesiredDuration, bLoop, SkelMesh);
        ClearTimer('OnAnimEnd');
        // End:0x4B
        if(!bLoop)
        {
            SetTimer(fDesiredDuration, false, 'OnAnimEnd');
        }
        //return;        
    }

    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x57
        if((Instigator != none) && Instigator.Weapon != self)
        {
            InvManager.ClientSyncWeapon(Instigator.Weapon);
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            super(Weapon).ServerStartFire(FireModeNum);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        // End:0x14
        if(bDebugWeapon)
        {
        }
        //return;        
    }
    stop;    
}

simulated state WeaponCharging
{
    simulated function BeginState(name PreviousStateName)
    {
        local bool bWasCharging, bWasCooling;
        local SEffectInfo EffectInfo;
        local SkyWeaponAttachment SWA;

        SWA = GetWeaponAttachment();
        // End:0x2F
        if(!HasAnyAmmo())
        {
            GotoState('WeaponFiring');
            return;
        }
        bWasCharging = PreviousStateName == 'WeaponCharging';
        bWasCooling = PreviousStateName == 'WeaponCooling';
        // End:0x77
        if(!bWasCharging)
        {
            bIsFiring = true;
            CurrChargeUpStage = 0;
        }
        // End:0x210
        if(((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length) && ChargeUpParams[CurrChargeUpStage].Duration > float(0))
        {
            ShotCost = ChargeUpParams[CurrChargeUpStage].AmmoCost;
            // End:0x108
            if(!bWasCooling)
            {
                ChargeUpParams[CurrChargeUpStage].DurationTimer = ChargeUpParams[CurrChargeUpStage].Duration;
            }
            // End:0x12A
            if(SWA != none)
            {
                SWA.CauseChargeUp();                
            }
            else
            {
                EffectInfo = ChargeUpParams[CurrChargeUpStage].Effect;
                EffectInfo.Emitter = none;
                AddEmitter(EffectInfo, true);
                ChargeUpParams[CurrChargeUpStage].Effect.Emitter = EffectInfo.Emitter;
            }
            // End:0x1ED
            if(ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component != none)
            {
                ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component.Play();
            }
            CauseRumble(ChargeUpParams[CurrChargeUpStage].Rumble);            
        }
        else
        {
            GotoState('WeaponFiring');
        }
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        // End:0xFD
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            // End:0xFD
            if(ChargeUpParams[CurrChargeUpStage].DurationTimer == 0.0000000)
            {
                // End:0xFD
                if(!ChargeUpParams[CurrChargeUpStage].bHoldUntilReleased)
                {
                    // End:0x7D
                    if((CurrChargeUpStage + 1) == ChargeUpParams.Length)
                    {
                        GotoState('WeaponFiring');                        
                    }
                    else
                    {
                        // End:0xFD
                        if((CurrChargeUpStage + 1) < ChargeUpParams.Length)
                        {
                            // End:0xE3
                            if(ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component != none)
                            {
                                ChargeUpParams[CurrChargeUpStage].ChargeUpSound.Component.Stop();
                            }
                            ++CurrChargeUpStage;
                            BeginState('WeaponCharging');
                        }
                    }
                }
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local int I;
        local SkyWeaponAttachment SWA;

        SWA = GetWeaponAttachment();
        StopLoopingChargeUpAudio();
        I = 0;
        J0x21:

        // End:0x5B [Loop If]
        if(I < ChargeUpParams.Length)
        {
            StopRumble(ChargeUpParams[I].Rumble);
            ++I;
            // [Loop Continue]
            goto J0x21;
        }
        // End:0x13F
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            // End:0x9A
            if(SWA != none)
            {
                SWA.StopAllEffects();                
            }
            else
            {
                I = 0;
                J0xA1:

                // End:0x13F [Loop If]
                if(I < ChargeUpParams.Length)
                {
                    // End:0x135
                    if(ChargeUpParams[I].Effect.Emitter != none)
                    {
                        ChargeUpParams[I].Effect.Emitter.Reset();
                        ChargeUpParams[I].Effect.Emitter.SetBase(none);
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0xA1;
                }
            }
        }
        // End:0x15A
        if(NextStateName != 'WeaponFiring')
        {
            bIsFiring = false;
        }
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        local float ChargeUpPct;
        local bool bShouldFire;

        // End:0x109
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            bShouldFire = (ChargeUpParams[CurrChargeUpStage].DurationTimer == 0.0000000) && ChargeUpParams[CurrChargeUpStage].bHoldUntilReleased;
            ChargeUpPct = 1.0000000 - (ChargeUpParams[CurrChargeUpStage].DurationTimer / ChargeUpParams[CurrChargeUpStage].Duration);
            ChargeUpParams[CurrChargeUpStage].CoolDownTimer = ChargeUpParams[CurrChargeUpStage].CoolDownTime * ChargeUpPct;
            ChargeUpParams[CurrChargeUpStage].DurationTimer = 0.0000000;
            // End:0x109
            if(bShouldFire)
            {
                bEndFireImmediately = true;
                GotoState('WeaponFiring');
                return;
            }
        }
        super(SkyWeaponBase).EndFire(FireModeNum);
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state WeaponCooling
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x56
        if(!IsTimerActive('CoolCheckTimer'))
        {
            // End:0x56
            if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
            {
                SetTimer(ChargeUpParams[CurrChargeUpStage].CoolDownTime, false, 'CoolCheckTimer');
            }
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local float TimeRemaining, ChargeUpPct;

        // End:0x1B
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
            return;
        }
        super(SkyWeaponBase).BeginFire(FireModeNum);
        // End:0x10B
        if((CurrChargeUpStage >= 0) && CurrChargeUpStage < ChargeUpParams.Length)
        {
            // End:0x10B
            if(ChargeUpParams[int(FireModeNum)].Duration > 0.0000000)
            {
                TimeRemaining = GetTimerRate('CoolCheckTimer') - GetTimerCount('CoolCheckTimer');
                ChargeUpPct = 1.0000000 - (TimeRemaining / ChargeUpParams[CurrChargeUpStage].Duration);
                ChargeUpParams[CurrChargeUpStage].DurationTimer = ChargeUpParams[CurrChargeUpStage].Duration * ChargeUpPct;
                ClearTimer('CoolCheckTimer');
                GotoState('WeaponCharging');
                return;
            }
        }
        GotoState('WeaponFiring');
        //return;        
    }

    simulated function CoolCheckTimer()
    {
        ClearTimer('CoolCheckTimer');
        GotoState('Active');
        bIsFiring = false;
        //return;        
    }
    stop;    
}
