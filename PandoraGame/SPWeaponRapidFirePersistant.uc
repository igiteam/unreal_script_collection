class SPWeaponRapidFirePersistant extends SPWeapon
    abstract
    native
    config(Game);

struct native SPWeaponRapidFirePersistantState
{
    var Actor m_owner;
    var bool m_allowRapidFire;
    var int m_actualBulletsPerSecond;
    var int m_genratedBulletsPerSecond;
    var int m_generatedSuppressionPerSecond;
    var int m_generatedTracersPerSecond;
    var bool m_bInfiniteAmmo;
    var transient bool m_bFiring;
    var transient int m_availableAmmo;
    var transient float m_accumulatedBullets;
    var transient float m_timeToNextSuppression;
    var transient float m_timeToNextVisibleTracer;
    var transient bool m_bShowTracer;
    var transient bool m_bSuppress;
    var transient float m_suppressionInterval;
    var transient float m_tracerInterval;
    var transient bool m_bReset;

    structdefaultproperties
    {
        m_owner=none
        m_allowRapidFire=true
        m_actualBulletsPerSecond=30
        m_genratedBulletsPerSecond=10
        m_generatedSuppressionPerSecond=1
        m_generatedTracersPerSecond=3
        m_bInfiniteAmmo=false
        m_bFiring=false
        m_availableAmmo=0
        m_accumulatedBullets=0.0000000
        m_timeToNextSuppression=0.0000000
        m_timeToNextVisibleTracer=0.0000000
        m_bShowTracer=false
        m_bSuppress=false
        m_suppressionInterval=0.0000000
        m_tracerInterval=0.0000000
        m_bReset=false
    }
};

var SPWeaponRapidFirePersistantState m_rapidFireControl;
var float m_ammoAmountFired;
var bool m_inRapdFireMode;
var bool m_isAntControlled;
var bool m_AntFakeFire;
var transient float m_nextSpawnShellCasingTime;

// Export USPWeaponRapidFirePersistant::execSPRF_StartFire(FFrame&, void* const)
native static simulated function SPRF_StartFire(out SPWeaponRapidFirePersistantState rapidFireControl, int availableAmmoForBurst);

// Export USPWeaponRapidFirePersistant::execSPRF_SetAmmoForBurst(FFrame&, void* const)
native static simulated function SPRF_SetAmmoForBurst(out SPWeaponRapidFirePersistantState rapidFireControl, int ammoForBurst);

// Export USPWeaponRapidFirePersistant::execSPRF_StopFire(FFrame&, void* const)
native static simulated function SPRF_StopFire(out SPWeaponRapidFirePersistantState rapidFireControl);

// Export USPWeaponRapidFirePersistant::execSPRF_CanGenerateBullet(FFrame&, void* const)
native static simulated function bool SPRF_CanGenerateBullet(out SPWeaponRapidFirePersistantState rapidFireControl);

// Export USPWeaponRapidFirePersistant::execSPRF_GetAccumulatedBullets(FFrame&, void* const)
native static simulated function int SPRF_GetAccumulatedBullets(out SPWeaponRapidFirePersistantState rapidFireControl);

// Export USPWeaponRapidFirePersistant::execSPRF_GetTickInterval(FFrame&, void* const)
native static simulated function float SPRF_GetTickInterval(out SPWeaponRapidFirePersistantState rapidFireControl);

// Export USPWeaponRapidFirePersistant::execSPRF_GetShotInfo(FFrame&, void* const)
native static simulated function SPRF_GetShotInfo(out SPWeaponRapidFirePersistantState rapidFireControl, out int accumulatedAmmo, out int bShowTracer, out int bSuppress);

// Export USPWeaponRapidFirePersistant::execSPProjectileFire(FFrame&, void* const)
native function Projectile SPProjectileFire(bool bUseFakeFire);

// Export USPWeaponRapidFirePersistant::execIsRapidFireMode(FFrame&, void* const)
native function bool IsRapidFireMode(int FireMode);

static simulated function float GetRoundsPerMinute()
{
    return 30.0000000;
    //return ReturnValue;    
}

static simulated function SPWeaponRapidFirePersistantState_Log(SPWeaponRapidFirePersistantState rapidFireControl)
{
    //return;    
}

simulated function StopFireEffectsForAnts()
{
    HideMuzzleFlashEmitter(true);
    ClearTimer('PlayFireEffectsForAnts');
    //return;    
}

simulated function PlayFireEffectsForAnts()
{
    PlayFireEffects(CurrentFireMode);
    //return;    
}

simulated function SpawnShellCasing(bool bOverride)
{
    // End:0x5C
    if(m_nextSpawnShellCasingTime < WorldInfo.TimeSeconds)
    {
        m_nextSpawnShellCasingTime = WorldInfo.TimeSeconds + ((1.0000000 / float(m_rapidFireControl.m_genratedBulletsPerSecond)) * 0.5000000);
        super.SpawnShellCasing(bOverride);
    }
    //return;    
}

