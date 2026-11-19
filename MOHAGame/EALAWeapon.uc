class EALAWeapon extends Weapon
    abstract
    native
    config(Weapon)
    hidecategories(Navigation);

const WTI_SEMIAUTORIFLE = 0;
const WTI_SMG = 1;
const WTI_RIFLE = 2;
const WTI_OTHER = 3;

enum EIronsightsState
{
    IRONSIGHTS_STATE_OFF,           // 0
    IRONSIGHTS_STATE_IN,            // 1
    IRONSIGHTS_STATE_OUT,           // 2
    IRONSIGHTS_STATE_ON,            // 3
    IRONSIGHTS_STATE_MAX            // 4
};

var(Tuning_AINoise) config float WeaponFireNoiseRadius;
var(Tuning_AINoise) config float WeaponEquipNoiseRadius;
var(Tuning_AINoise) config float WeaponReloadNoiseRadius;
var(Tuning_Ammo) config int AmmoCount[3];
var(Tuning_Ammo) config int MaxAmmoCount[3];
var(Tuning_Ammo) bool bInfiniteAmmo;
var(Tuning_Movement) config bool SupportsSprinting;
var(Tuning_Ironsights) bool bCanIronsight;
var() bool bHasMagnumRounds;
var() bool bVerboseLogging;
var bool bUseBoxTrace;
var bool bDropWeaponWhenPutDownDone;
var bool DrawTracer;
var bool RenderCursor;
var bool bEnableAlternateFireToggle;
var bool bAlternateFireMode;
var bool bMeleeInterruptEnabled;
var array<bool> RequiresAmmo;
var(Tuning_Ammo) class<EALAAmmoInventoryClass> AmmoClass[3];
var(Tuning_Ammo) config int PickupMinAmmo;
var(Tuning_Animations) config array<config name> WeaponFireAnim;
var(Tuning_Animations) config name WeaponEquipAnim;
var(Tuning_Animations) config array<config name> WeaponReloadAnim;
var(Tuning_Animations) config array<config name> WeaponIdleAnim;
var(Tuning_BulletDamage) config float ForceFalloffDistanceMax;
var(Tuning_BulletDamage) config float ForceFalloffDistanceStart;
var(Tuning_BulletDamage) config float NpcToPlayerDamageScale;
var(Tuning_BulletDamage) float BulletImpactStimulusThreat;
var(Tuning_FOV) config float PlayerFOV;
var(Tuning_Melee) config float MeleeTraceRange_StartingCameraPos;
var(Tuning_Melee) config float MeleeTraceRange_EndingCameraPos;
var(Tuning_Melee) config float MeleeInterval;
var(Tuning_Melee) config float MeleeImpactInterval;
var(Tuning_Melee) config float MeleeInterruptInterval;
var(Tuning_Melee) config float MeleeImpulse_Min;
var(Tuning_Melee) config float MeleeImpulse_Max;
var(Tuning_Melee) config Vector MeleeTraceExtents;
var(Tuning_Melee) config float MeleeEffectCullDistance;
var(Tuning_Movement) config float MoveSpeedMultipler;
var(Tuning_Ironsights) config float IronsightsInTime;
var(Tuning_Ironsights) config float IronsightsOutTime;
var(Tuning_Ironsights) config float IronsightsFireTime;
var(Tuning_Ironsights) config float IronsightsTargetWorldFOV;
var(Tuning_Ironsights) config float IronsightsTargetPlayerFOV;
var(Tuning_Ironsights) config float AltFireIronsightsTargetWorldFOV;
var(Tuning_Ironsights) config float AltFireIronsightsTargetPlayerFOV;
var(Tuning_Tracer) config name TraceStartSocket;
var(Tuning_Unreal) config float EquipTime_TUNE;
var(Tuning_Unreal) config float PutDownTime_TUNE;
var(Tuning_Unreal) config float FireIntervalStandard_TUNE;
var(Tuning_Unreal) config float FireIntervalSecond_TUNE;
var(Tuning_Unreal) config float WeaponRange_TUNE;
var(Tuning_Unreal) config float InstantHitDamageStandard_TUNE;
var(Tuning_Unreal) config float InstantHitDamageSecond_TUNE;
var(Tuning_Unreal) config float InstantHitDamageThird_TUNE;
var(Tuning_Unreal) config float InstantHitMomentumStandard_TUNE;
var(Tuning_Unreal) config float InstantHitMomentumSecond_TUNE;
var(Tuning_Unreal) config float InstantHitMomentumThird_TUNE;
var(Tuning_Upgrades) config int NumExpLevels;
var(Tuning_Upgrades) config float ExpPointsLevel1;
var(Tuning_Upgrades) config float ExpPointsLevel2;
var(Tuning_Upgrades) config float ExpPointsLevel3;
var(Tuning_Upgrades) config float ExpPointsLevel4;
var(Tuning_Upgrades) array< class<MOHAWeaponUpgrade> > WeaponUpgradeClasses;
var(Tuning_ViewOffset) config Vector vViewOffset;
var() MOHAIncludeClass.eWeaponClass WeaponClass;
var() MOHAIncludeClass.EWeaponType WeaponType;
var EALAWeapon.EIronsightsState IronsightsState;
var() SoundRiotMixSelect LowAmmoMixSelect;
var() config array<config float> LowAmmoMixThreshold;
var() SoundRiotMixSelect MagnumRoundsMix;
var() const localized string DisplayName;
var() SoundRiotRawAsset AudioPropertyFile;
var() SoundRiotRawAsset AudioBank;
var class<WeaponAttachment> AttachmentClass;
var class<MOHAHUDWeaponInfo> HUDInfoClass;
var class<MOHAWeaponExperienceComponent> WeaponExperienceClass;
var int CurrentUpgradeLevel;
var class<MOHAWeaponUpgrade> AutoUpgradeClass;
var export editinline SkeletalMeshComponent WeaponSkeletalMesh;
var float fMeleeStartingSpeed;
var Vector vMeleeStartCamPos;
var Rotator rMeleeStartCamRot;
var float IronsightsCurrentWorldFOV;
var float IronsightsStartingWorldFOV;
var float IronsightsCurrentPlayerFOV;
var float IronsightsStartingPlayerFOV;
var float IronsightsWorldZoomRate;
var float IronsightsPlayerZoomRate;
var Vector vDropWeaponLocation;
var Rotator rDropWeaponRotation;
var BURST_TYPE DefaultBurstType;
var int NPCWeaponTypeIndex;
var Vector PhysicalStartFireOverride;

// Export UEALAWeapon::execAddProjectileToPool(FFrame&, void* const)
native simulated function bool AddProjectileToPool(Projectile Proj);

