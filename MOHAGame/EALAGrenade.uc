class EALAGrenade extends EALAWeapon
    abstract
    native
    config(Weapon)
    hidecategories(Navigation);

var bool bFirePressed;
var() bool bShowExplosionSphere;
var bool bIsCooking;
var(Tuning_ExplosionLight) config bool bUseExplosionLight;
var Projectile SpawnedExplosive;
var float ThrowStrength;
var() config float ThrowTriggerLagStrength;
var() config float ExplosiveSpeed;
var() config float MaxExplosiveSpeed;
var() config float FuseTime;
var() config Rotator DirectionOffset;
var() config float TossThreshold;
var(Tuning_Animations) config name GrenadePinPullAnim;
var() config float ExplosiveDrawScale;
var float CookingSoundTimer;
var float CurrentCookSoundPlayInterval;
var array<float> CookingSoundPlayInterval;
var() config float HoldToCookTime;
var() config float ThrowInterval;
var() config float TossInterval;
var() config float PrimeInterval;
var() config float PullPinInterval;
var() config float PullBackInterval;
var() config float PrimeCutoff;
var() config float ClientActualThrowInterval;
var() config float ClientActualTossInterval;
var(Tuning_ExplosionLight) config Color LightColor;
var(Tuning_ExplosionLight) config float LightRadius;
var(Tuning_ExplosionLight) config float LightLifespan;
var(Tuning_ExplosionLight) config float LightBrightness;
var(Tuning_ExplosionLight) config float LightFalloffSpeed;
var(Tuning_ExplosionLight) config float LightFalloffExponent;
var(Tuning_ExplosionLight) config float LightCreationDelay;
var(Tuning_Ironsights) config Vector IronsightsCameraOffset;
var(Tuning_Sounds) export editinline AudioComponent CookingStartSound;
var(Tuning_Sounds) export editinline AudioComponent CookingCountdownSound;
var() config float ExplosivePawnVelocityScale;

simulated function AddUpgradeSequenceAmmo()
{
    //return;    
}

simulated function StartCooking()
{
    SetTimer(FuseTime);
    // End:0x3A
    if((CookingStartSound != none) && Instigator.IsLocallyControlled())
    {
        CookingStartSound.Play();
    }
    SetTimer(0.5000000, false, 'StartCookingSound');
    bIsCooking = true;
    CookingSoundTimer = 0.0000000;
    ClearPendingFire(1);
    CurrentCookSoundPlayInterval = CookingSoundPlayInterval[0];
    //return;    
}

function StartCookingSound()
{
    // End:0x2E
    if((CookingCountdownSound != none) && Instigator.IsLocallyControlled())
    {
        CookingCountdownSound.Play();
    }
    //return;    
}

simulated function UpdateCookingSound(float dt)
{
    local float FuseLength, FuseTimeRemaining, FuseRatio;

    // End:0x22
    if(!bIsCooking || IsTimerActive('StartCookingSound'))
    {
        return;
    }
    CookingSoundTimer += dt;
    // End:0xE9
    if((CookingSoundTimer > CurrentCookSoundPlayInterval) && CookingCountdownSound != none)
    {
        // End:0x7A
        if(Instigator.IsLocallyControlled())
        {
            CookingCountdownSound.Stop();
            CookingCountdownSound.Play();
        }
        CookingSoundTimer = 0.0000000;
        // End:0xE9
        if(GetTimerCount() > float(0))
        {
            FuseLength = GetTimerRate();
            FuseTimeRemaining = GetTimerRate() - GetTimerCount();
            FuseRatio = FuseTimeRemaining / FuseLength;
            // End:0xE9
            if(FuseRatio < 0.4000000)
            {
                CurrentCookSoundPlayInterval = CookingSoundPlayInterval[1];
            }
        }
    }
    //return;    
}