simulated event AnimNotify_FireAmmunition(optional bool bUseFakeFire)
{
    local float Frequency;

    // End:0xC4
    if(!IsRapidFireMode(int(CurrentFireMode)) || m_isAntControlled)
    {
        super.AnimNotify_FireAmmunition(bUseFakeFire);
        // End:0xC4
        if(m_isAntControlled)
        {
            ClearTimer('StopFireEffectsForAnts');
            // End:0xB1
            if(!IsTimerActive('PlayFireEffectsForAnts'))
            {
                Frequency = (GetRoundsPerMinute()) / 60.0000000;
                // End:0x8C
                if(Frequency > float(30))
                {
                    Frequency = 30.0000000;
                }
                Frequency = 1.0000000 / Frequency;
                SetTimer(Frequency, true, 'PlayFireEffectsForAnts');
            }
            SetTimer(0.1250000, false, 'StopFireEffectsForAnts');
        }
    }
    //return;    
}

function DBG_MsgW(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitRapidFire();
    m_isAntControlled = (Owner != none) && SPSkeletalMeshActorMAT(Owner) != none;
    //return;    
}

simulated function InitRapidFire()
{
    local SPWeaponRapidFirePersistantState Control;

    InitRapidFireData(self, Control);
    m_rapidFireControl = Control;
    m_rapidFireControl.m_bInfiniteAmmo = bIsNPCWeapon;
    //return;    
}

static simulated function InitRapidFireData(Actor theOwner, out SPWeaponRapidFirePersistantState rapidFireControl)
{
    rapidFireControl.m_owner = theOwner;
    rapidFireControl.m_actualBulletsPerSecond = int((GetRoundsPerMinute()) / 60.0000000);
    rapidFireControl.m_allowRapidFire = true;
    //return;    
}

simulated function BaseFireAmmunition(optional bool bUseFakeFire, optional int ammoToConsume)
{
    // End:0x30
    if(IsRapidFireMode(int(CurrentFireMode)))
    {
        m_ammoAmountFired = float(SPRF_GetAccumulatedBullets(m_rapidFireControl));        
    }
    else
    {
        m_ammoAmountFired = 1.0000000;
    }
    super.BaseFireAmmunition(bUseFakeFire, int(m_ammoAmountFired));
    SPRF_SetAmmoForBurst(m_rapidFireControl, AvailableAmmoInMagazine(CurrentFireMode));
    //return;    
}

simulated function SpawnMuzzleFlash(byte FireModeNum, Vector pos, Rotator Rot)
{
    // End:0x0B
    if(m_bDisableMuzzleFlash)
    {
        return;
    }
    ClearTimer('DestroyMuzzleFlashEmitter');
    // End:0x3F
    if(!HasMuzzleFlashEmitter())
    {
        super.SpawnMuzzleFlash(FireModeNum, pos, Rot);
    }
    HideMuzzleFlashEmitter(false);
    //return;    
}

simulated function StopFireEffects(byte FireModeNum)
{
    // End:0x2B
    if(HasMuzzleFlashEmitter())
    {
        HideMuzzleFlashEmitter(true);
        SetTimer(15.0000000, false, 'DestroyMuzzleFlashEmitter');
    }
    StopForceFeedBackEffect();
    //return;    
}

simulated function PutDownWeapon()
{
    super(Weapon).PutDownWeapon();
    StopForceFeedBackEffect();
    //return;    
}

simulated function StopForceFeedBackEffect()
{
    local PandoraPlayerController PPC;

    PPC = GetPandoraPlayerController();
    // End:0x53
    if((PPC != none) && m_gamePad.Fire_ForceFeedbackWaveform != none)
    {
        PPC.ClientStopForceFeedbackWaveform(m_gamePad.Fire_ForceFeedbackWaveform);
    }
    m_ForceFeedBackActive = false;
    //return;    
}