// Export UEALAWeapon::execFindProjectileInPool(FFrame&, void* const)
native simulated function bool FindProjectileInPool(out Projectile Proj, Class ProjClass);

// Export UEALAWeapon::execGetTraceOwner(FFrame&, void* const)
native simulated function Actor GetTraceOwner();

// Export UEALAWeapon::execGetTraceRange(FFrame&, void* const)
native simulated function float GetTraceRange();

// Export UEALAWeapon::execCalcWeaponFireNative(FFrame&, void* const)
native static simulated function ImpactInfo CalcWeaponFireNative(Actor TraceOwner, Vector StartTrace, Vector EndTrace, Vector vTraceExtents, optional out array<ImpactInfo> ImpactList);

simulated function OnAttachKnife()
{
    //return;    
}

simulated function OnDetachKnife()
{
    //return;    
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList)
{
    return CalcWeaponFireNative(GetTraceOwner(), StartTrace, EndTrace, GetTraceExtentsHelper(), ImpactList);
    //return ReturnValue;    
}

simulated function float GetCursorSpread()
{
    local float radialSpread, spreadDistance;

    radialSpread = -1.0000000;
    // End:0x77
    if(self.IsA('EALASmallArms'))
    {
        EALASmallArms(self).AccuracyComponent.AccuracyGetSpreadMultiplier(radialSpread, spreadDistance);
        radialSpread = ((spreadDistance != 0.0000000) ? (radialSpread / spreadDistance) * 10.0000000 : 0.0000000);        
    }
    else
    {
        // End:0xC4
        if(self.IsA('EALAGrenade'))
        {
            // End:0xAF
            if(((GetAmmoInClip()) + (GetReserveAmmo())) <= 0)
            {
                return radialSpread;                
            }
            else
            {
                radialSpread = EALAGrenade(self).ThrowStrength;
            }
        }
    }
    return radialSpread;
    //return ReturnValue;    
}

simulated function FireAmmunition()
{
    local WeaponAttachment WeapAttachment;

    super.FireAmmunition();
    // End:0x79
    if(NotEqual_InterfaceInterface(MOHAControllerInterface(Instigator.Controller), MOHAControllerInterface(none)))
    {
        // End:0x51
        if(MOHAPawn(Instigator) != none)
        {
            MOHAPawn(Instigator).NoiseRadius(WeaponFireNoiseRadius);
        }
        MOHAControllerInterface(Instigator.Controller).NotifyWeaponFired(self, CurrentFireMode);
    }
    WeapAttachment = GetWeaponAttachment();
    // End:0xA7
    if(WeapAttachment != none)
    {
        WeapAttachment.WeaponFired();
    }
    //return;    
}

simulated function bool ShouldFireWeaponAttachment()
{
    // End:0x29
    if(MOHAPawn(Instigator) != none)
    {
        return MOHAPawn(Instigator).ShouldFireWeaponAttachment();
    }
    return true;
    //return ReturnValue;    
}

simulated function WeaponAttachment GetWeaponAttachment()
{
    // End:0x24
    if(MOHAPawn(Instigator) != none)
    {
        return MOHAPawn(Instigator).CurrentWeaponAttachment;
    }
    // End:0x4E
    if(MOHAVehicle(Instigator) != none)
    {
        return MOHAVehicle(Instigator).GetWeaponAttachment(self);
    }
    //return ReturnValue;    
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact)
{
    super.ProcessInstantHit(FiringMode, Impact);
    // End:0x4D
    if(Impact.HitActor != none)
    {
        DrawDebugCoordinateSystem(Impact.HitLocation, rot(0, 0, 0), 100.0000000, false);
    }
    //return;    
}

// Export UEALAWeapon::execGetBarrelPosition(FFrame&, void* const)
native function Vector GetBarrelPosition();

event Vector EventGetPhysicalFireStartLoc(optional Vector AimDir)
{
    return GetPhysicalFireStartLoc(AimDir);
    //return ReturnValue;    
}

function SpawnGunshotStimulus(Vector Loc)
{
    // End:0xC7
    if(NotEqual_InterfaceInterface(MOHAControllerInterface(Instigator.Controller), MOHAControllerInterface(none)))
    {
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().AttachSender('Gunshot', 'Gunshot', Loc, rot(0, 0, 0),, 0, true, true);
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().PushStimuliSenderParamName('Gunshot', 'Shooter', Instigator.Name);
    }
    //return;    
}

function name GetPlayerShootStimulusID()
{
    return 'PlayerShoot';
    //return ReturnValue;    
}

function float GetPlayerShootThreatTime()
{
    return 5.0000000;
    //return ReturnValue;    
}

static function float GetPlayerShotAtThreatFromBrainState(AxonBrainState bs)
{
    local float threatTime;
    local StimulusSenderSubscription send;

    threatTime = 5.0000000;
    // End:0x5B
    if(bs.GetCallbackParamSender('Sender', send))
    {
        send.Owner.GetStimuliSenderParamFloat('PlayerShoot', 'threatTime', threatTime);
    }
    return threatTime;
    //return ReturnValue;    
}

simulated function DropWeapon(Vector vLocation, Rotator rRotation)
{
    local DroppedPickup MyDroppedPickup;

    MyDroppedPickup = DropFrom(vLocation, vect(0.0000000, 0.0000000, 0.0000000), rRotation);
    // End:0x6E
    if(MyDroppedPickup != none)
    {
        MOHADroppedPickup(MyDroppedPickup).SetAngularVelocity(vect(0.0000000, 0.0000000, 0.0000000));
        MOHAWeaponDroppedPickup(MyDroppedPickup).bDroppedByPlayer = true;
    }
    //return;    
}

function DroppedPickup DropFrom(Vector StartLocation, Vector StartVelocity, optional Rotator StartRotation, optional bool bNoCollisionFail = false)
{
    local DroppedPickup MyDroppedPickup;

    MyDroppedPickup = super.DropFrom(StartLocation, StartVelocity, StartRotation, bNoCollisionFail);
    // End:0x6E
    if((MyDroppedPickup != none) && MyDroppedPickup.CollisionComponent != none)
    {
        MyDroppedPickup.CollisionComponent.LastRenderTime = Mesh.LastRenderTime;
    }
    return MyDroppedPickup;
    //return ReturnValue;    
}