simulated function Timer()
{
    local MOHAProj_Explosive ProjExplosive;

    ConsumeAmmo(CurrentFireMode);
    ClearTimer();
    ClearPendingFire(0);
    HideMesh(true);
    SpawnedExplosive = SpawnProjectile(GrenadeStartLocation(), vect(1.0000000, 0.0000000, 0.0000000));
    ProjExplosive = MOHAProj_Explosive(SpawnedExplosive);
    // End:0x71
    if(ProjExplosive == none)
    {
        return;
    }
    // End:0xAD
    if(bIsCooking && ProjExplosive.MyCookedDamageType != none)
    {
        ProjExplosive.MyDamageType = ProjExplosive.MyCookedDamageType;
    }
    SetupLight();
    // End:0xFC
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        SpawnedExplosive.Explode(GrenadeStartLocation(), Vector(GrenadeStartDirection()));        
    }
    else
    {
        SpawnedExplosive.SetTimer(0.1000000);
        MOHAProj_Explosive(SpawnedExplosive).SetFuseTime(0.1000000);
    }
    bIsCooking = false;
    // End:0x15B
    if(none != CookingCountdownSound)
    {
        CookingSoundTimer = 0.0000000;
        CookingCountdownSound.Stop();
    }
    // End:0x188
    if((HasAnyAmmo()) || HasReserveAmmo())
    {
        GotoState('WeaponReload');        
    }
    else
    {
        WeaponEmpty();
        GotoState('Active');
    }
    //return;    
}

simulated exec function UpdateWeapon()
{
    UpdateWeaponVars();
    //return;    
}

simulated function Vector GrenadeStartLocation()
{
    // End:0x86
    if(Instigator.IsA('MOHAPlayerPawn'))
    {
        // End:0x5B
        if(MOHAPlayerPawn(Instigator).FPArms != none)
        {
            return MOHAPlayerPawn(Instigator).FPArms.GetBoneLocation('Camera', 0);            
        }
        else
        {
            return MOHAMultiplayerPawn(Instigator).Mesh.GetBoneLocation('Helmet', 0);
        }        
    }
    else
    {
        return Instigator.Location;
    }
    //return ReturnValue;    
}

simulated event Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    return GrenadeStartLocation();
    //return ReturnValue;    
}

simulated function Rotator GrenadeStartDirection()
{
    local Rotator startDirection;

    startDirection = SpawnedExplosive.Rotation;
    // End:0x63
    if(!TossGrenade())
    {
        startDirection.Yaw += DirectionOffset.Yaw;
        startDirection.Roll += DirectionOffset.Roll;
    }
    // End:0x92
    if(startDirection.Pitch > 32768)
    {
        startDirection.Pitch -= 65536;
    }
    // End:0xC4
    if(float(startDirection.Pitch) > MOHAProj_Explosive(SpawnedExplosive).PitchClamp)
    {
        return startDirection;        
    }
    else
    {
        // End:0x126
        if(float(startDirection.Pitch + DirectionOffset.Pitch) > MOHAProj_Explosive(SpawnedExplosive).PitchClamp)
        {
            startDirection.Pitch = int(MOHAProj_Explosive(SpawnedExplosive).PitchClamp);            
        }
        else
        {
            startDirection.Pitch += DirectionOffset.Pitch;
        }
    }
    return startDirection;
    //return ReturnValue;    
}

simulated function Rotator GrenadeStartRotation()
{
    // End:0x2B
    if(Instigator.IsA('MOHAPlayerPawn'))
    {
        return MOHAPlayerPawn(Instigator).CurrentView;
    }
    return Instigator.Rotation;
    //return ReturnValue;    
}

simulated function SetExplosiveSpeed()
{
    SpawnedExplosive.Speed = ExplosiveSpeed + (ThrowStrength * (MaxExplosiveSpeed - ExplosiveSpeed));
    //return;    
}

simulated function HideMesh(bool bMeshHidden)
{
    // End:0x20
    if(Mesh != none)
    {
        Mesh.SetHidden(bMeshHidden);
    }
    //return;    
}