simulated function Destroyed()
{
    DestroyMuzzleFlashEmitter();
    super.Destroyed();
    //return;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        local PandoraPlayerController PPC;

        // End:0x24
        if(!IsRapidFireMode(int(CurrentFireMode)))
        {
            super.BeginState(PreviousStateName);            
        }
        else
        {
            BeginStateRapidFire(PreviousStateName);
            // End:0xD5
            if(int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                // End:0xD2
                if(WorldInfo.GRI.bIsArbitrated)
                {
                    // End:0xD2
                    if(!bWeaponHasBeenFired && int(Role) == int(ROLE_Authority))
                    {
                        bWeaponHasBeenFired = true;
                        PPC = PandoraPlayerController(Pawn(Owner).Controller);
                        // End:0xD2
                        if(PPC != none)
                        {
                            PPC.ClientNewWeaponFiredAchievement(WeaponType);
                        }
                    }
                }                
            }
            else
            {
                // End:0x12B
                if(!bWeaponHasBeenFired)
                {
                    bWeaponHasBeenFired = true;
                    PPC = PandoraPlayerController(Pawn(Owner).Controller);
                    // End:0x12B
                    if(PPC != none)
                    {
                        PPC.SinglePlayerNewWeaponFiredAchievement(WeaponType);
                    }
                }
            }
            return;
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x1A
        if(m_inRapdFireMode == false)
        {
            super.EndState(NextStateName);            
        }
        else
        {
            EndStateRapidFire(NextStateName);
        }
        //return;        
    }

    simulated function PoppedState()
    {
        super(Object).PoppedState();
        OnLeaveState();
        //return;        
    }

    simulated function ContinuedState()
    {
        super(Object).ContinuedState();
        OnEnterState();
        //return;        
    }

    simulated function BeginStateRapidFire(name PreviousStateName)
    {
        // End:0x18
        if(!IsRapidFireMode(int(CurrentFireMode)))
        {
            return;
        }
        OnEnterState();
        //return;        
    }

    simulated function EndStateRapidFire(name NextStateName)
    {
        // End:0x18
        if(!IsRapidFireMode(int(CurrentFireMode)))
        {
            return;
        }
        OnLeaveState();
        //return;        
    }

    simulated function OnEnterState()
    {
        m_inRapdFireMode = true;
        PlayFiringAnim();
        SPRF_StartFire(m_rapidFireControl, AvailableAmmoInMagazine(CurrentFireMode));
        PlayFireEffects(CurrentFireMode);
        Sound_Looping = none;
        // End:0xC3
        if(Sound_FireStart != none)
        {
            // End:0x80
            if(Owner != none)
            {
                Sound_Looping = Owner.CreateAudioComponent(Sound_FireStart, false, true);                
            }
            else
            {
                Sound_Looping = CreateAudioComponent(Sound_FireStart, false, true);
            }
            // End:0xC3
            if(Sound_Looping != none)
            {
                Sound_Looping.bAutoDestroy = true;
                Sound_Looping.Play();
            }
        }
        TimeWeaponFiring(CurrentFireMode);
        //return;        
    }

    simulated function OnLeaveState()
    {
        // End:0x18
        if(!IsRapidFireMode(int(CurrentFireMode)))
        {
            return;
        }
        SPRF_StopFire(m_rapidFireControl);
        ClearTimer('RefireCheckTimer');
        ClearPendingFire(int(CurrentFireMode));
        ForceEndFire();
        m_inRapdFireMode = false;
        // End:0x7C
        if(Sound_Looping != none)
        {
            Sound_Looping.Stop();
            Sound_Looping = none;
        }
        PlayFireEndSound();
        // End:0xA5
        if(!HasAmmo(CurrentFireMode))
        {
            WeaponEmpty();
        }
        bDryFire = false;
        ClearFlashCount();
        StopFireEffects(CurrentFireMode);
        //return;        
    }

    simulated function TimeWeaponFiring(byte FireModeNum)
    {
        local float interval;

        // End:0x23
        if(!IsRapidFireMode(int(FireModeNum)))
        {
            super(Weapon).TimeWeaponFiring(FireModeNum);
            return;
        }
        // End:0x6A
        if(!IsTimerActive('RefireCheckTimer'))
        {
            interval = SPRF_GetTickInterval(m_rapidFireControl);
            RefireCheckTimer();
            SetTimer(interval, true, 'RefireCheckTimer');
        }
        //return;        
    }

    simulated function bool ShouldRefire()
    {
        // End:0x17
        if(!HasAmmo(CurrentFireMode))
        {
            return false;
        }
        return super(SPWeapon).ShouldRefire();
        //return ReturnValue;        
    }

    simulated function RefireCheckTimer()
    {
        // End:0x1E
        if(!IsRapidFireMode(int(CurrentFireMode)))
        {
            super.RefireCheckTimer();
            return;
        }
        // End:0x33
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x7D
        if(ShouldRefire())
        {
            PlayFiringAnim();
            PlayFiringSound();
            SPFireSetupRecoilEffect();
            // End:0x7B
            if(SPRF_CanGenerateBullet(m_rapidFireControl))
            {
                SPFireAmmunition();
            }
            return;
        }
        StopForceFeedBackEffect();
        // End:0xC4
        if(!bSemiAuto)
        {
            // End:0xA8
            if(bDryFire)
            {
                PlayWeaponEmptySound();                
            }
            else
            {
                // End:0xC4
                if(StillFiring(CurrentFireMode))
                {
                    bDryFire = true;
                    return;
                }
            }
        }
        StopFire(CurrentFireMode);
        GotoState('Active');
        //return;        
    }
    stop;    
}