simulated function SpawnImpactStimulus(Vector StartTrace, Vector Loc)
{
    local float threat;
    local MOHAScriptAIController msc;

    // End:0x246
    if(NotEqual_InterfaceInterface(MOHAControllerInterface(Instigator.Controller), MOHAControllerInterface(none)))
    {
        threat = BulletImpactStimulusThreat;
        // End:0xED
        if(Instigator.Controller.bIsPlayer)
        {
            MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().AttachSender('PlayerShoot', GetPlayerShootStimulusID(), Loc, rot(0, 0, 0),, 0, true, true);
            MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().PushStimuliSenderParamFloat('PlayerShoot', 'threatTime', GetPlayerShootThreatTime());            
        }
        else
        {
            msc = MOHAScriptAIController(Instigator.Controller);
            // End:0x14A
            if(msc != none)
            {
                // End:0x135
                if(!msc.UpdatePlayBulletImpact(StartTrace, Loc))
                {
                    return;
                }
                threat *= msc.fSuppressionThreatMultiplier;
            }
        }
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().AttachSender('BulletImpact', 'BulletImpact', Loc, rot(0, 0, 0),, 0, true, true);
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().PushStimuliSenderParamFloat('BulletImpact', 'threat', threat);
        MOHAControllerInterface(Instigator.Controller).GetStimulusComponent().PushStimuliSenderParamInt('BulletImpact', 'Team', MOHAControllerInterface(Instigator.Controller).GetTeamIndex());
    }
    //return;    
}

simulated function InstantFire()
{
    PerformWeaponTrace(Instigator.GetWeaponStartTraceLocation(self));
    //return;    
}

simulated function PerformWeaponTrace(Vector StartTrace)
{
    local Vector EndTrace;
    local array<ImpactInfo> ImpactList;
    local int idx;
    local ImpactInfo RealImpact;

    EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
    RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    // End:0xAB
    if(int(Instigator.Role) == int(ROLE_Authority))
    {
        SetFlashLocation(RealImpact.HitLocation);
        SpawnGunshotStimulus(StartTrace);
        SpawnImpactStimulus(StartTrace, RealImpact.HitLocation);        
    }
    else
    {
        PlayFireEffects(CurrentFireMode, RealImpact.HitLocation);
    }
    idx = 0;
    J0xD0:

    // End:0x104 [Loop If]
    if(idx < ImpactList.Length)
    {
        ProcessInstantHit(CurrentFireMode, ImpactList[idx]);
        idx++;
        // [Loop Continue]
        goto J0xD0;
    }
    //return;    
}

simulated function Projectile ProjectileFire()
{
    local Vector StartTrace, EndTrace, RealStartLoc, AimDir;
    local ImpactInfo TestImpact;
    local Projectile SpawnedProjectile;

    IncrementFlashCount();
    // End:0x127
    if(int(Instigator.Role) == int(ROLE_Authority))
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation(self);
        RealStartLoc = ((IsZero(PhysicalStartFireOverride)) ? GetPhysicalFireStartLoc() : PhysicalStartFireOverride);
        // End:0xF0
        if((StartTrace != RealStartLoc) && int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);            
        }
        else
        {
            AimDir = Vector(GetAdjustedAim(RealStartLoc));
        }
        SpawnedProjectile = SpawnProjectile(RealStartLoc, AimDir);
        return SpawnedProjectile;
    }
    return none;
    //return ReturnValue;    
}

simulated function Projectile SpawnProjectile(Vector vStartPos, Vector vForward)
{
    local Projectile SpawnedProjectile;
    local class<Projectile> ProjClass;

    SpawnedProjectile = none;
    ProjClass = GetProjectileClass();
    // End:0xA6
    if(ClassIsChildOf(ProjClass, Class'MOHAProj_Explosive') && FindProjectileInPool(SpawnedProjectile, ProjClass))
    {
        MOHAProj_Explosive(SpawnedProjectile).SetOwner(self);
        MOHAProj_Explosive(SpawnedProjectile).Instigator = Instigator;
        MOHAProj_Explosive(SpawnedProjectile).InstigatorController = Instigator.Controller;
        MOHAProj_Explosive(SpawnedProjectile).SetLocation(vStartPos);        
    }
    else
    {
        SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, vStartPos, rot(0, 0, 0), none, true);
    }
    // End:0xF2
    if(SpawnedProjectile != none)
    {
        SpawnedProjectile.Init(vForward);
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator preSpread, postSpread;

    // End:0x1C
    if(MOHAPawn(Instigator) == none)
    {
        return super.GetAdjustedAim(StartFireLoc);
    }
    preSpread = Instigator.GetAdjustedAimFor(self, StartFireLoc);
    postSpread = AddSpread(preSpread);
    return MOHAPawn(Instigator).GetPostAdjustedAimFor(self, StartFireLoc, preSpread, postSpread);
    //return ReturnValue;    
}

simulated function TimeWeaponEquipping()
{
    AttachWeaponTo(Instigator.Mesh);
    // End:0x39
    if(Instigator.IsFirstPerson())
    {
        PlayWeaponEquip();
    }
    SetTimer(GetEquipTime(), false, 'WeaponEquipped');
    //return;    
}

simulated function PlayWeaponEquip()
{
    local WeaponAttachment WeapAttachment;

    // End:0x2C
    if(WeaponEquipAnim != 'None')
    {
        PlayWeaponAnimation(WeaponEquipAnim, EquipTime);        
    }
    else
    {
        // End:0x63
        if((GetIdleAnimName(0)) != 'None')
        {
            PlayWeaponAnimation(GetIdleAnimName(0), 1.0000000);
        }
    }
    WeapAttachment = GetWeaponAttachment();
    // End:0x91
    if(WeapAttachment != none)
    {
        WeapAttachment.WeaponBeingEquiped();
    }
    //return;    
}

simulated function DetachWeapon()
{
    local MOHAPawn P;

    P = MOHAPawn(Instigator);
    // End:0x87
    if((P != none) && int(P.Role) == int(ROLE_Authority))
    {
        // End:0x87
        if(P.CurrentWeaponAttachmentClass == AttachmentClass)
        {
            P.SetWeaponClass(none);
            // End:0x87
            if(Instigator.IsLocallyControlled())
            {
                P.WeaponAttachmentChanged();
            }
        }
    }
    // End:0xA2
    if(none != WeaponSkeletalMesh)
    {
        WeaponSkeletalMesh.ForcedLodModel = 0;
    }
    SetHidden(true);
    //return;    
}