simulated function bool TossGrenade()
{
    return ThrowStrength <= TossThreshold;
    //return ReturnValue;    
}

simulated function float GetThrowInterval()
{
    return ((ThrowInterval > float(0)) ? ThrowInterval : 0.0000000);
    //return ReturnValue;    
}

simulated function float GetTossInterval()
{
    return ((TossInterval > float(0)) ? TossInterval : 0.0000000);
    //return ReturnValue;    
}

simulated function float GetPrimeInterval()
{
    return ((PrimeInterval > float(0)) ? PrimeInterval : 0.0000000);
    //return ReturnValue;    
}

function float GetPullPinInterval()
{
    return ((PullPinInterval > float(0)) ? PullPinInterval : 0.0000000);
    //return ReturnValue;    
}

function float GetPullBackInterval()
{
    return ((PullBackInterval > float(0)) ? PullBackInterval : 0.0000000);
    //return ReturnValue;    
}

simulated function SetupLight()
{
    // End:0x44
    if(bUseExplosionLight)
    {
        MOHAProj_Explosive(SpawnedExplosive).CreateLight(LightColor, LightRadius, LightLifespan, LightBrightness, LightFalloffSpeed, LightFalloffExponent, LightCreationDelay);
    }
    //return;    
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    return BaseAim;
    //return ReturnValue;    
}

simulated function UpdateThrowStrength(float dt)
{
    local float DesiredThrowStrength;

    // End:0x0D
    if(!bFirePressed)
    {
        return;
    }
    DesiredThrowStrength = MOHAPlayerPawn(Instigator).GetFireAxis();
    ThrowStrength = Class'MOHAUtilities'.static.LagValue(ThrowStrength, DesiredThrowStrength, ThrowTriggerLagStrength, dt);
    // End:0xB0
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && Instigator.IsLocallyControlled())
    {
        MOHAMultiplayerController(MOHAPlayerPawn(Instigator).Controller).SetGrenadeThrowStrength(ThrowStrength);
    }
    //return;    
}

simulated function Projectile ProjectileFire()
{
    local float TimerRate;
    local Vector pawnVelocity;
    local Rotator SpawnedRotation;
    local MOHAProj_Explosive ProjExplosive;
    local bool bWasCooking;

    // End:0x2B
    if(GetTimerCount() > float(0))
    {
        TimerRate = GetTimerRate() - GetTimerCount();        
    }
    else
    {
        TimerRate = FuseTime;
    }
    ClearTimer();
    bWasCooking = bIsCooking;
    bIsCooking = false;
    CookingSoundTimer = 0.0000000;
    // End:0x79
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return none;
    }
    // End:0xE8
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ThrowStrength = MOHAMultiplayerController(MOHAPlayerPawn(Instigator).Controller).m_GrenadeThrowStrength;
        MOHAMultiplayerController(MOHAPlayerPawn(Instigator).Controller).m_MPPlayerStats.StatAddGrenadeThrow();
    }
    SpawnedExplosive = MOHAProj_Explosive(super.ProjectileFire());
    SpawnedExplosive.SetDrawScale(ExplosiveDrawScale);
    HideMesh(true);
    SpawnedRotation = GrenadeStartDirection();
    SpawnedRotation.Yaw = Instigator.Rotation.Yaw;
    SetExplosiveSpeed();
    MOHAProj_Explosive(SpawnedExplosive).InitRotator(SpawnedRotation);
    SpawnedExplosive.SetRotation(GrenadeStartRotation());
    SpawnedExplosive.SetTimer(TimerRate);
    MOHAProj_Explosive(SpawnedExplosive).SetFuseTime(TimerRate);
    MOHAProj_Explosive(SpawnedExplosive).bShowExplosionSphere = bShowExplosionSphere;
    SetupLight();
    // End:0x22B
    if(Instigator.IsA('MOHAPlayerPawn'))
    {
        pawnVelocity = Instigator.Velocity * ExplosivePawnVelocityScale;
        SpawnedExplosive.Velocity += pawnVelocity;
    }
    ThrowStrength = 0.0000000;
    ProjExplosive = MOHAProj_Explosive(SpawnedExplosive);
    // End:0x28D
    if(bWasCooking && ProjExplosive.MyCookedDamageType != none)
    {
        // End:0x28D
        if(ProjExplosive != none)
        {
            ProjExplosive.MyDamageType = ProjExplosive.MyCookedDamageType;
        }
    }
    MOHAPlayerController(Instigator.Controller).playerStats.OnWeaponFire(WeaponType, WeaponClass);
    return SpawnedExplosive;
    //return ReturnValue;    
}

