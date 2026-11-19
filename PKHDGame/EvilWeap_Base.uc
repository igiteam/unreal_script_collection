class EvilWeap_Base extends UDKWeapon
    abstract
    native(Weapon)
    config(Weapon)
    hidecategories(Navigation);

enum EZoomState
{
    ZST_NotZoomed,                  // 0
    ZST_ZoomingOut,                 // 1
    ZST_ZoomingIn,                  // 2
    ZST_Zoomed,                     // 3
    ZST_MAX                         // 4
};

enum EWWeaponHand
{
    EWH_Default,                    // 0
    EWH_Hidden,                     // 1
    EWH_Right,                      // 2
    EWH_Left,                       // 3
    EWH_MAX                         // 4
};

enum AmmoWidgetDisplayStyle
{
    EAWDS_Numeric,                  // 0
    EAWDS_BarGraph,                 // 1
    EAWDS_Both,                     // 2
    EAWDS_None,                     // 3
    EAWDS_MAX                       // 4
};

struct native TCrosshair
{
    var Texture2D UpTex;
    var TextureCoordinates UpCord;
    var Texture2D DownTex;
    var TextureCoordinates DownCord;
    var Texture2D LeftTex;
    var TextureCoordinates LeftCord;
    var Texture2D RightTex;
    var TextureCoordinates RightCord;
    var Texture2D DotTex;
    var TextureCoordinates DotCord;

    structdefaultproperties
    {
        UpTex=none
        UpCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
        DownTex=none
        DownCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
        LeftTex=none
        LeftCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
        RightTex=none
        RightCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
        DotTex=none
        DotCord=(U=0.0000000,V=0.0000000,UL=0.0000000,VL=0.0000000)
    }
};

struct native BlendTimes
{
    var float BlendIn;
    var float BlendOut;

    structdefaultproperties
    {
        BlendIn=0.0000000
        BlendOut=0.0000000
    }
};

var bool bExportMenuData;
var transient bool MoveSpreadState;
var transient bool SprintSpreadState;
var transient bool JumpSpreadState;
var transient bool IsAltInCooldown;
var() bool bSuppressPickupSwitch;
var() bool bSelectable;
var() config bool ShouldBeRestored;
var transient bool NeedReload;
var transient bool IsResumingReload;
var transient bool bSuppressAutoReload;
var transient bool bSuppressAutoActiveAfterQuickHide;
var bool bWasLocked;
var() config bool DisplayDotCrosshair;
var bool bDisplayCrosshair;
var transient bool IsFrozen;
var globalconfig bool bSmallWeapons;
var() config bool BlockSprint;
var() config bool bNonlinearZoomInterpolation;
var() config bool ControlDOFWhenOffhand;
var() config bool ZoomedCrosshair;
var bool bSuperWeapon;
var bool bNeverForwardPendingFire;
var bool bSuppressSounds;
var() config bool SupportAlternateReload;
var transient bool UseAlternateReloadNext;
var bool bDisableSetPosition;
var bool bPendingShow;
var() config bool BothHandWeapon;
var() config bool UsesOffhand;
var() config bool SeperateOffHandFiring;
var() config bool OffHandDoesNotFire;
var() config bool AlwaysBothHandReload;
var bool bDebugWeapon;
var bool bShowAltMuzzlePSCWhenWeaponHidden;
var bool bMuzzleFlashPSCLoops;
var bool bMuzzleFlashAttached;
var bool bSplashJump;
var bool bRecommendSplashDamage;
var bool bSniping;
var bool bFastRepeater;
var bool bLockedAimWhileFiring;
var bool bUsingAimingHelp;
var bool bAllowFiringWithoutController;
var() config bool bTargetFrictionEnabled;
var() config bool bTargetAdhesionEnabled;
var bool bHasSuppressor;
var bool bForceHidden;
var bool bHasLocationSpeech;
var class<EvilAmmoPickupFactory> AmmoPickupClass;
var int LockerAmmoCount;
var() config int MaxAmmoCount;
var() repnotify config int MagazineAmmoCount;
var() config int MagazineMaxAmmoCount;
var() config float WeaponHitRange;
var() config array<config float> WeaponDamage;
var() config array<config float> WeaponMomentum;
var() config float WeaponCloseDamageMaxMultiplier;
var() config float WeaponCloseDamageDistance;
var() config array<config int> NumberOfShots;
var() config array<config float> WeaponSpread;
var() config array<config float> WeaponSpreadMax;
var() config array<config float> WeaponFireInterval;
var() config array<config float> FireCameraAnimScale;
var() config float ShotSpreadModifier;
var() config float ShotSpreadBackSpeed;
var() config float MoveSpreadMultiplier;
var() config float SprintSpreadMultiplier;
var() config float JumpSpreadMultiplier;
var transient float ShotSpreadHelper;
var transient int CurrentShotCount;
var array<int> ShotCost;
var array<float> MinReloadPct;
var array<CameraAnim> FireCameraAnim;
var array<CameraAnim> FireCameraAnimAlt;
var ForceFeedbackWaveform WeaponFireWaveForm;
var array<name> EffectSockets;
var int IconX;
var int IconY;
var int IconWidth;
var int IconHeight;
var() config float BlockingAltTime;
var float SwitchAbortTime;
var const localized string AmmoPickupString;
var EvilTouchPickUp_WeaponBase PickupArchetype;
var() float ReloadTime;
var transient float ReloadResumeTime;
var() config float ReloadAsDonePerc;
var transient int PendingFireHelper;
var TextureCoordinates IconCoordinates;
var float CurrentLockedScale;
var float StartLockedScale;
var float FinalLockedScale;
var float LockedScaleTime;
var float LockedStartTime;
var float LastHitEnemyTime;
var config Color CrosshairColor;
var float CrosshairScaling;
var TCrosshair Crosshair;
var() config float CrosshairOffset;
var() config float CrosshairSpreadMultiplier;
var() config float CrosshairTotalInvisibilitySpread;
var float DroppedPickupOffsetZ;
var() config float MovementSpeedModifier;
var EvilWeaponUpgradeInfo UpgradeInfo;
var(Upgrade) int UpgradeLevelGlobal;
var(Upgrade) int BaseSpreadUpgradeLevel;
var(Upgrade) int ReloadSpeedUpgradeLevel;
var(Upgrade) int FireIntervalUpgradeLevel;
var transient array<Actor> ActorHitWithCurrentShot;
var array<byte> bZoomedFireMode;
var byte ZoomedFireModeNum;
var byte InventoryGroup;
var EvilWeap_Base.EWWeaponHand WeaponHand;
var EvilWeap_Base.AmmoWidgetDisplayStyle AmmoDisplayType;
var() config float ZoomedTargetFOV;
var() config float ZoomedRate;
var() config float ZoomingTranslationRate;
var() config float ZoomingRotationRate;
var() config float ZoomingScaleRate;
var() config float ZoomingFOVRate;
var() config Vector ZoomedMeshTranslation;
var() config Rotator ZoomedMeshRotation;
var() config float ZoomedMeshScale;
var() config float ZoomedMeshFOV;
var() config float ZoomedSpreadMult;
var() config float ZoomedRecoilMult;
var transient Vector DesiredMeshTranslation;
var transient Rotator DesiredMeshRotation;
var transient float DesiredMeshScale;
var transient float DesiredMeshFOV;
var float ZoomFadeTime;
var SoundCue ZoomInSound;
var SoundCue ZoomOutSound;
var() config float DOF_FocusDistance;
var() config float DOF_FocusInnerRadius;
var(Animations) array<name> ZoomedWeaponIdleAnims;
var(Animations) array<name> ZoomedWeaponFireAnim;
var(Animations) array<name> ZoomedArmIdleAnims;
var(Animations) array<name> ZoomedArmFireAnim;
var() config float ZoomedBobDamping;
var() config float ZoomedJumpDamping;
var() config float ZoomedLagBackSpeed;
var float MaxZoomPitchLag;
var float MaxZoomYawLag;
var() config float ZoomedMovementSpeedModifier;
var transient float OldMovementSpeedModifier;
var class<EvilAttachment_Weap_Base> AttachmentClass;
var Vector PivotTranslation;
var EvilInventoryManager EvilInvManager;
var float GroupWeight;
var float InventoryWeight;
var(Animations) array<name> WeaponFireAnim;
var(Animations) array<name> ArmFireAnim;
var(Animations) AnimSet ArmsAnimSet;
var(Animations) name WeaponPutDownAnim;
var(Animations) name ArmsPutDownAnim;
var(Animations) name WeaponEquipAnim;
var(Animations) name ArmsEquipAnim;
var transient float QuickHideAnimDuration;
var(Animations) array<name> WeaponIdleAnims;
var(Animations) array<name> ArmIdleAnims;
var(Animations) CameraAnim EquippingCameraAnim;
var(Animations) CameraAnim PuttingDownCameraAnim;
var transient AnimNodeSlot CustomAnimNode;
var transient AnimNodeSlot CustomArmAnimNode;
var(Animations) config BlendTimes EquipAnimBlendTimes;
var(Animations) config BlendTimes PutDownAnimBlendTimes;
var(Animations) config BlendTimes IdleAnimBlendTimes;
var(Animations) config BlendTimes FireAnimBlendTimes;
var(Animations) config BlendTimes ReloadAnimBlendTimes;
var(Animations) config BlendTimes SprintAnimBlendTimes;
var(Animations) config BlendTimes JumpAnimBlendTimes;
var(Animations) config BlendTimes KickAnimBlendTimes;
var(Animations) name WeaponReloadAnim;
var(Animations) name ArmReloadAnim;
var(Animations) CameraAnim ReloadCameraAnim;
var export editinline AudioComponent ReloadSoundComp;
var(Animations) name WeaponReloadResumeAnim;
var(Animations) name ArmReloadResumeAnim;
var(Animations) CameraAnim ReloadResumeCameraAnim;
var(Sounds) SoundCue ReloadResumeSound;
var(Animations) name WeaponReloadAlternateAnim;
var(Animations) name ArmReloadAlternateAnim;
var(Sounds) SoundCue WeaponOutOfAmmoSound;
var(Sounds) SoundCue WeaponLowAmmoSound;
var(Animations) name WeaponSprintAnim;
var(Animations) name ArmSprintAnim;
var() float SprintAnimOffHandOffset;
var() float KickTime;
var(Animations) name WeaponJumpStartAnim;
var(Animations) name ArmJumpStartAnim;
var(Animations) name WeaponJumpFlyAnim;
var(Animations) name ArmJumpFlyAnim;
var(Animations) name WeaponJumpLandAnim;
var(Animations) name ArmJumpLandAnim;
var(Animations) CameraAnim JumpStartCameraAnim;
var(Animations) CameraAnim JumpFlyCameraAnim;
var(Animations) CameraAnim JumpLandCameraAnim;
var(Sounds) array<SoundCue> WeaponFireSnd;
var(Sounds) array<SoundCue> WeaponFireSnd1p;
var(Sounds) SoundCue WeaponPutDownSnd;
var(Sounds) SoundCue WeaponQuickPutDownSnd;
var(Sounds) SoundCue WeaponEquipSnd;
var(Sounds) SoundCue WeaponQuickEquipSnd;
var() float WeaponSoundInterval;
var() float WeaponSoundTime;
var(Sounds) SoundCue WeaponCrouchSound;
var(Sounds) SoundCue WeaponCrouchEndSound;
var(Sounds) SoundCue WeaponJumpSound;
var(Sounds) SoundCue WeaponLandSound;
var(Sounds) SoundCue WeaponFootStepSound;
var() float BobDamping;
var() float JumpDamping;
var float MaxPitchLag;
var float MaxYawLag;
var float LastRotUpdate;
var Rotator LastRotation;
var transient float LastSetPos;
var transient float CurrLeanLocVal;
var Vector FinalMeshTrans;
var Rotator FinalMeshRot;
var float OldLeadMag[2];
var int OldRotDiff[2];
var float OldMaxDiff[2];
var float RotChgSpeed;
var float ReturnChgSpeed;
var() config float LagBackSpeed;
var() export editinline DynamicLightEnvironmentComponent LightEnvironment;
var() config Vector BackForceVector;
var() config Vector BackForceMax;
var transient Vector BackForce;
var() config Vector ShotDistortionVector;
var() config Vector ShotDistortionMax;
var transient Vector ShotDistortion;
var transient Vector CurrentShotDistortion;
var() config float RecoilDelta;
var() config float RecoilMax;
var transient float Recoil;
var() class<EvilWeap_Base> OffHandWeaponClass;
var() string WeaponName;
var Color WeaponColor;
var float WeaponCanvasXPct;
var float WeaponCanvasYPct;
var array<name> MuzzleFlashSocket;
var export editinline UTParticleSystemComponent MuzzleFlashPSC;
var ParticleSystem MuzzleFlashPSCTemplate;
var ParticleSystem MuzzleFlashAltPSCTemplate;
var Color MuzzleFlashColor;
var export editinline UDKExplosionLight MuzzleFlashLight;
var class<UDKExplosionLight> MuzzleFlashLightClass;
var EvilLightActor MuzzleFlashLightArchetype;
var EvilLightActor MuzzleFlashLightActor;
var() float MuzzleFlashDuration;
var(FirstPerson) config Vector PlayerViewOffset;
var(FirstPerson) config Rotator PlayerRotationOffset;
var(FirstPerson) Vector SmallWeaponsOffset;
var(FirstPerson) float WideScreenOffsetScaling;
var Rotator WidescreenRotationOffset;
var Vector HiddenWeaponsOffset;
var float ProjectileSpawnOffset;
var(Effects) array<ParticleSystem> AfterShotEffect;
var(Effects) array<name> AfterShotEffectSocket;
var export editinline array<export editinline UTParticleSystemComponent> AfterShotEffectComponent;
var ParticleSystem SmokeTracePS;
var(Effects) ParticleSystem ReloadEffect;
var(Effects) name ReloadEffectSocket;
var export editinline UTParticleSystemComponent ReloadEffectComponent;
var Rotator LockerRotation;
var Vector LockerOffset;
var float CurrentRating;
var float AimError;
var ObjectiveAnnouncementInfo NeedToPickUpAnnouncement;
var array<float> AimingHelpRadius;
var config float WeaponRangeMin;
var() config float ZoomedTurnSpeedScalePct;
var() config float TargetFrictionDistanceMin;
var() config float TargetFrictionDistancePeak;
var() config float TargetFrictionDistanceMax;
var() config InterpCurveFloat TargetFrictionDistanceCurve;
var() config Vector2D TargetFrictionMultiplierRange;
var() config float TargetFrictionPeakRadiusScale;
var() config float TargetFrictionPeakHeightScale;
var() config Vector TargetFrictionOffset;
var() config float TargetFrictionZoomedBoostValue;
var() config float TargetAdhesionTimeMax;
var() config float TargetAdhesionDistanceMax;
var() config float TargetAdhesionAimDistY;
var() config float TargetAdhesionAimDistZ;
var() config Vector2D TargetAdhesionScaleRange;
var() config float TargetAdhesionScaleAmountMin;
var() config float TargetAdhesionTargetVelocityMin;
var() config float TargetAdhesionPlayerVelocityMin;
var() config float TargetAdhesionZoomedBoostValue;
var array<SoundNodeWave> LocationSpeech;
var const localized string UseHintString;

replication
{
    // Pos:0x000
    if(bNetOwner)
        BaseSpreadUpgradeLevel, FireIntervalUpgradeLevel, 
        IsResumingReload, MagazineAmmoCount, 
        ReloadResumeTime, ReloadSpeedUpgradeLevel, 
        UpgradeLevelGlobal, bSuppressAutoReload;

    // Pos:0x00A
    if(((int(Role) == int(ROLE_Authority)) && bNetDirty) && bNetOwner)
        EvilInvManager;
}

simulated function PostBeginPlay()
{
    local UTGameReplicationInfo GRI;
    local int I;

    super.PostBeginPlay();
    CalcInventoryWeight();
    // End:0x62
    if(Mesh != none)
    {
        Mesh.CastShadow = Class'EvilPlayerController'.default.bFirstPersonWeaponsSelfShadow;
    }
    bConsiderProjectileAcceleration = bConsiderProjectileAcceleration && ((WeaponProjectiles[0] != none) && class<EvilProjectile_Base>(WeaponProjectiles[0]).default.AccelRate > float(0)) || (WeaponProjectiles[1] != none) && class<EvilProjectile_Base>(WeaponProjectiles[1]).default.AccelRate > float(0);
    bSmallWeapons = Class'EvilWeap_Base'.default.bSmallWeapons;
    WeaponRange = WeaponHitRange;
    I = 0;
    J0x14B:

    // End:0x198 [Loop If]
    if(I < WeaponDamage.Length)
    {
        InstantHitDamage[I] = WeaponDamage[I];
        I++;
        // [Loop Continue]
        goto J0x14B;
    }
    I = 0;
    J0x1A3:

    // End:0x1F0 [Loop If]
    if(I < WeaponMomentum.Length)
    {
        InstantHitMomentum[I] = WeaponMomentum[I];
        I++;
        // [Loop Continue]
        goto J0x1A3;
    }
    I = 0;
    J0x1FB:

    // End:0x248 [Loop If]
    if(I < WeaponSpread.Length)
    {
        Spread[I] = WeaponSpread[I];
        I++;
        // [Loop Continue]
        goto J0x1FB;
    }
    I = 0;
    J0x253:

    // End:0x2A0 [Loop If]
    if(I < WeaponFireInterval.Length)
    {
        FireInterval[I] = WeaponFireInterval[I];
        I++;
        // [Loop Continue]
        goto J0x253;
    }
    DesiredMeshScale = Mesh.default.Scale;
    GRI = UTGameReplicationInfo(WorldInfo.GRI);
    // End:0x336
    if((GRI != none) && GRI.bConsoleServer)
    {
        AdjustWeaponTimingForConsole();
    }
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

function CreateCheckpointRecord(out InventoryRecord Record)
{
    Record.InventoryClassPath = PathName(Class);
    Record.AmmoCount = AmmoCount;
    Record.MagazineAmmoCount = MagazineAmmoCount;
    Record.bIsActiveWeapon = Instigator.Weapon == self;
    Record.bIsActiveLeftWeapon = Instigator.WeaponLeft == self;
    //return;    
}

function ApplyCheckpointRecord(const out InventoryRecord Record)
{
    AmmoCount = Record.AmmoCount;
    MagazineAmmoCount = Record.MagazineAmmoCount;
    //return;    
}

simulated function AdjustWeaponTimingForConsole()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x5F [Loop If]
    if(I < FireInterval.Length)
    {
        FireInterval[I] = FireInterval[I] / 1.1000000;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    EquipTime = EquipTime / 1.1000000;
    PutDownTime = PutDownTime / 1.1000000;
    //return;    
}

simulated function CreateOverlayMesh()
{
    local editinline SkeletalMeshComponent SKM_Source, SKM_Target;
    local editinline StaticMeshComponent STM;
    local EvilPawn P;

    // End:0x4D8
    if(((OverlayMesh == none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Mesh != none)
    {
        // End:0xC7
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            P = EvilPawn(Instigator);
            // End:0xC7
            if((P == none) || !P.bUpdateEyeheight)
            {
                return;
            }
        }
        OverlayMesh = new (Outer) Mesh.Class;
        // End:0x4D8
        if(OverlayMesh != none)
        {
            OverlayMesh.SetScale(1.0000000);
            OverlayMesh.SetOwnerNoSee(Mesh.bOwnerNoSee);
            OverlayMesh.SetOnlyOwnerSee(true);
            OverlayMesh.SetDepthPriorityGroup(2);
            OverlayMesh.CastShadow = false;
            SKM_Target = SkeletalMeshComponent(OverlayMesh);
            // End:0x365
            if(SKM_Target != none)
            {
                SKM_Source = SkeletalMeshComponent(Mesh);
                SKM_Target.SetSkeletalMesh(SKM_Source.SkeletalMesh);
                SKM_Target.AnimSets = SKM_Source.AnimSets;
                SKM_Target.SetParentAnimComponent(SKM_Source);
                SKM_Target.bUpdateSkelWhenNotRendered = false;
                SKM_Target.bIgnoreControllersWhenNotRendered = true;
                // End:0x362
                if(UDKSkeletalMeshComponent(SKM_Target) != none)
                {
                    UDKSkeletalMeshComponent(SKM_Target).SetFOV(UDKSkeletalMeshComponent(SKM_Source).FOV);
                }                
            }
            else
            {
                // End:0x497
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
    // End:0x33
    if(VarName == 'AmmoCount')
    {
        // End:0x30
        if(!HasAnyAmmo())
        {
            WeaponEmpty();
        }        
    }
    else
    {
        // End:0x75
        if(VarName == 'HitEnemy')
        {
            LastHitEnemyTime = WorldInfo.TimeSeconds;            
        }
        else
        {
            super(Actor).ReplicatedEvent(VarName);
        }
    }
    //return;    
}

simulated function CalcInventoryWeight()
{
    InventoryWeight = float((int(InventoryGroup) + int(1)) * 1000) + (GroupWeight * float(100));
    // End:0x59
    if(Priority < float(0))
    {
        Priority = InventoryWeight;
    }
    //return;    
}

function GivenTo(Pawn thisPawn, optional bool bDoNotActivate)
{
    local EvilEngine Engine;

    super(Inventory).GivenTo(thisPawn, bDoNotActivate);
    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x8C
    if((Engine != none) && int(Engine.PendingCheckpointAction) == int(1))
    {
        return;
    }
    // End:0xE6
    if((!BothHandWeapon && !UsesOffhand) && OffHandWeaponClass != none)
    {
        thisPawn.CreateInventory(OffHandWeaponClass, true);
    }
    //return;    
}

simulated function bool ShouldSwitchTo(EvilWeap_Base InWeapon)
{
    // End:0x97
    if(((InWeapon == none) || !InWeapon.bSelectable) || (int(InWeapon.GetHand()) != int(GetHand())) && int(InWeapon.GetHand()) > int(1))
    {
        return false;
    }
    // End:0x12D
    if((IsFiring()) || DenyClientWeaponSet())
    {
        // End:0x100
        if(InWeapon.UsesOffhand)
        {
            EvilInvManager.RetrySwitchToLeft(InWeapon);            
        }
        else
        {
            EvilInvManager.RetrySwitchTo(InWeapon);
        }
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

simulated function SetSkin(Material NewMaterial)
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

simulated function float GetCurrentDistanceAndTarget(out Actor Target)
{
    local float VeryFar;
    local Vector HitLocation, HitNormal, projStart, TargetLoc, X, Y,
	    Z;

    local Rotator CameraRot;
    local PlayerController PC;

    VeryFar = 32768.0000000;
    PC = PlayerController(Instigator.Controller);
    PC.GetPlayerViewPoint(projStart, CameraRot);
    GetAxes(CameraRot, X, Y, Z);
    TargetLoc = projStart + (X * VeryFar);
    Target = GetTraceOwner().Trace(HitLocation, HitNormal, TargetLoc, projStart, true,,, 1);
    // End:0x124
    if(Target == none)
    {
        return VeryFar;
    }
    return (HitLocation - projStart) Dot X;
    //return ReturnValue;    
}

simulated function ActiveRenderOverlays(HUD H)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0x79
    if((PC != none) && !PC.bNoCrosshair)
    {
        DrawWeaponCrosshair(H);
    }
    //return;    
}

simulated function DrawWeaponCrosshair(HUD HUD)
{
    local Vector2D CrosshairSize;
    local float X, Y, PickupScale, ScreenX, ScreenY;

    local UTHUDBase H;
    local float TargetDist, CrosshairAlpha;
    local EvilPawn P;
    local EvilPlayerController PC;
    local Actor Target;

    P = EvilPawn(Owner);
    // End:0x2D
    if(P == none)
    {
        return;
    }
    PC = EvilPlayerController(P.Controller);
    // End:0x6F
    if(PC == none)
    {
        return;
    }
    H = UTHUDBase(HUD);
    // End:0xF7
    if(((H == none) || !bDisplayCrosshair) || PC.bCinematicMode && !PC.bFiringOnZipLine)
    {
        return;
    }
    TargetDist = GetCurrentDistanceAndTarget(Target);
    // End:0x25B
    if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.3000000))
    {
        // End:0x1FC
        if(H.LastPickupTime > (WorldInfo.TimeSeconds - 0.1500000))
        {
            PickupScale = 1.0000000 + (float(5) * (WorldInfo.TimeSeconds - H.LastPickupTime));            
        }
        else
        {
            PickupScale = 1.0000000 + (float(5) * ((H.LastPickupTime + 0.3000000) - WorldInfo.TimeSeconds));
        }        
    }
    else
    {
        PickupScale = 1.0000000;
    }
    X = H.Canvas.ClipX * 0.5000000;
    Y = H.Canvas.ClipY * 0.5000000;
    CrosshairColor = ((H.bGreenCrosshair) ? H.LightGreenColor : (((Pawn(Target) != none) && Pawn(Target).IsAliveAndWell()) ? ((WorldInfo.GRI.OnSameTeam(Target, P)) ? MakeColor(13, 195, 0) : H.RedColor) : default.CrosshairColor));
    CrosshairAlpha = FClamp(255.0000000 - ((PC.VisualSpread / CrosshairTotalInvisibilitySpread) * float(255)), 0.0000000, 255.0000000);
    // End:0xA8F
    if((Crosshair.DotTex != none) && DisplayDotCrosshair)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.DotCord.VL) * PickupScale) * Y) / float(720);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.DotCord.UL / Crosshair.DotCord.VL);
        ScreenX = X - (CrosshairSize.X * 0.5000000);
        ScreenY = Y - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(Crosshair.DotTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.DotCord.U, Crosshair.DotCord.V, Crosshair.DotCord.UL, Crosshair.DotCord.VL);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.DotTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.DotCord.U, Crosshair.DotCord.V, Crosshair.DotCord.UL, Crosshair.DotCord.VL);
    }
    // End:0x10F1
    if(Crosshair.UpTex != none)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.UpCord.VL) * PickupScale) * Y) / float(720);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.UpCord.UL / Crosshair.UpCord.VL);
        ScreenX = X - (CrosshairSize.X * 0.5000000);
        ScreenY = (Y - (CrosshairSize.Y * 0.5000000)) - (CrosshairOffset + (PC.VisualSpread * CrosshairSpreadMultiplier));
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(Crosshair.UpTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.UpCord.U, Crosshair.UpCord.V, Crosshair.UpCord.UL, Crosshair.UpCord.VL);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.UpTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.UpCord.U, Crosshair.UpCord.V, Crosshair.UpCord.UL, Crosshair.UpCord.VL);
    }
    // End:0x1753
    if(Crosshair.DownTex != none)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.DownCord.VL) * PickupScale) * Y) / float(720);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.DownCord.UL / Crosshair.DownCord.VL);
        ScreenX = X - (CrosshairSize.X * 0.5000000);
        ScreenY = (Y - (CrosshairSize.Y * 0.5000000)) + (CrosshairOffset + (PC.VisualSpread * CrosshairSpreadMultiplier));
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(Crosshair.DownTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.DownCord.U, Crosshair.DownCord.V, Crosshair.DownCord.UL, Crosshair.DownCord.VL);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.DownTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.DownCord.U, Crosshair.DownCord.V, Crosshair.DownCord.UL, Crosshair.DownCord.VL);
    }
    // End:0x1DB5
    if(Crosshair.LeftTex != none)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.LeftCord.VL) * PickupScale) * Y) / float(720);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.LeftCord.UL / Crosshair.LeftCord.VL);
        ScreenX = (X - (CrosshairSize.X * 0.5000000)) - (CrosshairOffset + (PC.VisualSpread * CrosshairSpreadMultiplier));
        ScreenY = Y - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(Crosshair.LeftTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.LeftCord.U, Crosshair.LeftCord.V, Crosshair.LeftCord.UL, Crosshair.LeftCord.VL);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.LeftTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.LeftCord.U, Crosshair.LeftCord.V, Crosshair.LeftCord.UL, Crosshair.LeftCord.VL);
    }
    // End:0x2417
    if(Crosshair.RightTex != none)
    {
        CrosshairSize.Y = ((((H.ConfiguredCrosshairScaling * CrosshairScaling) * Crosshair.RightCord.VL) * PickupScale) * Y) / float(720);
        CrosshairSize.X = CrosshairSize.Y * (Crosshair.RightCord.UL / Crosshair.RightCord.VL);
        ScreenX = (X - (CrosshairSize.X * 0.5000000)) + (CrosshairOffset + (PC.VisualSpread * CrosshairSpreadMultiplier));
        ScreenY = Y - (CrosshairSize.Y * 0.5000000);
        H.Canvas.DrawColor = H.BlackColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX + float(1), ScreenY + float(1), TargetDist);
        H.Canvas.DrawTile(Crosshair.RightTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.RightCord.U, Crosshair.RightCord.V, Crosshair.RightCord.UL, Crosshair.RightCord.VL);
        H.Canvas.DrawColor = CrosshairColor;
        H.Canvas.DrawColor.A = byte(CrosshairAlpha);
        H.Canvas.SetPos(ScreenX, ScreenY, TargetDist);
        H.Canvas.DrawTile(Crosshair.RightTex, CrosshairSize.X, CrosshairSize.Y, Crosshair.RightCord.U, Crosshair.RightCord.V, Crosshair.RightCord.UL, Crosshair.RightCord.VL);
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    super(Weapon).DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x196
    if(EvilPawn(Instigator) != none)
    {
        HUD.Canvas.DrawText((((((((("Eyeheight " $ string(Instigator.EyeHeight)) $ " base ") $ string(Instigator.BaseEyeHeight)) $ " landbob ") $ string(EvilPawn(Instigator).LandBob)) $ " just landed ") $ string(EvilPawn(Instigator).bJustLanded)) $ " land recover ") $ string(EvilPawn(Instigator).bLandRecovery), false);
        out_YPos += out_YL;
    }
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    HUD.Canvas.DrawText((((("Zoom State:" @ string(GetZoomedState())) @ "ZoomedRate:") @ string(ZoomedRate)) @ "Target FOV:") @ string(ZoomedTargetFOV));
    out_YPos += out_YL;
    //return;    
}