simulated function float GetEquipTime()
{
    local float ETime;

    ETime = ((EquipTime > float(0)) ? EquipTime : 0.0100000);
    // End:0x49
    if((PendingFire(0)) || PendingFire(1))
    {
        ETime += 0.2500000;
    }
    return ETime;
    //return ReturnValue;    
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
    local int I, UpgradeLevel;

    // End:0x8F
    if((int(Role) == int(ROLE_Authority)) && MOHAPawn(Instigator) != none)
    {
        MOHAPawn(Instigator).SetWeaponClass(AttachmentClass);
        // End:0x8F
        if(Instigator.IsLocallyControlled() || int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            MOHAPawn(Instigator).WeaponAttachmentChanged();
            InitWeaponAttachment();
        }
    }
    SetHidden(true);
    // End:0x199
    if((MOHAPlayerPawn(Instigator) != none) && MOHAPlayerPawn(Instigator).WeaponUpgradeManager != none)
    {
        // End:0x109
        if(int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            UpgradeLevel = MOHAPlayerPawn(Instigator).WeaponUpgradeManager.GetAppliedUpgradeLevel(WeaponType);            
        }
        else
        {
            UpgradeLevel = MOHAPlayerPawn(Instigator).GetUpgradeStatus(int(WeaponClass));
            // End:0x14D
            if(AutoUpgradeClass != none)
            {
                AutoUpgradeClass.static.StaticUpgradeWeapon(self);
            }
        }
        I = 0;
        J0x154:

        // End:0x199 [Loop If]
        if(I <= UpgradeLevel)
        {
            MOHAPlayerPawn(Instigator).WeaponUpgradeManager.upgrade(WeaponType, I, self);
            I++;
            // [Loop Continue]
            goto J0x154;
        }
    }
    //return;    
}

simulated function InitWeaponAttachment()
{
    //return;    
}

simulated function AttachMuzzleSmoke()
{
    //return;    
}

simulated function AttachEjectionPortSmoke()
{
    //return;    
}

simulated function ConsumeAmmo(byte FireModeNum)
{
    // End:0x2E
    if(MOHAPawn(Instigator) != none)
    {
        MOHAPawn(Instigator).ConsumeAmmo(self, FireModeNum);
    }
    //return;    
}

simulated function int AddAmmo(int Amount)
{
    local int iStartingAmmo, iReserveAmmo, FireModeNum;

    FireModeNum = ((bAlternateFireMode) ? 1 : 0);
    iStartingAmmo = AmmoCount[FireModeNum];
    iReserveAmmo = MOHAInventoryManager(Instigator.InvManager).GetReserveAmmoCount(AmmoClass[FireModeNum]);
    // End:0x7D
    if(!bInfiniteAmmo && Amount > iReserveAmmo)
    {
        Amount = iReserveAmmo;
    }
    SetAmmoCount(Clamp(AmmoCount[FireModeNum] + Amount, 0, MaxAmmoCount[FireModeNum]), byte(FireModeNum));
    // End:0x13E
    if((((AmmoCount[FireModeNum] != iStartingAmmo) && Instigator != none) && Instigator.InvManager.IsA('MOHAInventoryManager')) && !bInfiniteAmmo)
    {
        MOHAInventoryManager(Instigator.InvManager).AddReserveAmmo(AmmoClass[FireModeNum], iStartingAmmo - AmmoCount[FireModeNum]);
    }
    return AmmoCount[FireModeNum];
    //return ReturnValue;    
}

simulated function SubtractAmmo(int Amount, byte FireModeNum)
{
    // End:0x10
    if(int(FireModeNum) >= 3)
    {
        return;
    }
    SetAmmoCount(Clamp(AmmoCount[int(FireModeNum)] - Amount, 0, MaxAmmoCount[int(FireModeNum)]), FireModeNum);
    //return;    
}

simulated function SetAmmoCount(int iCount, byte FireModeNum)
{
    // End:0x10
    if(int(FireModeNum) >= 3)
    {
        return;
    }
    AmmoCount[int(FireModeNum)] = iCount;
    UpdateLowAmmoMix(FireModeNum);
    //return;    
}

simulated function UpdateLowAmmoMix(byte FireModeNum)
{
    local bool bLowAmmoMixActive;
    local float fControlValue;

    bLowAmmoMixActive = LowAmmoMixSelect.IsActive();
    // End:0xD3
    if(((LowAmmoMixThreshold.Length > int(FireModeNum)) && float(AmmoCount[int(FireModeNum)]) <= LowAmmoMixThreshold[int(FireModeNum)]) && AmmoCount[int(FireModeNum)] != 0)
    {
        fControlValue = FClamp(1.0000000 - (float(AmmoCount[int(FireModeNum)] - 1) / LowAmmoMixThreshold[int(FireModeNum)]), 0.0000000, 1.0000000);
        // End:0xBC
        if(!bLowAmmoMixActive)
        {
            LowAmmoMixSelect.ActivateControl(fControlValue);            
        }
        else
        {
            LowAmmoMixSelect.UpdateControlValue(fControlValue);
        }        
    }
    else
    {
        // End:0xEB
        if(bLowAmmoMixActive)
        {
            LowAmmoMixSelect.DeActivate();
        }
    }
    //return;    
}

simulated function PutDownWeapon()
{
    super.PutDownWeapon();
    // End:0x34
    if((LowAmmoMixSelect != none) && LowAmmoMixSelect.IsActive())
    {
        LowAmmoMixSelect.DeActivate();
    }
    // End:0x62
    if((MagnumRoundsMix != none) && MagnumRoundsMix.IsActive())
    {
        MagnumRoundsMix.DeActivate();
    }
    //return;    
}

simulated function PlayerPawnDied()
{
    // End:0x2E
    if((LowAmmoMixSelect != none) && LowAmmoMixSelect.IsActive())
    {
        LowAmmoMixSelect.DeActivate();
    }
    // End:0x5C
    if((MagnumRoundsMix != none) && MagnumRoundsMix.IsActive())
    {
        MagnumRoundsMix.DeActivate();
    }
    //return;    
}

simulated function AddUpgradeSequenceAmmo()
{
    local int FireModeNum;

    FireModeNum = ((bAlternateFireMode) ? 1 : 0);
    SetAmmoCount(MaxAmmoCount[FireModeNum], byte(FireModeNum));
    //return;    
}

// Export UEALAWeapon::execGetAmmoInClip(FFrame&, void* const)
native simulated function int GetAmmoInClip();

// Export UEALAWeapon::execHasReserveAmmo(FFrame&, void* const)
native simulated function bool HasReserveAmmo();

// Export UEALAWeapon::execHasSecondaryAmmo(FFrame&, void* const)
native simulated function bool HasSecondaryAmmo();

// Export UEALAWeapon::execGetReserveAmmo(FFrame&, void* const)
native simulated function int GetReserveAmmo();

// Export UEALAWeapon::execGetSecondaryAmmo(FFrame&, void* const)
native simulated function int GetSecondaryAmmo();

simulated function UpdateViewmodelFOV()
{
    local float fFOV;

    fFOV = GetPlayerFOV();
    // End:0x51
    if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
    {
        MOHAPlayerPawn(Instigator).SetViewModelFOV(fFOV);
    }
    // End:0x7A
    if(MOHASkeletalMeshComponent(Mesh) != none)
    {
        MOHASkeletalMeshComponent(Mesh).FOV = fFOV;
    }
    //return;    
}