simulated function TimerEnd()
{
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x5B
    if(Instigator.IsA('MOHAPlayerPawn'))
    {
        // End:0x3C
        if(none != CookingStartSound)
        {
            Instigator.AttachComponent(CookingStartSound);
        }
        // End:0x5B
        if(none != CookingCountdownSound)
        {
            Instigator.AttachComponent(CookingCountdownSound);
        }
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super.Tick(DeltaTime);
    HandleGrenadeIronsights();
    UpdateThrowStrength(DeltaTime);
    UpdateCookingSound(DeltaTime);
    //return;    
}

simulated function HandleGrenadeIronsights()
{
    // End:0x11
    if(!IsActiveWeapon())
    {
        return;
    }
    // End:0x60
    if(((IronsightsButtonDown()) && int(IronsightsState) == int(0)) && CanIronsight())
    {
        StartIronsightsZoom();
        SetTimer(IronsightsInTime, false, 'GrenadeIronsightsOnTimer');        
    }
    else
    {
        // End:0xA2
        if(!IronsightsButtonDown() && int(IronsightsState) == int(3))
        {
            EndIronsightsZoom();
            SetTimer(IronsightsOutTime, false, 'GrenadeIronsightsOffTimer');            
        }
        else
        {
            // End:0xDF
            if((IsPuttingDownWeapon()) && int(IronsightsState) == int(3))
            {
                EndIronsightsZoom();
                SetTimer(PutDownTime, false, 'GrenadeIronsightsOffTimer');
            }
        }
    }
    //return;    
}

simulated function GrenadeIronsightsOnTimer()
{
    IronsightsState = 3;
    //return;    
}

simulated function GrenadeIronsightsOffTimer()
{
    IronsightsState = 0;
    //return;    
}

simulated event GetViewOffset(out Vector vWeaponOffset)
{
    local float fPerc, fFOVRange;

    // End:0x72
    if(int(IronsightsState) != int(0))
    {
        fFOVRange = IronsightsStartingWorldFOV - IronsightsTargetWorldFOV;
        fPerc = ((fFOVRange != 0.0000000) ? FClamp((IronsightsStartingWorldFOV - IronsightsCurrentWorldFOV) / fFOVRange, 0.0000000, 1.0000000) : 1.0000000);
        vWeaponOffset = IronsightsCameraOffset * fPerc;        
    }
    else
    {
        super.GetViewOffset(vWeaponOffset);
    }
    //return;    
}

simulated function WeaponEmpty()
{
    super.WeaponEmpty();
    // End:0x3F
    if(((none == Instigator) || none == Instigator.InvManager) || Instigator.Health <= 0)
    {
        return;
    }
    MOHAInventoryManager(Instigator.InvManager).SwitchGrenade();
    //return;    
}

simulated function bool PutWeaponDownWhenEmpty()
{
    return true;
    //return ReturnValue;    
}

simulated function bool HideCursorInIronsights()
{
    return false;
    //return ReturnValue;    
}

simulated function MOHAPhysicalMaterialProperty.EImpactType GetMeleeImpactType()
{
    return 27;
    //return ReturnValue;    
}

simulated state GrenadePinPull
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x66
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_PrimeEvent();
            PlayWeaponAnimation(GrenadePinPullAnim, PrimeInterval);
            SetTimer(PrimeInterval, false, 'TimerEnd');
            StartCooking();            
        }
        else
        {
            TimerEnd();
        }
        //return;        
    }

    simulated function TimerEnd()
    {
        GotoState('GrenadePrimed');
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x0F
        if(int(FireModeNum) != 0)
        {
            return;
        }
        bFirePressed = true;
        super(Weapon).BeginFire(FireModeNum);
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        // End:0x0F
        if(int(FireModeNum) != 0)
        {
            return;
        }
        // End:0x20
        if(bFirePressed)
        {
            bFirePressed = false;
        }
        GotoState('GrenadeThrowing');
        super(Weapon).EndFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state GrenadePrimed
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x32
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_PrimeIdleEvent();            
        }
        PlayWeaponAnimation(WeaponFireAnim[0], 0.0667000, true);
        //return;        
    }

    simulated function EndState(name PreviousStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        //return;        
    }

    simulated function EndFire(byte FireModeNum)
    {
        // End:0x0F
        if(int(FireModeNum) != 0)
        {
            return;
        }
        // End:0x20
        if(bFirePressed)
        {
            bFirePressed = false;
        }
        GotoState('GrenadeThrowing');
        super(Weapon).EndFire(FireModeNum);
        //return;        
    }
    stop;    
}