simulated function float GetFireInterval(byte FireModeNum)
{
    return (FireInterval[int(FireModeNum)] * UpgradeInfo.GetFireIntervalForLevel(((FireIntervalUpgradeLevel > 0) ? FireIntervalUpgradeLevel : UpgradeLevelGlobal))) * ((EvilPawn(Owner) != none) ? EvilPawn(Owner).FireRateMultiplier : 1.0000000);
    //return ReturnValue;    
}

simulated function float GetCurrentSpread(byte FireModeNum)
{
    local float CurrentSpread, CalculatedShotSpread;

    CurrentSpread = Spread[int(FireModeNum)];
    // End:0x40
    if(MoveSpreadState)
    {
        CurrentSpread *= MoveSpreadMultiplier;
    }
    // End:0x61
    if(JumpSpreadState)
    {
        CurrentSpread *= JumpSpreadMultiplier;
    }
    // End:0x82
    if(SprintSpreadState)
    {
        CurrentSpread *= SprintSpreadMultiplier;
    }
    CalculatedShotSpread = ShotSpreadHelper * ShotSpreadModifier;
    // End:0x12A
    if((CalculatedShotSpread > WeaponSpreadMax[int(FireModeNum)]) && ShotSpreadModifier != float(0))
    {
        ShotSpreadHelper -= ((CalculatedShotSpread - WeaponSpreadMax[int(FireModeNum)]) / ShotSpreadModifier);
        CalculatedShotSpread = ShotSpreadHelper * ShotSpreadModifier;
    }
    CurrentSpread += CalculatedShotSpread;
    // End:0x244
    if(((CurrentShotCount == 0) && NumberOfShots[int(FireModeNum)] == 1) && !MoveSpreadState || JumpSpreadState)
    {
        // End:0x1EF
        if(bFastRepeater)
        {
            return (CurrentSpread * 0.9000000) * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));            
        }
        else
        {
            return (CurrentSpread * 0.2000000) * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));
        }
    }
    return CurrentSpread * UpgradeInfo.GetBaseSpreadForLevel(((BaseSpreadUpgradeLevel > 0) ? BaseSpreadUpgradeLevel : UpgradeLevelGlobal));
    //return ReturnValue;    
}

simulated function PlayArmAnimation(name Sequence, float fDesiredDuration, optional bool OffHand, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    //return;    
}