simulated function bool FiringRequiresAmmo(byte FireModeNum)
{
    return (int(FireModeNum) >= RequiresAmmo.Length) || RequiresAmmo[int(FireModeNum)];
    //return ReturnValue;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    // End:0x11
    if(int(FireModeNum) >= 3)
    {
        return false;
    }
    // End:0x2E
    if(FiringStatesArray[int(FireModeNum)] == 'WeaponMeleeFire')
    {
        return true;
    }
    return AmmoCount[int(FireModeNum)] > 0;
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    local byte FireModeNum;

    FireModeNum = byte(((bAlternateFireMode) ? 1 : 0));
    return AmmoCount[int(FireModeNum)] > 0;
    //return ReturnValue;    
}

simulated function bool HasFullClip()
{
    local byte FireModeNum;

    FireModeNum = byte(((bAlternateFireMode) ? 1 : 0));
    return AmmoCount[int(FireModeNum)] >= MaxAmmoCount[int(FireModeNum)];
    //return ReturnValue;    
}

simulated function WeaponEmpty()
{
    GetWeaponAttachment().WeaponIsEmpty();
    //return;    
}

simulated function bool PutWeaponDownWhenEmpty()
{
    return true;
    //return ReturnValue;    
}

simulated function StartReload(byte FireModeNum)
{
    // End:0x44
    if((MOHAPawn(Instigator) != none) && int(Instigator.Role) == int(ROLE_Authority))
    {
        MOHAPawn(Instigator).NoiseRadius(WeaponReloadNoiseRadius);
    }
    //return;    
}

simulated function OnProjectileToss()
{
    //return;    
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    // End:0x1D
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    // End:0x32
    if('None' == Sequence)
    {
        return;
    }
    // End:0x3F
    if(none == WeaponSkeletalMesh)
    {
        return;
    }
    WeaponSkeletalMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);
    //return;    
}

simulated function float GetMeleeInterval()
{
    return MeleeInterval;
    //return ReturnValue;    
}

simulated function float GetMeleeImpactInterval()
{
    return MeleeImpactInterval;
    //return ReturnValue;    
}

simulated function float GetMeleeInterruptInterval()
{
    return ((MeleeInterruptInterval >= MeleeImpactInterval) ? MeleeInterruptInterval : MeleeImpactInterval);
    //return ReturnValue;    
}

simulated function float GetMeleeDamage()
{
    return InstantHitDamage[2];
    //return ReturnValue;    
}

simulated function bool IsPuttingDownWeapon()
{
    return false;
    //return ReturnValue;    
}

simulated function name GetIdleAnimName(byte FireModeNum)
{
    return ((WeaponIdleAnim.Length > int(FireModeNum)) ? WeaponIdleAnim[int(FireModeNum)] : 'None');
    //return ReturnValue;    
}

simulated function name GetFireAnimName(byte FireModeNum)
{
    return ((WeaponFireAnim.Length > int(FireModeNum)) ? WeaponFireAnim[int(FireModeNum)] : 'None');
    //return ReturnValue;    
}

event Vector GetTraceExtentsHelper()
{
    return GetTraceExtents();
    //return ReturnValue;    
}

simulated function MOHAPhysicalMaterialProperty.EImpactType GetMeleeImpactType()
{
    return 25;
    //return ReturnValue;    
}

exec function UpdateWeapon()
{
    //return;    
}

simulated function bool GameplayAllowsReload()
{
    return true;
    //return ReturnValue;    
}

simulated function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    UpdateWeapon();
    //return;    
}

simulated function AttachmentChanged(WeaponAttachment Attachment)
{
    // End:0x0D
    if(none == Attachment)
    {
        return;
    }
    Mesh = Attachment.Mesh;
    WeaponSkeletalMesh = SkeletalMeshComponent(Attachment.Mesh);
    //return;    
}

simulated function bool HeldByPlayer()
{
    return Instigator.IsFirstPerson();
    //return ReturnValue;    
}

simulated event GetViewOffset(out Vector vWeaponOffset)
{
    vWeaponOffset = vViewOffset;
    //return;    
}

function BURST_TYPE GetDefaultBurstType()
{
    return DefaultBurstType;
    //return ReturnValue;    
}

function BURST_TYPE GetShortBurst()
{
    return GetDefaultBurstType();
    //return ReturnValue;    
}

function BURST_TYPE GetLongBurst()
{
    return GetDefaultBurstType();
    //return ReturnValue;    
}

function BURST_TYPE GetVeryLongBurst()
{
    return GetDefaultBurstType();
    //return ReturnValue;    
}

function BURST_TYPE GetWildBurst()
{
    return GetDefaultBurstType();
    //return ReturnValue;    
}

function string GetDisplayName()
{
    return DisplayName;
    //return ReturnValue;    
}

function BURST_TYPE GetSuppressingBurst()
{
    return GetDefaultBurstType();
    //return ReturnValue;    
}

simulated function bool CanIronsight()
{
    // End:0x39
    if(MOHAPlayerPawn(Instigator) != none)
    {
        return bCanIronsight && !MOHAPlayerPawn(Instigator).IsWeaponDisabled();        
    }
    else
    {
        return bCanIronsight;
    }
    //return ReturnValue;    
}

function int GetRandDesiredPosture()
{
    // End:0x0D
    if(Rand(100) < 70)
    {
        return 1;
    }
    return 0;
    //return ReturnValue;    
}

function int GetDesiredPosture()
{
    return -1;
    //return ReturnValue;    
}

function int GetWeaponTypeIndex()
{
    return NPCWeaponTypeIndex;
    //return ReturnValue;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x39
    if((Instigator != none) && Instigator.IsHumanControlled())
    {
        TickZoom(DeltaTime);
    }
    //return;    
}

simulated function float GetIronsightsTargetPlayerFOV()
{
    // End:0x23
    if(bAlternateFireMode && AltFireIronsightsTargetPlayerFOV != 0.0000000)
    {
        return AltFireIronsightsTargetPlayerFOV;        
    }
    else
    {
        return IronsightsTargetPlayerFOV;
    }
    //return ReturnValue;    
}

simulated function float GetIronsightsTargetWorldFOV()
{
    // End:0x23
    if(bAlternateFireMode && AltFireIronsightsTargetWorldFOV != 0.0000000)
    {
        return AltFireIronsightsTargetWorldFOV;        
    }
    else
    {
        return IronsightsTargetWorldFOV;
    }
    //return ReturnValue;    
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return ((int(IronsightsState) != int(0)) ? IronsightsCurrentWorldFOV : FOVAngle);
    //return ReturnValue;    
}