simulated state GrenadeThrowing
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0xC7
        if((int(WorldInfo.NetMode) != int(NM_Standalone)) && !MOHAPlayerPawn(Instigator).IsLocallyControlled())
        {
            // End:0x84
            if(TossGrenade())
            {
                MOHAPlayerPawn(Instigator).Weapon_TossEvent();
                SetTimer(ClientActualTossInterval, false, 'OnProjectileToss');
                SetTimer(TossInterval, false, 'TimerEnd');                
            }
            else
            {
                MOHAPlayerPawn(Instigator).Weapon_ThrowEvent();
                SetTimer(ClientActualThrowInterval, false, 'OnProjectileToss');
                SetTimer(ThrowInterval, false, 'TimerEnd');
            }            
        }
        else
        {
            // End:0x149
            if(Instigator.IsA('MOHAPlayerPawn'))
            {
                // End:0x11A
                if(TossGrenade())
                {
                    MOHAPlayerPawn(Instigator).Weapon_TossEvent();
                    SetTimer(TossInterval, false, 'TimerEnd');                    
                }
                else
                {
                    MOHAPlayerPawn(Instigator).Weapon_ThrowEvent();
                    SetTimer(ThrowInterval, false, 'TimerEnd');
                }                
            }
            else
            {
                OnProjectileToss();
            }
        }
        //return;        
    }

    simulated function OnProjectileToss()
    {
        ClearPendingFire(0);
        ClearPendingFire(1);
        FireAmmunition();
        // End:0x42
        if(CookingCountdownSound != none)
        {
            CookingCountdownSound.Stop();
            bIsCooking = false;
        }
        //return;        
    }

    simulated function TimerEnd()
    {
        // End:0x2D
        if((HasAnyAmmo()) || HasReserveAmmo())
        {
            GotoState('WeaponReload');            
        }
        else
        {
            WeaponEmpty();
            GotoState('Active');
        }
        //return;        
    }

    simulated function EndState(name PreviousStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        //return;        
    }
    stop;    
}