simulated function PlayArmAnim(name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime)
{
    local EvilPawn UTP;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;
    local AnimNodeSequence AnimNode;
    local float DesiredRate;

    // End:0x67
    if(((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) || Instigator == none) || !Instigator.IsFirstPerson())
    {
        return;
    }
    UTP = EvilPawn(Instigator);
    // End:0x94
    if(UTP == none)
    {
        return;
    }
    // End:0x289
    if(CustomArmAnimNode != none)
    {
        // End:0x19B
        if(Duration > 0.0000000)
        {
            CustomArmAnimNode.bFixNumChildren = true;
            CustomArmAnimNode.PlayCustomAnimByDuration(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride);
            CustomArmAnimNode.SetActorAnimEndNotification(true);
            CustomArmAnimNode.SetRootBoneAxisOption(0, 0, 0);
            CustomArmAnimNode.SetRootBoneRotationOption(0, 0, 0);            
        }
        else
        {
            CustomArmAnimNode.bFixNumChildren = true;
            CustomArmAnimNode.PlayCustomAnim(AnimName, DefaultAnimSpeed, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
            CustomArmAnimNode.SetActorAnimEndNotification(true);
            CustomArmAnimNode.SetRootBoneAxisOption(0, 0, 0);
            CustomArmAnimNode.SetRootBoneRotationOption(0, 0, 0);
        }
        return;
    }
    // End:0x48B
    if(UTP.bArmsAttached && ArmsAnimSet != none)
    {
        ArmMeshComp = GetArmMeshComponent();
        AnimNode = GetArmAnimNodeSeq();
        // End:0x306
        if((ArmMeshComp == none) || AnimNode == none)
        {
            return;
        }
        // End:0x3E3
        if(Duration > 0.0000000)
        {
            AnimNode.SetAnim(AnimName);
            // End:0x3E0
            if(AnimNode.AnimSeq != none)
            {
                DesiredRate = AnimNode.AnimSeq.SequenceLength / Duration;
                AnimNode.PlayAnim(bLooping, DesiredRate);
            }            
        }
        else
        {
            AnimNode.SetAnim(AnimName);
            // End:0x46A
            if(AnimNode.AnimSeq != none)
            {
                AnimNode.PlayAnim(bLooping, DefaultAnimSpeed, StartTime);
            }
        }
        AnimNode.bCauseActorAnimEnd = true;
    }
    //return;    
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    //return;    
}

simulated function PlayWeaponAnim(name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local AnimNodeSequence AnimNode;
    local float DesiredRate;

    // End:0x30
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x228
    if(CustomAnimNode != none)
    {
        // End:0x137
        if(Duration > 0.0000000)
        {
            CustomAnimNode.bFixNumChildren = true;
            CustomAnimNode.PlayCustomAnimByDuration(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride);
            CustomAnimNode.SetActorAnimEndNotification(true);
            CustomAnimNode.SetRootBoneAxisOption(0, 0, 0);
            CustomAnimNode.SetRootBoneRotationOption(0, 0, 0);            
        }
        else
        {
            CustomAnimNode.bFixNumChildren = true;
            CustomAnimNode.PlayCustomAnim(AnimName, DefaultAnimSpeed, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
            CustomAnimNode.SetActorAnimEndNotification(true);
            CustomAnimNode.SetRootBoneAxisOption(0, 0, 0);
            CustomAnimNode.SetRootBoneRotationOption(0, 0, 0);
        }
        return;        
    }
    else
    {
        // End:0x420
        if((Mesh != none) && Mesh.bAttached)
        {
            // End:0x286
            if(SkelMesh == none)
            {
                SkelMesh = SkeletalMeshComponent(Mesh);
            }
            AnimNode = GetWeaponAnimNodeSeq();
            // End:0x2BC
            if((SkelMesh == none) || AnimNode == none)
            {
                return;
            }
            // End:0x399
            if(Duration > 0.0000000)
            {
                AnimNode.SetAnim(AnimName);
                // End:0x396
                if(AnimNode.AnimSeq != none)
                {
                    DesiredRate = AnimNode.AnimSeq.SequenceLength / Duration;
                    AnimNode.PlayAnim(bLooping, DesiredRate);
                }                
            }
            else
            {
                AnimNode.SetAnim(AnimName);
                // End:0x420
                if(AnimNode.AnimSeq != none)
                {
                    AnimNode.PlayAnim(bLooping, DefaultAnimSpeed, StartTime);
                }
            }
        }
    }
    //return;    
}

simulated function StopWeaponAnimation()
{
    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x80
    if(CustomAnimNode != none)
    {
        CustomAnimNode.StopAnim();
        CustomAnimNode.StopCustomAnim(0.0000000);        
    }
    else
    {
        super(Weapon).StopWeaponAnimation();
    }
    //return;    
}

simulated function StopArmAnimation()
{
    local AnimNodeSequence AnimSeq;

    // End:0x2B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x80
    if(CustomArmAnimNode != none)
    {
        CustomArmAnimNode.StopAnim();
        CustomArmAnimNode.StopCustomAnim(0.0000000);        
    }
    else
    {
        AnimSeq = GetArmAnimNodeSeq();
        // End:0xC2
        if(AnimSeq != none)
        {
            AnimSeq.StopAnim();
        }
    }
    //return;    
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
    // End:0xAD
    if((int(FireModeNum) < WeaponFireAnim.Length) && WeaponFireAnim[int(FireModeNum)] != 'None')
    {
        PlayWeaponAnim(WeaponFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    // End:0x16A
    if(((int(FireModeNum) < ArmFireAnim.Length) && ArmFireAnim[int(FireModeNum)] != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmFireAnim[int(FireModeNum)], GetFireInterval(FireModeNum), FireAnimBlendTimes.BlendIn, FireAnimBlendTimes.BlendOut,, true);
    }
    CauseMuzzleFlash();
    ShakeView();
    //return;    
}

simulated function StopFireEffects(byte FireModeNum)
{
    StopMuzzleFlash();
    //return;    
}

simulated function ShakeView()
{
    local EvilPlayerController PC;
    local int AnimIndex;
    local float AnimRate;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0x30E
    if((PC != none) && LocalPlayer(PC.Player) != none)
    {
        // End:0x1C0
        if((int(CurrentFireMode) == int(0)) && FireCameraAnim.Length > 0)
        {
            AnimIndex = Rand(FireCameraAnim.Length);
            AnimRate = FireCameraAnim[AnimIndex].AnimLength / (GetFireInterval(CurrentFireMode));
            PC.PlayCameraAnim(FireCameraAnim[AnimIndex], ((int(GetZoomedState()) > int(1)) ? PC.GetFOVAngle() / PC.DefaultFOV : FMax((Loge(ShotSpreadHelper) + float(1)) * FireCameraAnimScale[int(CurrentFireMode)], 1.0000000)), AnimRate, 0.0500000, 0.0500000);            
        }
        else
        {
            // End:0x30E
            if((int(CurrentFireMode) == int(1)) && FireCameraAnimAlt.Length > 0)
            {
                AnimIndex = Rand(FireCameraAnimAlt.Length);
                AnimRate = FireCameraAnimAlt[AnimIndex].AnimLength / (GetFireInterval(CurrentFireMode));
                PC.PlayCameraAnim(FireCameraAnimAlt[AnimIndex], ((int(GetZoomedState()) > int(1)) ? PC.GetFOVAngle() / PC.DefaultFOV : FMax((Loge(ShotSpreadHelper) + float(1)) * FireCameraAnimScale[int(CurrentFireMode)], 1.0000000)), AnimRate, 0.0500000, 0.0500000);
            }
        }
    }
    // End:0x393
    if((PC != none) && LocalPlayer(PC.Player) != none)
    {
        EvilPlayerController(Instigator.Controller).ClientPlayForceFeedbackWaveform(WeaponFireWaveForm);
    }
    //return;    
}

simulated function WeaponCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
    local Rotator DeltaRotator;
    local float CurrentRecoilDelta;

    CurrentRecoilDelta = RecoilDelta * UpgradeInfo.GetFireIntervalForLevel(((FireIntervalUpgradeLevel > 0) ? FireIntervalUpgradeLevel : UpgradeLevelGlobal));
    Recoil = FInterpTo(Recoil, float(CurrentShotCount) * CurrentRecoilDelta, fDeltaTime, 10.0000000);
    Recoil = FClamp(Recoil, 0.0000000, RecoilMax);
    DeltaRotator.Pitch = int(Recoil);
    out_CamRot += DeltaRotator;
    //return;    
}

simulated function WeaponPlaySound(SoundCue Sound, optional SoundCue Sound1p)
{
    local PlayerController PC;

    // End:0x238
    if(((Sound != none) && Instigator != none) && !bSuppressSounds)
    {
        PC = PlayerController(Instigator.Controller);
        // End:0xD8
        if((PC != none) && PC.IsLocalPlayerController())
        {
            PC.ClientPlaySound(((Sound1p != none) ? Sound1p : Sound));
        }
        // End:0x131
        if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            Instigator.PlaySound(Sound, false, true);            
        }
        else
        {
            // End:0x238
            if((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                // End:0x237
                foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
                {
                    // End:0x236
                    if(PC != Instigator.Controller)
                    {
                        PC.ClientHearSound(Sound, Instigator, Instigator.Location, false);
                    }                    
                }                
            }
        }
    }
    //return;    
}

simulated function PlayFiringSound()
{
    // End:0xF0
    if(int(CurrentFireMode) < WeaponFireSnd.Length)
    {
        // End:0xF0
        if((WeaponFireSnd[int(CurrentFireMode)] != none) && WorldInfo.TimeSeconds >= (WeaponSoundTime + WeaponSoundInterval))
        {
            MakeNoise(1.0000000);
            WeaponPlaySound(WeaponFireSnd[int(CurrentFireMode)], ((int(CurrentFireMode) < WeaponFireSnd1p.Length) ? WeaponFireSnd1p[int(CurrentFireMode)] : none));
            WeaponSoundTime = WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

simulated function PlayJumpingSound()
{
    WeaponPlaySound(WeaponJumpSound);
    //return;    
}

simulated function PlayLandingSound()
{
    WeaponPlaySound(WeaponLandSound);
    //return;    
}

simulated function PlayCrouchingSound()
{
    WeaponPlaySound(WeaponCrouchSound);
    //return;    
}

simulated function PlayCrouchingEndSound()
{
    WeaponPlaySound(WeaponCrouchEndSound);
    //return;    
}

simulated function PlayFootStepSound()
{
    WeaponPlaySound(WeaponFootStepSound);
    //return;    
}

simulated event MuzzleFlashTimer()
{
    // End:0x3F
    if((MuzzleFlashPSC != none) && !bMuzzleFlashPSCLoops)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
    //return;    
}

simulated event CauseMuzzleFlashLight()
{
    local Vector LightLoc;

    // End:0x71
    if((WorldInfo.bDropDetail && !WorldInfo.IsConsoleBuild(3)) || WorldInfo.IsConsoleBuild())
    {
        return;
    }
    // End:0xC2
    if(MuzzleFlashLightActor != none)
    {
        MuzzleFlashLightActor.DisableLight(false);
        MuzzleFlashLightActor.Restart();        
    }
    else
    {
        // End:0xF3
        if(MuzzleFlashLight != none)
        {
            MuzzleFlashLight.ResetLight();            
        }
        else
        {
            // End:0x1BB
            if(MuzzleFlashLightArchetype != none)
            {
                SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(MuzzleFlashSocket[int(CurrentFireMode)], LightLoc,, 0);
                MuzzleFlashLightActor = Spawn(Class'EvilLightActor', self,, LightLoc,, MuzzleFlashLightArchetype);
                MuzzleFlashLightActor.SetBase(self);
                MuzzleFlashLightActor.Activate();                
            }
            else
            {
                // End:0x230
                if(MuzzleFlashLightClass != none)
                {
                    MuzzleFlashLight = new (Outer) MuzzleFlashLightClass;
                    SkeletalMeshComponent(Mesh).AttachComponentToSocket(MuzzleFlashLight, MuzzleFlashSocket[int(CurrentFireMode)]);
                }
            }
        }
    }
    //return;    
}

simulated event CauseMuzzleFlash()
{
    local EvilPawn P;
    local ParticleSystem MuzzleTemplate;

    // End:0xA3
    if(int(WorldInfo.NetMode) != int(NM_Client))
    {
        P = EvilPawn(Instigator);
        // End:0xA3
        if(((P == none) || !P.bUpdateEyeheight) && !Instigator.IsA('EvilVehicle_Base'))
        {
            return;
        }
    }
    CauseMuzzleFlashLight();
    // End:0x2E9
    if((int(GetHand()) != int(1)) || ((bShowAltMuzzlePSCWhenWeaponHidden && Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
    {
        // End:0x137
        if(!bMuzzleFlashAttached)
        {
            AttachMuzzleFlash();
        }
        // End:0x2D2
        if(MuzzleFlashPSC != none)
        {
            // End:0x2D2
            if(!bMuzzleFlashPSCLoops || !MuzzleFlashPSC.bIsActive || MuzzleFlashPSC.bWasDeactivated)
            {
                // End:0x229
                if(((Instigator != none) && int(Instigator.FiringMode) == int(1)) && MuzzleFlashAltPSCTemplate != none)
                {
                    MuzzleTemplate = MuzzleFlashAltPSCTemplate;
                    MuzzleFlashPSC.SetIgnoreOwnerHidden(bShowAltMuzzlePSCWhenWeaponHidden);                    
                }
                else
                {
                    // End:0x24B
                    if(MuzzleFlashPSCTemplate != none)
                    {
                        MuzzleTemplate = MuzzleFlashPSCTemplate;
                    }
                }
                // End:0x29F
                if(MuzzleTemplate != MuzzleFlashPSC.Template)
                {
                    MuzzleFlashPSC.SetTemplate(MuzzleTemplate);
                }
                SetMuzzleFlashParams(MuzzleFlashPSC);
                MuzzleFlashPSC.ActivateSystem();
            }
        }
        SetTimer(MuzzleFlashDuration, false, 'MuzzleFlashTimer');
    }
    //return;    
}

simulated event StopMuzzleFlash()
{
    ClearTimer('MuzzleFlashTimer');
    MuzzleFlashTimer();
    // End:0x4C
    if(MuzzleFlashPSC != none)
    {
        MuzzleFlashPSC.DeactivateSystem();
    }
    // End:0x7B
    if(MuzzleFlashLightActor != none)
    {
        MuzzleFlashLightActor.DisableLight(true);
    }
    //return;    
}

simulated function TimeWeaponPutDown()
{
    // End:0x2C
    if(Instigator.IsFirstPerson())
    {
        PlayWeaponPutDown();
    }
    super(Weapon).TimeWeaponPutDown();
    //return;    
}

simulated function PlayWeaponPutDown()
{
    // End:0x6E
    if(WeaponPutDownAnim != 'None')
    {
        PlayWeaponAnim(WeaponPutDownAnim, PutDownTime, PutDownAnimBlendTimes.BlendIn, PutDownAnimBlendTimes.BlendOut);
    }
    // End:0xED
    if((ArmsPutDownAnim != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmsPutDownAnim, PutDownTime, PutDownAnimBlendTimes.BlendIn, PutDownAnimBlendTimes.BlendOut);
    }
    // End:0x1BA
    if((WeaponPutDownSnd != none) && ((EvilInvManager.PendingWeapon == none) && EvilInvManager.PendingWeaponLeft == none) || (EvilWeap_Melee_Base(EvilInvManager.PendingWeapon) != none) || EvilWeap_Melee_Base(EvilInvManager.PendingWeaponLeft) != none)
    {
        WeaponPlaySound(WeaponPutDownSnd);
    }
    //return;    
}

simulated function TimeWeaponEquipping()
{
    AttachWeaponTo(Instigator.Mesh);
    PlayWeaponEquip();
    SetTimer(GetEquipTime(), false, 'WeaponEquipped');
    //return;    
}

simulated function float GetEquipTime()
{
    local float ETime;

    ETime = ((EquipTime > float(0)) ? EquipTime * DefaultAnimSpeed : 0.0100000);
    return ETime;
    //return ReturnValue;    
}

simulated function PlayWeaponEquip()
{
    // End:0x6E
    if(WeaponEquipAnim != 'None')
    {
        PlayWeaponAnim(WeaponEquipAnim, EquipTime, EquipAnimBlendTimes.BlendIn, EquipAnimBlendTimes.BlendOut);
    }
    // End:0xED
    if((ArmsEquipAnim != 'None') && ArmsAnimSet != none)
    {
        PlayArmAnim(ArmsEquipAnim, EquipTime, EquipAnimBlendTimes.BlendIn, EquipAnimBlendTimes.BlendOut);
    }
    // End:0x139
    if((WeaponEquipSnd != none) && WorldInfo.TimeSeconds > float(3))
    {
        WeaponPlaySound(WeaponEquipSnd);
    }
    //return;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    local EvilPawn UTP;
    local editinline SkeletalMeshComponent SkelMesh;

    UTP = EvilPawn(Instigator);
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x114
    if(Instigator.IsFirstPerson())
    {
        AttachComponent(Mesh);
        EnsureWeaponOverlayComponentLast();
        SetHidden(true);
        bPendingShow = true;
        Mesh.SetLightEnvironment(LightEnvironment);
        // End:0x111
        if((int(GetHand()) == int(1)) && UTP.bArmsAttached)
        {
            GetArmMeshComponent().SetHidden(true);
        }        
    }
    else
    {
        SetHidden(true);
        // End:0x1C4
        if(UTP != none)
        {
            Mesh.SetLightEnvironment(LightEnvironment);
            UTP.ArmsMesh[0].SetHidden(true);
            UTP.ArmsMesh[1].SetHidden(true);
        }
    }
    SetWeaponOverlayFlags(UTP);
    // End:0x35D
    if((int(Role) == int(ROLE_Authority)) && UTP != none)
    {
        // End:0x23C
        if(int(GetHand()) == int(3))
        {
            UTP.CurrentWeaponLeftAttachmentClass = AttachmentClass;            
        }
        else
        {
            UTP.CurrentWeaponAttachmentClass = AttachmentClass;
        }
        // End:0x35D
        if(((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_Standalone)) || (int(WorldInfo.NetMode) == int(NM_Client)) && Instigator.IsLocallyControlled())
        {
            // End:0x33E
            if(int(GetHand()) == int(3))
            {
                UTP.WeaponLeftAttachmentChanged();                
            }
            else
            {
                UTP.WeaponAttachmentChanged();
            }
        }
    }
    SetSkin(EvilPawn(Instigator).ReplicatedBodyMaterial);
    // End:0x3E1
    if(SkelMesh != none)
    {
        // End:0x3CE
        if(SkelMesh.Animations != none)
        {
            UpdateAnimNodeReferences();            
        }
        else
        {
            SetTimer(0.1000000, false, 'UpdateAnimNodeReferences');
        }
    }
    //return;    
}

simulated function UpdateAnimNodeReferences()
{
    local editinline SkeletalMeshComponent WeaponSkelMesh;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;

    WeaponSkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x2D
    if(WeaponSkelMesh == none)
    {
        return;
    }
    // End:0xB4
    if((WeaponSkelMesh.Animations == none) && WeaponSkelMesh.AnimTreeTemplate != none)
    {
        WeaponSkelMesh.SetAnimTreeTemplate(WeaponSkelMesh.AnimTreeTemplate);
    }
    // End:0xDA
    if(WeaponSkelMesh.Animations == none)
    {
        return;
    }
    CustomAnimNode = AnimNodeSlot(WeaponSkelMesh.FindAnimNode('CustomAnim'));
    ArmMeshComp = GetArmMeshComponent();
    // End:0x171
    if(((ArmsAnimSet == none) || ArmMeshComp == none) || ArmMeshComp.Animations == none)
    {
        return;
    }
    CustomArmAnimNode = AnimNodeSlot(ArmMeshComp.FindAnimNode('CustomAnim'));
    //return;    
}

simulated event AnimTreeUpdated(SkeletalMeshComponent SkelMesh)
{
    // End:0x21
    if(SkelMesh == Mesh)
    {
        UpdateAnimNodeReferences();
    }
    super(Actor).AnimTreeUpdated(SkelMesh);
    //return;    
}

simulated function SetMuzzleFlashParams(ParticleSystemComponent PSC)
{
    PSC.SetColorParameter('MuzzleFlashColor', MuzzleFlashColor);
    PSC.SetVectorParameter('MFlashScale', vect(0.5000000, 0.5000000, 0.5000000));
    UDKParticleSystemComponent(PSC).SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
    //return;    
}

simulated function AttachMuzzleFlash()
{
    local editinline SkeletalMeshComponent SKMesh;

    bMuzzleFlashAttached = true;
    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x13C
    if(SKMesh != none)
    {
        // End:0x13C
        if((MuzzleFlashPSCTemplate != none) || MuzzleFlashAltPSCTemplate != none)
        {
            MuzzleFlashPSC = new (Outer) Class'UTParticleSystemComponent';
            MuzzleFlashPSC.bAutoActivate = false;
            MuzzleFlashPSC.SetDepthPriorityGroup(2);
            MuzzleFlashPSC.SetFOV(UDKSkeletalMeshComponent(SKMesh).default.FOV);
            SKMesh.AttachComponentToSocket(MuzzleFlashPSC, MuzzleFlashSocket[int(CurrentFireMode)]);
        }
    }
    //return;    
}

simulated function DetachWeapon()
{
    local EvilPawn P;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;

    CustomAnimNode = none;
    CustomArmAnimNode = none;
    DetachComponent(Mesh);
    // End:0x4B
    if(OverlayMesh != none)
    {
        DetachComponent(OverlayMesh);
    }
    SetSkin(none);
    P = EvilPawn(Instigator);
    // End:0x21D
    if(P != none)
    {
        ArmMeshComp = GetArmMeshComponent();
        // End:0xD5
        if((ArmsAnimSet != none) && ArmMeshComp != none)
        {
            ArmMeshComp.SetHidden(true);
        }
        // End:0x21D
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x190
            if((int(GetHand()) == int(ROLE_Authority)) && P.CurrentWeaponLeftAttachmentClass == AttachmentClass)
            {
                P.CurrentWeaponLeftAttachmentClass = none;
                // End:0x18D
                if(Instigator.IsLocallyControlled())
                {
                    P.WeaponLeftAttachmentChanged();
                }                
            }
            else
            {
                // End:0x21D
                if(P.CurrentWeaponAttachmentClass == AttachmentClass)
                {
                    P.CurrentWeaponAttachmentClass = none;
                    // End:0x21D
                    if(Instigator.IsLocallyControlled())
                    {
                        P.WeaponAttachmentChanged();
                    }
                }
            }
        }
    }
    SetBase(none);
    SetHidden(true);
    DetachMuzzleFlash();
    Mesh.SetLightEnvironment(none);
    //return;    
}

simulated function DetachMuzzleFlash()
{
    local editinline SkeletalMeshComponent SKMesh;

    bMuzzleFlashAttached = false;
    SKMesh = SkeletalMeshComponent(Mesh);
    // End:0x6E
    if(SKMesh != none)
    {
        // End:0x6E
        if(MuzzleFlashPSC != none)
        {
            SKMesh.DetachComponent(MuzzleFlashPSC);
        }
    }
    MuzzleFlashPSC = none;
    //return;    
}

simulated function ChangeVisibility(bool bIsVisible)
{
    local editinline SkeletalMeshComponent SkelMesh;
    local editinline PrimitiveComponent Primitive;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;

    // End:0x101
    if(Mesh != none)
    {
        // End:0x5F
        if(bIsVisible && !Mesh.bAttached)
        {
            AttachComponent(Mesh);
            EnsureWeaponOverlayComponentLast();
        }
        SetHidden(!bIsVisible);
        SkelMesh = SkeletalMeshComponent(Mesh);
        // End:0x101
        if(SkelMesh != none)
        {
            // End:0x100
            foreach SkelMesh.AttachedComponents(Class'Engine.PrimitiveComponent', Primitive)
            {
                Primitive.SetHidden(!bIsVisible);                
            }            
        }
    }
    // End:0x175
    if((ArmsAnimSet != none) && int(GetHand()) != int(1))
    {
        ArmMeshComp = GetArmMeshComponent();
        // End:0x175
        if(ArmMeshComp != none)
        {
            ArmMeshComp.SetHidden(!bIsVisible);
        }
    }
    // End:0x1C6
    if(OverlayMesh != none)
    {
        OverlayMesh.SetHidden(!bIsVisible || int(GetHand()) == int(1));
    }
    //return;    
}

simulated function PerformWeaponChange()
{
    // End:0x9D
    if(EvilPawn(Instigator) != none)
    {
        // End:0x66
        if(Instigator.IsLocallyControlled())
        {
            EvilPawn(Instigator).WeaponChanged(self);            
        }
        else
        {
            // End:0x9D
            if(Instigator.Controller == none)
            {
                SetTimer(0.0100000, false, 'PerformWeaponChange');
            }
        }
    }
    //return;    
}

simulated function GetViewAxes(out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
    // End:0x5F
    if(EvilVehicle_Base(Owner) != none)
    {
        EvilVehicle_Base(Owner).GetWeaponViewAxes(self, XAxis, YAxis, ZAxis);        
    }
    else
    {
        // End:0xC1
        if(Instigator.Controller == none)
        {
            GetAxes(Instigator.Rotation, XAxis, YAxis, ZAxis);            
        }
        else
        {
            GetAxes(Instigator.Controller.Rotation, XAxis, YAxis, ZAxis);
        }
    }
    //return;    
}

reliable server function ServerReselectWeapon()
{
    //return;    
}

simulated function bool CanThrow()
{
    return bCanThrow;
    //return ReturnValue;    
}

simulated function EvilWeap_Base.EWWeaponHand GetHand()
{
    return WeaponHand;
    //return ReturnValue;    
}

simulated event SetPosition(UDKPawn Holder)
{
    local EvilPawn Pawn;
    local PlayerController PC;
    local float Delta, FinalMeshScale, FinalMeshFOV;
    local Vector DrawOffset, ViewOffset, FinalSmallWeaponsOffset, FinalLocation;
    local EvilWeap_Base.EWWeaponHand CurrentHand;
    local Rotator NewRotation, FinalRotation, SpecRotation;
    local Vector2D ViewportSize;
    local bool bIsWideScreen;
    local Vector SpecViewLoc, LeanLoc;
    local float AspectRatio;
    local PerPlayerSplitscreenData PPSD;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;
    local int PlayerIndex;
    local LocalPlayer LP;

    // End:0x35
    if(!Holder.IsFirstPerson() || bDisableSetPosition)
    {
        return;
    }
    Pawn = EvilPawn(Holder);
    PC = PlayerController(Pawn.Controller);
    Delta = WorldInfo.TimeSeconds - LastSetPos;
    LastSetPos = WorldInfo.TimeSeconds;
    ShotSpreadHelper = FInterpTo(ShotSpreadHelper, 0.0000000, Delta, ShotSpreadBackSpeed);
    // End:0x134
    if(ArmsAnimSet != none)
    {
        ArmMeshComp = GetArmMeshComponent();
    }
    CurrentHand = GetHand();
    // End:0x239
    if(bForceHidden || int(CurrentHand) == int(1))
    {
        Mesh.SetHidden(true);
        // End:0x1BA
        if(ArmMeshComp != none)
        {
            ArmMeshComp.SetHidden(true);
        }
        NewRotation = Holder.GetViewRotation();
        SetLocation(Instigator.GetPawnViewLocation() + (HiddenWeaponsOffset >> NewRotation));
        SetRotation(NewRotation);
        SetBase(Instigator);
        return;
    }
    // End:0x25D
    if(bPendingShow)
    {
        SetHidden(false);
        bPendingShow = false;
    }
    Mesh.SetHidden(false);
    // End:0x2AC
    if(ArmMeshComp != none)
    {
        ArmMeshComp.SetHidden(false);
    }
    LP = LocalPlayer(PC.Player);
    LP.ViewportClient.GetViewportSize(ViewportSize);
    PlayerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LP);
    // End:0x448
    if(PlayerIndex != -1)
    {
        PPSD = LocalPlayer(PC.Player).ViewportClient.SplitscreenInfo[int(LocalPlayer(PC.Player).ViewportClient.GetSplitscreenConfiguration())].PlayerData[PlayerIndex];        
    }
    else
    {
        PPSD.SizeX = 1.0000000;
        PPSD.SizeY = 1.0000000;
    }
    ViewportSize.X *= PPSD.SizeX;
    ViewportSize.Y *= PPSD.SizeY;
    AspectRatio = ((ViewportSize.Y > 0.0000000) ? ViewportSize.X / ViewportSize.Y : 0.0000000);
    bIsWideScreen = AspectRatio > 1.7000000;
    ViewOffset = PlayerViewOffset;
    FinalSmallWeaponsOffset = SmallWeaponsOffset;
    switch(CurrentHand)
    {
        // End:0x6BC
        case 3:
            Mesh.SetScale3D(default.Mesh.Scale3D * vect(1.0000000, -1.0000000, 1.0000000));
            // End:0x673
            if(ArmMeshComp != none)
            {
                ArmMeshComp.SetScale3D(ArmMeshComp.default.Scale3D * vect(1.0000000, -1.0000000, 1.0000000));
            }
            ViewOffset.Y *= -1.0000000;
            FinalSmallWeaponsOffset.Y *= -1.0000000;
            // End:0x753
            break;
        // End:0x74D
        case 2:
            Mesh.SetScale3D(default.Mesh.Scale3D);
            // End:0x74A
            if(ArmMeshComp != none)
            {
                ArmMeshComp.SetScale3D(ArmMeshComp.default.Scale3D);
            }
            // End:0x753
            break;
        // End:0xFFFF
        default:
            // End:0x753
            break;
            break;
    }
    // End:0x7C1
    if(bIsWideScreen || int(GetZoomedState()) > int(1))
    {
        ViewOffset += (WideScreenOffsetScaling * FinalSmallWeaponsOffset);
        // End:0x7BE
        if(bSmallWeapons)
        {
            ViewOffset += (0.9000000 * FinalSmallWeaponsOffset);
        }        
    }
    else
    {
        // End:0x7E5
        if(bSmallWeapons)
        {
            ViewOffset += FinalSmallWeaponsOffset;            
        }
        else
        {
            ViewOffset += ((0.7000000 * AspectRatio) * FinalSmallWeaponsOffset);
        }
    }
    // End:0xFC8
    if(Holder.Controller == none)
    {
        // End:0xF57
        if(DemoRecSpectator(PC) != none)
        {
            PC.GetPlayerViewPoint(SpecViewLoc, SpecRotation);
            DrawOffset = ViewOffset >> SpecRotation;
            DrawOffset += EvilPawn(Holder).WeaponBob(BobDamping, JumpDamping);
            BackForce.X = FInterpTo(BackForce.X, float(CurrentShotCount) * BackForceVector.X, Delta, 8.0000000);
            BackForce.Y = FInterpTo(BackForce.Y, float(CurrentShotCount) * BackForceVector.Y, Delta, 8.0000000);
            BackForce.Z = FInterpTo(BackForce.Z, float(CurrentShotCount) * BackForceVector.Z, Delta, 8.0000000);
            BackForce.X = FClamp(BackForce.X, -BackForceMax.X, BackForceMax.X);
            BackForce.Y = FClamp(BackForce.Y, -BackForceMax.Y, BackForceMax.Y);
            BackForce.Z = FClamp(BackForce.Z, -BackForceMax.Z, BackForceMax.Z);
            DrawOffset += (BackForce >> SpecRotation);
            CurrentShotDistortion.X = FInterpTo(CurrentShotDistortion.X, ShotDistortion.X, Delta, 6.0000000);
            CurrentShotDistortion.Y = FInterpTo(CurrentShotDistortion.Y, ShotDistortion.Y, Delta, 6.0000000);
            CurrentShotDistortion.Z = FInterpTo(CurrentShotDistortion.Z, ShotDistortion.Z, Delta, 6.0000000);
            DrawOffset += (CurrentShotDistortion >> Holder.Controller.Rotation);
            FinalLocation = SpecViewLoc + DrawOffset;
            SetLocation(FinalLocation);
            SetBase(Holder);
            SpecRotation = RTransform(PlayerRotationOffset, SpecRotation);
            SpecRotation.Yaw = LagRot(SpecRotation.Yaw & 65535, LastRotation.Yaw & 65535, MaxYawLag, 0);
            SpecRotation.Pitch = LagRot(SpecRotation.Pitch & 65535, LastRotation.Pitch & 65535, MaxPitchLag, 1);
            LastRotUpdate = WorldInfo.TimeSeconds;
            LastRotation = SpecRotation;
            // End:0xF1E
            if(bIsWideScreen || int(GetZoomedState()) > int(1))
            {
                SpecRotation += WidescreenRotationOffset;                
            }
            else
            {
                SpecRotation += ((0.7000000 * AspectRatio) * WidescreenRotationOffset);
            }
            SetRotation(SpecRotation);
            return;            
        }
        else
        {
            DrawOffset = (ViewOffset >> Holder.GetBaseAimRotation()) + (EvilPawn(Holder).GetEyeHeight() * vect(0.0000000, 0.0000000, 1.0000000));
        }        
    }
    else
    {
        DrawOffset.Z = EvilPawn(Holder).GetEyeHeight();
        DrawOffset += EvilPawn(Holder).WeaponBob(BobDamping, JumpDamping);
        // End:0x10FC
        if(EvilPlayerController(Holder.Controller) != none)
        {
            DrawOffset += (EvilPlayerController(Holder.Controller).ShakeOffset >> Holder.Controller.Rotation);
        }
        DrawOffset = DrawOffset + (ViewOffset >> Holder.Controller.Rotation);
        BackForce.X = FInterpTo(BackForce.X, float(CurrentShotCount) * BackForceVector.X, Delta, 8.0000000);
        BackForce.Y = FInterpTo(BackForce.Y, float(CurrentShotCount) * BackForceVector.Y, Delta, 8.0000000);
        BackForce.Z = FInterpTo(BackForce.Z, float(CurrentShotCount) * BackForceVector.Z, Delta, 8.0000000);
        BackForce.X = FClamp(BackForce.X, -BackForceMax.X, BackForceMax.X);
        BackForce.Y = FClamp(BackForce.Y, -BackForceMax.Y, BackForceMax.Y);
        BackForce.Z = FClamp(BackForce.Z, -BackForceMax.Z, BackForceMax.Z);
        DrawOffset += (BackForce >> Holder.Controller.Rotation);
        CurrentShotDistortion.X = FInterpTo(CurrentShotDistortion.X, ShotDistortion.X, Delta, 6.0000000);
        CurrentShotDistortion.Y = FInterpTo(CurrentShotDistortion.Y, ShotDistortion.Y, Delta, 6.0000000);
        CurrentShotDistortion.Z = FInterpTo(CurrentShotDistortion.Z, ShotDistortion.Z, Delta, 6.0000000);
        DrawOffset += (CurrentShotDistortion >> Holder.Controller.Rotation);
    }
    // End:0x1846
    if(EvilPawn(Holder) != none)
    {
        // End:0x1699
        if(int(EvilPawn(Holder).CurrentLeanState) == int(1))
        {
            CurrLeanLocVal = FInterpTo(CurrLeanLocVal, -EvilPawn(Holder).LeanLenght, Delta, 10.0000000);            
        }
        else
        {
            // End:0x1720
            if(int(EvilPawn(Holder).CurrentLeanState) == int(2))
            {
                CurrLeanLocVal = FInterpTo(CurrLeanLocVal, EvilPawn(Holder).LeanLenght, Delta, 10.0000000);                
            }
            else
            {
                CurrLeanLocVal = FInterpTo(CurrLeanLocVal, 0.0000000, Delta, 10.0000000);
            }
        }
        LeanLoc.Y = CurrLeanLocVal;
        // End:0x17B8
        if(int(GetZoomedState()) == int(3))
        {
            LeanLoc.Z = Recoil * 0.0030000;
        }
        DrawOffset += (LeanLoc >> ((Holder.Controller == none) ? Holder.Rotation : Holder.Controller.Rotation));
    }
    FinalLocation = Holder.Location + DrawOffset;
    SetLocation(FinalLocation);
    SetBase(Holder);
    NewRotation = ((Holder.Controller == none) ? Holder.GetBaseAimRotation() : Holder.Controller.Rotation);
    NewRotation = RTransform(PlayerRotationOffset, NewRotation);
    NewRotation.Pitch += int(Recoil);
    // End:0x1AF3
    if(Holder.Controller != none)
    {
        FinalRotation.Yaw = LagRot(NewRotation.Yaw & 65535, LastRotation.Yaw & 65535, ((int(GetZoomedState()) == int(0)) ? MaxYawLag : MaxZoomYawLag), 0);
        FinalRotation.Pitch = LagRot(NewRotation.Pitch & 65535, LastRotation.Pitch & 65535, ((int(GetZoomedState()) == int(0)) ? MaxPitchLag : MaxZoomPitchLag), 1);
        FinalRotation.Roll = NewRotation.Roll;        
    }
    else
    {
        FinalRotation = NewRotation;
    }
    LastRotUpdate = WorldInfo.TimeSeconds;
    LastRotation = NewRotation;
    // End:0x1B7D
    if(bIsWideScreen || int(GetZoomedState()) > int(1))
    {
        FinalRotation += WidescreenRotationOffset;        
    }
    else
    {
        FinalRotation += ((0.7000000 * AspectRatio) * WidescreenRotationOffset);
    }
    SetRotation(FinalRotation);
    // End:0x1D97
    if(Mesh.Translation != DesiredMeshTranslation)
    {
        FinalMeshTrans.X = ZoomInterpolation(Mesh.Translation.X, DesiredMeshTranslation.X, ZoomingTranslationRate, Delta);
        FinalMeshTrans.Y = ZoomInterpolation(Mesh.Translation.Y, DesiredMeshTranslation.Y, ZoomingTranslationRate, Delta);
        FinalMeshTrans.Z = ZoomInterpolation(Mesh.Translation.Z, DesiredMeshTranslation.Z, ZoomingTranslationRate, Delta);
        Mesh.SetTranslation(FinalMeshTrans);
    }
    // End:0x1F9E
    if(RDiff(Mesh.Rotation, DesiredMeshRotation) > 0.1000000)
    {
        FinalMeshRot.Yaw = int(ZoomInterpolation(float(Mesh.Rotation.Yaw), float(DesiredMeshRotation.Yaw), ZoomingRotationRate, Delta));
        FinalMeshRot.Pitch = int(ZoomInterpolation(float(Mesh.Rotation.Pitch), float(DesiredMeshRotation.Pitch), ZoomingRotationRate, Delta));
        FinalMeshRot.Roll = int(ZoomInterpolation(float(Mesh.Rotation.Roll), float(DesiredMeshRotation.Roll), ZoomingRotationRate, Delta));
        Mesh.SetRotation(FinalMeshRot);
    }
    // End:0x2027
    if(ArmMeshComp != none)
    {
        ArmMeshComp.SetTranslation(DrawOffset + (FinalMeshTrans >> FinalRotation));
        ArmMeshComp.SetRotation(RTransform(FinalMeshRot, FinalRotation));
    }
    // End:0x20FF
    if(Mesh.Scale != DesiredMeshScale)
    {
        FinalMeshScale = ZoomInterpolation(Mesh.Scale, DesiredMeshScale, ZoomingScaleRate, Delta);
        Mesh.SetScale(FinalMeshScale);
        // End:0x20FF
        if(ArmMeshComp != none)
        {
            ArmMeshComp.SetScale(FinalMeshScale);
        }
    }
    // End:0x2205
    if((DesiredMeshFOV > float(0)) && UDKSkeletalMeshComponent(Mesh).FOV != DesiredMeshFOV)
    {
        FinalMeshFOV = ZoomInterpolation(UDKSkeletalMeshComponent(Mesh).FOV, DesiredMeshFOV, ZoomingFOVRate, Delta);
        UDKSkeletalMeshComponent(Mesh).SetFOV(FinalMeshFOV);
        // End:0x2205
        if(ArmMeshComp != none)
        {
            ArmMeshComp.SetFOV(FinalMeshFOV);
        }
    }
    //return;    
}

simulated function float ZoomInterpolation(float fCurrent, float fDesired, float fRate, float fTimeDelta)
{
    local float Delta;

    // End:0xE8
    if(fRate > 0.0000000)
    {
        Delta = fRate * fTimeDelta;
        // End:0x79
        if(bNonlinearZoomInterpolation)
        {
            fCurrent = FInterpTo(fCurrent, fDesired, fTimeDelta, fRate);            
        }
        else
        {
            // End:0xBC
            if(fCurrent > fDesired)
            {
                fCurrent = FMax(fDesired, fCurrent - Delta);                
            }
            else
            {
                fCurrent = FMin(fDesired, fCurrent + Delta);
            }
        }        
    }
    else
    {
        fCurrent = fDesired;
    }
    return fCurrent;
    //return ReturnValue;    
}

simulated function bool ShouldLagRot()
{
    return true;
    //return ReturnValue;    
}

simulated function int LagRot(int NewValue, int LastValue, float MaxDiff, int Index)
{
    local int RotDiff;
    local float LeadMag, DeltaTime;

    // End:0x49
    if(ClockwiseFrom_IntInt(NewValue, LastValue))
    {
        // End:0x46
        if(LastValue > NewValue)
        {
            LastValue -= 65536;
        }        
    }
    else
    {
        // End:0x70
        if(NewValue > LastValue)
        {
            NewValue -= 65536;
        }
    }
    DeltaTime = WorldInfo.TimeSeconds - LastRotUpdate;
    RotDiff = NewValue - LastValue;
    // End:0x162
    if((RotDiff == 0) || OldRotDiff[Index] == 0)
    {
        LeadMag = ((ShouldLagRot()) ? OldLeadMag[Index] : 0.0000000);
        // End:0x15F
        if((RotDiff == 0) && OldRotDiff[Index] == 0)
        {
            OldMaxDiff[Index] = 0.0000000;
        }        
    }
    else
    {
        // End:0x2CC
        if((RotDiff > 0) == (OldRotDiff[Index] > 0))
        {
            // End:0x231
            if(ShouldLagRot())
            {
                MaxDiff = FMin(1.0000000, Abs(float(RotDiff)) / (float(12000) * DeltaTime)) * MaxDiff;
                OldMaxDiff[Index] = MaxDiff;
                LeadMag = ((NewValue > LastValue) ? float(-1) * MaxDiff : MaxDiff);                
            }
            else
            {
                LeadMag = 0.0000000;
            }
            // End:0x2BA
            if(DeltaTime < (float(1) / RotChgSpeed))
            {
                LeadMag = ((1.0000000 - (RotChgSpeed * DeltaTime)) * OldLeadMag[Index]) + ((RotChgSpeed * DeltaTime) * LeadMag);                
            }
            else
            {
                LeadMag = 0.0000000;
            }            
        }
        else
        {
            LeadMag = 0.0000000;
            OldMaxDiff[Index] = 0.0000000;
            // End:0x34A
            if(DeltaTime < (float(1) / ReturnChgSpeed))
            {
                LeadMag = (1.0000000 - (ReturnChgSpeed * DeltaTime)) * OldLeadMag[Index];
            }
        }
    }
    // End:0x3C8
    if((LeadMag * (LeadMag - ((LagBackSpeed * DeltaTime) * OldLeadMag[Index]))) > float(0))
    {
        LeadMag -= ((LagBackSpeed * DeltaTime) * OldLeadMag[Index]);        
    }
    else
    {
        LeadMag = 0.0000000;
    }
    OldLeadMag[Index] = LeadMag;
    OldRotDiff[Index] = RotDiff;
    return int(float(NewValue) + LeadMag);
    //return ReturnValue;    
}

function AdjustPlayerDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    //return;    
}

function float RelativeStrengthVersus(Pawn P, float Dist)
{
    return 0.0000000;
    //return ReturnValue;    
}

simulated function float GetWeaponRating()
{
    // End:0x33
    if((Instigator == none) || !HasAnyAmmo())
    {
        CurrentRating = Priority;
    }
    return CurrentRating;
    //return ReturnValue;    
}

function bool CanAttack(Actor Other)
{
    local float Dist, CheckDist, OtherHeight;
    local Vector HitLocation, HitNormal, projStart, TargetLoc;
    local Actor HitActor, TestActor;
    local class<Projectile> ProjClass;
    local int I;

    // End:0x37
    if((Instigator == none) || Instigator.Controller == none)
    {
        return false;
    }
    Dist = VSize(Instigator.Location - Other.Location);
    // End:0x9B
    if(Dist > (MaxRange()))
    {
        return false;
    }
    projStart = ((bInstantHit) ? InstantFireStartTrace() : GetPhysicalFireStartLoc());
    // End:0x17B
    if(!Instigator.Controller.LineOfSightTo(Other, projStart))
    {
        // End:0x17B
        if(!Other.bHasAlternateTargetLocation || !Instigator.Controller.LineOfSightTo(Other, projStart, true))
        {
            return false;
        }
    }
    // End:0x2C2
    if(!bInstantHit)
    {
        ProjClass = GetProjectileClass();
        // End:0x20D
        if(ProjClass == none)
        {
            I = 0;
            J0x1B8:

            // End:0x20D [Loop If]
            if(I < WeaponProjectiles.Length)
            {
                ProjClass = WeaponProjectiles[I];
                // End:0x1FF
                if(ProjClass != none)
                {
                    // [Explicit Break]
                    goto J0x20D;
                }
                I++;
                // [Loop Continue]
                goto J0x1B8;
            }
        }
        J0x20D:

        // End:0x22E
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
    TargetLoc = Other.GetTargetLocation(Instigator);
    // End:0x36D
    if(Pawn(Other) != none)
    {
        OtherHeight = Pawn(Other).GetCollisionHeight();
        TargetLoc.Z += (0.9000000 * OtherHeight);
    }
    // End:0x3C8
    if(bInstantHit)
    {
        HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, TargetLoc, projStart, true,,, 1);        
    }
    else
    {
        // End:0x4C4
        foreach GetTraceOwner().TraceActors(Class'Engine.Actor', TestActor, HitLocation, HitNormal, TargetLoc, projStart,,, 1)
        {
            // End:0x4C3
            if((TestActor.bBlockActors || TestActor.bProjTarget) && (VSize(HitLocation - projStart) <= CheckDist) || TestActor.IsStationary())
            {
                HitActor = TestActor;
                // End:0x4C4
                break;
            }            
        }        
    }
    // End:0x58A
    if((((HitActor == none) || HitActor == Other) || !HitActor.IsA('Pawn') && !HitActor.IsA('EvilGameObjective')) || !WorldInfo.GRI.OnSameTeam(Instigator, HitActor))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
    //return ReturnValue;    
}

function float GetDamageRadius()
{
    local class<Projectile> CurrentProjectileClass;

    CurrentProjectileClass = GetProjectileClass();
    // End:0x29
    if(CurrentProjectileClass == none)
    {
        return 0.0000000;
    }
    return CurrentProjectileClass.default.DamageRadius;
    //return ReturnValue;    
}

function bool CanHeal(Actor Other)
{
    return false;
    //return ReturnValue;    
}

function float GetOptimalRangeFor(Actor Target)
{
    return MaxRange();
    //return ReturnValue;    
}

function bool FireOnRelease()
{
    return int(ShouldFireOnRelease[int(CurrentFireMode)]) != int(0);
    //return ReturnValue;    
}

function bool FocusOnLeader(bool bLeaderFiring)
{
    return false;
    //return ReturnValue;    
}

function bool RecommendRangedAttack()
{
    return false;
    //return ReturnValue;    
}

function float SuggestAttackStyle()
{
    return 0.0000000;
    //return ReturnValue;    
}

function float SuggestDefenseStyle()
{
    return 0.0000000;
    //return ReturnValue;    
}

function float RangedAttackTime()
{
    return 0.0000000;
    //return ReturnValue;    
}

function bool SplashJump()
{
    return bSplashJump;
    //return ReturnValue;    
}

function bool ShouldFireWithoutTarget()
{
    return false;
    //return ReturnValue;    
}

function byte BestMode()
{
    local byte Best;

    // End:0x17
    if(IsFiring())
    {
        return CurrentFireMode;
    }
    // End:0x2F
    if(FRand() < 0.5000000)
    {
        Best = 1;
    }
    // End:0x71
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

function bool IsFullyCharged()
{
    return false;
    //return ReturnValue;    
}

simulated function bool ReadyToFire(bool bFinished)
{
    return false;
    //return ReturnValue;    
}

simulated function bool StillFiring(byte FireMode)
{
    return super(Weapon).StillFiring(FireMode);
    //return ReturnValue;    
}

function ConsumeAmmo(byte FireModeNum)
{
    local GameReplicationInfo GRI;

    GRI = WorldInfo.GRI;
    AddAmmoForFireMode(FireModeNum, -ShotCost[int(FireModeNum)]);
    // End:0xAD
    if((GRI == none) || !GRI.IsCoopMultiplayerGame() && GRI.IsMultiplayerGame())
    {
        return;
    }
    // End:0xF4
    if(((float(AmmoCount) / float(MaxAmmoCount)) < 0.1000000) && !IsTimerActive('ShowLowAmmoWarning'))
    {
        ShowLowAmmoWarning();
    }
    //return;    
}

function int AddAmmoForFireMode(byte FireModeNum, int Amount)
{
    // End:0x4B
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        return AddAmmo(Amount);
    }
    return -1;
    //return ReturnValue;    
}

function int AddAmmo(int Amount)
{
    local int OldAmmo;

    OldAmmo = AmmoCount;
    AmmoCount = Clamp(AmmoCount + Amount, 0, MaxAmmoCount);
    // End:0x83
    if((EvilInvManager == none) || EvilInvManager.bInfiniteAmmo)
    {
        AmmoCount = MaxAmmoCount;
    }
    // End:0x167
    if((((EvilPawn(Owner) != none) && (!UsesOffhand && EvilPawn(Owner).Weapon == self) || UsesOffhand && EvilPawn(Owner).WeaponLeft == self) && OldAmmo == 0) && Amount > 0)
    {
        EvilPawn(Owner).DoReload(true);        
    }
    else
    {
        // End:0x1CE
        if(((Amount < 0) && Amount == -ShotCost[0]) || Amount == 1)
        {
            MagazineAmmoCount = Clamp(MagazineAmmoCount + Amount, 0, MagazineMaxAmmoCount);
        }
    }
    return AmmoCount;
    //return ReturnValue;    
}

simulated function int GetAmmoCount(byte FireModeNum)
{
    // End:0x41
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        return AmmoCount;
    }
    return -1;
    //return ReturnValue;    
}

simulated function int GetMaxAmmoCount(byte FireModeNum)
{
    // End:0x41
    if((int(FireModeNum) < ShotCost.Length) && ShotCost[int(FireModeNum)] > 0)
    {
        return MaxAmmoCount;
    }
    return -1;
    //return ReturnValue;    
}

simulated function bool AmmoMaxed(int Mode)
{
    return AmmoCount >= MaxAmmoCount;
    //return ReturnValue;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    // End:0x34
    if(Amount == 0)
    {
        return AmmoCount >= ShotCost[int(FireModeNum)];        
    }
    else
    {
        return AmmoCount >= Amount;
    }
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    return (AmmoCount > 0) || (ShotCost[0] == 0) && ShotCost[1] == 0;
    //return ReturnValue;    
}

simulated function float DesireAmmo(bool bDetour)
{
    return 1.0000000 - (float(AmmoCount) / float(MaxAmmoCount));
    //return ReturnValue;    
}

simulated function bool NeedAmmo()
{
    return AmmoCount < MaxAmmoCount;
    //return ReturnValue;    
}

simulated function bool NeedAmmoForFireMode(int FireModeNum)
{
    return NeedAmmo();
    //return ReturnValue;    
}

simulated function bool NeedAmmoMag()
{
    return MagazineAmmoCount < MagazineMaxAmmoCount;
    //return ReturnValue;    
}

simulated function bool IsMagazineEmpty()
{
    return MagazineAmmoCount == 0;
    //return ReturnValue;    
}

simulated function Loaded(optional bool bUseWeaponMax)
{
    local int I;

    I = 0;
    J0x0C:

    // End:0x70 [Loop If]
    if(I < ShotCost.Length)
    {
        AddAmmoForFireMode(byte(I), ((bUseWeaponMax) ? GetMaxAmmoCount(byte(I)) : 999));
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

simulated function Unloaded()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x5D [Loop If]
    if(I < ShotCost.Length)
    {
        AddAmmoForFireMode(byte(I), -GetMaxAmmoCount(byte(I)));
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    local DroppedPickup DP;

    // End:0x165
    if(ItemClass == Class)
    {
        DP = DroppedPickup(Pickup);
        // End:0xF4
        if(DP != none)
        {
            // End:0x70
            if(DP.Instigator == Instigator)
            {
                return true;
            }
            AddAmmo(EvilWeap_Base(DP.Inventory).AmmoCount);
            DP.PickedUpBy(Instigator);
            AnnouncePickup(Instigator);            
        }
        else
        {
            AddAmmo(default.AmmoCount);
            // End:0x150
            if(PickupFactory(Pickup) != none)
            {
                PickupFactory(Pickup).PickedUpBy(Instigator);
            }
            AnnouncePickup(Instigator);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function WeaponEmpty()
{
    // End:0x1B
    if(IsFiring())
    {
        GotoState('Active');
    }
    // End:0x96
    if(((Instigator != none) && Instigator.IsLocallyControlled()) && !HasAnyAmmo())
    {
        Instigator.InvManager.SwitchToBestWeapon(true);
    }
    //return;    
}

simulated function bool bReadyToFire()
{
    return true;
    //return ReturnValue;    
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent)
{
    local ImpactInfo CurrentImpact;
    local bool bOldBlockActors, bOldCollideActors;
    local EvilPhysicalMaterialPropertyBase PhysMatProp;

    CurrentImpact = super(Weapon).CalcWeaponFire(StartTrace, EndTrace, ImpactList, Extent);
    // End:0x2A3
    if(CurrentImpact.HitInfo.PhysMaterial != none)
    {
        PhysMatProp = EvilPhysicalMaterialPropertyBase(CurrentImpact.HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'EvilPhysicalMaterialPropertyBase'));
        // End:0x2A3
        if((PhysMatProp != none) && PhysMatProp.PassThroughDamping < 1.0000000)
        {
            CurrentImpact.HitActor.bProjTarget = false;
            bOldCollideActors = CurrentImpact.HitActor.bCollideActors;
            bOldBlockActors = CurrentImpact.HitActor.bBlockActors;
            CurrentImpact.HitActor.SetCollision(false, false);            
            CalcWeaponFire(CurrentImpact.HitLocation, EndTrace, ImpactList, Extent);
            CurrentImpact.HitActor.bProjTarget = true;
            CurrentImpact.HitActor.SetCollision(bOldCollideActors, bOldBlockActors);
        }
    }
    return CurrentImpact;
    //return ReturnValue;    
}

simulated function Vector InstantFireStartTrace()
{
    return Instigator.GetWeaponStartTraceLocation(self);
    //return ReturnValue;    
}

simulated function Vector InstantFireEndTrace(Vector StartTrace)
{
    return StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
    //return ReturnValue;    
}

simulated function InstantFire()
{
    local int K;
    local Vector StartTrace, EndTrace;
    local array<ImpactInfo> ImpactList;
    local ImpactInfo RealImpact, NearImpact;
    local int I, FinalImpactIndex;
    local array<Vector> FlashLocationArray;
    local float OldSpread;
    local EvilPlayerController EvilPC;
    local float CurrentBulletPower;
    local EvilPhysicalMaterialPropertyBase PhysProp;

    EvilPC = ((Instigator != none) ? EvilPlayerController(Instigator.Controller) : none);
    ActorHitWithCurrentShot.Length = 0;
    K = 0;
    J0x5A:

    // End:0x4CB [Loop If]
    if(K < NumberOfShots[int(CurrentFireMode)])
    {
        // End:0x123
        if((NumberOfShots[int(CurrentFireMode)] > 1) && EvilPC != none)
        {
            // End:0xF5
            if(K == 0)
            {
                OldSpread = Spread[int(CurrentFireMode)];
                Spread[int(CurrentFireMode)] = 0.0000000;                
            }
            else
            {
                // End:0x123
                if(K == 1)
                {
                    Spread[int(CurrentFireMode)] = OldSpread;
                }
            }
        }
        ImpactList.Remove(0, ImpactList.Length);
        StartTrace = InstantFireStartTrace();
        EndTrace = InstantFireEndTrace(StartTrace);
        bUsingAimingHelp = false;
        RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
        FinalImpactIndex = ImpactList.Length - 1;
        // End:0x299
        if((FinalImpactIndex >= 0) && (RealImpact.HitActor == none) || !RealImpact.HitActor.bProjTarget)
        {
            NearImpact = InstantAimHelp(StartTrace, EndTrace, RealImpact);
            // End:0x299
            if(NearImpact.HitActor != none)
            {
                bUsingAimingHelp = true;
                RealImpact = NearImpact;
            }
        }
        // End:0x30A
        if(EqualEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)) && RealImpact.HitActor != none)
        {
            EvilProcessInstantHit(CurrentFireMode, RealImpact, 1.0000000);            
        }
        else
        {
            CurrentBulletPower = 1.0000000;
            I = 0;
            J0x324:

            // End:0x494 [Loop If]
            if(I < ImpactList.Length)
            {
                // End:0x446
                if((I > 0) && ImpactList[I - 1].HitInfo.PhysMaterial != none)
                {
                    PhysProp = EvilPhysicalMaterialPropertyBase(ImpactList[I - 1].HitInfo.PhysMaterial.GetPhysicalMaterialProperty(Class'EvilPhysicalMaterialPropertyBase'));
                    // End:0x446
                    if(PhysProp != none)
                    {
                        CurrentBulletPower = FMax(0.0000000, CurrentBulletPower - PhysProp.PassThroughDamping);
                    }
                }
                // End:0x486
                if(CurrentBulletPower > float(0))
                {
                    EvilProcessInstantHit(CurrentFireMode, ImpactList[I], CurrentBulletPower);
                }
                I++;
                // [Loop Continue]
                goto J0x324;
            }
        }
        FlashLocationArray.AddItem(RealImpact.HitLocation);
        K++;
        // [Loop Continue]
        goto J0x5A;
    }
    SetFlashLocationArray(FlashLocationArray);
    //return;    
}

static function bool FindNearestBone(EvilPawn Victim, Vector InitialHitLocation, out name BestBone, out Vector BestHitLocation, out array<name> AcceptedBoneNames)
{
    local int I, J, Dist, bestDist;
    local Vector BoneLoc;
    local name BoneName;
    local bool bAcceptedBoneNameFound;

    // End:0x35C
    if((Victim != none) && Victim.Mesh.PhysicsAsset != none)
    {
        I = 0;
        J0x55:

        // End:0x343 [Loop If]
        if(I < Victim.Mesh.PhysicsAsset.BodySetup.Length)
        {
            BoneName = Victim.Mesh.PhysicsAsset.BodySetup[I].BoneName;
            // End:0x335
            if((BoneName != 'None') && Victim.Mesh.MatchRefBone(BoneName) != -1)
            {
                // End:0x20C
                if(AcceptedBoneNames.Length > 0)
                {
                    bAcceptedBoneNameFound = false;
                    J = 0;
                    J0x1A4:

                    // End:0x1FA [Loop If]
                    if(J < AcceptedBoneNames.Length)
                    {
                        // End:0x1EC
                        if(BoneName == AcceptedBoneNames[J])
                        {
                            bAcceptedBoneNameFound = true;
                            // [Explicit Break]
                            goto J0x1FA;
                        }
                        J++;
                        // [Loop Continue]
                        goto J0x1A4;
                    }
                    J0x1FA:

                    // End:0x20C
                    if(!bAcceptedBoneNameFound)
                    {
                        // [Explicit Continue]
                        goto J0x335;
                    }
                }
                BoneLoc = Victim.Mesh.GetBoneLocation(BoneName);
                Dist = int(VSize(InitialHitLocation - BoneLoc));
                // End:0x335
                if((I == 0) || Dist < bestDist)
                {
                    bestDist = Dist;
                    BestBone = Victim.Mesh.PhysicsAsset.BodySetup[I].BoneName;
                    BestHitLocation = BoneLoc;
                }
            }
            J0x335:

            I++;
            // [Loop Continue]
            goto J0x55;
        }
        // End:0x35C
        if(BestBone != 'None')
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function ImpactInfo InstantAimHelp(Vector StartTrace, Vector EndTrace, ImpactInfo RealImpact)
{
    local ImpactInfo NearImpact;
    local Pawn ShotTarget;
    local EvilPlayerController UTPC;
    local Controller C;
    local float AimHelpDist;
    local Vector ClosestPoint;
    local name BestBone;
    local array<name> AcceptedBoneNames;

    NearImpact.HitActor = none;
    C = ((Instigator != none) ? Instigator.Controller : none);
    UTPC = EvilPlayerController(C);
    // End:0xB4
    if((UTPC != none) && !UTPC.AimingHelp(true))
    {
        return NearImpact;
    }
    // End:0x61D
    if(((C != none) && C.ShotTarget != none) && (AimingHelpRadius[Min(int(CurrentFireMode), 1)] > 0.0000000) || !C.bIsPlayer && EvilPawn(Instigator).NPCAimingHelpRadius > 0.0000000)
    {
        ShotTarget = C.ShotTarget;
        // End:0x1D6
        if(RealImpact.HitActor != none)
        {
            EndTrace = RealImpact.HitLocation;
        }
        // End:0x61D
        if(((EndTrace - ShotTarget.Location) Dot (ShotTarget.Location - StartTrace)) > float(0))
        {
            PointDistToLine(ShotTarget.Location, EndTrace - StartTrace, StartTrace, ClosestPoint);
            AimHelpDist = (((UTPC != none) ? UTPC.AimHelpModifier() : 1.0000000) * ((C.bIsPlayer) ? AimingHelpRadius[Min(int(CurrentFireMode), 1)] : EvilPawn(Instigator).NPCAimingHelpRadius)) * Class'EvilProjectile_Base'.default.GlobalCheckRadiusTweak;
            // End:0x39A
            if(ShotTarget.Velocity == vect(0.0000000, 0.0000000, 0.0000000))
            {
                AimHelpDist *= ((UTPC != none) ? 0.5000000 : 1.0000000);
            }
            // End:0x61D
            if((Abs(ClosestPoint.Z - ShotTarget.Location.Z) < (ShotTarget.CylinderComponent.CollisionHeight + AimHelpDist)) && VSize2D(ClosestPoint - ShotTarget.Location) < (ShotTarget.CylinderComponent.CollisionRadius + AimHelpDist))
            {
                NearImpact.HitActor = ShotTarget;
                NearImpact.HitLocation = ClosestPoint;
                NearImpact.HitNormal = Normal(EndTrace - StartTrace);
                NearImpact.StartTrace = StartTrace;
                NearImpact.RayDir = Normal(EndTrace - StartTrace);
                FindNearestBone(EvilPawn(ShotTarget), NearImpact.HitLocation, BestBone, NearImpact.HitLocation, AcceptedBoneNames);
                NearImpact.HitInfo.BoneName = BestBone;
            }
        }
    }
    return NearImpact;
    //return ReturnValue;    
}

simulated function Projectile ProjectileFire()
{
    local Vector RealStartLoc;
    local Projectile SpawnedProjectile;

    IncrementFlashCountEvil();
    // End:0x13B
    if(int(Role) == int(ROLE_Authority))
    {
        RealStartLoc = GetPhysicalFireStartLoc();
        SpawnedProjectile = Spawn(GetProjectileClass(),,, RealStartLoc);
        // End:0x131
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Damage = WeaponDamage[int(CurrentFireMode)];
            SpawnedProjectile.MomentumTransfer = WeaponMomentum[int(CurrentFireMode)];
            SpawnedProjectile.Init(Vector(GetAdjustedAim(RealStartLoc)));
        }
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    EvilProcessInstantHit(FiringMode, Impact, 1.0000000);
    //return;    
}

simulated function EvilProcessInstantHit(byte FiringMode, ImpactInfo Impact, float BulletPower)
{
    local bool bFixMomentum;
    local float SaveMomentum, Distance, SaveDamage;
    local KActorFromStatic NewKActor;
    local editinline StaticMeshComponent HitStaticMesh;

    // End:0x40D
    if(Impact.HitActor != none)
    {
        // End:0x133
        if(Impact.HitActor.bWorldGeometry)
        {
            HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
            // End:0x133
            if((HitStaticMesh != none) && HitStaticMesh.CanBecomeDynamic())
            {
                NewKActor = Class'Engine.KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
                // End:0x133
                if(NewKActor != none)
                {
                    Impact.HitActor = NewKActor;
                }
            }
        }
        // End:0x40D
        if(!Impact.HitActor.bStatic && Impact.HitActor != Instigator)
        {
            CheckAndUpdateHitEnemyIndicator(Impact.HitActor);
            SaveMomentum = InstantHitMomentum[int(FiringMode)];
            SaveDamage = InstantHitDamage[int(FiringMode)];
            // End:0x26B
            if((EvilPawn(Impact.HitActor) == none) && InstantHitMomentum[int(FiringMode)] == float(0))
            {
                InstantHitMomentum[int(FiringMode)] = 1.0000000;
                bFixMomentum = true;
            }
            // End:0x2B9
            if(ActorHitWithCurrentShot.Find(Impact.HitActor) != -1)
            {
                InstantHitMomentum[int(FiringMode)] = 1.0000000;
            }
            Distance = VSize(Impact.HitLocation - (InstantFireStartTrace()));
            // End:0x34A
            if(Distance < WeaponCloseDamageDistance)
            {
                InstantHitDamage[int(FiringMode)] *= ((((float(1) - WeaponCloseDamageMaxMultiplier) / WeaponCloseDamageDistance) * Distance) + WeaponCloseDamageMaxMultiplier);
            }
            InstantHitDamage[int(FiringMode)] *= BulletPower;
            InstantHitMomentum[int(FiringMode)] *= BulletPower;
            ProcessInstantHit(FiringMode, Impact, 1);
            InstantHitDamage[int(FiringMode)] = SaveDamage;
            InstantHitMomentum[int(FiringMode)] = SaveMomentum;
            // End:0x40D
            if(bFixMomentum)
            {
                InstantHitMomentum[int(FiringMode)] = 0.0000000;
            }
        }
    }
    // End:0x4C2
    if((SmokeTracePS != none) && EqualEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)))
    {
        WorldInfo.MyEmitterPool.SpawnEmitter(SmokeTracePS, Impact.StartTrace, Rotator(Impact.RayDir));
    }
    ActorHitWithCurrentShot.AddItem(Impact.HitActor);
    //return;    
}

simulated function CheckAndUpdateHitEnemyIndicator(Actor HitActor)
{
    // End:0x22C
    if(((((((((((int(HitActor.Role) == int(ROLE_Authority)) && HitActor.bProjTarget) && !WorldInfo.GRI.OnSameTeam(Instigator, HitActor)) && HitActor.Instigator != Instigator) && PhysicsVolume(HitActor) == none) && !PassThroughDamage(HitActor)) && (EvilPawn(HitActor) == none) || (EvilPawn(HitActor) != none) && EvilPawn(HitActor).IsAliveAndWell()) && !HitActor.IsA('EvilUsableTriggerSwitch')) && !HitActor.IsA('KActor')) && !HitActor.IsA('KAsset')) && !HitActor.IsA('FracturedStaticMeshActor'))
    {
        HitEnemy++;
        LastHitEnemyTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

simulated function EvilWeap_Base.EZoomState GetZoomedState()
{
    local PlayerController PC;

    PC = PlayerController(Instigator.Controller);
    // End:0x112
    if((PC != none) && PC.GetFOVAngle() != PC.DefaultFOV)
    {
        // End:0xC9
        if(PC.GetFOVAngle() == PC.DesiredFOV)
        {
            return 3;
        }
        return ((PC.GetFOVAngle() < PC.DesiredFOV) ? 1 : 2);
    }
    return 0;
    //return ReturnValue;    
}

simulated function bool CheckZoom(byte FireModeNum)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0x187
    if(((PC != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
    {
        EndFire(FireModeNum);
        // End:0x185
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            // End:0x119
            if(int(GetZoomedState()) == int(NM_Client))
            {
                ZoomedFireModeNum = 255;
                EndZoom(PC);
                // End:0x116
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerEndZoom(PC);
                }                
            }
            else
            {
                // End:0x185
                if(int(GetZoomedState()) == int(0))
                {
                    ZoomedFireModeNum = FireModeNum;
                    StartZoom(PC);
                    // End:0x185
                    if(int(Role) < int(ROLE_Authority))
                    {
                        ServerStartZoom(PC, FireModeNum);
                    }
                }
            }
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

reliable server function ServerStartZoom(EvilPlayerController PC, byte FireModeNum)
{
    ZoomedFireModeNum = FireModeNum;
    StartZoom(PC);
    //return;    
}

simulated function StartZoom(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    local int I;

    // End:0xBD
    if((((!BothHandWeapon && !UsesOffhand) && Instigator != none) && EvilWeap_Base(Instigator.WeaponLeft) != none) && !bZoomSyncFromOther)
    {
        EvilWeap_Base(Instigator.WeaponLeft).StartZoom(PC, true);
    }
    // End:0xFD
    if(!bZoomSyncFromOther)
    {
        PC.StartZoom(ZoomedTargetFOV, ZoomedRate);
    }
    // End:0x120
    if(ZoomInSound != none)
    {
        WeaponPlaySound(ZoomInSound);
    }
    DesiredMeshTranslation = ZoomedMeshTranslation;
    DesiredMeshRotation = ZoomedMeshRotation;
    DesiredMeshScale = ZoomedMeshScale;
    DesiredMeshFOV = ZoomedMeshFOV;
    ZoomingTranslationRate = default.ZoomingTranslationRate;
    ZoomingRotationRate = default.ZoomingRotationRate;
    ZoomingScaleRate = default.ZoomingScaleRate;
    I = 0;
    J0x1B0:

    // End:0x208 [Loop If]
    if(I < WeaponSpread.Length)
    {
        Spread[I] = WeaponSpread[I] * ZoomedSpreadMult;
        I++;
        // [Loop Continue]
        goto J0x1B0;
    }
    MoveSpreadMultiplier = 1.0000000;
    SprintSpreadMultiplier = 1.0000000;
    JumpSpreadMultiplier = 1.0000000;
    ShotSpreadModifier = 0.0000000;
    BackForceVector = vect(0.0000000, 0.0000000, 0.0000000);
    ShotDistortionVector = vect(0.0000000, 0.0000000, 0.0000000);
    RecoilDelta = default.RecoilDelta * ZoomedRecoilMult;
    WeaponIdleAnims = ZoomedWeaponIdleAnims;
    WeaponFireAnim = ZoomedWeaponFireAnim;
    ArmIdleAnims = ZoomedArmIdleAnims;
    ArmFireAnim = ZoomedArmFireAnim;
    BobDamping = ZoomedBobDamping;
    JumpDamping = ZoomedJumpDamping;
    LagBackSpeed = ZoomedLagBackSpeed;
    // End:0x330
    if(IsInState('Active'))
    {
        RestartIdleAnim();
    }
    // End:0x34B
    if(!ZoomedCrosshair)
    {
        bDisplayCrosshair = false;
    }
    OldMovementSpeedModifier = PC.MyEvilPawn.MovementSpeedModifier;
    // End:0x3FC
    if(PC.MyEvilPawn.CanModifyMovementSpeed())
    {
        PC.MyEvilPawn.ChangeSpeedModifier(ZoomedMovementSpeedModifier);
    }
    PC.NotifyWeaponZooming(true);
    //return;    
}

reliable server function ServerEndZoom(EvilPlayerController PC)
{
    ZoomedFireModeNum = 255;
    EndZoom(PC);
    //return;    
}

simulated function EndZoomWorker(EvilPlayerController PC)
{
    local int I;

    DesiredMeshTranslation = vect(0.0000000, 0.0000000, 0.0000000);
    DesiredMeshRotation = rot(0, 0, 0);
    DesiredMeshScale = Mesh.default.Scale;
    DesiredMeshFOV = UDKSkeletalMeshComponent(Mesh).default.FOV;
    I = 0;
    J0x92:

    // End:0xDF [Loop If]
    if(I < WeaponSpread.Length)
    {
        Spread[I] = WeaponSpread[I];
        I++;
        // [Loop Continue]
        goto J0x92;
    }
    MoveSpreadMultiplier = default.MoveSpreadMultiplier;
    SprintSpreadMultiplier = default.SprintSpreadMultiplier;
    JumpSpreadMultiplier = default.JumpSpreadMultiplier;
    ShotSpreadModifier = default.ShotSpreadModifier;
    BackForceVector = default.BackForceVector;
    ShotDistortionVector = default.ShotDistortionVector;
    RecoilDelta = default.RecoilDelta;
    CurrentShotCount = 0;
    ShotSpreadHelper = 0.0000000;
    // End:0x196
    if(MoveSpreadState)
    {
        SetSpreadMoving(true);
    }
    // End:0x1AE
    if(SprintSpreadState)
    {
        SetSpreadSprinting(true);
    }
    // End:0x1C6
    if(JumpSpreadState)
    {
        SetSpreadJumping(true);
    }
    WeaponIdleAnims = default.WeaponIdleAnims;
    WeaponFireAnim = default.WeaponFireAnim;
    ArmIdleAnims = default.ArmIdleAnims;
    ArmFireAnim = default.ArmFireAnim;
    BobDamping = default.BobDamping;
    JumpDamping = default.JumpDamping;
    LagBackSpeed = default.LagBackSpeed;
    // End:0x266
    if(IsInState('Active'))
    {
        RestartIdleAnim();
    }
    bDisplayCrosshair = default.bDisplayCrosshair;
    EvilPawn(PC.Pawn).ChangeSpeedModifier(OldMovementSpeedModifier);
    PC.NotifyWeaponZooming(false);
    //return;    
}

simulated function EndZoom(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    // End:0xBD
    if((((!BothHandWeapon && !UsesOffhand) && Instigator != none) && EvilWeap_Base(Instigator.WeaponLeft) != none) && !bZoomSyncFromOther)
    {
        EvilWeap_Base(Instigator.WeaponLeft).EndZoom(PC, true);
    }
    // End:0x112
    if(!bZoomSyncFromOther)
    {
        PC.StartZoom(PC.DefaultFOV, ZoomedRate);
    }
    // End:0x135
    if(ZoomOutSound != none)
    {
        WeaponPlaySound(ZoomOutSound);
    }
    ZoomingTranslationRate = default.ZoomingTranslationRate;
    ZoomingRotationRate = default.ZoomingRotationRate;
    ZoomingScaleRate = default.ZoomingScaleRate;
    EndZoomWorker(PC);
    //return;    
}

simulated function EndZoomInstant(EvilPlayerController PC, optional bool bZoomSyncFromOther = false)
{
    // End:0xBD
    if((((!BothHandWeapon && !UsesOffhand) && Instigator != none) && EvilWeap_Base(Instigator.WeaponLeft) != none) && !bZoomSyncFromOther)
    {
        EvilWeap_Base(Instigator.WeaponLeft).EndZoomInstant(PC, true);
    }
    // End:0xEB
    if(!bZoomSyncFromOther)
    {
        PC.EndZoom();
    }
    ZoomingTranslationRate = 0.0000000;
    ZoomingRotationRate = 0.0000000;
    ZoomingScaleRate = 0.0000000;
    EndZoomWorker(PC);
    //return;    
}

reliable client simulated function ClientEndFire(byte FireModeNum)
{
    // End:0x3C
    if(int(Role) != int(ROLE_Authority))
    {
        ClearPendingFire(int(FireModeNum));
        EndFire(FireModeNum);
    }
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    local EvilPlayerController PC;

    // End:0x106
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && Instigator != none)
    {
        PC = EvilPlayerController(Instigator.Controller);
        // End:0x106
        if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
        {
            PC.StopZoom();
        }
    }
    super(Weapon).EndFire(FireModeNum);
    //return;    
}

simulated function SendToFiringState(byte FireModeNum)
{
    // End:0x3E
    if((int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
    {
        return;
    }
    super(Weapon).SendToFiringState(FireModeNum);
    //return;    
}

simulated function FireAmmunition()
{
    local float logn;

    // End:0xB8
    if((int(CurrentFireMode) >= bZoomedFireMode.Length) || int(bZoomedFireMode[int(CurrentFireMode)]) == int(0))
    {
        PlayFiringSound();
        super(Weapon).FireAmmunition();
        // End:0x90
        if(EvilPawn(Instigator) != none)
        {
            EvilPawn(Instigator).DeactivateSpawnProtection();
        }
        EvilInvManager.OwnerEvent('FiredWeapon');
    }
    CurrentShotCount++;
    ShotSpreadHelper += float(1);
    logn = Loge(float(CurrentShotCount));
    ShotDistortion.X = RandRange(FMax(-logn * ShotDistortionVector.X, -ShotDistortionMax.X), FMin(logn * ShotDistortionVector.X, ShotDistortionMax.X));
    ShotDistortion.Y = RandRange(FMax(-logn * ShotDistortionVector.Y, -ShotDistortionMax.Y), FMin(logn * ShotDistortionVector.Y, ShotDistortionMax.Y));
    ShotDistortion.Z = RandRange(FMax(-logn * ShotDistortionVector.Z, -ShotDistortionMax.Z), FMin(logn * ShotDistortionVector.Z, ShotDistortionMax.Z));
    // End:0x441
    if(((EvilPawn(Owner) != none) && EvilPlayerController(EvilPawn(Owner).Controller) != none) && EvilPlayerReplicationInfo(EvilPlayerController(EvilPawn(Owner).Controller).PlayerReplicationInfo) != none)
    {
        EvilPlayerReplicationInfo(EvilPlayerController(EvilPawn(Owner).Controller).PlayerReplicationInfo).AddShot(((UsesOffhand) ? EvilInvManager.FindOtherHandWeaponFor(self) : self));
    }
    //return;    
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    local Vector X, Y, Z;
    local float CurrentSpread, RandY, RandZ;

    CurrentSpread = GetCurrentSpread(CurrentFireMode);
    // End:0x3B
    if(CurrentSpread == float(0))
    {
        return BaseAim;        
    }
    else
    {
        GetAxes(BaseAim, X, Y, Z);
        RandY = FRand() - 0.5000000;
        RandZ = Sqrt(0.5000000 - Square(RandY)) * (FRand() - 0.5000000);
        return Rotator((X + ((RandY * CurrentSpread) * Y)) + ((RandZ * CurrentSpread) * Z));
    }
    //return ReturnValue;    
}

event bool IsReloading()
{
    return false;
    //return ReturnValue;    
}

simulated function PreloadTextures(bool bForcePreload)
{
    // End:0x6E
    if(UDKSkeletalMeshComponent(Mesh) != none)
    {
        UDKSkeletalMeshComponent(Mesh).PreloadTextures(bForcePreload, WorldInfo.TimeSeconds + float(2));
    }
    //return;    
}

simulated function bool AllowSwitchTo(EvilWeap_Base NewWeapon)
{
    // End:0x97
    if(((NewWeapon == none) || !NewWeapon.bSelectable) || (int(NewWeapon.GetHand()) != int(GetHand())) && int(NewWeapon.GetHand()) > int(1))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool TryPutDown()
{
    local float MinTimerTarget, TimerCount;

    bWeaponPutDown = true;
    // End:0x32
    if(!IsTimerActive('RefireCheckTimer'))
    {
        PutDownWeapon();        
    }
    else
    {
        MinTimerTarget = GetTimerRate('RefireCheckTimer') * MinReloadPct[int(CurrentFireMode)];
        TimerCount = GetTimerCount('RefireCheckTimer');
        // End:0xA9
        if(TimerCount >= MinTimerTarget)
        {
            PutDownWeapon();            
        }
        else
        {
            SetTimer(MinTimerTarget - TimerCount, false, 'FiringPutDownWeapon');
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function FiringPutDownWeapon()
{
    // End:0x17
    if(bWeaponPutDown)
    {
        PutDownWeapon();
    }
    //return;    
}

simulated function Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    local EvilPlayerController PC;
    local Vector FireStartLoc, HitLocation, HitNormal, FireDir, FireEnd, ProjBox;

    local Actor HitActor;
    local Rotator FireRot;
    local class<Projectile> FiredProjectileClass;
    local int TraceFlags;

    // End:0x60D
    if(Instigator != none)
    {
        PC = EvilPlayerController(Instigator.Controller);
        FireRot = Instigator.GetViewRotation();
        FireDir = Vector(FireRot);
        // End:0x11D
        if(((PC == none) || PC.bCenteredWeaponFire) || int(WeaponHand) == int(1))
        {
            FireStartLoc = Instigator.GetPawnViewLocation() + (FireDir * FireOffset.X);            
        }
        else
        {
            // End:0x184
            if(int(WeaponHand) == int(3))
            {
                FireStartLoc = Instigator.GetPawnViewLocation() + ((FireOffset * vect(1.0000000, -1.0000000, 1.0000000)) >> FireRot);                
            }
            else
            {
                FireStartLoc = Instigator.GetPawnViewLocation() + (FireOffset >> FireRot);
            }
        }
        // End:0x603
        if((PC != none) || CustomTimeDilation < 1.0000000)
        {
            FiredProjectileClass = GetProjectileClass();
            // End:0x603
            if(FiredProjectileClass != none)
            {
                FireEnd = FireStartLoc + (FireDir * ProjectileSpawnOffset);
                TraceFlags = ((bCollideComplex) ? 1 : 0);
                // End:0x585
                if(FiredProjectileClass.default.CylinderComponent.CollisionRadius > float(0))
                {
                    FireEnd += (FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X);
                    ProjBox = FiredProjectileClass.default.CylinderComponent.CollisionRadius * vect(1.0000000, 1.0000000, 0.0000000);
                    ProjBox.Z = FiredProjectileClass.default.CylinderComponent.CollisionHeight;
                    HitActor = Trace(HitLocation, HitNormal, FireEnd, Instigator.Location, true, ProjBox,, TraceFlags);
                    // End:0x433
                    if(HitActor == none)
                    {
                        HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, ProjBox,, TraceFlags);                        
                    }
                    else
                    {
                        FireStartLoc = Instigator.Location - (FireDir * FiredProjectileClass.default.CylinderComponent.Translation.X);
                        FireStartLoc.Z = FireStartLoc.Z + FMin(Instigator.EyeHeight, (Instigator.CylinderComponent.CollisionHeight - FiredProjectileClass.default.CylinderComponent.CollisionHeight) - 1.0000000);
                        return FireStartLoc;
                    }                    
                }
                else
                {
                    HitActor = Trace(HitLocation, HitNormal, FireEnd, FireStartLoc, true, vect(0.0000000, 0.0000000, 0.0000000),, TraceFlags);
                }
                return ((HitActor == none) ? FireEnd : HitLocation - (float(3) * FireDir));
            }
        }
        return FireStartLoc;
    }
    return Location;
    //return ReturnValue;    
}

simulated function Vector GetEffectLocation()
{
    local Vector SocketLocation;

    // End:0x40
    if(int(GetHand()) == int(1))
    {
        SocketLocation = Instigator.Location;        
    }
    else
    {
        // End:0xE0
        if((SkeletalMeshComponent(Mesh) != none) && EffectSockets[int(CurrentFireMode)] != 'None')
        {
            // End:0xDD
            if(!SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation(EffectSockets[int(CurrentFireMode)], SocketLocation))
            {
                SocketLocation = Location;
            }            
        }
        else
        {
            // End:0x148
            if(Mesh != none)
            {
                SocketLocation = Mesh.Bounds.Origin + (vect(45.0000000, 0.0000000, 0.0000000) >> Rotation);                
            }
            else
            {
                SocketLocation = Location;
            }
        }
    }
    return SocketLocation;
    //return ReturnValue;    
}

simulated function SetupArmsAnim()
{
    local EvilPawn UTP;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;

    UTP = EvilPawn(Instigator);
    // End:0x109
    if(UTP != none)
    {
        ArmMeshComp = GetArmMeshComponent();
        // End:0x50
        if(ArmMeshComp == none)
        {
            return;
        }
        // End:0xE9
        if(ArmsAnimSet != none)
        {
            ArmMeshComp.AnimSets[1] = ArmsAnimSet;
            ArmMeshComp.SetHidden(false);
            ArmMeshComp.SetLightEnvironment(UTP.LightEnvironment);            
        }
        else
        {
            ArmMeshComp.SetHidden(true);
        }
    }
    //return;    
}

simulated function UDKSkeletalMeshComponent GetArmMeshComponent()
{
    local EvilPawn P;

    P = EvilPawn(Owner);
    // End:0x7F
    if(P != none)
    {
        // End:0x5E
        if(!UsesOffhand)
        {
            return P.ArmsMesh[0];            
        }
        else
        {
            return P.ArmsMesh[1];
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function bool IsPuttingDown()
{
    return false;
    //return ReturnValue;    
}

simulated function AnimNodeSequence GetArmAnimNodeSeq()
{
    local AnimTree Tree;
    local AnimNodeSequence AnimSeq;
    local editinline UDKSkeletalMeshComponent ArmMeshComp;

    // End:0x2F
    if(CustomArmAnimNode != none)
    {
        return CustomArmAnimNode.GetCustomAnimNodeSeq();
    }
    ArmMeshComp = GetArmMeshComponent();
    // End:0x149
    if(ArmMeshComp != none)
    {
        Tree = AnimTree(ArmMeshComp.Animations);
        // End:0x10E
        if(Tree != none)
        {
            AnimSeq = AnimNodeSequence(AnimNodeBlend(Tree.Children[0].Anim).Children[0].Anim);            
        }
        else
        {
            AnimSeq = AnimNodeSequence(ArmMeshComp.Animations);
        }
        return AnimSeq;
    }
    return none;
    //return ReturnValue;    
}

simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
    local AnimTree Tree;
    local AnimNodeSequence AnimSeq;
    local editinline SkeletalMeshComponent SkelMesh;

    // End:0x2F
    if(CustomAnimNode != none)
    {
        return CustomAnimNode.GetCustomAnimNodeSeq();
    }
    SkelMesh = SkeletalMeshComponent(Mesh);
    // End:0x151
    if(SkelMesh != none)
    {
        Tree = AnimTree(SkelMesh.Animations);
        // End:0x116
        if(Tree != none)
        {
            AnimSeq = AnimNodeSequence(AnimNodeBlend(Tree.Children[0].Anim).Children[0].Anim);            
        }
        else
        {
            AnimSeq = AnimNodeSequence(SkelMesh.Animations);
        }
        return AnimSeq;
    }
    return none;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x63
    if(((Instigator != none) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
    {
        PreloadTextures(false);
    }
    super(Weapon).Destroyed();
    //return;    
}

simulated function RestartIdleAnim(optional bool bInstant = false)
{
    //return;    
}

simulated function OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
{
    //return;    
}

simulated function SetWeaponOverlayFlags(UTPawn OwnerPawn)
{
    local MaterialInterface InstanceToUse;
    local byte Flags;
    local int I;
    local UTGameReplicationInfo GRI;

    // End:0x2BB
    if(OwnerPawn != none)
    {
        GRI = UTGameReplicationInfo(WorldInfo.GRI);
        // End:0x140
        if(GRI != none)
        {
            Flags = OwnerPawn.WeaponOverlayFlags;
            I = 0;
            J0x82:

            // End:0x140 [Loop If]
            if(I < GRI.WeaponOverlays.Length)
            {
                // End:0x132
                if((GRI.WeaponOverlays[I] != none) && bool(int(Flags) & (1 << I)))
                {
                    InstanceToUse = GRI.WeaponOverlays[I];
                    // [Explicit Break]
                    goto J0x140;
                }
                I++;
                // [Loop Continue]
                goto J0x82;
            }
        }
        J0x140:

        // End:0x159
        if(InstanceToUse != none)
        {
            CreateOverlayMesh();
        }
        // End:0x2BB
        if(OverlayMesh != none)
        {
            // End:0x266
            if(InstanceToUse != none)
            {
                I = 0;
                J0x182:

                // End:0x1EE [Loop If]
                if(I < OverlayMesh.GetNumElements())
                {
                    OverlayMesh.SetMaterial(I, InstanceToUse);
                    I++;
                    // [Loop Continue]
                    goto J0x182;
                }
                // End:0x263
                if(!OverlayMesh.bAttached)
                {
                    OverlayMesh.SetHidden(Mesh.HiddenGame);
                    AttachComponent(OverlayMesh);
                }                
            }
            else
            {
                // End:0x2BB
                if(OverlayMesh.bAttached)
                {
                    DetachComponent(OverlayMesh);
                    OverlayMesh.SetHidden(true);
                }
            }
        }
    }
    //return;    
}

static function float DetourWeight(Pawn Other, float PathWeight)
{
    return 0.0000000;
    //return ReturnValue;    
}

function bool RecommendLongRangedAttack()
{
    return false;
    //return ReturnValue;    
}

simulated function ThrottleLook(out float aTurn, out float aLookUp)
{
    //return;    
}

simulated function Activate()
{
    SetupArmsAnim();
    super(Weapon).Activate();
    //return;    
}

simulated function PutDownWeapon()
{
    // End:0x87
    if(IsReloading())
    {
        OnReloadEnd(true);
        // End:0x87
        if((EvilPawn(Owner) != none) && EvilPawn(Owner).WaitingForDualReload)
        {
            EvilPawn(Owner).WaitingForDualReload = false;
        }
    }
    EndQuickHideFromNotify();
    GotoState('WeaponPuttingDown');
    //return;    
}

simulated event float GetPowerPerc()
{
    return 0.0000000;
    //return ReturnValue;    
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    local EvilTouchPickUp_WeaponBase Pickup;
    local Rotator Rot;
    local bool SuppressPickupSpawn;
    local int I;

    // End:0x87
    if(IsReloading())
    {
        OnReloadEnd(true);
        // End:0x87
        if((EvilPawn(Owner) != none) && EvilPawn(Owner).WaitingForDualReload)
        {
            EvilPawn(Owner).WaitingForDualReload = false;
        }
    }
    // End:0x98
    if(!CanThrow())
    {
        return;
    }
    // End:0x324
    if((PickupArchetype != none) && !UsesOffhand)
    {
        // End:0x150
        foreach OverlappingActors(Class'EvilTouchPickUp_WeaponBase', Pickup, PickupArchetype.CheckSameDropDistance, StartLocation)
        {
            // End:0x14F
            if(Pickup.WeaponClass == PickupArchetype.WeaponClass)
            {
                SuppressPickupSpawn = true;
                // End:0x150
                break;
            }            
        }        
        // End:0x324
        if(Instigator.IsPlayerPawn() || !SuppressPickupSpawn)
        {
            Rot.Roll = int(float(90) * 182.0444000);
            Rot.Yaw = Rand(65536);
            Pickup = Spawn(Class'EvilTouchPickUp_WeaponBase',,, StartLocation + vect(0.0000000, 0.0000000, 3.0000000), Rot, PickupArchetype);
            // End:0x324
            if(Pickup != none)
            {
                I = 0;
                J0x236:

                // End:0x29A [Loop If]
                if(I < ShotCost.Length)
                {
                    Pickup.AmmoAmount[I] = GetAmmoCount(byte(I));
                    I++;
                    // [Loop Continue]
                    goto J0x236;
                }
                Pickup.MaxPickCount = 1;
                Pickup.SetPhysics(2);
                Pickup.Velocity = StartVelocity;
                Pickup.Instigator = Instigator;
            }
        }
    }
    // End:0x387
    if(((Instigator != none) && Instigator.IsHumanControlled()) && Instigator.IsLocallyControlled())
    {
        PreloadTextures(false);
    }
    super(Weapon).DropFrom(StartLocation, StartVelocity);
    //return;    
}

function ThrowFrom(Vector StartLocation, Vector StartVelocity)
{
    local EvilTouchPickUp_WeaponBase tmpPickupArchetype;

    tmpPickupArchetype = PickupArchetype;
    PickupArchetype = none;
    DropFrom(StartLocation, StartVelocity);
    PickupArchetype = tmpPickupArchetype;
    //return;    
}

reliable client simulated function ClientWeaponThrown()
{
    // End:0x7B
    if((Instigator != none) && EvilPlayerController(Instigator.Controller) != none)
    {
        EvilPlayerController(Instigator.Controller).EndZoom();
    }
    super(Weapon).ClientWeaponThrown();
    //return;    
}

simulated function bool CanViewAccelerationWhenFiring()
{
    return false;
    //return ReturnValue;    
}

simulated function HolderEnteredVehicle()
{
    //return;    
}

simulated function bool CoversScreenSpace(Vector ScreenLoc, Canvas Canvas)
{
    return (ScreenLoc.X > ((float(1) - WeaponCanvasXPct) * Canvas.ClipX)) && ScreenLoc.Y > ((float(1) - WeaponCanvasYPct) * Canvas.ClipY);
    //return ReturnValue;    
}

static simulated function DrawKillIcon(Canvas Canvas, float ScreenX, float ScreenY, float HUDScaleX, float HUDScaleY)
{
    local Color CanvasColor;

    CanvasColor = Canvas.DrawColor;
    Canvas.DrawColor = Class'UTHUD'.default.BlackColor;
    Canvas.DrawColor.A = CanvasColor.A;
    Canvas.SetPos(ScreenX - float(2), ScreenY - float(2));
    Canvas.DrawTile(Class'UTHUD'.default.AltHudTexture, 4.0000000 + (HUDScaleX * float(96)), 4.0000000 + (HUDScaleY * float(64)), default.IconCoordinates.U, default.IconCoordinates.V, default.IconCoordinates.UL, default.IconCoordinates.VL);
    Canvas.DrawColor = Class'UTHUD'.default.WhiteColor;
    Canvas.DrawColor.A = CanvasColor.A;
    Canvas.SetPos(ScreenX, ScreenY);
    Canvas.DrawTile(Class'UTHUD'.default.AltHudTexture, HUDScaleX * float(96), HUDScaleY * float(64), default.IconCoordinates.U, default.IconCoordinates.V, default.IconCoordinates.UL, default.IconCoordinates.VL);
    Canvas.DrawColor = CanvasColor;
    //return;    
}

simulated function bool EnableFriendlyWarningCrosshair()
{
    return true;
    //return ReturnValue;    
}

simulated function bool DoMeleeKick()
{
    // End:0x62
    if(!NeedReload && (!bSuppressAutoReload && MagazineAmmoCount < ShotCost[int(CurrentFireMode)]) && AmmoCount > 0)
    {
        NeedReload = true;
    }
    // End:0x84
    if(!IsInState('MeleeKick'))
    {
        GotoState('MeleeKick');
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
{
    // End:0x6B
    if(!NeedReload && (!bSuppressAutoReload && MagazineAmmoCount < ShotCost[int(CurrentFireMode)]) && AmmoCount > 0)
    {
        NeedReload = true;
    }
    // End:0xA0
    if(!IsInState('QuickHide'))
    {
        QuickHideAnimDuration = HideTime;
        GotoState('QuickHide');
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function EndQuickHide(optional float DrawTime = 0.0000000)
{
    //return;    
}

simulated function EndQuickHideFromNotify()
{
    // End:0x1A
    if(EvilPawn(Owner) == none)
    {
        return;
    }
    // End:0x55
    if(UsesOffhand)
    {
        EvilPawn(Owner).EndQuickHideCurrentWeapon();        
    }
    else
    {
        EvilPawn(Owner).EndQuickHideCurrentWeapon(,,, true);
    }
    //return;    
}

event Jumped()
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0xCE
    if((!IsFrozen && !IsInState('Jumping')) && Instigator.IsPlayerPawn())
    {
        // End:0xCE
        if((PC != none) && JumpStartCameraAnim != none)
        {
            PC.PlayCameraAnim(JumpStartCameraAnim,,, 0.2000000, 0.2000000);
        }
    }
    //return;    
}

event Landed(Vector HitNormal, Actor FloorActor)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0xBA
    if(!IsFrozen && Instigator.IsPlayerPawn())
    {
        // End:0xBA
        if((PC != none) && JumpLandCameraAnim != none)
        {
            PC.PlayCameraAnim(JumpLandCameraAnim,,, 0.2000000, 0.2000000);
        }
    }
    super(Actor).Landed(HitNormal, FloorActor);
    //return;    
}

simulated function IncrementFlashCountEvil(optional bool bIsMelee = false)
{
    // End:0x94
    if(EvilPawn(Instigator) != none)
    {
        EvilPawn(Instigator).SetFiringLeft(self, int(GetHand()) == int(3));
        EvilPawn(Instigator).IncrementFlashCountEvil(self, CurrentFireMode, bIsMelee);
    }
    //return;    
}

simulated function ClearFlashCountEvil(optional bool bIsMelee = false)
{
    // End:0x50
    if(EvilPawn(Instigator) != none)
    {
        EvilPawn(Instigator).ClearFlashCountEvil(self, bIsMelee);
    }
    //return;    
}

function SetFlashLocationArray(array<Vector> HitLocationArray, optional bool bIsMelee = false)
{
    // End:0x9D
    if(EvilPawn(Instigator) != none)
    {
        EvilPawn(Instigator).SetFiringLeft(self, int(GetHand()) == int(3));
        EvilPawn(Instigator).SetFlashLocationArray(self, CurrentFireMode, HitLocationArray, bIsMelee);
    }
    //return;    
}

function SetFlashLocation(Vector HitLocation)
{
    local array<Vector> FlashLocationArray;

    FlashLocationArray.AddItem(HitLocation);
    SetFlashLocationArray(FlashLocationArray);
    //return;    
}

function ClearFlashLocationArray(optional bool bIsMelee = false)
{
    // End:0x50
    if(EvilPawn(Instigator) != none)
    {
        EvilPawn(Instigator).ClearFlashLocationArray(self, bIsMelee);
    }
    //return;    
}

simulated function SetSpreadMoving(bool bState)
{
    local EvilPlayerController PC;

    PC = EvilPlayerController(Instigator.Controller);
    // End:0x8F
    if((PC != none) && (int(PC.bDuck) == int(1)) || !MoveSpreadState && !bState)
    {
        return;
    }
    MoveSpreadState = bState;
    //return;    
}

simulated function SetSpreadJumping(bool bState)
{
    JumpSpreadState = bState;
    //return;    
}

simulated function SetSpreadSprinting(bool bState)
{
    SprintSpreadState = bState;
    //return;    
}

simulated function bool IsReloadNeeded()
{
    return (MagazineAmmoCount != MagazineMaxAmmoCount) && AmmoCount > MagazineAmmoCount;
    //return ReturnValue;    
}

simulated function ReloadWeapon(optional bool bForce = false, optional bool bAlternate = false)
{
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerReloadWeapon();
    }
    // End:0x153
    if(bForce || ((!NeedReload && MagazineAmmoCount != MagazineMaxAmmoCount) && AmmoCount > MagazineAmmoCount) && GetStateName() != 'WeaponFiring')
    {
        NeedReload = true;
        // End:0x130
        if((EvilPlayerController(EvilPawn(Owner).Controller) != none) && EvilPlayerController(EvilPawn(Owner).Controller).bFiringOnZipLine)
        {
            DoQuickHide();
            ReloadAmmo();            
        }
        else
        {
            UseAlternateReloadNext = bAlternate;
            GotoState('ReloadState');
        }
    }
    //return;    
}

reliable server function ServerReloadWeapon()
{
    ReloadWeapon();
    //return;    
}

simulated function StartSprint()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartSprint();
    }
    // End:0x58
    if(IsInState('WeaponFiring'))
    {
        SetTimer((GetFireInterval(CurrentFireMode)) * 0.2500000, false, 'StartSprint');
        return;
    }
    // End:0x72
    if(!SprintSpreadState)
    {
        SetSpreadSprinting(true);
    }
    // End:0x92
    if(!IsInState('SprintState'))
    {
        GotoState('SprintState');
    }
    //return;    
}

reliable server function ServerStartSprint()
{
    StartSprint();
    //return;    
}

simulated function StopSprint()
{
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStopSprint();
    }
    ClearTimer('StartSprint');
    // End:0x4A
    if(SprintSpreadState)
    {
        SetSpreadSprinting(false);
    }
    // End:0x68
    if(IsInState('SprintState', true))
    {
        GotoState('Active');
    }
    //return;    
}

reliable server function ServerStopSprint()
{
    StopSprint();
    //return;    
}

simulated function float GetReloadTime()
{
    return ReloadTime * UpgradeInfo.GetReloadSpeedForLevel(((ReloadSpeedUpgradeLevel > 0) ? ReloadSpeedUpgradeLevel : UpgradeLevelGlobal));
    //return ReturnValue;    
}

simulated event OnReloadStart(bool bResuming)
{
    local EvilPlayerController PC;
    local EvilPawn P;
    local float DesiredRate;

    P = EvilPawn(Owner);
    PC = EvilPlayerController(P.Controller);
    // End:0x239
    if(P != none)
    {
        P.NotifyWeapReloadStart(self);
        // End:0x141
        if(bResuming)
        {
            // End:0x11B
            if((PC != none) && ReloadResumeCameraAnim != none)
            {
                DesiredRate = ReloadResumeCameraAnim.AnimLength / (GetReloadTime());
                PC.PlayCameraAnim(ReloadResumeCameraAnim,, DesiredRate, 0.2000000, 0.2000000);
            }
            // End:0x13E
            if(ReloadResumeSound != none)
            {
                WeaponPlaySound(ReloadResumeSound);
            }            
        }
        else
        {
            // End:0x1D3
            if((PC != none) && ReloadCameraAnim != none)
            {
                DesiredRate = ReloadCameraAnim.AnimLength / (GetReloadTime());
                PC.PlayCameraAnim(ReloadCameraAnim,, DesiredRate, 0.2000000, 0.2000000);
            }
            P.AttachComponent(ReloadSoundComp);
            ReloadSoundComp.Play();
        }
        P.StartReload();
    }
    //return;    
}

simulated event OnReloadEnd(bool bInterrupted)
{
    // End:0x10B
    if(EvilPawn(Owner) != none)
    {
        EvilPawn(Owner).NotifyWeapReloadEnd(self);
        // End:0x10B
        if(EvilPlayerController(EvilPawn(Owner).Controller) != none)
        {
            EvilPlayerReplicationInfo(EvilPlayerController(EvilPawn(Owner).Controller).PlayerReplicationInfo).AddReload(((UsesOffhand) ? EvilInvManager.FindOtherHandWeaponFor(self) : self));
        }
    }
    // End:0x156
    if(bInterrupted)
    {
        ReloadSoundComp.Stop();
        ReloadSoundComp.DetachFromAny();
    }
    //return;    
}

simulated function ReloadAmmoTimer()
{
    //return;    
}

simulated function ReloadTimer()
{
    //return;    
}

simulated function float GetQuickHideDurationForDualReload()
{
    local AnimSequence ReloadSeq;
    local AnimNotifyEvent HideNotify;

    ReloadSeq = SkeletalMeshComponent(Mesh).FindAnimSequence(WeaponReloadAnim);
    // End:0x116
    if(ReloadSeq != none)
    {
        // End:0x115
        foreach ReloadSeq.Notifies(HideNotify)
        {
            // End:0x114
            if((AnimNotify_Script(HideNotify.Notify) != none) && AnimNotify_Script(HideNotify.Notify).NotifyName == 'QuickHideDoneTime')
            {                
                return HideNotify.Time / DefaultAnimSpeed;
            }            
        }        
    }
    return 0.0000000;
    //return ReturnValue;    
}

simulated function bool CheckSkipReloadIfAnimTime(float NormalizedPerc, out float ResumeTime)
{
    local AnimNodeSequence AnimNode;

    AnimNode = GetWeaponAnimNodeSeq();
    // End:0xD6
    if(AnimNode != none)
    {
        // End:0xC5
        if((AnimNode.GetTimeLeft() / AnimNode.GetAnimPlaybackLength()) > (float(1) - NormalizedPerc))
        {
            ResumeTime = AnimNode.GetAnimPlaybackLength() - AnimNode.GetTimeLeft();
            return false;            
        }
        else
        {
            ResumeTime = 0.0000000;
            return true;
        }
    }
    ResumeTime = 0.0000000;
    return true;
    //return ReturnValue;    
}

simulated function HandleFinishedFiring()
{
    // End:0x2A
    if(IsTimerActive('StartSprint'))
    {
        StopFire(CurrentFireMode);
    }
    // End:0x120
    if(NeedReload || (!bSuppressAutoReload && MagazineAmmoCount < ShotCost[int(CurrentFireMode)]) && AmmoCount > 0)
    {
        // End:0x11D
        if((EvilPawn(Owner) != none) && (EvilPawn(Owner).Weapon == self) || EvilPawn(Owner).WeaponLeft == self)
        {
            EvilPawn(Owner).DoReload();
        }        
    }
    else
    {
        // End:0x13C
        if(!HasAnyAmmo())
        {
            WeaponEmpty();            
        }
        else
        {
            GotoState('Active');
        }
    }
    //return;    
}

function ReloadAmmo()
{
    // End:0x2D
    if(AmmoCount > MagazineMaxAmmoCount)
    {
        MagazineAmmoCount = MagazineMaxAmmoCount;        
    }
    else
    {
        MagazineAmmoCount = AmmoCount;
    }
    //return;    
}

simulated function AltCooldownTimer()
{
    ClearTimer('AltCooldownTimer');
    IsAltInCooldown = false;
    //return;    
}

simulated function bool ShouldRefire()
{
    local bool bResult;

    // End:0x25
    if(MagazineAmmoCount < ShotCost[int(CurrentFireMode)])
    {
        return false;
    }
    // End:0x3E
    if(IsTimerActive('StartSprint'))
    {
        return false;
    }
    // End:0xB5
    if(int(CurrentFireMode) == int(1))
    {
        // End:0x64
        if(IsAltInCooldown == true)
        {
            return false;
        }
        // End:0xB5
        if(!IsTimerActive('AltCooldownTimer') && BlockingAltTime > float(0))
        {
            SetTimer(BlockingAltTime, false, 'AltCooldownTimer');
            IsAltInCooldown = true;
            return false;
        }
    }
    bResult = super(Weapon).ShouldRefire();
    // End:0x127
    if(bResult && EvilPawn(Owner) != none)
    {
        bResult = !EvilPawn(Owner).DualWieldRefireNotify(self);
    }
    return bResult;
    //return ReturnValue;    
}

reliable server function ServerStartFire(byte FireModeNum)
{
    // End:0x57
    if(((Instigator == none) || Instigator.Controller != none) || bAllowFiringWithoutController)
    {
        super(Weapon).ServerStartFire(FireModeNum);
    }
    //return;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0x1C
    if(int(FireModeNum) >= ShotCost.Length)
    {
        return;
    }
    // End:0xA0
    if(int(FireModeNum) == int(1))
    {
        // End:0x51
        if((IsAltInCooldown == true) || NeedReload)
        {
            return;
        }
        // End:0xA0
        if(!IsTimerActive('AltCooldownTimer') && BlockingAltTime > float(0))
        {
            SetTimer(BlockingAltTime, false, 'AltCooldownTimer');
            IsAltInCooldown = true;
        }
    }
    super(Weapon).StartFire(FireModeNum);
    //return;    
}

simulated function ShowLowAmmoWarning()
{
    // End:0x40
    if(IsTimerActive('ShowLowAmmoWarning'))
    {
        WeaponPlaySound(WeaponLowAmmoSound);
        SetTimer(1.0000000, true, 'ShowLowAmmoWarning');
        return;
    }
    // End:0x62
    if(WeaponLowAmmoSound != none)
    {
        SetTimer(0.1000000, true, 'ShowLowAmmoWarning');
    }
    // End:0x8E
    if(!IsTimerActive('HideLowAmmoWarning'))
    {
        SetTimer(3.0000000, false, 'HideLowAmmoWarning');
    }
    //return;    
}

simulated function HideLowAmmoWarning()
{
    ClearTimer('ShowLowAmmoWarning');
    //return;    
}

simulated function ShowNoAmmoWarning()
{
    // End:0x23
    if(WeaponOutOfAmmoSound != none)
    {
        WeaponPlaySound(WeaponOutOfAmmoSound);
    }
    // End:0x4F
    if(!IsTimerActive('HideNoAmmoWarning'))
    {
        SetTimer(1.0000000, false, 'HideNoAmmoWarning');
    }
    //return;    
}

simulated function HideNoAmmoWarning()
{
    //return;    
}

auto simulated state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        // End:0x16A
        if(Instigator != none)
        {
            PC = EvilPlayerController(Instigator.Controller);
            // End:0xBB
            if((PC != none) && LocalPlayer(PC.Player) != none)
            {
                PC.SetFOV(PC.DefaultFOV);
            }
            // End:0x16A
            if((PC != none) && PC.MyEvilPawn.CanModifyMovementSpeed())
            {
                PC.MyEvilPawn.ChangeSpeedModifier(PC.MyEvilPawn.default.MovementSpeedModifier);
            }
        }
        super.BeginState(PreviousStateName);
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
    simulated event ReplicatedEvent(name VarName)
    {
        // End:0x2A
        if((VarName == 'AmmoCount') && !HasAnyAmmo())
        {
            return;
        }
        global.ReplicatedEvent(VarName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        global.BeginFire(FireModeNum);
        // End:0x6D
        if(!HasAmmo(FireModeNum) && int(FireModeNum) == int(CurrentFireMode))
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

    simulated event EndState(name NextStateName)
    {
        ClearFlashLocationArray();
        // End:0x41
        if((int(CurrentFireMode) == int(1)) && IsAltInCooldown)
        {
            StopFire(CurrentFireMode);
        }
        CurrentShotCount = 0;
        ShotSpreadHelper = 0.0000000;
        ShotDistortion = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x2FC
        if((int(CurrentFireMode) < AfterShotEffect.Length) && AfterShotEffect[int(CurrentFireMode)] != none)
        {
            // End:0xEB
            if(int(CurrentFireMode) >= AfterShotEffectComponent.Length)
            {
                AfterShotEffectComponent.Add((int(CurrentFireMode) + int(1)) - AfterShotEffectComponent.Length);
            }
            // End:0x246
            if(AfterShotEffectComponent[int(CurrentFireMode)] == none)
            {
                AfterShotEffectComponent[int(CurrentFireMode)] = new (Outer) Class'UTParticleSystemComponent';
                AfterShotEffectComponent[int(CurrentFireMode)].SetTemplate(AfterShotEffect[int(CurrentFireMode)]);
                AfterShotEffectComponent[int(CurrentFireMode)].SetDepthPriorityGroup(2);
                AfterShotEffectComponent[int(CurrentFireMode)].SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
                UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(AfterShotEffectComponent[int(CurrentFireMode)], AfterShotEffectSocket[int(CurrentFireMode)]);                
            }
            else
            {
                // End:0x2A5
                if(!AfterShotEffectComponent[int(CurrentFireMode)].bIsActive)
                {
                    AfterShotEffectComponent[int(CurrentFireMode)].ActivateSystem();                    
                }
                else
                {
                    AfterShotEffectComponent[int(CurrentFireMode)].DeactivateSystem();
                    AfterShotEffectComponent[int(CurrentFireMode)].ActivateSystem();
                }
            }
        }
        super.EndState(NextStateName);
        SetCurrentFireMode(0);
        //return;        
    }
    stop;    
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;
        local int I;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0x85
        if(PC != none)
        {
            // End:0x85
            if(EquippingCameraAnim != none)
            {
                PC.PlayCameraAnim(EquippingCameraAnim,,, 0.2000000, 0.2000000);
            }
        }
        super.BeginState(PreviousStateName);
        PerformWeaponChange();
        I = 0;
        J0xAD:

        // End:0xFA [Loop If]
        if(I < WeaponSpread.Length)
        {
            Spread[I] = WeaponSpread[I];
            I++;
            // [Loop Continue]
            goto J0xAD;
        }
        SetCurrentFireMode(0);
        HideNoAmmoWarning();
        HideLowAmmoWarning();
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
        // End:0x6E
        if((SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
        {
            Mesh.SetRotation(default.Mesh.Rotation);
        }
        ClearTimer('WeaponEquipped');
        NeedReload = false;
        // End:0x14D
        if((MagazineAmmoCount == 0) && AmmoCount > 0)
        {
            // End:0x14D
            if((EvilPawn(Owner) != none) && (EvilPawn(Owner).Weapon == self) || EvilPawn(Owner).WeaponLeft == self)
            {
                EvilPawn(Owner).DoReload();
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponAbortEquip extends WEAPDEBUGSTATE
{
    simulated function bool IsPuttingDown()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PrevStateName)
    {
        local AnimNodeSequence AnimNode;
        local float Rate;

        super.BeginState(PrevStateName);
        SetTimer(FMax(SwitchAbortTime, 0.0100000),, 'WeaponEquipAborted');
        // End:0x300
        if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
        {
            // End:0x19C
            if(WeaponEquipAnim != 'None')
            {
                AnimNode = GetWeaponAnimNodeSeq();
                // End:0x19C
                if((AnimNode != none) && AnimNode.AnimSeq != none)
                {
                    AnimNode.SetAnim(WeaponPutDownAnim);
                    Rate = AnimNode.AnimSeq.SequenceLength / PutDownTime;
                    AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
                }
            }
            // End:0x300
            if(((ArmsEquipAnim != 'None') && ArmsAnimSet != none) && Instigator != none)
            {
                AnimNode = GetArmAnimNodeSeq();
                // End:0x300
                if((AnimNode != none) && AnimNode.AnimSeq != none)
                {
                    AnimNode.SetAnim(ArmsPutDownAnim);
                    Rate = AnimNode.AnimSeq.SequenceLength / PutDownTime;
                    AnimNode.PlayAnim(false, Rate, AnimNode.AnimSeq.SequenceLength - (SwitchAbortTime * Rate));
                }
            }
        }
        //return;        
    }

    simulated function WeaponEquipAborted()
    {
        DetachWeapon();
        GotoState('Inactive');
        // End:0x47
        if(UsesOffhand)
        {
            EvilInvManager.ChangedWeaponLeft();            
        }
        else
        {
            EvilInvManager.ChangedWeapon();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('WeaponEquipAborted');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    ignores ReloadWeapon, StartSprint, Activate;

    simulated function bool DoMeleeKick()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool IsPuttingDown()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPawn P;
        local EvilPlayerController PC;
        local int I;

        P = EvilPawn(Owner);
        PC = EvilPlayerController(Instigator.Controller);
        // End:0x12F
        if(PC != none)
        {
            // End:0xA8
            if(LocalPlayer(PC.Player) != none)
            {
                PC.EndZoom();
            }
            EndZoomInstant(PC);
            // End:0x101
            if(PuttingDownCameraAnim != none)
            {
                PC.PlayCameraAnim(PuttingDownCameraAnim,,, 0.2000000, 0.2000000);
            }
            // End:0x12F
            if(P != none)
            {
                P.StartHideWeapon();
            }
        }
        // End:0x1DA
        if((EvilPawn(Owner) != none) && EvilPawn(Owner).WaitingForDualReload)
        {
            // End:0x1AF
            if(UsesOffhand)
            {
                EvilPawn(Owner).EndQuickHideCurrentWeapon();                
            }
            else
            {
                EvilPawn(Owner).EndQuickHideCurrentWeapon(,,, true);
            }
        }
        TimeWeaponPutDown();
        bWeaponPutDown = false;
        ClearPendingFire(int(CurrentFireMode));
        HideNoAmmoWarning();
        HideLowAmmoWarning();
        I = 0;
        J0x224:

        // End:0x273 [Loop If]
        if(I < AfterShotEffectComponent.Length)
        {
            AfterShotEffectComponent[I].DeactivateSystem();
            I++;
            // [Loop Continue]
            goto J0x224;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x81
        if((SkeletalMeshComponent(Mesh) == none) || WeaponEquipAnim == 'None')
        {
            Mesh.SetRotation(default.Mesh.Rotation);
        }
        //return;        
    }

    simulated function bool bReadyToFire()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function WeaponIsDown()
    {
        // End:0x24
        if(InvManager.CancelWeaponChange())
        {
            return;
        }
        DetachWeapon();
        GotoState('Inactive');
        // End:0x96
        if((int(GetHand()) == int(3)) && EvilInventoryManager(InvManager) != none)
        {
            EvilInventoryManager(InvManager).ChangedWeaponLeft();            
        }
        else
        {
            InvManager.ChangedWeapon();
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function StartSprint()
    {
        // End:0x1E
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStartSprint();
        }
        // End:0x38
        if(!SprintSpreadState)
        {
            SetSpreadSprinting(true);
        }
        // End:0x90
        if((EvilPawn(Owner) != none) && !EvilPawn(Owner).WaitingForDualReload)
        {
            GotoState('SprintState');            
        }
        else
        {
            SetTimer(0.1000000, false, 'StartSprint');
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(CheckZoom(FireModeNum))
        {
            return;
        }
        // End:0x5F
        if((EvilPawn(Instigator) != none) && EvilPawn(Instigator).WaitingForDualReload)
        {
            return;
        }
        // End:0xF9
        if(!bDeleteMe && Instigator != none)
        {
            // End:0xA2
            if(!HasAmmo(FireModeNum))
            {
                ShowNoAmmoWarning();
            }
            global.BeginFire(FireModeNum);
            // End:0xF9
            if(PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum))
            {
                SendToFiringState(FireModeNum);
            }
        }
        //return;        
    }

    simulated function RestartIdleAnim(optional bool bInstant = false)
    {
        local int IdleIndex;

        // End:0x26F
        if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && WeaponIdleAnims.Length > 0)
        {
            IdleIndex = Rand(WeaponIdleAnims.Length);
            PlayWeaponAnim(WeaponIdleAnims[IdleIndex], 0.0000000, ((bInstant) ? 0.0000000 : IdleAnimBlendTimes.BlendIn), ((bInstant) ? -1.0000000 : IdleAnimBlendTimes.BlendOut),, true);
            // End:0x26F
            if((ArmIdleAnims.Length > IdleIndex) && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmIdleAnims[IdleIndex], 0.0000000, ((bInstant) ? 0.0000000 : IdleAnimBlendTimes.BlendIn), ((bInstant) ? -1.0000000 : IdleAnimBlendTimes.BlendOut),, true);
                // End:0x26F
                if(!IsTimerActive('RestartIdleAnim'))
                {
                    // End:0x26F
                    if(NotEqual_InterfaceInterface(EvilPlayer_interface(Instigator), EvilPlayer_interface(none)))
                    {
                        switch(GetHand())
                        {
                            // End:0x222
                            case 3:
                                EvilPlayer_interface(Instigator).SetOnArmAnimEndDelegate(OnArmAnimEnd, true);
                                // End:0x26F
                                break;
                            // End:0x227
                            case 0:
                            // End:0x22C
                            case 1:
                            // End:0x26C
                            case 2:
                                EvilPlayer_interface(Instigator).SetOnArmAnimEndDelegate(OnArmAnimEnd, false);
                            // End:0xFFFF
                            default:
                                break;
                        }
                    }
                    else
                    {
                    }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x26F! */
                }
            }
            //return;            
        }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x005! */
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        RestartIdleAnim();
        //return;        
    }

    simulated function OnArmAnimEnd(bool RightHand, optional AnimNodeSequence SeqNode, optional float PlayedTime, optional float ExcessTime)
    {
        RestartIdleAnim();
        //return;        
    }

    simulated function PlayWeaponAnim(name AnimName, float Duration, optional float BlendInTime, optional float BlendOutTime, optional bool bLooping, optional bool bOverride, optional float StartTime)
    {
        global.PlayWeaponAnim(AnimName, Duration, BlendInTime, BlendOutTime, bLooping, bOverride, StartTime);
        ClearTimer('RestartIdleAnim');
        // End:0x130
        if(bLooping)
        {
            // End:0x9C
            if(Duration > float(0))
            {
                SetTimer(Duration, false, 'RestartIdleAnim');                
            }
            else
            {
                // End:0x130
                if((ArmsAnimSet == none) || SkeletalMeshComponent(Mesh).GetAnimLength(AnimName) != float(0))
                {
                    SetTimer(SkeletalMeshComponent(Mesh).GetAnimLength(AnimName) / DefaultAnimSpeed, false, 'RestartIdleAnim');
                }
            }
        }
        //return;        
    }

    simulated function ChangeVisibility(bool bIsVisible)
    {
        local bool bNeedToPlayAnim;

        bNeedToPlayAnim = !Mesh.bAttached;
        global.ChangeVisibility(bIsVisible);
        // End:0x58
        if(bNeedToPlayAnim)
        {
            RestartIdleAnim();
        }
        //return;        
    }

    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x88
        if((Instigator != none) && Instigator.Weapon != self)
        {
            EvilInvManager.ClientSyncWeapon(Instigator.Weapon);
            global.ServerStartFire(FireModeNum);            
        }
        else
        {
            global.ServerStartFire(FireModeNum);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int I;
        local EvilPlayerController PC;

        RestartIdleAnim();
        super.BeginState(PreviousStateName);
        // End:0x3C
        if(int(Role) == int(ROLE_Authority))
        {
            CacheAIController();
        }
        // End:0x56
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0xCF
            if(PreviousStateName != 'SprintState')
            {
                I = 0;
                J0x78:

                // End:0xCC [Loop If]
                if(I < GetPendingFireLength())
                {
                    // End:0xBE
                    if(PendingFire(I))
                    {
                        BeginFire(byte(I));
                        // [Explicit Break]
                        goto J0xCC;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x78;
                }
                J0xCC:
                
            }
            else
            {
                SetTimer(IdleAnimBlendTimes.BlendIn, false, 'CheckPendingFire');
            }
        }
        // End:0x1A8
        if((InvManager != none) && InvManager.LastAttemptedSwitchToWeapon != none)
        {
            // End:0x188
            if(InvManager.LastAttemptedSwitchToWeapon != self)
            {
                InvManager.LastAttemptedSwitchToWeapon.ClientWeaponSet(true);
            }
            InvManager.LastAttemptedSwitchToWeapon = none;
        }
        // End:0x1F6
        if(NeedReload)
        {
            // End:0x1F6
            if(EvilPawn(Owner) != none)
            {
                EvilPawn(Owner).DoReload();
            }
        }
        // End:0x210
        if(JumpSpreadState)
        {
            global.Jumped();            
        }
        else
        {
            // End:0x27F
            if(SprintSpreadState || (!SprintSpreadState && EvilPawn(Owner) != none) && EvilPawn(Owner).IsRealSprinting())
            {
                global.StartSprint();
            }
        }
        // End:0x355
        if(!SprintSpreadState && Instigator != none)
        {
            PC = EvilPlayerController(Instigator.Controller);
            // End:0x355
            if((PC != none) && PC.MyEvilPawn.CanModifyMovementSpeed())
            {
                PC.MyEvilPawn.ChangeSpeedModifier(MovementSpeedModifier);
            }
        }
        //return;        
    }

    simulated function CheckPendingFire()
    {
        local EvilPlayerController PC;
        local int I;

        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xA5
        if((PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC);
            // End:0xA3
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
            return;
        }
        I = 0;
        J0xB0:

        // End:0x104 [Loop If]
        if(I < GetPendingFireLength())
        {
            // End:0xF6
            if(PendingFire(I))
            {
                BeginFire(byte(I));
                // [Explicit Break]
                goto J0x104;
            }
            I++;
            // [Loop Continue]
            goto J0xB0;
        }
        J0x104:

        //return;        
    }
    stop;    
}

simulated state Frozen extends Inactive
{
    ignores Activate, TimeWeaponEquipping, TimeWeaponPutDown, HandleFinishedFiring, ReloadWeapon;

    simulated function bool AllowSwitchTo(EvilWeap_Base NewWeapon)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool ShouldSwitchTo(EvilWeap_Base InWeapon)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool TryPutDown()
    {
        return global.TryPutDown();
        //return ReturnValue;        
    }

    simulated function StartSprint()
    {
        // End:0x1E
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStartSprint();
        }
        // End:0x38
        if(!SprintSpreadState)
        {
            SetSpreadSprinting(true);
        }
        //return;        
    }

    reliable server function ServerStartFire(byte FireModeNum)
    {
        // End:0x8C
        if(((Instigator == none) || Instigator.Controller != none) || bAllowFiringWithoutController)
        {
            // End:0x8C
            if((Instigator == none) || !Instigator.bNoWeaponFiring)
            {
                BeginFire(FireModeNum);
            }
        }
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0xD0
        if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
        {
            // End:0xCD
            if(int(ZoomedFireModeNum) < int(255))
            {
                ZoomedFireModeNum = 255;
            }            
        }
        else
        {
            // End:0x13F
            if((Instigator == none) || !Instigator.bNoWeaponFiring)
            {
                // End:0x12C
                if(int(Role) < int(ROLE_Authority))
                {
                    ServerStartFire(FireModeNum);
                }
                BeginFire(FireModeNum);
            }
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x47
        if((EvilPawn(Instigator) != none) && EvilPawn(Instigator).WaitingForDualReload)
        {
            return;
        }
        PendingFireHelper = int(FireModeNum);
        //return;        
    }

    simulated function StopFire(byte FireModeNum)
    {
        EndFire(FireModeNum);
        // End:0x3A
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStopFire(FireModeNum);
        }
        //return;        
    }

    reliable server function ServerStopFire(byte FireModeNum)
    {
        EndFire(FireModeNum);
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        PendingFireHelper = -1;
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        super.BeginState(PreviousStateName);
        IsFrozen = true;
        PendingFireHelper = -1;
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xC9
        if((PC != none) && int(GetZoomedState()) == int(3))
        {
            EndZoom(PC);
            // End:0xC9
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        super(WEAPDEBUGSTATE).EndState(NextStateName);
        IsFrozen = false;
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xC2
        if((PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC);
            // End:0xC2
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        // End:0xFA
        if(PendingFireHelper > -1)
        {
            SetPendingFire(PendingFireHelper);
            PendingFireHelper = -1;            
        }
        else
        {
            ClearPendingFire(int(CurrentFireMode));
        }
        //return;        
    }
    stop;    
}

simulated state MeleeKick extends Frozen
{
    simulated function bool DoMeleeKick()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        PlayWeaponAnim('WeaponKick', KickTime, KickAnimBlendTimes.BlendIn, KickAnimBlendTimes.BlendOut);
        PlayArmAnim('WeaponKick', KickTime, KickAnimBlendTimes.BlendIn, KickAnimBlendTimes.BlendOut);
        SetTimer(KickTime, false, 'EndKick');
        //return;        
    }

    simulated function EndKick()
    {
        // End:0x4E
        if(NeedReload)
        {
            // End:0x4E
            if(EvilPawn(Owner) != none)
            {
                EvilPawn(Owner).DoReload();
            }
        }
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state QuickHide extends Frozen
{
    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoMeleeKick()
    {
        return (EvilPawn(Owner) != none) && EvilPawn(Owner).WaitingForDualReload;
        //return ReturnValue;        
    }

    simulated function ReloadWeapon(optional bool bForce = false, optional bool bAlternate = false)
    {
        // End:0x41
        if(bForce)
        {
            bSuppressAutoActiveAfterQuickHide = true;
            global.ReloadWeapon(bForce, bAlternate);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bSuppressAutoActiveAfterQuickHide = false;
        PlayWeaponAnim(WeaponPutDownAnim, ((QuickHideAnimDuration > 0.0000000) ? QuickHideAnimDuration : PutDownTime * 0.5000000), PutDownAnimBlendTimes.BlendIn * 0.5000000, PutDownAnimBlendTimes.BlendOut * 0.5000000);
        // End:0x15B
        if((ArmsPutDownAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmsPutDownAnim, ((QuickHideAnimDuration > 0.0000000) ? QuickHideAnimDuration : PutDownTime * 0.5000000), PutDownAnimBlendTimes.BlendIn * 0.5000000, PutDownAnimBlendTimes.BlendOut * 0.5000000);
        }
        SetTimer(((QuickHideAnimDuration > 0.0000000) ? QuickHideAnimDuration / DefaultAnimSpeed : (PutDownTime * 0.5000000) / DefaultAnimSpeed), false, 'DoneQuickHide');
        // End:0x1D0
        if(WeaponQuickPutDownSnd != none)
        {
            WeaponPlaySound(WeaponQuickPutDownSnd);
        }
        //return;        
    }

    simulated function EndQuickHide(optional float DrawTime = 0.0000000)
    {
        // End:0x22
        if(IsTimerActive('LeaveQuickHide'))
        {
            return;
        }
        PerformWeaponChange();
        SetupArmsAnim();
        bForceHidden = false;
        PlayWeaponAnim(WeaponEquipAnim, ((DrawTime > 0.0000000) ? DrawTime : EquipTime * 0.5000000), EquipAnimBlendTimes.BlendIn * 0.5000000, EquipAnimBlendTimes.BlendOut * 0.5000000);
        // End:0x17E
        if((ArmsEquipAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmsEquipAnim, ((DrawTime > 0.0000000) ? DrawTime : EquipTime * 0.5000000), EquipAnimBlendTimes.BlendIn * 0.5000000, EquipAnimBlendTimes.BlendOut * 0.5000000);
        }
        SetTimer(((DrawTime > 0.0000000) ? DrawTime / DefaultAnimSpeed : (EquipTime * 0.5000000) / DefaultAnimSpeed), false, 'LeaveQuickHide');
        // End:0x1F3
        if(WeaponQuickEquipSnd != none)
        {
            WeaponPlaySound(WeaponQuickEquipSnd);
        }
        //return;        
    }

    simulated function DoneQuickHide()
    {
        // End:0x41
        if(EvilPawn(Instigator) != none)
        {
            EvilPawn(Instigator).NotifyWeapQuickHideDone(self);
        }
        // End:0x98
        if(EvilPlayerController(EvilPawn(Owner).Controller).bFiringOnZipLine)
        {
            EndQuickHide();            
        }
        else
        {
            bForceHidden = true;
        }
        //return;        
    }

    simulated function LeaveQuickHide()
    {
        // End:0x41
        if(EvilPawn(Instigator) != none)
        {
            EvilPawn(Instigator).NotifyWeapQuickHideEnd(self);
        }
        // End:0x8F
        if(NeedReload)
        {
            // End:0x8F
            if(EvilPawn(Owner) != none)
            {
                EvilPawn(Owner).DoReload();
            }
        }
        // End:0xAC
        if(!bSuppressAutoActiveAfterQuickHide)
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

simulated state Jumping extends Frozen
{
    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;

        super.BeginState(PreviousStateName);
        PlayWeaponAnim(WeaponJumpStartAnim, 0.0000000, JumpAnimBlendTimes.BlendIn, JumpAnimBlendTimes.BlendOut);
        // End:0xE1
        if((ArmJumpStartAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmJumpStartAnim, 0.0000000, JumpAnimBlendTimes.BlendIn, JumpAnimBlendTimes.BlendOut);
        }
        PC = EvilPlayerController(Instigator.Controller);
        // End:0x168
        if((PC != none) && JumpStartCameraAnim != none)
        {
            PC.PlayCameraAnim(JumpStartCameraAnim,,, 0.2000000, 0.2000000);
        }
        //return;        
    }

    simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
    {
        local EvilPlayerController PC;

        // End:0x118
        if(SeqNode.AnimSeqName == WeaponJumpStartAnim)
        {
            PlayWeaponAnim(WeaponJumpFlyAnim, 0.0000000,,, true);
            // End:0x8E
            if((ArmJumpFlyAnim != 'None') && ArmsAnimSet != none)
            {
                PlayArmAnim(ArmJumpFlyAnim, 0.0000000,,, true);
            }
            PC = EvilPlayerController(Instigator.Controller);
            // End:0x115
            if((PC != none) && JumpFlyCameraAnim != none)
            {
                PC.PlayCameraAnim(JumpFlyCameraAnim,,, 0.2000000, 0.2000000, true);
            }            
        }
        else
        {
            // End:0x152
            if(SeqNode.AnimSeqName == WeaponJumpLandAnim)
            {
                GotoState('Active');
            }
        }
        super(Actor).OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
        //return;        
    }

    event Landed(Vector HitNormal, Actor FloorActor)
    {
        local EvilPlayerController PC;

        super(EvilWeap_Base).Landed(HitNormal, FloorActor);
        PlayWeaponAnim(WeaponJumpLandAnim, 0.0000000, JumpAnimBlendTimes.BlendIn, JumpAnimBlendTimes.BlendOut);
        // End:0xEA
        if((ArmJumpLandAnim != 'None') && ArmsAnimSet != none)
        {
            PlayArmAnim(ArmJumpLandAnim, 0.0000000, JumpAnimBlendTimes.BlendIn, JumpAnimBlendTimes.BlendOut);
        }
        PC = EvilPlayerController(Instigator.Controller);
        // End:0x171
        if((PC != none) && JumpLandCameraAnim != none)
        {
            PC.PlayCameraAnim(JumpLandCameraAnim,,, 0.2000000, 0.2000000);
        }
        //return;        
    }
    stop;    
}

simulated state SprintState extends WEAPDEBUGSTATE
{
    ignores HandleFinishedFiring, ReloadWeapon;

    simulated function bool DoMeleeKick()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0x106
        if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
        {
            PC.SetSprint(false);
            // End:0xF0
            if(int(ZoomedFireModeNum) < int(255))
            {
                ZoomedFireModeNum = 255;                
            }
            else
            {
                ZoomedFireModeNum = FireModeNum;
            }            
        }
        else
        {
            super(Weapon).StartFire(FireModeNum);
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0x60
        if(PC != none)
        {
            PC.SetSprint(false);
        }
        SetPendingFire(int(FireModeNum));
        //return;        
    }

    simulated function bool AllowSwitchTo(EvilWeap_Base NewWeapon)
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local AnimTree Tree;
        local EvilPlayerController PC;
        local editinline UDKSkeletalMeshComponent ArmMeshComp;

        super.BeginState(PreviousStateName);
        BobDamping = 1.0000000;
        JumpDamping = 1.0000000;
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0xD1
        if((int(GetZoomedState()) != int(0)) && int(ZoomedFireModeNum) < int(255))
        {
            EndZoom(PC);
            // End:0xD1
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
        }
        Tree = AnimTree(SkeletalMeshComponent(Mesh).Animations);
        // End:0x18A
        if((Tree != none) && CustomAnimNode == none)
        {
            AnimNodeBlend(Tree.Children[0].Anim).SetBlendTarget(1.0000000, 0.2000000);            
        }
        else
        {
            PlayWeaponAnim(WeaponSprintAnim, 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true,, ((UsesOffhand) ? (SkeletalMeshComponent(Mesh).GetAnimLength(WeaponSprintAnim) / DefaultAnimSpeed) * SprintAnimOffHandOffset : 0.0000000));
        }
        ArmMeshComp = GetArmMeshComponent();
        // End:0x3B7
        if(ArmMeshComp != none)
        {
            Tree = AnimTree(ArmMeshComp.Animations);
            // End:0x30A
            if((Tree != none) && CustomArmAnimNode == none)
            {
                AnimNodeBlend(Tree.Children[0].Anim).SetBlendTarget(1.0000000, 0.2000000);                
            }
            else
            {
                PlayArmAnim(ArmSprintAnim, 0.0000000, SprintAnimBlendTimes.BlendIn, SprintAnimBlendTimes.BlendOut, true,, ((UsesOffhand) ? (SkeletalMeshComponent(Mesh).GetAnimLength(ArmSprintAnim) / DefaultAnimSpeed) * SprintAnimOffHandOffset : 0.0000000));
            }
        }
        SprintAnimOffHandOffset = default.SprintAnimOffHandOffset;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local AnimTree Tree;

        super.EndState(NextStateName);
        BobDamping = default.BobDamping;
        JumpDamping = default.JumpDamping;
        // End:0xED
        if(CustomAnimNode == none)
        {
            Tree = AnimTree(SkeletalMeshComponent(Mesh).Animations);
            // End:0xED
            if(Tree != none)
            {
                AnimNodeBlend(Tree.Children[0].Anim).SetBlendTarget(0.0000000, 0.2000000);
            }
        }
        //return;        
    }
    stop;    
}

simulated state ReloadState extends WEAPDEBUGSTATE
{
    ignores Jumped, ReloadWeapon;

    event bool IsReloading()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function StartSprint()
    {
        // End:0x1E
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStartSprint();
        }
        // End:0x38
        if(!SprintSpreadState)
        {
            SetSpreadSprinting(true);
        }
        //return;        
    }

    simulated function bool DoMeleeKick()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool DoQuickHide(optional float HideTime = 0.0000000)
    {
        local bool bResult;

        NeedReload = !CheckSkipReloadIfAnimTime(ReloadAsDonePerc, ReloadResumeTime) && !IsResumingReload;
        bResult = global.DoQuickHide(HideTime);
        // End:0x7C
        if(bResult)
        {
            OnReloadEnd(true);            
        }
        else
        {
            ReloadResumeTime = 0.0000000;
            NeedReload = false;
        }
        return bResult;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local EvilPlayerController PC;
        local EvilPawn P;
        local float CurrentTime;

        super.BeginState(PreviousStateName);
        P = EvilPawn(Owner);
        PC = EvilPlayerController(P.Controller);
        // End:0xE1
        if((PC != none) && int(GetZoomedState()) == int(3))
        {
            EndZoom(PC);
            // End:0xC1
            if(int(Role) < int(ROLE_Authority))
            {
                ServerEndZoom(PC);
            }
            // End:0xE1
            if(int(ZoomedFireModeNum) < int(255))
            {
                ZoomedFireModeNum = 255;
            }
        }
        StopFireEffects(CurrentFireMode);
        // End:0x111
        if(ReloadResumeTime != float(0))
        {
            IsResumingReload = true;
        }
        OnReloadStart(IsResumingReload);
        // End:0x22C
        if(IsResumingReload && WeaponReloadResumeAnim != 'None')
        {
            PlayWeaponAnim(WeaponReloadResumeAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut);
            PlayArmAnim(ArmReloadResumeAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut);
            SetTimer(GetReloadTime(), false, 'ReloadTimer');
            NeedReload = false;
            ReloadAmmo();            
        }
        else
        {
            // End:0x2FC
            if(UseAlternateReloadNext)
            {
                PlayWeaponAnim(WeaponReloadAlternateAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut,,, ReloadResumeTime);
                PlayArmAnim(ArmReloadAlternateAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut,,, ReloadResumeTime);                
            }
            else
            {
                PlayWeaponAnim(WeaponReloadAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut,,, ReloadResumeTime);
                PlayArmAnim(ArmReloadAnim, GetReloadTime(), ReloadAnimBlendTimes.BlendIn, ReloadAnimBlendTimes.BlendOut,,, ReloadResumeTime);
            }
            SetTimer(FMax((GetReloadTime()) - ReloadResumeTime, 0.0010000), false, 'ReloadTimer');
            // End:0x41E
            if(CheckSkipReloadIfAnimTime(ReloadAsDonePerc, CurrentTime))
            {
                NeedReload = false;
                ReloadAmmo();                
            }
            else
            {
                SetTimer(FMax(((GetReloadTime()) * ReloadAsDonePerc) - ReloadResumeTime, 0.0010000), false, 'ReloadAmmoTimer');
            }
        }
        ReloadResumeTime = 0.0000000;
        //return;        
    }

    simulated function ReloadFX()
    {
        // End:0xFB
        if(ReloadEffectComponent == none)
        {
            ReloadEffectComponent = new (Outer) Class'UTParticleSystemComponent';
            ReloadEffectComponent.SetTemplate(ReloadEffect);
            ReloadEffectComponent.SetDepthPriorityGroup(2);
            ReloadEffectComponent.SetFOV(UDKSkeletalMeshComponent(Mesh).FOV);
            UDKSkeletalMeshComponent(Mesh).AttachComponentToSocket(ReloadEffectComponent, ReloadEffectSocket);            
        }
        else
        {
            ReloadEffectComponent.ActivateSystem();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local EvilPlayerController PC;

        super.EndState(NextStateName);
        PC = EvilPlayerController(EvilPawn(Owner).Controller);
        // End:0x7B
        if(ReloadEffectComponent != none)
        {
            ReloadEffectComponent.DeactivateSystem();
        }
        // End:0xE4
        if((PC != none) && int(ZoomedFireModeNum) < int(255))
        {
            StartZoom(PC);
            // End:0xE4
            if(int(Role) < int(ROLE_Authority))
            {
                ServerStartZoom(PC, ZoomedFireModeNum);
            }
        }
        IsResumingReload = false;
        UseAlternateReloadNext = false;
        //return;        
    }

    simulated function ReloadAmmoTimer()
    {
        NeedReload = false;
        ReloadAmmo();
        //return;        
    }

    simulated function ReloadTimer()
    {
        local EvilPawn P;

        P = EvilPawn(Owner);
        // End:0x91
        if(((P == none) || P.IsPlayerPawn()) || int(P.PawnAction) != 12)
        {
            GotoState('Active');
            OnReloadEnd(false);
        }
        SetTimer(FMax(0.1000000, ((P.TopHalfAnimSlot.GetCustomAnimNodeSeq() != none) ? P.TopHalfAnimSlot.GetCustomAnimNodeSeq().GetTimeLeft() : 0.1000000)), false, 'ReloadTimer');
        //return;        
    }

    simulated function StartFire(byte FireModeNum)
    {
        local EvilPlayerController PC;

        PC = EvilPlayerController(Instigator.Controller);
        // End:0xD0
        if((((PC != none) && LocalPlayer(PC.Player) != none) && int(FireModeNum) < bZoomedFireMode.Length) && int(bZoomedFireMode[int(FireModeNum)]) != int(0))
        {
            // End:0xCD
            if(int(ZoomedFireModeNum) < int(255))
            {
                ZoomedFireModeNum = 255;
            }            
        }
        else
        {
            super(Weapon).StartFire(FireModeNum);
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        SetPendingFire(int(FireModeNum));
        //return;        
    }
    stop;    
}

defaultproperties
{
    bExportMenuData=true
    bSelectable=true
    ShouldBeRestored=true
    bDisplayCrosshair=true
    bNonlinearZoomInterpolation=true
    SeperateOffHandFiring=true
    MaxAmmoCount=1
    MagazineAmmoCount=1
    MagazineMaxAmmoCount=1
    WeaponHitRange=6000.0000000
    WeaponDamage[0]=0.0000000
    WeaponDamage[1]=0.0000000
    WeaponMomentum[0]=0.0000000
    WeaponMomentum[1]=0.0000000
    WeaponCloseDamageMaxMultiplier=5.5000000
    WeaponCloseDamageDistance=300.0000000
    NumberOfShots[0]=1
    NumberOfShots[1]=1
    WeaponSpread[0]=0.0000000
    WeaponSpread[1]=0.0000000
    WeaponSpreadMax[0]=0.2000000
    WeaponSpreadMax[1]=0.2000000
    WeaponFireInterval[0]=0.1500000
    WeaponFireInterval[1]=0.1500000
    FireCameraAnimScale[0]=0.9000000
    FireCameraAnimScale[1]=0.9000000
    ShotSpreadModifier=0.0300000
    ShotSpreadBackSpeed=10.0000000
    MoveSpreadMultiplier=1.8000000
    SprintSpreadMultiplier=4.8000000
    JumpSpreadMultiplier=5.8000000
    ShotCost[0]=1
    ShotCost[1]=0
    MinReloadPct[0]=0.6000000
    MinReloadPct[1]=0.6000000
    // Reference: ForceFeedbackWaveform'Default__EvilWeap_Base.ForceFeedbackWaveformShooting1'
    begin object name="ForceFeedbackWaveformShooting1" class=Class'Engine.ForceFeedbackWaveform'
        Samples=/* Array type was not detected. */
    end object
    WeaponFireWaveForm=ForceFeedbackWaveformShooting1
    EffectSockets[0]="MuzzleFlashSocket"
    EffectSockets[1]="MuzzleFlashSocket"
    IconX=458
    IconY=83
    IconWidth=31
    IconHeight=45
    ReloadTime=1.6000000
    ReloadAsDonePerc=0.4500000
    IconCoordinates=(U=600.0000000,V=341.0000000,UL=111.0000000,VL=58.0000000)
    CurrentLockedScale=1.0000000
    StartLockedScale=2.0000000
    FinalLockedScale=1.0000000
    LockedScaleTime=0.1500000
    LastHitEnemyTime=-1000.0000000
    CrosshairColor=(R=255,G=255,B=255,A=255)
    CrosshairScaling=1.0000000
    CrosshairOffset=6.0000000
    CrosshairSpreadMultiplier=450.0000000
    CrosshairTotalInvisibilitySpread=0.3000000
    MovementSpeedModifier=1.0000000
    UpgradeInfo=EvilWeaponUpgradeInfo'ar_WeaponUpgrades.Info.Base_Info'
    bZoomedFireMode=/* ERROR: System.ArgumentOutOfRangeException */
    ZoomedFireModeNum=255
    ZoomedTargetFOV=60.0000000
    ZoomedRate=125.0000000
    ZoomingTranslationRate=13.0000000
    ZoomingRotationRate=13.0000000
    ZoomingScaleRate=13.0000000
    ZoomingFOVRate=13.0000000
    ZoomedMeshScale=1.0000000
    ZoomedSpreadMult=0.3000000
    ZoomedRecoilMult=0.4000000
    DOF_FocusDistance=65.0000000
    DOF_FocusInnerRadius=30.0000000
    ZoomedWeaponIdleAnims[0]="WeaponAim"
    ZoomedWeaponFireAnim[0]="WeaponAimFire"
    ZoomedWeaponFireAnim[1]="WeaponAimFire"
    ZoomedArmIdleAnims[0]="WeaponAim"
    ZoomedArmFireAnim[0]="WeaponAimFire"
    ZoomedArmFireAnim[1]="WeaponAimFire"
    ZoomedBobDamping=0.8300000
    ZoomedJumpDamping=0.9000000
    ZoomedLagBackSpeed=13.0000000
    MaxZoomPitchLag=160.0000000
    MaxZoomYawLag=250.0000000
    ZoomedMovementSpeedModifier=0.5000000
    PivotTranslation=(X=0.0000000,Y=-25.0000000,Z=0.0000000)
    WeaponFireAnim[0]="WeaponFire"
    WeaponFireAnim[1]="WeaponFire"
    ArmFireAnim[0]="WeaponFire"
    ArmFireAnim[1]="WeaponFire"
    WeaponPutDownAnim="WeaponPutDown"
    ArmsPutDownAnim="WeaponPutDown"
    WeaponEquipAnim="WeaponEquip"
    ArmsEquipAnim="WeaponEquip"
    WeaponIdleAnims[0]="WeaponIdle"
    ArmIdleAnims[0]="WeaponIdle"
    EquipAnimBlendTimes=(BlendIn=0.0100000,BlendOut=-1.0000000)
    PutDownAnimBlendTimes=(BlendIn=0.1000000,BlendOut=-1.0000000)
    IdleAnimBlendTimes=(BlendIn=0.2000000,BlendOut=-1.0000000)
    FireAnimBlendTimes=(BlendIn=0.0100000,BlendOut=-1.0000000)
    ReloadAnimBlendTimes=(BlendIn=0.1500000,BlendOut=-1.0000000)
    SprintAnimBlendTimes=(BlendIn=0.1500000,BlendOut=-1.0000000)
    JumpAnimBlendTimes=(BlendIn=0.1000000,BlendOut=-1.0000000)
    KickAnimBlendTimes=(BlendIn=0.1000000,BlendOut=-1.0000000)
    WeaponReloadAnim="WeaponReload"
    ArmReloadAnim="WeaponReload"
    // Reference: AudioComponent'Default__EvilWeap_Base.ReloadSound'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'ReloadSound'
    begin object name="ReloadSound" class=Class'Engine.AudioComponent'
        bStopWhenOwnerDestroyed=true
        bAllowSpatialization=false
    end object
    ReloadSoundComp=ReloadSound
    WeaponReloadAlternateAnim="WeaponReloadAlternative"
    ArmReloadAlternateAnim="WeaponReloadAlternative"
    WeaponSprintAnim="WeaponSprint"
    ArmSprintAnim="WeaponSprint"
    SprintAnimOffHandOffset=0.5000000
    KickTime=0.6800000
    WeaponFireSnd[0]=none
    WeaponFireSnd[1]=none
    BobDamping=1.3000000
    JumpDamping=1.8000000
    MaxPitchLag=1600.0000000
    MaxYawLag=2500.0000000
    RotChgSpeed=3.0000000
    ReturnChgSpeed=3.0000000
    LagBackSpeed=2.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilWeap_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    begin object name="MyLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bUseBooleanEnvironmentShadowing=false
        bSynthesizeSHLight=true
        bIsCharacterLightEnvironment=true
    end object
    LightEnvironment=MyLightEnvironment
    BackForceVector=(X=-0.5000000,Y=0.0400000,Z=0.3000000)
    BackForceMax=(X=15.0000000,Y=1.0000000,Z=4.0000000)
    ShotDistortionVector=(X=0.0000000,Y=0.7000000,Z=0.2500000)
    ShotDistortionMax=(X=0.0000000,Y=5.0000000,Z=3.0000000)
    RecoilDelta=170.0000000
    RecoilMax=4000.0000000
    WeaponName="Weapon Base"
    WeaponColor=(R=255,G=255,B=255,A=255)
    WeaponCanvasXPct=0.3500000
    WeaponCanvasYPct=0.3500000
    MuzzleFlashSocket[0]="MuzzleFlashSocket"
    MuzzleFlashSocket[1]="MuzzleFlashSocket"
    MuzzleFlashDuration=0.3300000
    SmallWeaponsOffset=(X=16.0000000,Y=6.0000000,Z=-6.0000000)
    WideScreenOffsetScaling=0.8000000
    WidescreenRotationOffset=(Pitch=900,Yaw=0,Roll=0)
    HiddenWeaponsOffset=(X=0.0000000,Y=-50.0000000,Z=-50.0000000)
    ProjectileSpawnOffset=20.0000000
    LockerRotation=(Pitch=16384,Yaw=0,Roll=0)
    LockerOffset=(X=0.0000000,Y=0.0000000,Z=-15.0000000)
    CurrentRating=0.5000000
    AimError=525.0000000
    AimingHelpRadius[0]=20.0000000
    AimingHelpRadius[1]=20.0000000
    ZoomedTurnSpeedScalePct=0.8500000
    TargetFrictionDistanceMin=320.0000000
    TargetFrictionDistancePeak=1500.0000000
    TargetFrictionDistanceMax=3000.0000000
    TargetFrictionDistanceCurve=(Points=/* Array type was not detected. */,InterpMethod=EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents)
    TargetFrictionMultiplierRange=(X=0.3000000,Y=0.4000000)
    TargetFrictionPeakRadiusScale=1.0000000
    TargetFrictionPeakHeightScale=0.2000000
    TargetFrictionOffset=(X=0.0000000,Y=0.0000000,Z=32.0000000)
    TargetFrictionZoomedBoostValue=0.2500000
    TargetAdhesionDistanceMax=2000.0000000
    TargetAdhesionAimDistY=128.0000000
    TargetAdhesionAimDistZ=96.0000000
    TargetAdhesionScaleRange=(X=0.3000000,Y=2.8500000)
    TargetAdhesionZoomedBoostValue=0.2500000
    FiringStatesArray=/* Array type was not detected. */
    WeaponFireTypes=/* Array type was not detected. */
    WeaponProjectiles=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    Spread=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitMomentum=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.4500000
    PutDownTime=0.3500000
    WeaponRange=22000.0000000
    // Reference: UDKSkeletalMeshComponent'Default__EvilWeap_Base.FirstPersonMesh'
    begin object name="FirstPersonMesh" class=Class'UDKBase.UDKSkeletalMeshComponent'
        FOV=75.0000000
        bOverrideAttachmentOwnerVisibility=true
        ReplacementPrimitive=none
        DepthPriorityGroup=ESceneDepthPriorityGroup.SDPG_Foreground
        bOnlyOwnerSee=true
        bUseAsOccluder=false
        CastShadow=false
        bCastDynamicShadow=false
        LightingChannels=(Unnamed_1=true,Unnamed_6=true)
    end object
    Mesh=FirstPersonMesh
    ShouldFireOnRelease=/* Array type was not detected. */
    MaxDesireability=0.5000000
    DroppedPickupClass=none
    // Reference: SkeletalMeshComponent'Default__EvilWeap_Base.PickupMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'PickupMesh'
    begin object name="PickupMesh" class=Class'Engine.SkeletalMeshComponent'
        bForceRefpose=1
        bUpdateSkelWhenNotRendered=false
        bIgnoreControllersWhenNotRendered=true
        ReplacementPrimitive=none
        MaxDrawDistance=6000.0000000
        CachedMaxDrawDistance=6000.0000000
        CastShadow=false
        bForceDirectLightMap=true
        bCastDynamicShadow=false
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    Components[0]=MyLightEnvironment
    Components[1]=ReloadSound
    TickGroup=ETickingGroup.TG_PostAsyncWork
    MessageClass=Class'EvilPickupMessage'
}