simulated function StartIronsightsZoom()
{
    // End:0xAB
    if((Instigator != none) && Instigator.IsHumanControlled())
    {
        IronsightsState = 1;
        IronsightsStartingWorldFOV = MOHAPlayerController(Instigator.Controller).GetLastFOV();
        IronsightsCurrentWorldFOV = IronsightsStartingWorldFOV;
        IronsightsWorldZoomRate = ((GetIronsightsTargetWorldFOV()) - IronsightsStartingWorldFOV) / IronsightsInTime;
        IronsightsStartingPlayerFOV = PlayerFOV;
        IronsightsCurrentPlayerFOV = IronsightsStartingPlayerFOV;
        IronsightsPlayerZoomRate = ((GetIronsightsTargetPlayerFOV()) - IronsightsStartingPlayerFOV) / IronsightsInTime;
    }
    //return;    
}

simulated function EndIronsightsZoom()
{
    IronsightsState = 2;
    IronsightsWorldZoomRate = (80.0000000 - IronsightsCurrentWorldFOV) / IronsightsOutTime;
    IronsightsPlayerZoomRate = (IronsightsStartingPlayerFOV - IronsightsCurrentPlayerFOV) / IronsightsOutTime;
    //return;    
}

simulated event TickZoom(float DeltaTime)
{
    // End:0x11
    if(!IsActiveWeapon())
    {
        return;
    }
    // End:0x86
    if(int(IronsightsState) != int(0))
    {
        IronsightsCurrentWorldFOV += (IronsightsWorldZoomRate * DeltaTime);
        IronsightsCurrentWorldFOV = FClamp(IronsightsCurrentWorldFOV, GetIronsightsTargetWorldFOV(), FMax(IronsightsStartingWorldFOV, 80.0000000));
        IronsightsCurrentPlayerFOV += (IronsightsPlayerZoomRate * DeltaTime);
        IronsightsCurrentPlayerFOV = FClamp(IronsightsCurrentPlayerFOV, GetIronsightsTargetPlayerFOV(), IronsightsStartingPlayerFOV);
    }
    UpdateViewmodelFOV();
    //return;    
}

simulated function float GetPlayerFOV()
{
    // End:0x46
    if(int(IronsightsState) == int(0))
    {
        // End:0x3D
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            return PlayerFOV;            
        }
        else
        {
            return 0.0000000;
        }        
    }
    else
    {
        return IronsightsCurrentPlayerFOV;
    }
    //return ReturnValue;    
}

simulated function StartFire(byte FireModeNum)
{
    // End:0xC2
    if(int(Instigator.Controller.Role) < int(ROLE_Authority))
    {
        // End:0x9C
        if((int(FireModeNum) == 0) && (int(WeaponFireTypes[0]) == int(1)) || (int(WeaponFireTypes[1]) == int(1)) && bAlternateFireMode)
        {
            MOHAMultiplayerController(Instigator.Controller).ServerStartFireWithLocation(FireModeNum, (GetPhysicalFireStartLoc()) * float(10));            
        }
        else
        {
            MOHAMultiplayerController(Instigator.Controller).ServerStartFire(FireModeNum);
        }
    }
    BeginFire(FireModeNum);
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    EndFire(FireModeNum);
    // End:0xA8
    if(int(Instigator.Controller.Role) < int(ROLE_Authority))
    {
        // End:0x82
        if(EALAGrenade(self) != none)
        {
            MOHAMultiplayerController(Instigator.Controller).ServerStopFireGrenade(FireModeNum, MOHAMultiplayerController(Instigator.Controller).m_GrenadeThrowStrength);            
        }
        else
        {
            MOHAMultiplayerController(Instigator.Controller).ServerStopFire(FireModeNum);
        }
    }
    //return;    
}

simulated event bool IronsightsButtonDown()
{
    // End:0x29
    if(MOHAPlayerPawn(Instigator) != none)
    {
        return MOHAPlayerPawn(Instigator).AimButtonDown();
    }
    return false;
    //return ReturnValue;    
}

simulated function bool HideCursorInIronsights()
{
    return true;
    //return ReturnValue;    
}

simulated function bool ProcessWeaponAttachmentChanged()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsMeleeFiringMode(int iFireModeNum)
{
    return FiringStatesArray[iFireModeNum] == 'WeaponMeleeFire';
    //return ReturnValue;    
}

simulated function Actor PerformBulletTrace(Vector vHit, Vector vHitNormal, Vector vEnd, Vector vStart)
{
    return GetTraceOwner().Trace(vHit, vHitNormal, vEnd, vStart, true, vect(0.0000000, 0.0000000, 0.0000000),, 1);
    //return ReturnValue;    
}

simulated function UpdateWeaponVars()
{
    EquipTime = EquipTime_TUNE;
    PutDownTime = PutDownTime_TUNE;
    FireInterval[0] = FireIntervalStandard_TUNE;
    FireInterval[1] = FireIntervalSecond_TUNE;
    WeaponRange = WeaponRange_TUNE;
    InstantHitDamage[0] = InstantHitDamageStandard_TUNE;
    InstantHitDamage[1] = InstantHitDamageSecond_TUNE;
    InstantHitDamage[2] = InstantHitDamageThird_TUNE;
    InstantHitMomentum[0] = InstantHitMomentumStandard_TUNE;
    InstantHitMomentum[1] = InstantHitMomentumSecond_TUNE;
    InstantHitMomentum[2] = InstantHitMomentumThird_TUNE;
    //return;    
}

simulated function UpdateMeshVisibility(name ToggleMesh, bool show)
{
    local SkelControlSingleBone SkCtrl;

    // End:0x0D
    if(none == WeaponSkeletalMesh)
    {
        return;
    }
    SkCtrl = SkelControlSingleBone(WeaponSkeletalMesh.FindSkelControl(ToggleMesh));
    // End:0x39
    if(none == SkCtrl)
    {
        return;
    }
    SkCtrl.ControlStrength = 1.0000000;
    SkCtrl.SetSkelControlActive(true);
    SkCtrl.BoneScale = float(((show) ? 1 : 0));
    //return;    
}

simulated function int GetMaxUpgradeLevel()
{
    return WeaponUpgradeClasses.Length - 1;
    //return ReturnValue;    
}

simulated function DropWeaponWhenPutDownDone(Vector vLocation, Rotator rRotation)
{
    bDropWeaponWhenPutDownDone = true;
    vDropWeaponLocation = vLocation;
    rDropWeaponRotation = rRotation;
    //return;    
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    return BaseAim;
    //return ReturnValue;    
}