simulated state WeaponReload
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x46
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).Weapon_RaiseWeaponEvent();
            SetTimer(EquipTime, false, 'TimerEnd');            
        }
        else
        {
            TimerEnd();
        }
        HideMesh(false);
        PlayWeaponAnimation(WeaponIdleAnim[0], 0.0667000, true);
        //return;        
    }

    simulated function TimerEnd()
    {
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name PreviousStateName)
    {
        // End:0x2F
        if(Instigator.IsA('MOHAPlayerPawn'))
        {
            MOHAPlayerPawn(Instigator).ActivityDoneEvent();
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x20
        if(AmmoCount[0] > 0)
        {
            AddAmmo(-AmmoCount[0]);
        }
        PlayWeaponAnimation(WeaponIdleAnim[0], 0.0667000, true);
        bFirePressed = false;
        ThrowStrength = 0.0000000;
        ClearTimer();
        I = 0;
        J0x5A:

        // End:0xA3 [Loop If]
        if(I < InvManager.PendingFire.Length)
        {
            // End:0x99
            if(PendingFire(I))
            {
                BeginFire(byte(I));
                // [Explicit Break]
                goto J0xA3;
            }
            I++;
            // [Loop Continue]
            goto J0x5A;
        }
        J0xA3:

        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x21
        if(!HasReserveAmmo() && int(FireModeNum) != 2)
        {
            return;
        }
        // End:0x40
        if(int(FireModeNum) == 2)
        {
            GotoState('WeaponMeleeFire');            
        }
        else
        {
            // End:0x52
            if(int(FireModeNum) == 1)
            {
                return;                
            }
            else
            {
                // End:0x86
                if(int(FireModeNum) == 0)
                {
                    bFirePressed = true;
                    AddAmmo(MaxAmmoCount[0]);
                    GotoState('GrenadePinPull');
                }
            }
        }
        super.BeginFire(FireModeNum);
        //return;        
    }
    stop;    
}

defaultproperties
{
    bUseExplosionLight=true
    ThrowTriggerLagStrength=10.0000000
    ExplosiveSpeed=600.0000000
    MaxExplosiveSpeed=1800.0000000
    FuseTime=5.0000000
    DirectionOffset=(Pitch=4000,Yaw=0,Roll=0)
    TossThreshold=0.7500000
    ExplosiveDrawScale=1.5000000
    CookingSoundPlayInterval[0]=0.2500000
    CookingSoundPlayInterval[1]=0.1000000
    HoldToCookTime=0.2500000
    ThrowInterval=1.1333000
    TossInterval=0.6667000
    PrimeInterval=1.0333000
    PullPinInterval=1.2667000
    PullBackInterval=0.6667000
    ClientActualThrowInterval=0.1200000
    ClientActualTossInterval=0.0400000
    LightColor=(R=255,G=255,B=230,A=0)
    LightRadius=300.0000000
    LightLifespan=0.1000000
    LightBrightness=10.0000000
    LightFalloffSpeed=10.1000000
    LightFalloffExponent=2.0000000
    LightCreationDelay=0.0500000
    IronsightsCameraOffset=(X=3.0000000,Y=0.0000000,Z=-4.0000000)
    // Reference: AudioComponent'Default__EALAGrenade.CookingStartSound01'
    begin object name=CookingStartSound01 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Grenade.Grenade_CookStarted'
    end object
    CookingStartSound=CookingStartSound01
    // Reference: AudioComponent'Default__EALAGrenade.CookingCountdownSound01'
    begin object name=CookingCountdownSound01 class=Class'Engine.AudioComponent'
        SoundCue=SoundCue'Aud_GCm_FakeWAV.Grenade.Grenade_TimerTick'
    end object
    CookingCountdownSound=CookingCountdownSound01
    ExplosivePawnVelocityScale=0.5000000
    MaxAmmoCount[0]=1
    MaxAmmoCount[1]=1
    PickupMinAmmo=1
    HUDInfoClass=Class'MOHAHUDWeaponInfoFragGrenade'
    WeaponFireTypes=/* Array type was not detected. */
    FiringStatesArray=/* Array type was not detected. */
    Spread=/* Array type was not detected. */
    InstantHitDamage=/* Array type was not detected. */
    InstantHitDamageTypes=/* Array type was not detected. */
    EquipTime=0.9000000
    // Reference: MOHASkeletalMeshComponent'Default__EALAGrenade.PickupMesh'
    begin object name=PickupMesh
    end object
    DroppedPickupMesh=PickupMesh
    PickupFactoryMesh=PickupMesh
}