simulated function ExitIronSights()
{
    IronsightsState = 0;
    // End:0x6D
    if(MOHAPlayerPawn(Instigator) != none)
    {
        MOHAPlayerPawn(Instigator).SetViewModelFOV(PlayerFOV);
        MOHAPlayerController(Instigator.Controller).ToggleCursor(true);
        MOHAPlayerPawn(Instigator).bIronsightsActive = false;
    }
    // End:0x96
    if(MOHASkeletalMeshComponent(Mesh) != none)
    {
        MOHASkeletalMeshComponent(Mesh).FOV = PlayerFOV;
    }
    GotoState('Active');
    //return;    
}

simulated function bool IsUsableByPlayer()
{
    return true;
    //return ReturnValue;    
}

simulated function bool ShouldRefire()
{
    // End:0x20
    if(IsWeaponDisabled())
    {
        ClearPendingFire(int(CurrentFireMode));
        return false;
    }
    return super.ShouldRefire();
    //return ReturnValue;    
}

simulated function bool IsWeaponDisabled()
{
    local MOHAPlayerPawn P;

    P = MOHAPlayerPawn(Instigator);
    return (P != none) && P.IsWeaponDisabled();
    //return ReturnValue;    
}

simulated function bool IsRestoringExperience()
{
    return (MOHAPlayerPawn(Instigator) != none) && MOHAPlayerPawn(Instigator).bRestoringExperience;
    //return ReturnValue;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        I = ((bAlternateFireMode) ? 1 : 0);
        // End:0x54
        if((GetIdleAnimName(byte(I))) != 'None')
        {
            PlayWeaponAnimation(GetIdleAnimName(byte(I)), 1.0000000, true);
        }
        // End:0x6A
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0xD6
            if((HasAnyAmmo()) || HasReserveAmmo())
            {
                I = 0;
                J0x8D:

                // End:0xD6 [Loop If]
                if(I < InvManager.PendingFire.Length)
                {
                    // End:0xCC
                    if(PendingFire(I))
                    {
                        BeginFire(byte(I));
                        // [Explicit Break]
                        goto J0xD6;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x8D;
                }
            }
        }
        J0xD6:

        //return;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated event EndState(name NextStateName)
    {
        local MOHAControllerInterface ControllerInterface;

        super.EndState(NextStateName);
        // End:0x5D
        if(Instigator != none)
        {
            ControllerInterface = MOHAControllerInterface(Instigator.Controller);
            // End:0x5D
            if(NotEqual_InterfaceInterface(ControllerInterface, MOHAControllerInterface(none)))
            {
                ControllerInterface.NotifyWeaponFinishedFiring(self, CurrentFireMode);
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x3C
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_LowerWeaponEvent();
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x30
        if(bDropWeaponWhenPutDownDone)
        {
            DropWeapon(vDropWeaponLocation, rDropWeaponRotation);
            bDropWeaponWhenPutDownDone = false;
        }
        //return;        
    }

    simulated function bool IsPuttingDownWeapon()
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
        // End:0x55
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPawn(Instigator).NoiseRadius(WeaponEquipNoiseRadius);
            MOHAPlayerPawn(Instigator).Weapon_RaiseWeaponEvent();
        }
        // End:0x6D
        if(bHasMagnumRounds)
        {
            MagnumRoundsMix.ActiveAsMixFader();
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x50
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
            MOHAPlayerController(Instigator.Controller).OnWeaponEquipped();
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state WeaponMeleeFire
{
    simulated function BeginState(name PreviousStateName)
    {
        BeginMelee();
        //return;        
    }

    simulated function BeginMelee()
    {
        MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        PlayWeaponAnimation(GetFireAnimName(CurrentFireMode), 1.0000000, true);
        vMeleeStartCamPos = Instigator.GetWeaponStartTraceLocation();
        rMeleeStartCamRot = Instigator.GetBaseAimRotation();
        fMeleeStartingSpeed = VSize(Instigator.Velocity);
        bMeleeInterruptEnabled = false;
        // End:0xC5
        if((Instigator != none) && Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_MeleeEvent();
        }
        TimeWeaponMelee();
        //return;        
    }

    simulated function float GetMeleeTraceRange(bool bFromStartingCameraPos)
    {
        // End:0x12
        if(bFromStartingCameraPos)
        {
            return MeleeTraceRange_StartingCameraPos;            
        }
        else
        {
            return MeleeTraceRange_EndingCameraPos;
        }
        //return ReturnValue;        
    }

    simulated function EndMeleeTimer()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        ClearTimer('EndMeleeTimer');
        ClearTimer('PerformMeleeTrace');
        ClearTimer('MeleeInterruptEnabled');
        EndFire(CurrentFireMode);
        super(Object).EndState(NextStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x2C
        if((IsMeleeFiringMode(int(FireModeNum))) && bMeleeInterruptEnabled)
        {
            BeginMelee();            
        }
        else
        {
            // End:0x4A
            if(int(FireModeNum) == 0)
            {
                SetPendingFire(int(FireModeNum));
            }
        }
        //return;        
    }

    simulated function PerformMeleeTrace()
    {
        local Vector vStartTrace, vEndTrace, vAimDir;
        local array<ImpactInfo> ImpactList;
        local ImpactInfo HitImpact, Impact;
        local int idx;
        local float fVelocityMult, fImpulseMagnitude, fDamageMagnitude;
        local bool bHasDetailedImpactInfo;

        vAimDir = Vector(rMeleeStartCamRot);
        vStartTrace = vMeleeStartCamPos;
        vEndTrace = vStartTrace + (vAimDir * (GetMeleeTraceRange(true)));
        bUseBoxTrace = false;
        bHasDetailedImpactInfo = false;
        HitImpact = CalcWeaponFire(vStartTrace, vEndTrace, ImpactList);
        // End:0x83
        if(HitImpact.HitActor != none)
        {
            bHasDetailedImpactInfo = true;
        }
        // End:0xBF
        if(HitImpact.HitActor == none)
        {
            bUseBoxTrace = true;
            HitImpact = CalcWeaponFire(vStartTrace, vEndTrace, ImpactList);
        }
        // End:0x147
        if(HitImpact.HitActor == none)
        {
            vAimDir = Vector(Instigator.GetBaseAimRotation());
            vStartTrace = Instigator.GetWeaponStartTraceLocation();
            vEndTrace = vStartTrace + (vAimDir * (GetMeleeTraceRange(false)));
            HitImpact = CalcWeaponFire(vStartTrace, vEndTrace, ImpactList);
        }
        fVelocityMult = float(Clamp(int(fMeleeStartingSpeed / Instigator.GroundSpeed), 0, 1));
        fImpulseMagnitude = MeleeImpulse_Min + ((MeleeImpulse_Max - MeleeImpulse_Min) * fVelocityMult);
        idx = 0;
        J0x191:

        // End:0x319 [Loop If]
        if(idx < ImpactList.Length)
        {
            Impact = ImpactList[idx];
            // End:0x30F
            if(Impact.HitActor != none)
            {
                // End:0x223
                if((fMeleeStartingSpeed > Instigator.GroundSpeed) && Pawn(Impact.HitActor) != none)
                {
                    fDamageMagnitude = float(Pawn(Impact.HitActor).Health);                    
                }
                else
                {
                    fDamageMagnitude = InstantHitDamage[int(CurrentFireMode)];
                }
                // End:0x255
                if(!bHasDetailedImpactInfo)
                {
                    GetDetailedHitInfo(vStartTrace, Impact);
                }
                Impact.HitActor.TakeDamage(int(fDamageMagnitude), Instigator.Controller, Impact.HitLocation, fImpulseMagnitude * Impact.RayDir, InstantHitDamageTypes[int(CurrentFireMode)], Impact.HitInfo, self);
                // End:0x30F
                if(true == (EffectIsRelevant(Location, false, MeleeEffectCullDistance)))
                {
                    GetWeaponAttachment().PlayImpactEffectsWithImpactInfo(Impact, int(GetMeleeImpactType()));
                }
            }
            idx++;
            // [Loop Continue]
            goto J0x191;
        }
        Class'Engine.JuiceSubsystem'.static.LevelEvent("Gameplay", "WeaponMeleeFire", string(Class.Name), 0, float(InventoryId), "", MOHAPawn(Instigator).Location);
        //return;        
    }

    simulated function GetDetailedHitInfo(Vector vStart, out ImpactInfo Impact)
    {
        local Pawn HitActor;
        local ImpactInfo updatedImpact;
        local Vector vEnd, HitLocation, HitNormal;
        local TraceHitInfo HitInfo;

        HitActor = Pawn(Impact.HitActor);
        // End:0xCC
        if((HitActor != none) && HitActor.Mesh != none)
        {
            vEnd = HitActor.Mesh.GetBoneLocation('Spine2');
            updatedImpact.HitActor = Trace(HitLocation, HitNormal, vEnd, vStart, true, vect(0.0000000, 0.0000000, 0.0000000), HitInfo, 1);
            // End:0xCC
            if(updatedImpact.HitActor == HitActor)
            {
                Impact.HitInfo = HitInfo;
            }
        }
        //return;        
    }

    simulated function TimeWeaponMelee()
    {
        SetTimer(GetMeleeInterval(), false, 'EndMeleeTimer');
        SetTimer(GetMeleeImpactInterval(), false, 'PerformMeleeTrace');
        SetTimer(GetMeleeInterruptInterval(), false, 'MeleeInterruptEnabled');
        //return;        
    }

    simulated function MeleeInterruptEnabled()
    {
        bMeleeInterruptEnabled = true;
        //return;        
    }

    simulated function Vector GetTraceExtents()
    {
        // End:0x12
        if(bUseBoxTrace)
        {
            return MeleeTraceExtents;            
        }
        else
        {
            return vect(0.0000000, 0.0000000, 0.0000000);
        }
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    MaxAmmoCount[0]=10
    MaxAmmoCount[1]=10
    SupportsSprinting=true
    bCanIronsight=true
    RenderCursor=true
    PickupMinAmmo=20
    ForceFalloffDistanceMax=100000.0000000
    ForceFalloffDistanceStart=50000.0000000
    NpcToPlayerDamageScale=1.0000000
    BulletImpactStimulusThreat=1.0000000
    PlayerFOV=65.0000000
    MeleeTraceRange_StartingCameraPos=200.0000000
    MeleeTraceRange_EndingCameraPos=160.0000000
    MeleeInterval=0.7500000
    MeleeImpactInterval=0.2500000
    MeleeInterruptInterval=0.5000000
    MeleeImpulse_Min=30000.0000000
    MeleeImpulse_Max=75000.0000000
    MeleeTraceExtents=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    MeleeEffectCullDistance=2000.0000000
    MoveSpeedMultipler=1.0000000
    IronsightsInTime=0.2900000
    IronsightsOutTime=0.2400000
    IronsightsFireTime=0.0900000
    IronsightsTargetWorldFOV=55.0000000
    IronsightsTargetPlayerFOV=50.0000000
    TraceStartSocket="Barrel"
    EquipTime_TUNE=1.2700000
    PutDownTime_TUNE=0.7300000
    FireIntervalStandard_TUNE=0.3000000
    FireIntervalSecond_TUNE=0.3000000
    WeaponRange_TUNE=16384.0000000
    InstantHitDamageStandard_TUNE=25.0000000
    InstantHitDamageSecond_TUNE=25.0000000
    InstantHitDamageThird_TUNE=50.0000000
    InstantHitMomentumStandard_TUNE=6000.0000000
    InstantHitMomentumSecond_TUNE=6000.0000000
    InstantHitMomentumThird_TUNE=6000.0000000
    LowAmmoMixSelect=SoundRiotMixSelect'Aud_GCm_MixSnapshot.LowAmmo_Fader'
    MagnumRoundsMix=SoundRiotMixSelect'Aud_GCm_MixSnapshot.Magnum_Fader'
    AudioPropertyFile=SoundRiotRawAsset'Aud_Weapons_All_SoundRiot.Audio'
    HUDInfoClass=Class'MOHAHUDWeaponInfo'
    WeaponExperienceClass=Class'MOHAWeaponExperienceComponent'
    CurrentUpgradeLevel=-1
    DefaultBurstType=(iNumShots=1,iPreDelayShots=0,fMinDelay=0.0000000,fMaxDelay=0.7500000,PauseProbability=(Points=/* Array type was not detected. */,InterpMethod=0),StartingSpreadOffset=200.0000000,BaseConvergeTime=2.7500000,ScaleFromRange=1400.0000000)
    NPCWeaponTypeIndex=3
    bMeleeWeapon=true
    PickupSound=SoundCue'Aud_GCm_FakeWAV.PlaceHolder.PlaceHolder'
    DroppedPickupClass=Class'MOHAWeaponDroppedPickup'
    // Reference: MOHASkeletalMeshComponent'Default__EALAWeapon.PickupMesh'
    begin object name=PickupMesh class=Class'MOHASkeletalMeshComponent'
        iMinLODLevel=1
        CastShadow=false
        bCastDynamicShadow=false
        LightingChannels=(bInitialized=true,Characters_Weapons_Vehicles=true)
        CollideActors=true
        RBChannel=5
        RBCollideWithChannels=(Default=true)
        bNotifyRigidBodyCollision=true
        bUseHardwareScene=true
        ScriptRigidBodyCollisionThreshold=2.0000000
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
    RemoteRole=0
    bStasis=true
}