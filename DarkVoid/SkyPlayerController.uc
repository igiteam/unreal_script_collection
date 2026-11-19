class SkyPlayerController extends SkyPlayerControllerCoverUser
    native
    config(Game);

enum AutoCenterState
{
    ACS_Idle,                       // 0
    ACS_Waiting,                    // 1
    ACS_Centering,                  // 2
    ACS_MAX                         // 3
};

enum EQuickLookCamera
{
    QLC_None,                       // 0
    QLC_Right,                      // 1
    QLC_Left,                       // 2
    QLC_Up,                         // 3
    QLC_Down,                       // 4
    QLC_MAX                         // 5
};

struct native SAudioCategories
{
    var string category;
    var int RefCount;

    structdefaultproperties
    {
        category=""
        RefCount=0
    }
};

var() float WeaponImpulse;
var() float HoldDistanceMin;
var() float HoldDistanceMax;
var() float ThrowImpulse;
var() float ChangeHoldDistanceIncrement;
var() export editinline RB_Handle PhysicsGrabber;
var float HoldDistance;
var Quat HoldOrientation;
var() float FlashRecoverTime;
var float CurrentFlashLength;
var globalconfig SkyPawnBase.ESkyWeaponHand SecondaryWeaponHandPreference;
var SkyPawnBase.ESkyWeaponHand SecondaryWeaponHand;
var SkyPlayerController.AutoCenterState m_AutoCenterState;
var SkyPlayerController.EQuickLookCamera QuickLookCam;
var Actor.EPhysics SavedMatineePhysics;
var float LastMoveX;
var float LastMoveY;
var transient Vector m_vLastRawJoystick;
var transient Vector m_vCurrRawJoystick;
var transient float m_fLastJoyMag;
var transient float m_fCurrJoyMag;
var PlayerInput OldInput;
var transient bool bWantToLeave;
var transient bool bWantsThrustAfterExit;
var transient bool bWantRocketpackThrust;
var bool m_bPeggedLastFrame;
var transient bool m_bReticleMaxed;
var transient bool m_bReticleMaxedLast;
var bool m_bMagnetismOn;
var bool m_bAutoCenter;
var transient bool bAutoTarget_PawnRelative;
var bool bAutoTarget_PawnRelative_Normal;
var bool bAutoTarget_PawnRelative_Vehicle;
var bool bAutoTarget_PawnRelative_Melee;
var transient bool bPerformedPressUseAction;
var bool bHasCachedPlayerViewPoint;
var() bool bCanHijack;
var bool bNearestTargetCam;
var transient bool bNearestTargetCamNodeBlendedIn;
var bool bFreeLookCam;
var transient bool bFreeLookCamNodeBlendedIn;
var transient bool bQuickLookCamNodeBlendedIn;
var transient bool bAllowSprint;
var transient bool bAttemptingSprint;
var bool bAlreadyEjecting;
var bool bLockedEject;
var bool bDisableVehicleExit;
var bool FtB_bActionOnFadeToBlackComplete;
var bool FtB_InteractionOrVehicleExit;
var bool FtB_Hijack;
var bool FtB_SwappingAAGun;
var bool FtB_bInProgress;
var transient bool bAudioLevelsLoweredOnDeath;
var transient bool bZeroingRoll;
var transient bool bZeroingRollLastFrame;
var transient bool bInstantZeroRoll;
var() float WantRocketpackThrustTimeout;
var Rotator UserRotationOffset;
var Pawn ViewTargetAirVehicle;
var() float StickDeadZoneMin;
var() float StickDeadZoneMax;
var() float m_fReticleAccelTime;
var float m_fReticleAccelStartTime;
var() float m_fStickPeggedThreshold;
var() float m_fStickPeggedUpDownLimit;
var() float m_fPrePeggedThresholdSpeedPercent;
var transient Rotator m_rReticleRotation;
var float m_fReticleDistFromCamera;
var array<Vector2D> m_ReticleAccelCurvePoints;
var Rotator m_rTargetTransOrigRot;
var Rotator m_rTargetTransFinalRot;
var Rotator m_rTargetTransOrigRetRot;
var Rotator m_rTargetTransFinalRetRot;
var transient Vector m_vJoystickVel;
var SkyPawn m_pMagnetismTarget;
var() config float m_fMagnetismReticleSize;
var() config float m_fMagnetismMinDist;
var() config float m_fMagnetismMinDistHover;
var Vector m_vMagnetismClosestOnPill;
var Vector m_vMagnetismClosestOnTrace;
var() config float m_fMagnetismStrengthPercent;
var() config float m_fMagnetismStrengthPercentCover;
var() config float m_fMagnetismStrengthPercentHover;
var() config float m_fMagnetismStrengthPercentMin;
var() config float m_fMagnetismStrengthPercentCoverMin;
var() config float m_fMagnetismStrengthPercentHoverMin;
var deprecated int m_nReticleSensitivity;
var deprecated array<Vector2D> m_ReticleSpeedsDefault;
var() array<Rotator> m_ReticleOffsetValues;
var() array<bool> m_ReticleToggle;
var() float m_fAutoCenterWaitTime;
var float m_fAutoCenterWaitTimer;
var() float m_fAutoCenterSpeed;
var float m_fAutoCenterTime;
var float m_fAutoCenterStartTime;
var int m_nAutoCenterBeginPitch;
var() float m_fAutoCenterMinPitch;
var int m_nAutoCenterMinPitch;
var Rotator m_rReticleRotationDelta;
var transient float AutoTargetLastValidTargetTime;
var transient float AutoTargetLastLockedOnTime;
var float AutoTargetLockTolerance;
var transient Actor PendingAutoTarget;
var transient float PendingAutoTargetTime;
var float AutoTargetLockAcquireTime;
var SoundCue AutoTargetLostSound;
var float AutoTargetLockCheckTime;
var transient float AutoTarget_LOSTolerance;
var transient float AutoTarget_Radius;
var float AutoTarget_LOSTolerance_Normal;
var float AutoTarget_Radius_Normal;
var float AutoTarget_LOSTolerance_Vehicle;
var float AutoTarget_Radius_Vehicle;
var float AutoTarget_LOSTolerance_Melee;
var float AutoTarget_Radius_Melee;
var() float WeaponPickup_UseButtonHoldTime;
var transient float WeaponPickup_UseButtonHoldTimer;
var Vehicle MostRecentVehiclePossessed;
var Vector MostRecentVehiclePossessedLocation;
var Rotator MostRecentVehiclePossessedRotation;
var Pawn MostRecentHijackTarget;
var Vector MostRecentHijackTargetLocation;
var Rotator MostRecentHijackTargetRotation;
var Vector vCachedPlayerViewPoint;
var Rotator rCachedPlayerViewPoint;
var class<Pawn> MP_Class;
var float MP_RespawnTime;
var float SP_RespawnTime;
var SkyAnnouncer SAnnouncer;
var Camera OldCamera;
var Pawn NearestTarget;
var() float NearestTargetRange;
var transient float FreeLookCamNodeBlendTime;
var int DisableThrustCount;
var int ForceThrustCount;
var SkyCamera CameraTemplate;
var float SpecialMoveInputTimeout;
var SkyAIController SkyAIDebugTarget;
var SkySeqAct_InteractiveInterp InteractiveMatinee;
var transient int LastAttemptedSprintMode;
var transient Actor BestPickup;
var float FtB_TimeOfFadeToBlack;
var float FtB_TimeOfBlack;
var float FtB_TimeOfFadeFromBlack;
var SkyVehicle_AAGun_Gatling NextAAGun;
var transient int XeGammaCurPoint;
var transient float XeGammaCurTime;
var transient name notifyPopupName;
var transient float ZeroRollTime;
var transient float ZeroRollStartTime;
var transient Quat ZeroRollInitialQuat;
var transient int PlayerHiddenRefCount;
var transient int AllPawnsHiddenRefCount;
var transient int MatineePlayerRefCount;
var transient array<SAudioCategories> AudioCategoryRefCounts;
var transient float LockoutExitRocketpackTimerAfterTurnAroundVolume;
var transient float LastPilotChatterVOTime;
var(PilotChatter) float PilotChatterVODelayMin;
var(PilotChatter) float PilotChatterVODelayMax;
var transient float CurrentPilotChatterVODelay;
var transient float LastRespawnedFromCheckpointTime;
var transient float DelayBeforeBoost;

// Export USkyPlayerController::execLimitViewRotationNative(FFrame&, void* const)
native final function Rotator LimitViewRotationNative(Rotator rViewRotation, float fViewPitchMin, float fViewPitchMax);

// Export USkyPlayerController::execIsCameraInverted(FFrame&, void* const)
native final function bool IsCameraInverted();

// Export USkyPlayerController::execGetCurrentFireMode(FFrame&, void* const)
native final function int GetCurrentFireMode();

// Export USkyPlayerController::execIsInVerticalCoverDown(FFrame&, void* const)
native final function bool IsInVerticalCoverDown();

// Export USkyPlayerController::execIsInVerticalCoverUp(FFrame&, void* const)
native final function bool IsInVerticalCoverUp();

// Export USkyPlayerController::execIsInVerticalCover(FFrame&, void* const)
native final function bool IsInVerticalCover();

// Export USkyPlayerController::execAdjustReticleSensitivity(FFrame&, void* const)
native final function Rotator AdjustReticleSensitivity(float fDeltaTime);

// Export USkyPlayerController::execIsEditor(FFrame&, void* const)
native final function bool IsEditor();

// Export USkyPlayerController::execToggleLockFrameRateNative(FFrame&, void* const)
native final function ToggleLockFrameRateNative();

// Export USkyPlayerController::execLockMoveInput(FFrame&, void* const)
native function LockMoveInput(bool bNewMoveInput, optional bool bZeroInput);

// Export USkyPlayerController::execFindJumpVehicleTarget(FFrame&, void* const)
native final function Vehicle FindJumpVehicleTarget(const out JumpVehicleFindParams SearchParams, optional Vehicle Invalid);

// Export USkyPlayerController::execIsInFOV(FFrame&, void* const)
native final function bool IsInFOV(Rotator SourceOrientation, float FOVDegrees, Vector TargetDirection, optional bool Horizontal = true);

simulated event Destroyed()
{
    super(SkyPlayerControllerBase).Destroyed();
    // End:0x1E
    if(SAnnouncer != none)
    {
        SAnnouncer.Destroy();
    }
    //return;    
}

reliable client simulated function ClientSPlayAnnouncement(class<SkyLocalMessage> InMessageClass, byte MessageIndex, optional Object OptionalObject)
{
    SPlayAnnouncement(InMessageClass, MessageIndex, OptionalObject);
    //return;    
}

simulated event PostBeginPlay()
{
    local OnlineProfileSettings Options;
    local int Value;

    super(PlayerController).PostBeginPlay();
    Options = GetProfileSettings();
    // End:0x75
    if(Options != none)
    {
        Options.GetProfileSettingValueInt(16, Value);
        m_bMagnetismOn = Value == 1;
        Options.GetProfileSettingValueInt(17, Value);
        m_bAutoCenter = Value == 1;
    }
    m_nAutoCenterMinPitch = int((m_fAutoCenterMinPitch / 360.0000000) * float(65536));
    SetTimer(1.0000000, false, 'CheckForGrenadeVoiceOver');
    //return;    
}

function SPlayAnnouncement(class<SkyLocalMessage> InMessageClass, byte MessageIndex, optional Object OptionalObject)
{
    // End:0x25
    if((WorldInfo.GRI == none) || SAnnouncer == none)
    {
        return;
    }
    SAnnouncer.PlayAnnouncement(InMessageClass, MessageIndex, OptionalObject);
    //return;    
}

simulated function CheckForGrenadeVoiceOver()
{
    local Actor OutActor;
    local float TimerDelay;
    local SkyPawn SP;
    local SkyPawnSoundGroup SPSG;

    SP = SkyPawn(Pawn);
    // End:0x199
    if(SP != none)
    {
        SPSG = SkyPawnSoundGroup(SP.SoundGroup);
        // End:0x186
        if(((SPSG != none) && SPSG.VO_GrenadeNearby != none) && SkyGame(WorldInfo.Game) != none)
        {
            // End:0x186
            if(SkyGame(WorldInfo.Game).StimulusSystem.FindClosestStimulus(Pawn.Location, SPSG.GrenadeNearbyDistance, OutActor) >= 0)
            {
                // End:0x186
                if(((SkyProj_Grenade(OutActor) != none) && SkyProj_Grenade(OutActor).bIsExpanding == false) || SkyProj_Dynamite(OutActor) != none)
                {
                    // End:0x186
                    if(SkyProj_SecondaryItemBase(OutActor).FiringPawn != Pawn)
                    {
                        SP.PlayVoiceOver(SPSG.VO_GrenadeNearby);
                        TimerDelay = float(Max(1, int(float(1) + OutActor.GetRemainingTimeForTimer('DetonateTimer'))));
                        SetTimer(TimerDelay, false, 'CheckForGrenadeVoiceOver');
                        return;
                    }
                }
            }
        }
        SetTimer(1.0000000, false, 'CheckForGrenadeVoiceOver');
    }
    //return;    
}

function SetCharacter(string inCharacter)
{
    MP_Class = class<Pawn>(DynamicLoadObject(inCharacter, Class'Core.Class', true));
    //return;    
}

exec function DropThru()
{
    local SkyBot SB;

    // End:0x79
    foreach WorldInfo.AllControllers(Class'SkyBot', SB)
    {
        // End:0x78
        if(SB != none)
        {
            SB.Pawn.bCollideWorld = false;
            SB.Pawn.SetBase(none);
            SB.Pawn.SetPhysics(2);
        }        
    }    
    SetTimer(0.5000000, false, 'ReenableBotCollision');
    //return;    
}

function ReenableBotCollision()
{
    local SkyBot SB;

    // End:0x45
    foreach WorldInfo.AllControllers(Class'SkyBot', SB)
    {
        // End:0x44
        if(SB != none)
        {
            SB.Pawn.bCollideWorld = true;
        }        
    }    
    //return;    
}

exec function KillHijackTarget()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x83
    if((SP != none) && SP.HijackTarget != none)
    {
        SP.HijackTarget.TakeDamage(10000, self, SP.HijackTarget.Location, vect(0.0000000, 0.0000000, 1.0000000), Class'SkyDmgType_LargeBallistics');
    }
    //return;    
}

exec function KillInteractionPartner()
{
    local SkyPawn SP;
    local SkyInteractor Interactor;
    local SkyArchonPilot SAP;

    SP = SkyPawn(Pawn);
    // End:0xF9
    if(SP != none)
    {
        Interactor = SP.GetInteractionPartner();
        SAP = SkyArchonPilot(Interactor);
        // End:0xB1
        if((SAP != none) && SAP.PilotedPawn != none)
        {
            SAP.PilotedPawn.TakeDamage(50000, self, Interactor.Location, vect(0.0000000, 0.0000000, 1.0000000), Class'SkyDmgType_LargeBallistics');            
        }
        else
        {
            // End:0xF9
            if(Interactor != none)
            {
                Interactor.TakeDamage(50000, self, Interactor.Location, vect(0.0000000, 0.0000000, 1.0000000), Class'SkyDmgType_LargeBallistics');
            }
        }
    }
    //return;    
}

exec function GetNum()
{
    local FracturedStaticMeshActor FracActor;

    // End:0x11
    foreach AllActors(Class'Engine.FracturedStaticMeshActor', FracActor)
    {        
    }    
    //return;    
}

exec function RestoreFracturedMeshes()
{
    local FracturedStaticMeshActor FracActor;

    WorldInfo.MyFractureManager.ResetPoolVisibility();
    // End:0x43
    foreach AllActors(Class'Engine.FracturedStaticMeshActor', FracActor)
    {
        FracActor.ResetVisibility();        
    }    
    //return;    
}

exec function CauseDamage(optional int num)
{
    // End:0x66
    if(Pawn.DrivenVehicle != none)
    {
        Pawn.DrivenVehicle.TakeDamage(num, self, Pawn.DrivenVehicle.Location, vect(0.0000000, 0.0000000, 1.0000000), none);        
    }
    else
    {
        // End:0xAA
        if(Pawn != none)
        {
            Pawn.TakeDamage(num, self, Pawn.Location, vect(0.0000000, 0.0000000, 1.0000000), none);
        }
    }
    //return;    
}

exec function Suicide()
{
    // End:0x37
    if(SkyVehicle(Pawn) != none)
    {
        SkyVehicle(Pawn).Died(none, Class'Engine.DmgType_Suicided', Location);        
    }
    else
    {
        ServerSuicide();
    }
    //return;    
}

exec function ToggleIK()
{
    local SkyPawn SP;
    local SkyVehicle SV;

    SV = SkyVehicle(Pawn);
    // End:0x38
    if(SV != none)
    {
        SP = SkyPawn(SV.Driver);        
    }
    else
    {
        SP = SkyPawn(Pawn);
    }
    // End:0x8C
    if(SP != none)
    {
        SP.IKEnabled = !SP.IKEnabled;
        // End:0x8C
        if(SP.IKEnabled)
        {            
        }
    }
    //return;    
}

exec function AdjustAimFreq(float NewTime)
{
    local SkyBot SB;

    // End:0x3E
    foreach WorldInfo.AllControllers(Class'SkyBot', SB)
    {
        // End:0x3D
        if(SB != none)
        {
            SB.AdjustedAim_LineCheckInterval = NewTime;
        }        
    }    
    //return;    
}

exec function ToggleLockFramerate()
{
    ToggleLockFrameRateNative();
    //return;    
}

exec function ToggleAILogging()
{
    local SkyAIController AIC;

    SkyGame(WorldInfo.Game).bAILogging = !SkyGame(WorldInfo.Game).bAILogging;
    // End:0x118
    foreach WorldInfo.AllControllers(Class'SkyAIController', AIC)
    {
        // End:0x117
        if(AIC != none)
        {
            // End:0xB5
            if(SkyGame(WorldInfo.Game).bAILogging)
            {
                // End:0xB2
                if(!AIC.bAILogging)
                {
                    AIC.bAILogging = true;
                }
                // End:0x117
                continue;
            }
            // End:0x117
            if(AIC.bAILogging)
            {
                AIC.bAILogging = false;
                // End:0x117
                if(AIC.AILogFile != none)
                {
                    AIC.AILogFile.Destroy();
                    AIC.AILogFile = none;
                }
            }
        }        
    }    
    //return;    
}

reliable client simulated function ApplyFlash(float flength)
{
    CurrentFlashLength += flength;
    //return;    
}

event bool AutoPitchAllowed()
{
    local SkyPlayerInput pSPI;
    local SkyPawn pSP;
    local bool bRightStickMoved, bLeftStickMoved;

    pSPI = SkyPlayerInput(PlayerInput);
    pSP = SkyPawn(Pawn);
    // End:0x3A
    if((pSPI == none) || pSP == none)
    {
        return true;
    }
    bRightStickMoved = (pSPI.Display_aTurn != float(0)) || pSPI.Display_aLookUp != float(0);
    bLeftStickMoved = ((pSPI.Display_aBaseY != float(0)) || pSPI.Display_aStrafe != float(0)) || pSP.bIsFreefalling;
    return (bLeftStickMoved && !bRightStickMoved) && !pSP.IsFiring() || pSP.PrimaryWSM.IsReloading();
    //return ReturnValue;    
}

event bool ControllerMoved()
{
    local SkyPlayerInput pSPI;
    local SkyPawn pSP;

    pSPI = SkyPlayerInput(PlayerInput);
    pSP = SkyPawn(Pawn);
    // End:0x3A
    if((pSPI == none) || pSP == none)
    {
        return false;
    }
    return (((pSPI.Display_aTurn != float(0)) || pSPI.Display_aLookUp != float(0)) || pSPI.Display_aMouseX != float(0)) || pSPI.Display_aMouseY != float(0);
    //return ReturnValue;    
}

event PlayerTick(float DeltaTime)
{
    local Rotator rResult;
    local float fAlpha;
    local int I;
    local SkyPlayerInput pSPI;
    local SkyVehicle pSV;

    pSPI = SkyPlayerInput(PlayerInput);
    super(PlayerController).PlayerTick(DeltaTime);
    // End:0x56
    if(WeaponPickup_UseButtonHoldTimer > float(0))
    {
        WeaponPickup_UseButtonHoldTimer -= DeltaTime;
        // End:0x56
        if(WeaponPickup_UseButtonHoldTimer <= float(0))
        {
            WeaponPickup_UseButtonHoldTimer = 0.0000000;
            DoPickup();
        }
    }
    // End:0x20E
    if(m_bAutoCenter)
    {
        rResult = Rotation;
        switch(m_AutoCenterState)
        {
            // End:0xBC
            case 0:
                // End:0xB9
                if((AutoPitchAllowed()) && Abs(float(Rotation.Pitch)) > float(m_nAutoCenterMinPitch))
                {
                    m_fAutoCenterWaitTimer = m_fAutoCenterWaitTime;
                    m_AutoCenterState = 1;
                }
                // End:0x20E
                break;
            // End:0x14D
            case 1:
                // End:0xD8
                if(!AutoPitchAllowed())
                {
                    m_AutoCenterState = 0;
                }
                m_fAutoCenterWaitTimer -= DeltaTime;
                // End:0x14A
                if(m_fAutoCenterWaitTimer <= 0.0000000)
                {
                    m_fAutoCenterStartTime = WorldInfo.TimeSeconds;
                    m_nAutoCenterBeginPitch = Rotation.Pitch;
                    m_fAutoCenterTime = ((Abs(float(m_nAutoCenterBeginPitch)) / 65536.0000000) * 360.0000000) / m_fAutoCenterSpeed;
                    m_AutoCenterState = 2;
                }
                // End:0x20E
                break;
            // End:0x20B
            case 2:
                // End:0x169
                if(!AutoPitchAllowed())
                {
                    m_AutoCenterState = 0;
                }
                fAlpha = (WorldInfo.TimeSeconds - m_fAutoCenterStartTime) / m_fAutoCenterTime;
                // End:0x1B8
                if(fAlpha >= 1.0000000)
                {
                    rResult.Pitch = 0;
                    m_AutoCenterState = 0;                    
                }
                else
                {
                    fAlpha = (1.0000000 - Cos(3.1415930 * fAlpha)) / 2.0000000;
                    rResult.Pitch = int(Lerp(float(m_nAutoCenterBeginPitch), 0.0000000, fAlpha));
                }
                SetRotation(rResult);
                // End:0x20E
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x24F
        if(pSPI != none)
        {
            XeGammaUpdateStickInput(pSPI.RawJoyRight * DeltaTime, pSPI.RawJoyUp * DeltaTime);
        }
        pSV = SkyVehicle(Pawn);
        // End:0x448
        if(pSV != none)
        {
            I = 0;
            J0x271:

            // End:0x359 [Loop If]
            if(I < pSV.Seats.Length)
            {
                // End:0x34F
                if((SkyVWeap(pSV.Seats[I].Gun) != none) && SkyVWeap(pSV.Seats[I].Gun).bShouldRefire == true)
                {
                    SkyVWeap(pSV.Seats[I].Gun).bShouldRefire = false;
                    pSV.Seats[I].Gun.FireAmmunition();
                }
                I++;
                // [Loop Continue]
                goto J0x271;
            }
            I = 0;
            J0x360:

            // End:0x448 [Loop If]
            if(I < pSV.SkySeats.Length)
            {
                // End:0x43E
                if((SkyVWeap(pSV.SkySeats[I].SecondaryGun) != none) && SkyVWeap(pSV.SkySeats[I].SecondaryGun).bShouldRefire == true)
                {
                    SkyVWeap(pSV.SkySeats[I].SecondaryGun).bShouldRefire = false;
                    pSV.SkySeats[I].SecondaryGun.FireAmmunition();
                }
                I++;
                // [Loop Continue]
                goto J0x360;
            }
        }
        // End:0x461
        if(LockoutExitRocketpackTimerAfterTurnAroundVolume > float(0))
        {
            LockoutExitRocketpackTimerAfterTurnAroundVolume -= DeltaTime;
        }
        //return;        
    }
}

event LevelStreamingStatusChanged(LevelStreaming LevelObject, bool bNewShouldBeLoaded, bool bNewShouldBeVisible, bool bNewShouldBlockOnLoad)
{
    local SkyPawnCoverUser SPCU;
    local SkyGame Info;
    local int I;

    // End:0x1B7
    if(!bNewShouldBeLoaded)
    {
        // End:0x9E
        foreach WorldInfo.AllPawns(Class'SkyPawnCoverUser', SPCU)
        {
            // End:0x9D
            if((SPCU.IsInCover() && SPCU.CurrentLink != none) && SPCU.CurrentLink.Outer == LevelObject.LoadedLevel)
            {
                SPCU.ExitCover(true, true);
            }            
        }        
        // End:0x1B7
        if(WorldInfo != none)
        {
            Info = SkyGame(WorldInfo.Game);
            // End:0x1B7
            if(Info != none)
            {
                I = 0;
                J0xD6:

                // End:0x143 [Loop If]
                if(I < Info.AvailLandingZones.Length)
                {
                    // End:0x139
                    if(Info.AvailLandingZones[I].Outer == LevelObject.LoadedLevel)
                    {
                        Info.AvailLandingZones.Remove(I, 1);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xD6;
                }
                I = 0;
                J0x14A:

                // End:0x1B7 [Loop If]
                if(I < Info.AvailTurnAroundVolumes.Length)
                {
                    // End:0x1AD
                    if(Info.AvailTurnAroundVolumes[I].Outer == LevelObject.LoadedLevel)
                    {
                        Info.AvailTurnAroundVolumes.Remove(I, 1);
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x14A;
                }
            }
        }
    }
    super(PlayerController).LevelStreamingStatusChanged(LevelObject, bNewShouldBeLoaded, bNewShouldBeVisible, bNewShouldBlockOnLoad);
    //return;    
}

// Export USkyPlayerController::execTriggerDeathLoadingScreen(FFrame&, void* const)
native function TriggerDeathLoadingScreen();

function ResetAudioLevels()
{
    local OnlineProfileSettings Options;
    local int VOValue, SFXValue;

    VOValue = 100;
    SFXValue = 100;
    Options = GetProfileSettings();
    // End:0x61
    if(Options != none)
    {
        Options.GetProfileSettingValueInt(66, VOValue);
        Options.GetProfileSettingValueInt(65, SFXValue);
    }
    SetCinematicCategory("ingame", float(VOValue) / 100.0000000, 0.5000000);
    SetCinematicCategory("MASTERFADER", float(SFXValue) / 100.0000000, 0.5000000);
    SetCinematicCategory("UI", float(SFXValue) / 100.0000000, 0.5000000);
    //return;    
}

event InitInputSystem()
{
    super(PlayerController).InitInputSystem();
    // End:0x21
    if(PlayerInput != none)
    {
        PlayerInput.Init();
    }
    InitInputSystemHelper(WorldInfo.GetGameSequence());
    InitInputSystemHelper(WorldInfo.GetGlobalSequence());
    ResetReticleRotation();
    // End:0xAB
    if((ForceFeedbackManager != none) && ForceFeedbackManagerClassName == "PS3Drv.PS3ForceFeedbackManager")
    {
        ForceFeedbackManager.ScaleAllWaveformsBy = 10.0000000;
    }
    //return;    
}

function InitInputSystemHelper(Sequence GameSeq)
{
    local array<SequenceObject> AllSeqEvents;
    local SkyKismetInputInteraction DI_InputInteraction, MB_InputInteraction;
    local int I;

    // End:0x144
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'Engine.SequenceEvent', true, AllSeqEvents);
        // End:0x144
        if(AllSeqEvents.Length > 0)
        {
            I = 0;
            J0x39:

            // End:0x144 [Loop If]
            if(I < AllSeqEvents.Length)
            {
                // End:0xC3
                if(SkySeqEvent_DemoInput(AllSeqEvents[I]) != none)
                {
                    // End:0x8F
                    if(DI_InputInteraction == none)
                    {
                        DI_InputInteraction = new (self) Class'SkyKismetInputInteraction';
                        Interactions.Insert(0, 1);
                        Interactions[0] = DI_InputInteraction;
                    }
                    DI_InputInteraction.InputEvents[DI_InputInteraction.InputEvents.Length] = SkySeqEvent_DemoInput(AllSeqEvents[I]);
                    // [Explicit Continue]
                    goto J0x13A;
                }
                // End:0x13A
                if(SkySeqEvent_MultiButtonPress(AllSeqEvents[I]) != none)
                {
                    // End:0x109
                    if(MB_InputInteraction == none)
                    {
                        MB_InputInteraction = new (self) Class'SkyKismetInputInteraction';
                        Interactions.Insert(0, 1);
                        Interactions[0] = MB_InputInteraction;
                    }
                    MB_InputInteraction.MultiInputEvents[MB_InputInteraction.MultiInputEvents.Length] = SkySeqEvent_MultiButtonPress(AllSeqEvents[I]);
                }
                J0x13A:

                I++;
                // [Loop Continue]
                goto J0x39;
            }
        }
    }
    //return;    
}

function ResetReticleRotation()
{
    local Vector vCamLoc;
    local Rotator rCamRot;

    GetPlayerViewPoint(vCamLoc, rCamRot);
    // End:0x2D
    if(PlayerCamera != none)
    {
        m_rReticleRotation = rCamRot;        
    }
    else
    {
        // End:0x50
        if(Pawn != none)
        {
            m_rReticleRotation = Pawn.Rotation;            
        }
        else
        {
            return;
        }
    }
    m_rReticleRotation = AddRotators(m_rReticleRotation, m_ReticleOffsetValues[GetCurrentFireMode()]);
    //return;    
}

exec function PrevWeapon()
{
    local SkyPawn P;

    P = SkyPawn(Pawn);
    // End:0xBF
    if(P != none)
    {
        // End:0x34
        if(P.UsingSecondaryItem())
        {
            return;
        }
        // End:0xBF
        if((((!P.IsInteracting() && !P.IsGripping()) && !P.ThrownFromGripPoint()) && !P.ReleasedGripPoint()) && !P.ShotFromGripPoint())
        {
            super(SkyPlayerControllerBase).PrevWeapon();
        }
    }
    //return;    
}

exec function NextWeapon()
{
    local SkyPawn P;

    P = SkyPawn(Pawn);
    // End:0xBF
    if(P != none)
    {
        // End:0x34
        if(P.UsingSecondaryItem())
        {
            return;
        }
        // End:0xBF
        if((((!P.IsInteracting() && !P.IsGripping()) && !P.ThrownFromGripPoint()) && !P.ReleasedGripPoint()) && !P.ShotFromGripPoint())
        {
            super(SkyPlayerControllerBase).NextWeapon();
        }
    }
    //return;    
}

reliable server function ServerSetSecondaryHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    SecondaryWeaponHand = NewWeaponHand;
    // End:0x39
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).SetSecondaryHand(WeaponHand);
    }
    //return;    
}

function SetSecondaryHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    SecondaryWeaponHandPreference = NewWeaponHand;
    SaveConfig();
    // End:0x3C
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).SetSecondaryHand(SecondaryWeaponHand);
    }
    ServerSetSecondaryHand(NewWeaponHand);
    //return;    
}

function bool PlayerCanRestartGame(PlayerController aPlayer)
{
    return false;
    //return ReturnValue;    
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
    return false;
    //return ReturnValue;    
}

event bool TakeOverVehicle(Vehicle V)
{
    // End:0x2A
    if(V.Driver != none)
    {
        V.DriverLeave(true);
    }
    return V.TryToDrive(Pawn);
    //return ReturnValue;    
}

event bool EnterVehicle()
{
    // End:0x12
    if(Vehicle(Pawn) != none)
    {
        return false;
    }
    // End:0x21
    if(FindVehicleToDrive())
    {
        return true;
    }
    //return ReturnValue;    
}

function CheckTouchActivate(Pawn aPawn, bool bVehicleTransition)
{
    // End:0x1C
    if(!bVehicleTransition)
    {
        super(PlayerController).CheckTouchActivate(aPawn, bVehicleTransition);
    }
    //return;    
}

simulated function int GetSecretIndex()
{
    // End:0x0F
    if(UsingUltraPack())
    {
        return 0;
    }
    return super(PlayerController).GetSecretIndex();
    //return ReturnValue;    
}

function Possess(Pawn aPawn, bool bVehicleTransition)
{
    local SkyPawn SP;
    local SkyVehicle SV;

    super(SkyPlayerControllerBase).Possess(aPawn, bVehicleTransition);
    SP = SkyPawn(aPawn);
    SV = SkyVehicle(aPawn);
    // End:0x5D
    if((SP != none) && SP.SecondaryWeapon == none)
    {
        ClientSwitchToBestSecondaryWeapon();
    }
    // End:0x105
    if(PlayerCamera != none)
    {
        // End:0xB8
        if(SP != none)
        {
            SkyCamera(PlayerCamera).SetFadeToBlackBasedOnPawn(SP.FadeToBlackDeathDelayTime, SP.FadeToBlackTime);
            SP_RespawnTime = 1.0000000;            
        }
        else
        {
            // End:0x105
            if(SV != none)
            {
                SkyCamera(PlayerCamera).SetFadeToBlackBasedOnPawn(SV.FadeToBlackDeathDelayTime, SV.FadeToBlackTime);
                SP_RespawnTime = 1.0000000;
            }
        }
    }
    // End:0x124
    if(SP != none)
    {
        SP.UpdateSecrets();
    }
    //return;    
}

exec function SwitchToBestSecondaryWeapon()
{
    // End:0x24
    if((Pawn == none) || Pawn.InvManager == none)
    {
        return;
    }
    // End:0x62
    if(SkyInventoryManager(Pawn.InvManager) != none)
    {
        SkyInventoryManager(Pawn.InvManager).SwitchToBestSecondaryWeapon();
    }
    //return;    
}

reliable client simulated function ClientSwitchToBestSecondaryWeapon()
{
    SwitchToBestSecondaryWeapon();
    //return;    
}

function bool OnControllerDisconnectPause()
{
    CheckPause(true);
    return true;
    //return ReturnValue;    
}

function RegisterOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x6F
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x6F
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.AddLoginChangeDelegate(NotifyLoginChange);
        }
    }
    super(PlayerController).RegisterOnlineDelegates();
    //return;    
}

function ClearOnlineDelegates()
{
    local OnlinePlayerInterface PlayerInterface;
    local LocalPlayer LocPlayer;

    LocPlayer = LocalPlayer(Player);
    // End:0x6F
    if((LocPlayer != none) && OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x6F
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            PlayerInterface.ClearLoginChangeDelegate(NotifyLoginChange);
        }
    }
    //return;    
}

function NotifyLoginChange(byte ControllerId, OnlineSubsystem.ELoginChangeType Type)
{
    local GameUISceneClient GSC;
    local UIScene notifyPopup;
    local bool bAtTitleScreen;

    // End:0x15
    if(Class'Engine.GameEngine'.static.IsConsumerDemo())
    {
        return;
    }
    // End:0x37
    if(LocalPlayer(Player).ControllerId != int(ControllerId))
    {
        return;
    }
    // End:0x49
    if(int(Type) == int(0))
    {
        return;
    }
    GSC = Class'Engine.UIInteraction'.static.GetSceneClient();
    // End:0x191
    if(GSC != none)
    {
        bAtTitleScreen = false;
        // End:0xBA
        if(GetURLMap() == "mainmenu")
        {
            // End:0x96
            if(int(Type) == int(2))
            {
                return;
            }
            bAtTitleScreen = GSC.FindSceneByTag('UI_Tech_Pause') == none;
        }
        // End:0xD7
        if(GSC.bInLoadTransition == 1)
        {
            bAtTitleScreen = false;
        }
        // End:0x191
        if(!bAtTitleScreen && GSC.FindSceneByTag(notifyPopupName) == none)
        {
            notifyPopup = none;
            // End:0x15F
            if(GSC.bInLoadTransition == 0)
            {
                GSC.MessageBoxOpenByPath("UI.DefaultNotifyScene_LoginChanged", notifyPopup);                
            }
            else
            {
                GSC.bDetectedSigninChangeInLoad = true;
            }
            // End:0x191
            if(notifyPopup != none)
            {
                notifyPopupName = notifyPopup.SceneTag;
            }
        }
    }
    //return;    
}

function bool NotifiedLoggedOutCallback(UIScreenObject EventObject, int PlayerIndex)
{
    local GameUISceneClient GSC;
    local UIScene curScene;

    GSC = Class'Engine.UIInteraction'.static.GetSceneClient();
    // End:0x6B
    if(GSC != none)
    {
        J0x21:

        // End:0x6B [Loop If]
        if(GSC.GetActiveSceneCount() > 0)
        {
            curScene = GSC.GetActiveScene();
            GSC.CloseScene(curScene, true, true);
            // [Loop Continue]
            goto J0x21;
        }
    }    
    ConsoleCommand("open mainmenu?causeevent=logout");
    return true;
    //return ReturnValue;    
}

function StartSprint(int Mode)
{
    SkyPawn(Pawn).StartSprint(Mode);
    //return;    
}

function StopSprint()
{
    SkyPawn(Pawn).StopSprint();
    //return;    
}

exec function StartJumpOrDodge()
{
    local SkyCamera SkyCam;
    local SkyPawn Spawn;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x36
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    Spawn = SkyPawn(Pawn);
    // End:0x6F
    if((Spawn != none) && Spawn.IsInWalkVolume() == true)
    {
        return;
    }
    // End:0xD8
    if((((Spawn != none) && SkyWeaponBase(Spawn.Weapon) != none) && SkyWeaponBase(Spawn.Weapon).bIsLargeWeapon) && int(Pawn.Physics) != int(2))
    {
        return;
    }
    StartJump();
    //return;    
}

exec function StartJump()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x190
    if((SP != none) && !SP.IsGripping())
    {
        // End:0x82
        if(!SP.CannotJumpNow() && int(SP.FallState) != int(1))
        {
            SP.StartJump();            
        }
        else
        {
            // End:0xA6
            if(SP.IsParachuting())
            {
                StopParachute();                
            }
            else
            {
                // End:0xC8
                if(SP.RocketPack == none)
                {
                    StartParachute();                    
                }
                else
                {
                    // End:0x111
                    if(!SP.IsRocketPacking() && SP.CanRocketPack())
                    {
                        SP.StartRocketPack();                        
                    }
                    else
                    {
                        // End:0x190
                        if(SP.CanRocketPack() && SP.RocketPackArchetype.bAllowBoost)
                        {
                            SP.bWasInFreeFall = SP.IsFreefalling();
                            SP.SetRocketPackState(1);
                            GotoState('PlayerBoosting');
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function StartRocketPackFromTimer()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x67
    if(((SP != none) && int(SP.FallState) != int(4)) && int(SP.FallState) != int(5))
    {
        SP.StartRocketPack();
    }
    //return;    
}

event LandingStopRocketPack()
{
    SkyPawn(Pawn).StopRocketPack();
    //return;    
}

exec function CutRocketPack()
{
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    ClearTimer('StartRocketPackFromTimer');
    // End:0x46
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    // End:0xE8
    if(((SkyPawn(Pawn) == none) || SkyPawn(Pawn).RocketPack == none) || (SkyPawn(Pawn).RocketPack.bAllowBoost == false) && (SkyPawn(Pawn).RocketPack.bAllowDoubleJump == false) || !SkyPawn(Pawn).RocketPack.bHasDoubleJump)
    {
        return;
    }
    SkyPawn(Pawn).GotoRocketPackGlide();
    //return;    
}

exec event ToggleRocketPackThrust()
{
    local SkyCamera SkyCam;
    local SkyPawnPlayerCharacter Spawn;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x36
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    // End:0x55
    if((LockoutExitRocketpackTimerAfterTurnAroundVolume > 0.0000000) || bLockedEject == true)
    {
        return;
    }
    Spawn = SkyPawnPlayerCharacter(Pawn);
    // End:0x18D
    if(Spawn != none)
    {
        // End:0x9E
        if(Spawn.bFailedUse || Spawn.IsInteracting())
        {
            return;
        }
        // End:0x146
        if(((((Spawn.RocketPack != none) && Spawn.RocketPack.bAllowThrust) && !bWantRocketpackThrust) && int(Spawn.Physics) == int(1)) && DisableThrustCount <= 0)
        {
            bWantRocketpackThrust = true;
            SetTimer(WantRocketpackThrustTimeout, false, 'DoesntWantRocketpackThrust');
            Spawn.RocketPack.RocketPackPlayTag(22);            
        }
        else
        {
            bLockedEject = true;
            SetTimer(0.5000000, false, 'EndLockedEject');
            Spawn.ToggleRocketPackThrust();
            ClearTimer('DoesntWantRocketpackThrust');
            bWantRocketpackThrust = false;
        }
    }
    //return;    
}

function DoesntWantRocketpackThrust()
{
    local SkyPawn Spawn;

    bWantRocketpackThrust = false;
    Spawn = SkyPawn(Pawn);
    // End:0x43
    if(Spawn != none)
    {
        Spawn.RocketPack.RocketPackPlayTag(23);
    }
    //return;    
}

function EndLockedEject()
{
    bLockedEject = false;
    //return;    
}

exec function ReleaseGrip()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x11C
    if(SP != none)
    {
        // End:0x11C
        if(SP.IsGripping())
        {
            // End:0x11C
            if(((((((!SP.ThrownFromGripPoint() && !SP.ReleasedGripPoint()) && !SP.ShotFromGripPoint()) && !SP.IsBeginningHijack()) && !SP.IsEndingHijack()) && !SP.IsInteracting()) && !SP.IsBeingThrashed()) && !SP.GripDangleIsActive())
            {
                SP.SetReleasedGripPoint();
            }
        }
    }
    //return;    
}

exec function SwitchWeapon(byte T)
{
    SkyPawn(Pawn).SwitchWeapon(T);
    //return;    
}

exec function Hijack(optional byte FireModeNum)
{
    // End:0x60
    if(((Pawn != none) && SkyPawn(Pawn) != none) && SkyPawn(Pawn).JumpVehicleTargetCurrent != none)
    {
        SetTimer(1.5000000, false, 'EnableVehicleExit');
        bDisableVehicleExit = true;
        Intervehic();
    }
    //return;    
}

function EnableVehicleExit()
{
    bDisableVehicleExit = false;
    //return;    
}

exec function CoverDangleAction(string Button)
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Pawn);
    // End:0x34
    if(SPCU != none)
    {
        SPCU.CoverDangleAction(Button);
    }
    //return;    
}

exec function CoverDangleFailureAction()
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(Pawn);
    // End:0x2F
    if(SPCU != none)
    {
        SPCU.CoverDangleFailureRecover();
    }
    //return;    
}

exec function GripDangleAction(string Button)
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x34
    if(SP != none)
    {
        SP.GripDangleAction(Button);
    }
    //return;    
}

exec function StartVehicleSecondaryFire(optional byte FireModeNum)
{
    // End:0x28
    if(SkyVehicle(Pawn) != none)
    {
        SkyVehicle(Pawn).StartSecondaryFire(0);
    }
    //return;    
}

exec function StopVehicleSecondaryFire(optional byte FireModeNum)
{
    // End:0x28
    if(SkyVehicle(Pawn) != none)
    {
        SkyVehicle(Pawn).StopSecondaryFire(0);
    }
    //return;    
}

exec function StartSecondaryItemFire(optional byte FireModeNum)
{
    local SkyPawn SP;
    local SkyWeaponBase SWB;

    SP = SkyPawn(Pawn);
    // End:0xA3
    if(SP != none)
    {
        SWB = SkyWeaponBase(SP.Weapon);
        // End:0x58
        if((SWB != none) && SWB.bIsLargeWeapon)
        {
            return;
        }
        SP.SecondaryWSM.FiringInput(true,, true);
        // End:0xA3
        if(SkyHUD(myHUD) != none)
        {
            SkyHUD(myHUD).HudIdleTime = 0.0000000;
        }
    }
    //return;    
}

exec function StopSecondaryItemFire(optional byte FireModeNum)
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x3D
    if(SP != none)
    {
        SP.SecondaryWSM.FiringInput(false);
    }
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    // End:0x2B
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).HudIdleTime = 0.0000000;
    }
    super(SkyPlayerControllerBase).StartFire(FireModeNum);
    //return;    
}

exec event StopFire(optional byte FireModeNum)
{
    super(SkyPlayerControllerBase).StopFire(FireModeNum);
    //return;    
}

exec function StartAuxFire(optional byte AuxWeaponIndex)
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x37
    if(SP != none)
    {
        SP.StartAuxWeaponFire(int(AuxWeaponIndex));
    }
    //return;    
}

exec function StopAuxFire(optional byte AuxWeaponIndex)
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x37
    if(SP != none)
    {
        SP.StopAuxWeaponFire(int(AuxWeaponIndex));
    }
    //return;    
}

exec function PressInitiateSpecialMove()
{
    // End:0xCA
    if(((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).AllowSpecialMoves()) && LockoutExitRocketpackTimerAfterTurnAroundVolume <= float(0))
    {
        // End:0xB3
        if(!WorldInfo.IsConsoleBuild() && SkyPlayerInput(PlayerInput).bWaitingForSpecialMoveInput)
        {
            SkyAirVehicle(Pawn).CheckInputForSpecialMove(0.0000000, 1.0000000, 0.0000000, float(((PlayerInput.bInvertMouse) ? 1 : -1)), true);
        }
        SkyPlayerInput(PlayerInput).bWaitingForSpecialMoveInput = true;
    }
    //return;    
}

exec function ReleaseInitiateSpecialMove()
{
    // End:0x3D
    if((SkyPlayerInput(PlayerInput) != none) && SkyPlayerInput(PlayerInput).bWaitingForSpecialMoveInput)
    {
        SetTimer(SpecialMoveInputTimeout, false, 'StopWaitingForSpecialMoveInput');
    }
    //return;    
}

exec function SwitchToLeftLinkVehicle()
{
    SwitchToNewVehicleLink(false);
    //return;    
}

exec function SwitchToRightLinkVehicle()
{
    SwitchToNewVehicleLink(true);
    //return;    
}

function SwitchToNewVehicleLink(bool bRight)
{
    local SkyPawn Driver;
    local SkyVehicle_AAGun_Gatling CurAAGun;

    // End:0x0B
    if(FtB_bInProgress)
    {
        return;
    }
    CurAAGun = SkyVehicle_AAGun_Gatling(Pawn);
    // End:0x40
    if(CurAAGun != none)
    {
        Driver = SkyPawn(CurAAGun.Driver);
    }
    // End:0x18B
    if(Driver != none)
    {
        // End:0x18B
        if(((bRight && CurAAGun.LinkedVehicleFactoryRight != none) && CurAAGun.LinkedVehicleFactoryRight.SpawnedVehicle != none) || (!bRight && CurAAGun.LinkedVehicleFactoryLeft != none) && CurAAGun.LinkedVehicleFactoryLeft.SpawnedVehicle != none)
        {
            // End:0x101
            if(bRight)
            {
                NextAAGun = SkyVehicle_AAGun_Gatling(CurAAGun.LinkedVehicleFactoryRight.SpawnedVehicle);                
            }
            else
            {
                NextAAGun = SkyVehicle_AAGun_Gatling(CurAAGun.LinkedVehicleFactoryLeft.SpawnedVehicle);
            }
            // End:0x181
            if(CurAAGun.bFadeToBlackAAGunSwap)
            {
                SwapAAGunFadeToBlack(CurAAGun.AAGunSwap_TimeUntilFadeToBlack, CurAAGun.AAGunSwap_TimeOfFadeToBlack, CurAAGun.AAGunSwap_TimeOfBlack, CurAAGun.AAGunSwap_TimeOfFadeFromBlack);                
            }
            else
            {
                SwapAAGuns();
            }
        }
    }
    //return;    
}

function SwapAAGuns()
{
    local SkyPawn Driver;
    local SkyVehicle_AAGun_Gatling CurAAGun;

    CurAAGun = SkyVehicle_AAGun_Gatling(Pawn);
    // End:0x35
    if(CurAAGun != none)
    {
        Driver = SkyPawn(CurAAGun.Driver);
    }
    // End:0xCA
    if((Driver != none) && NextAAGun != none)
    {
        CurAAGun.bSwappingAAGuns = true;
        CurAAGun.DriverLeave(true);
        Driver.OverrideVehicleEnter = true;
        SetRotation(NextAAGun.Rotation);
        NextAAGun.TryToDriveEvent(Driver);
        Driver.OverrideVehicleEnter = false;
        NextAAGun = none;
    }
    //return;    
}

simulated function StopWaitingForSpecialMoveInput()
{
    SkyPlayerInput(PlayerInput).bWaitingForSpecialMoveInput = false;
    //return;    
}

exec function PrevSecondaryWeapon()
{
    // End:0x30
    if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).UsingSecondaryItem())
    {
        return;
    }
    // End:0xC7
    if((Pawn != none) && Vehicle(Pawn) == none)
    {
        // End:0x64
        if(WorldInfo.Pauser != none)
        {
            return;
        }
        // End:0x8A
        if(SkyPawn(Pawn).SecondaryWeapon == none)
        {
            SwitchToBestSecondaryWeapon();
            return;
        }
        // End:0xC7
        if(SkyInventoryManager(Pawn.InvManager) != none)
        {
            SkyInventoryManager(Pawn.InvManager).PrevSecondaryWeapon();
        }
    }
    //return;    
}

exec function NextSecondaryWeapon()
{
    // End:0x30
    if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).UsingSecondaryItem())
    {
        return;
    }
    // End:0xC7
    if((Pawn != none) && Vehicle(Pawn) == none)
    {
        // End:0x64
        if(WorldInfo.Pauser != none)
        {
            return;
        }
        // End:0x8A
        if(SkyPawn(Pawn).SecondaryWeapon == none)
        {
            SwitchToBestSecondaryWeapon();
            return;
        }
        // End:0xC7
        if(SkyInventoryManager(Pawn.InvManager) != none)
        {
            SkyInventoryManager(Pawn.InvManager).NextSecondaryWeapon();
        }
    }
    //return;    
}

exec function EquipDynamite()
{
    EquipSecondaryWeapon(Class'SkyItem_Dynamite');
    //return;    
}

simulated function EquipSecondaryWeapon(class<Weapon> WeaponClass)
{
    local Weapon pWeapon;

    // End:0x30
    if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).UsingSecondaryItem())
    {
        return;
    }
    // End:0xD6
    if(Vehicle(Pawn) == none)
    {
        // End:0xD6
        if(WorldInfo.Pauser == none)
        {
            // End:0xD6
            if(SkyInventoryManager(Pawn.InvManager) != none)
            {
                pWeapon = Weapon(SkyInventoryManager(Pawn.InvManager).FindInventoryType(WeaponClass));
                // End:0xD6
                if(pWeapon != none)
                {
                    SkyInventoryManager(Pawn.InvManager).SetCurrentSecondaryWeapon(pWeapon);
                }
            }
        }
    }
    //return;    
}

exec function SwapPrimaryWeapon()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x6A
    if(((SP != none) && SP.CanSwapWeapon()) && SP.PrimaryWSM != none)
    {
        SP.PrimaryWSM.TrySwap();
    }
    // End:0x94
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).HudIdleTime = 0.0000000;
    }
    //return;    
}

event SwapPrimaryWeaponEvent()
{
    // End:0x2A
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).SwapPrimaryWeapon();
    }
    //return;    
}

exec function TraceAndEditClass()
{
    TraceAndEdit(true);
    //return;    
}

exec function TraceAndEditActor()
{
    TraceAndEdit(false);
    //return;    
}

function TraceAndEdit(bool bEditClass)
{
    local Vector CamLoc, StartShot, EndShot, X, Y, Z,
	    HitLocation, HitNormal, ZeroVec;

    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local Rotator CamRot;

    // End:0x35
    if(SkyPawn(Pawn) != none)
    {
        HitActor = SkyPawn(Pawn).AutoAimImpact.HitActor;
    }
    // End:0xCA
    if(HitActor == none)
    {
        GetPlayerViewPoint(CamLoc, CamRot);
        GetAxes(CamRot, X, Y, Z);
        ZeroVec = vect(0.0000000, 0.0000000, 0.0000000);
        StartShot = CamLoc;
        EndShot = StartShot + (10000.0000000 * X);
        HitActor = Trace(HitLocation, HitNormal, EndShot, StartShot, true, ZeroVec, HitInfo);
    }
    // End:0xD7
    if(HitActor == none)
    {
        return;
    }
    // End:0x119
    if(!bEditClass)
    {        
        ConsoleCommand("EditActor Name=" $ string(HitActor.Name));        
    }
    else
    {        
        ConsoleCommand("UCEXPORT " $ string(HitActor.Class.Name));
    }
    //return;    
}

exec function EditController()
{
    local string Command;

    Command = "editactor name=" $ string(self.Name);    
    ConsoleCommand(Command);
    //return;    
}

exec function EditInput()
{
    local string Command;

    Command = "editactor name=" $ string(PlayerInput.Name);
    ClientMessage(Command);    
    ConsoleCommand(Command);
    //return;    
}

exec function NextSeat()
{
    //return;    
}

exec function PrevSeat()
{
    //return;    
}

function bool UsingFirstPersonCamera()
{
    return ((PlayerCamera == none) || PlayerCamera.CameraStyle == 'FirstPerson') && LocalPlayer(Player) != none;
    //return ReturnValue;    
}

// Export USkyPlayerController::execGetPlayerViewPointNative(FFrame&, void* const)
native final simulated function GetPlayerViewPointNative(out Vector POVLocation, out Rotator POVRotation);

simulated event GetPlayerViewPoint(out Vector POVLocation, out Rotator POVRotation)
{
    // End:0x21
    if(bHasCachedPlayerViewPoint)
    {
        POVLocation = vCachedPlayerViewPoint;
        POVRotation = rCachedPlayerViewPoint;
        return;
    }
    GetPlayerViewPointNative(POVLocation, POVRotation);
    //return;    
}

simulated function SendCameraToServer(Vector Loc, Rotator Rot)
{
    local Vector rvec;

    rvec = Vector(Rot);
    ServerReceiveCamera(Loc * 10.0000000, rvec * 1000.0000000);
    //return;    
}

reliable server function ServerReceiveCamera(Vector Loc, Vector Rot)
{
    CalcViewLocation = Loc * 0.1000000;
    CalcViewRotation = Rotator(Rot * 0.0010000);
    // End:0x82
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).NetViewRot = Rot;
        SkyPawn(Pawn).NetViewLoc = (CalcViewLocation - Pawn.Location) * 10.0000000;
    }
    //return;    
}

simulated function SendStickInputToServer(float fwd, float Strafe)
{
    local Vector2D Stick;

    Stick.X = Strafe * 1000.0000000;
    Stick.Y = fwd * 1000.0000000;
    ServerReceiveStickInput(Stick);
    //return;    
}

reliable server function ServerReceiveStickInput(Vector2D Stick)
{
    // End:0x2A
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).NetStick = Stick;
    }
    //return;    
}

reliable client simulated function ResetControls()
{
    ResetPlayerMovementInput();
    //return;    
}

// Export USkyPlayerController::execCopyKeyStates(FFrame&, void* const)
native function CopyKeyStates(SkyPlayerInput From, SkyPlayerInput To);

reliable client simulated function SetControls(PlayerInput NewInput)
{
    local int InteractionIdx;

    // End:0x7E
    if(NewInput != none)
    {
        OldInput = PlayerInput;
        PlayerInput = NewInput;
        CopyKeyStates(SkyPlayerInput(OldInput), SkyPlayerInput(PlayerInput));
        InteractionIdx = Interactions.Find(OldInput);
        // End:0x6D
        if(InteractionIdx == -1)
        {
            InteractionIdx = Interactions.Length;
        }
        Interactions[InteractionIdx] = PlayerInput;
    }
    //return;    
}

simulated function ResetPlayerMovementInput()
{
    super(PlayerController).ResetPlayerMovementInput();
    bLockMoveInput = default.bLockMoveInput;
    // End:0x54
    if((SkyVehicle(Pawn) == none) && SkyPlayerInput(PlayerInput) != none)
    {
        SkyPlayerInput(PlayerInput).SetLayout("OnFoot");
    }
    //return;    
}

event ProcessViewRotation(float fDeltaTime, out Rotator rOutViewRot, Rotator rDeltaRot)
{
    // End:0x2E
    if(PlayerCamera != none)
    {
        PlayerCamera.ProcessViewRotation(fDeltaTime, rOutViewRot, rDeltaRot);
    }
    // End:0x5F
    if(Pawn != none)
    {
        Pawn.ProcessViewRotation(fDeltaTime, rOutViewRot, rDeltaRot);        
    }
    else
    {
        rOutViewRot += rDeltaRot;
        rOutViewRot = LimitViewRotation(rOutViewRot, -16384.0000000, 16383.0000000);
    }
    //return;    
}

simulated function Rotator LimitReticleRotation(Rotator ReticleRot, float ViewPitchMin, float ViewPitchMax)
{
    ReticleRot.Pitch = ReticleRot.Pitch & 65535;
    // End:0xC1
    if((float(ReticleRot.Pitch) > ViewPitchMax) && float(ReticleRot.Pitch) < (float(65536) + ViewPitchMin))
    {
        // End:0xA0
        if(ReticleRot.Pitch < 32768)
        {
            ReticleRot.Pitch = int(ViewPitchMax);            
        }
        else
        {
            ReticleRot.Pitch = int(float(65536) + ViewPitchMin);
        }
    }
    return ReticleRot;
    //return ReturnValue;    
}

// Export USkyPlayerController::execUpdateRotation_MoveReticle(FFrame&, void* const)
native function Rotator UpdateRotation_MoveReticle(float DeltaTime);

// Export USkyPlayerController::execZeroOutRoll(FFrame&, void* const)
native function ZeroOutRoll(out Rotator NewRotation, float DeltaTime);

// Export USkyPlayerController::execUpdateRotation(FFrame&, void* const)
native function UpdateRotation(float DeltaTime);

unreliable server function SetSPGroundSpeed(float Speed)
{
    Pawn.GroundSpeed = Speed;
    //return;    
}

event IgnoreMoveInputEvent(bool bNewMoveInput)
{
    IgnoreMoveInput(bNewMoveInput);
    //return;    
}

event IgnoreLookInputEvent(bool bNewLookInput)
{
    IgnoreLookInput(bNewLookInput);
    //return;    
}

exec function ToggleParachute()
{
    // End:0x29
    if(SkyPawn(Pawn).IsParachuting())
    {
        StopParachute();        
    }
    else
    {
        StartParachute();
    }
    //return;    
}

exec function StartParachute()
{
    // End:0x35
    if(SkyPawn(Pawn).CanParachute())
    {
        SkyPawn(Pawn).StartParachute();
    }
    //return;    
}

exec function StopParachute()
{
    // End:0x35
    if(SkyPawn(Pawn).IsParachuting())
    {
        SkyPawn(Pawn).StopParachute();
    }
    //return;    
}

exec function ToggleRocketPack()
{
    // End:0x29
    if(SkyPawn(Pawn).IsRocketPacking())
    {
        StopRocketPack();        
    }
    else
    {
        StartRocketPack();
    }
    //return;    
}

exec function StartRocketPack()
{
    // End:0x35
    if(SkyPawn(Pawn).CanRocketPack())
    {
        SkyPawn(Pawn).StartRocketPack();
    }
    //return;    
}

exec function StopRocketPack()
{
    // End:0x35
    if(SkyPawn(Pawn).IsRocketPacking())
    {
        SkyPawn(Pawn).StopRocketPack();
    }
    //return;    
}

exec function ReloadWeapon()
{
    local SkyPawn SP;
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x36
    if((SkyCam != none) && SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    SP = SkyPawn(Pawn);
    // End:0x7E
    if((SP != none) && SP.CanReloadWeapon())
    {
        SP.ReloadWeapon();
    }
    // End:0xA8
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).HudIdleTime = 0.0000000;
    }
    //return;    
}

exec function Intervehic(optional bool RocketPackVersion)
{
    local SkyPawn SP;
    local SkyAirVehicle CurrentSkyAirVehicle;

    // End:0x1E
    if(RocketPackVersion && SkyAirVehicle_RocketPackThrust(Pawn) == none)
    {
        return;
    }
    // End:0x3D
    if(!RocketPackVersion && SkyAirVehicle_RocketPackThrust(Pawn) != none)
    {
        return;
    }
    // End:0x4A
    if(!bCanHijack)
    {
        return;
    }
    SP = SkyPawn(Pawn);
    // End:0x97
    if((SP != none) && SP.IsHijacking() || SP.JumpVehicleTarget != none)
    {
        return;
    }
    // End:0x13C
    if(Vehicle(Pawn) != none)
    {
        SP = SkyPawn(Vehicle(Pawn).Driver);
        // End:0x103
        if((SP != none) && SP.IsHijacking() || SP.JumpVehicleTarget != none)
        {
            return;
        }
        SP.bHijackingFromVehicle = true;
        SP.HijackPrevVehicleClass = SkyAirVehicle(Pawn).Class;        
    }
    else
    {
        SP.bHijackingFromVehicle = false;
        SP.HijackPrevVehicleClass = none;
    }
    // End:0x3CF
    if(SP != none)
    {
        SP.SetFallState(5);
        SP.JumpVehicleTarget = SP.JumpVehicleTargetCurrent;
        MostRecentHijackTarget = SP.JumpVehicleTargetCurrent;
        MostRecentHijackTargetLocation = SP.JumpVehicleTargetCurrent.Location;
        MostRecentHijackTargetRotation = SP.JumpVehicleTargetCurrent.Rotation;
        // End:0x284
        if((SkyAirVehicle(SP.JumpVehicleTarget) != none) && !SkyAirVehicle(SP.JumpVehicleTarget).IsBeingHijacked())
        {
            SkyAirVehicle(SP.JumpVehicleTarget).SetBeingHijacked(SP);
            SkyVehicle(SP.JumpVehicleTarget).NotifyTeamClearEnemy();            
        }
        else
        {
            SP.JumpVehicleTarget = none;
            return;
        }
        // End:0x2C0
        if(int(Role) < int(ROLE_Authority))
        {
            ServerIntervehic(SP.JumpVehicleTarget);
        }
        // End:0x38E
        if(SP.JumpVehicleTarget != none)
        {
            // End:0x2FE
            if(RocketPackVersion)
            {
                SP.RocketPack.RocketPackPlayTag(17);
            }
            CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
            // End:0x384
            if(CurrentSkyAirVehicle != none)
            {
                SP.bHijackClearInput = true;
                // End:0x354
                if(SkyVehicle(Pawn) != none)
                {
                    SkyVehicle(Pawn).StopWeaponFiring();
                }
                StopWantToLeave();
                SP.ExitingVehicle = CurrentSkyAirVehicle;
                SP.SetCollision(false, false);
            }
            NearestTargetCamOff();
        }
        IgnoreMoveInput(true);
        IgnoreLookInput(true);
        // End:0x3CF
        if(!SP.bHijackingFromVehicle)
        {
            SP.JumpVehicle();
        }
    }
    //return;    
}

exec function Houdini(optional bool bGhost)
{
    local SkyCamera SkyCam;

    SkyCam = SkyCamera(PlayerCamera);
    // End:0x39
    if((SkyCam == none) || !SkyCam.IsFreeCamWithNoPlayerMovement())
    {
        return;
    }
    Pawn.SetLocationNoCheck(SkyCam.Location);
    SkyCam.CameraStyle = 'FixedTracking';
    // End:0x9C
    if(bGhost)
    {
        bCheatFlying = true;
        GotoState('PlayerFlying');
        bCollideWorld = false;
    }
    //return;    
}

exec function ThrustIntervehic()
{
    Intervehic(true);
    //return;    
}

reliable server function ServerIntervehic(Vehicle jvt)
{
    // End:0x44
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).JumpVehicleTarget = jvt;
        SkyPawn(Pawn).JumpVehicleTargetCurrent = jvt;
    }
    //return;    
}

exec function OnStartUseInput()
{
    local SkyPlayerInput SPI;

    // End:0x0B
    if(FtB_bInProgress)
    {
        return;
    }
    SPI = SkyPlayerInput(PlayerInput);
    // End:0x44
    if((SPI != none) && int(SPI.bCheatButton) != int(0))
    {
        return;
    }
    // End:0x5E
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedPressUseAction();
    }
    ServerPressUse();
    //return;    
}

exec function Use()
{
    // End:0x0B
    if(FtB_bInProgress)
    {
        return;
    }
    super(PlayerController).Use();
    //return;    
}

reliable server function ServerPressUse()
{
    PerformedPressUseAction();
    //return;    
}

exec function OnStopUseInput()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        PerformedReleaseUseAction();
    }
    ServerReleaseUse();
    //return;    
}

reliable server function ServerReleaseUse()
{
    PerformedReleaseUseAction();
    //return;    
}

simulated function bool PerformedPressUseAction()
{
    local bool Result;
    local Vehicle V;
    local array< class<SkyInteraction> > IgnoredInteractions;

    IgnoredInteractions.Add(2);
    IgnoredInteractions[0] = Class'SkyMeleeInteraction';
    IgnoredInteractions[1] = Class'SkyEnteringVehicleInteraction';
    StartInteraction(IgnoredInteractions, false);
    // End:0xCB
    if(Pawn != none)
    {
        V = Vehicle(Pawn);
        // End:0xB0
        if((V != none) && V.Driver != none)
        {
            Result = Pawn.IsInteracting() || V.Driver.IsInteracting();            
        }
        else
        {
            Result = Pawn.IsInteracting();
        }
    }
    // End:0xD6
    if(Result)
    {
        return true;
    }
    // End:0xEE
    if(V == none)
    {
        Result = PerformedUseAction();
    }
    // End:0xF9
    if(Result)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool PerformedReleaseUseAction()
{
    return false;
    //return ReturnValue;    
}

exec function PressedPickupAction()
{
    // End:0x18
    if(CanPickupWeapon())
    {
        WeaponPickup_UseButtonHoldTimer = WeaponPickup_UseButtonHoldTime;
    }
    //return;    
}

exec function ReleasedPickupAction()
{
    WeaponPickup_UseButtonHoldTimer = 0.0000000;
    //return;    
}

exec function TryMelee()
{
    local SkyPawnPlayerCharacter SPPC;
    local SkyPawn SP;
    local SkyWeapon SW;
    local array< class<SkyInteraction> > DesiredInteractions;

    // End:0x11F
    if((BestPickup == none) || (Pawn != none) && Pawn.CachedInteractionIsA(Class'SkyMeleeInteraction'))
    {
        SP = SkyPawn(Pawn);
        // End:0xA6
        if(SP != none)
        {
            // End:0x6A
            if(SP.IsInWalkVolume())
            {
                return;
            }
            SW = SkyWeapon(SP.Weapon);
            // End:0xA6
            if((SW != none) && SW.bIsLargeWeapon)
            {
                return;
            }
        }
        DesiredInteractions.Add(1);
        DesiredInteractions[0] = Class'SkyMeleeInteraction';
        StartInteraction(DesiredInteractions, true);
        // End:0x11F
        if((Pawn != none) && !Pawn.IsInteracting())
        {
            SPPC = SkyPawnPlayerCharacter(Pawn);
            // End:0x11F
            if(SPPC != none)
            {
                SPPC.FailedUseAction();
            }
        }
    }
    //return;    
}

exec function TryEnterVehicle()
{
    local array< class<SkyInteraction> > DesiredInteractions;

    // End:0x2F
    if(!FtB_bInProgress)
    {
        DesiredInteractions.Add(1);
        DesiredInteractions[0] = Class'SkyEnteringVehicleInteraction';
        StartInteraction(DesiredInteractions, true);
    }
    //return;    
}

reliable server function bool CanPickupWeapon()
{
    local SkyPawn SP;
    local SkyPawn_MaxValenti SPMax;

    SP = SkyPawn(Pawn);
    // End:0x20D
    if((SP != none) && ((((((((((((((((SP.bGoingIntervehicular || SP.IsHijacking()) || SP.IsInteracting()) || SP.IsGripping()) || SP.ThrownFromGripPoint()) || SP.ReleasedGripPoint()) || SP.ShotFromGripPoint()) || int(SP.ParachuteState) != int(0)) || int(SkyPawnCoverUser(SP).GetCoverState()) != int(0)) || SP.IsMelee()) || SP.UsingSecondaryItem()) || WorldInfo.Game.CinematicDisableInputRefCount > 0) || SP.IsFreefalling()) || SP.IsGliding()) || int(SP.FallState) != int(5)) || SP.PrimaryWSM.IsTransitioning()) || SP.SecondaryWSM.IsTransitioning()) || SP.IsInWalkVolume() == true)
    {
        return false;
    }
    SPMax = SkyPawn_MaxValenti(Pawn);
    // End:0x23F
    if((SPMax != none) && SPMax.bFailedUse)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

reliable server function bool DoPickup()
{
    local SkyPawn SP;
    local SkyPickup Pickup;
    local SkyPickupFactory PickupFactory;
    local bool CanPickup;

    // End:0x12
    if(int(Role) < int(ROLE_Authority))
    {
        return true;
    }
    SP = SkyPawn(Pawn);
    CanPickup = CanPickupWeapon();
    // End:0x1EF
    if((SP != none) && CanPickup)
    {
        // End:0x1EF
        if(int(SP.PickupState) == int(0))
        {
            PickupFactory = SkyPickupFactory(BestPickup);
            // End:0x129
            if((PickupFactory != none) && PickupFactory.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
            {
                // End:0x10F
                if(SkyWeaponPickupFactory(PickupFactory) != none)
                {
                    return SP.BeginWeaponPickup(PickupFactory, true, !SkyWeaponPickupFactory(PickupFactory).SpawnedArchetype.bIsSecondaryWeapon, SkyWeaponPickupFactory(PickupFactory).SpawnedArchetype.bIsLargeWeapon);                    
                }
                else
                {
                    return SP.BeginItemPickup(PickupFactory);
                }
            }
            Pickup = SkyPickup(BestPickup);
            // End:0x1EF
            if((Pickup != none) && Pickup.CanGive(SkyPlayerReplicationInfo(PlayerReplicationInfo)))
            {
                // End:0x1D5
                if(SkyWeaponPickup(Pickup) != none)
                {
                    return SP.BeginWeaponPickup(Pickup, false, !SkyWeapon(Pickup.DroppedItemArchetype).bIsSecondaryWeapon, SkyWeapon(Pickup.DroppedItemArchetype).bIsLargeWeapon);                    
                }
                else
                {
                    return SP.BeginItemPickup(Pickup);
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

exec function DropPrimary()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x39
    if(int(SP.PickupState) != int(0))
    {
        return;
    }
    // End:0x52
    if(SP.UsingSecondaryItem())
    {
        return;
    }
    // End:0xA9
    if(SP.Weapon != none)
    {
        SP.PickupState = 4;
        SP.bPickupState_Primary = true;
        SP.PrimaryWSM.Discard();
    }
    //return;    
}

reliable server function ServerDropPrimary()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x5E
    if(SP.Weapon != none)
    {
        SP.DropWeapon(SkyWeapon(SP.Weapon));
        return;
    }
    //return;    
}

exec function DropSecondary()
{
    local SkyPawn SP;
    local SkyWeapon SecondaryWeapon;

    SP = SkyPawn(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x39
    if(int(SP.PickupState) != int(0))
    {
        return;
    }
    // End:0x52
    if(SP.UsingSecondaryItem())
    {
        return;
    }
    SecondaryWeapon = SkyWeapon(SP.SecondaryWeapon);
    // End:0x79
    if(SecondaryWeapon == none)
    {
        return;
    }
    // End:0xE9
    if((SP.SecondaryWeapon != none) && SecondaryWeapon.HasAnyAmmo())
    {
        SP.PickupState = 4;
        SP.bPickupState_Primary = false;
        SP.SecondaryWSM.Discard();
    }
    //return;    
}

reliable server function ServerDropSecondary()
{
    local SkyPawn SP;
    local SkyWeapon SecondaryWeapon;

    SP = SkyPawn(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    SecondaryWeapon = SkyWeapon(SP.SecondaryWeapon);
    // End:0x44
    if(SecondaryWeapon == none)
    {
        return;
    }
    // End:0xE6
    if(SP.SecondaryWeapon != none)
    {
        // End:0x9D
        if(SecondaryWeapon.HasAnyAmmo())
        {
            SP.DropWeapon(SkyWeapon(SP.SecondaryWeapon));            
        }
        else
        {
            // End:0xE4
            if(SP.InvManager != none)
            {
                SP.InvManager.RemoveFromInventory(SkyWeapon(SP.SecondaryWeapon));
            }
        }
        return;
    }
    //return;    
}

function NotifyDrop()
{
    local SkyPawn SP;
    local SkyWeapon SkyWeap;

    SP = SkyPawn(Pawn);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    // End:0x153
    if(int(SP.Role) == int(ROLE_Authority))
    {
        // End:0x149
        if(((SP.SecondaryWSM != none) && SP.SecondaryWSM.IsAcquiring()) || (SP.PrimaryWSM != none) && SP.PrimaryWSM.IsAcquiring())
        {
            // End:0x13C
            if(SP.bPickupState_Primary)
            {
                SkyWeap = SkyWeapon(SP.Weapon);
                // End:0x12F
                if((SP.bAllowTwoWeapons && SP.BackWeapon == none) && !SkyWeap.bIsLargeWeapon)
                {
                    SP.SwapPrimaryWeapon(true);                    
                }
                else
                {
                    ServerDropPrimary();
                }                
            }
            else
            {
                ServerDropSecondary();
            }            
        }
        else
        {
            ServerDropPrimary();
        }
    }
    //return;    
}

exec function DoJumpVehicle()
{
    SkyPawn(Pawn).JumpVehicleTarget = SkyPawn(Pawn).JumpVehicleTargetCurrent;
    // End:0x52
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).JumpVehicle();
    }
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector CamLoc;
    local Rotator CamRot, Rot;
    local Vector TL, TR, BL, BR;
    local Rotator rReticleRotOffset;
    local float X, Y;
    local SkyAIController SAC;
    local float losYaw;
    local Rotator losRot;
    local Canvas Canvas;
    local Actor AutoTarget;
    local int nCurrentFireMode;
    local bool bLastDebug, bLastDebugTemp;

    super(SkyPlayerControllerBase).DisplayDebug(HUD, out_YL, out_YPos);
    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255);
    // End:0x9D
    if(SkyPawn(Pawn) != none)
    {
        Canvas.DrawText("CalcPawnRotation: " @ string(SkyPawn(Pawn).CalcPawnRotationState));
        out_YPos += out_YL;
    }
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0xEF
    if(SkyPlayerInput(PlayerInput) != none)
    {
        SkyPlayerInput(PlayerInput).DisplayDebug(HUD, out_YL, out_YPos);
    }
    // End:0x16F
    if(HUD.ShouldDisplayDebug('pool'))
    {
        // End:0x16F
        if(SkyGameReplicationInfo(WorldInfo.GRI).SOP != none)
        {
            SkyGameReplicationInfo(WorldInfo.GRI).SOP.DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    // End:0x19E
    if(HUD.ShouldDisplayDebug('cine'))
    {
        ShowCineDebug(Canvas);
    }
    // End:0x1CD
    if(HUD.ShouldDisplayDebug('Cam'))
    {
        ShowCameraDebug(Canvas);
    }
    // End:0x4A9
    if(HUD.ShouldDisplayDebug('AutoTarget'))
    {
        // End:0x21A
        if(SkyPawn(Pawn) != none)
        {
            AutoTarget = SkyPawn(Pawn).AutoTarget;            
        }
        else
        {
            // End:0x272
            if(Vehicle(Pawn) != none)
            {
                // End:0x272
                if(SkyPawn(Vehicle(Pawn).Driver) != none)
                {
                    AutoTarget = SkyPawn(Vehicle(Pawn).Driver).AutoTarget;
                }
            }
        }
        DrawDebugSphere(AutoTarget.Location, 25.0000000, 5, 255, 0, 0, false);
        // End:0x413
        if(Pawn != none)
        {
            // End:0x2D6
            if(AutoTarget != none)
            {
                DrawDebugLine(Pawn.Location, AutoTarget.Location, 255, 255, 0, false);
            }
            DrawDebugSphere(Pawn.Location, AutoTarget_Radius, 16, 255, 255, 255, false);
            // End:0x31A
            if(bAutoTarget_PawnRelative)
            {
                losRot = Pawn.Rotation;                
            }
            else
            {
                losRot = Rotation;
            }
            losRot.Pitch = 0;
            losRot.Roll = 0;
            losYaw = AutoTarget_LOSTolerance * float(65536 / 360);
            losRot.Yaw += int(losYaw);
            DrawDebugLine(Pawn.Location, Pawn.Location + (Vector(losRot) * 1000.0000000), 0, 0, 255, false);
            losRot.Yaw -= int(2.0000000 * losYaw);
            DrawDebugLine(Pawn.Location, Pawn.Location + (Vector(losRot) * 1000.0000000), 0, 0, 255, false);
        }
        Canvas.SetDrawColor(0, 0, 255);
        Canvas.DrawText((((((("AutoTarget: " @ string(AutoTarget)) @ ", ") @ string(bAutoTarget_PawnRelative)) @ ", ") @ string(AutoTarget_LOSTolerance)) @ ", ") @ string(AutoTarget_Radius));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x4D8
    if(HUD.ShouldDisplayDebug('coverlabel'))
    {
        ShowCoverLabels(Canvas);
    }
    // End:0x511
    if(HUD.ShouldDisplayDebug('Squads'))
    {
        ShowSquads(Canvas, out_YL, out_YPos);
    }
    // End:0x54A
    if(HUD.ShouldDisplayDebug('moveticket'))
    {
        ShowMoveTickets(Canvas, out_YL, out_YPos);
    }
    // End:0x885
    if(((((HUD.ShouldDisplayDebug('AI') || HUD.ShouldDisplayDebug('planeai')) || HUD.ShouldDisplayDebug('splines')) || HUD.ShouldDisplayDebug('tethers')) || HUD.ShouldDisplayDebug('Gangs')) || HUD.ShouldDisplayDebug('planeaiCollision'))
    {
        // End:0x648
        if(SkyAIDebugTarget != none)
        {
            bLastDebug = SkyAIDebugTarget.bDebug;
            SkyAIDebugTarget.bDebug = true;
        }
        // End:0x690
        if((SkyAIDebugTarget != none) && SkyAIDebugTarget.Pawn != none)
        {
            SkyAIDebugTarget.DisplayDebug(HUD, out_YL, out_YPos);            
        }
        else
        {
            // End:0x862
            foreach WorldInfo.AllControllers(Class'SkyAIController', SAC)
            {
                // End:0x861
                if((SAC != none) && SAC.Pawn != none)
                {
                    bLastDebugTemp = SAC.bDebug;
                    // End:0x707
                    if(SAC != SkyAIDebugTarget)
                    {
                        SAC.bDebug = false;
                    }
                    // End:0x7E5
                    if(SkyBotControllerBase(SAC) != none)
                    {
                        // End:0x7E2
                        if((((HUD.ShouldDisplayDebug('planeai') || HUD.ShouldDisplayDebug('splines')) || HUD.ShouldDisplayDebug('tethers')) || HUD.ShouldDisplayDebug('Gangs')) || HUD.ShouldDisplayDebug('planeaiCollision'))
                        {
                            SAC.DisplayDebug(HUD, out_YL, out_YPos);
                        }                        
                    }
                    else
                    {
                        // End:0x84A
                        if(HUD.ShouldDisplayDebug('AI') || HUD.ShouldDisplayDebug('Gangs'))
                        {
                            SAC.DisplayDebug(HUD, out_YL, out_YPos);
                        }
                    }
                    SAC.bDebug = bLastDebugTemp;
                }                
            }            
        }
        // End:0x885
        if(SkyAIDebugTarget != none)
        {
            SkyAIDebugTarget.bDebug = bLastDebug;
        }
    }
    // End:0xF88
    if(HUD.ShouldDisplayDebug('Reticle'))
    {
        X = HUD.Canvas.CurX;
        Y = HUD.Canvas.CurY;
        GetPlayerViewPoint(CamLoc, CamRot);
        nCurrentFireMode = GetCurrentFireMode();
        rReticleRotOffset = m_ReticleOffsetValues[nCurrentFireMode];
        Rot = CamRot + rReticleRotOffset;
        TR = (Vector(Rot) * m_fReticleDistFromCamera) + CamLoc;
        Rot = CamRot + rReticleRotOffset;
        TL = (Vector(Rot) * m_fReticleDistFromCamera) + CamLoc;
        Rot = CamRot + rReticleRotOffset;
        BL = (Vector(Rot) * m_fReticleDistFromCamera) + CamLoc;
        Rot = CamRot + rReticleRotOffset;
        BR = (Vector(Rot) * m_fReticleDistFromCamera) + CamLoc;
        DrawDebugLine(TR, TL, 255, 0, 0);
        DrawDebugLine(TL, BL, 255, 0, 0);
        DrawDebugLine(BL, BR, 255, 0, 0);
        DrawDebugLine(BR, TR, 255, 0, 0);
        TR = HUD.Canvas.Project(TR);
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawRect(1.0000000, 1.0000000);
        TL = HUD.Canvas.Project(TL);
        HUD.Canvas.SetPos(TL.X, TL.Y);
        HUD.Canvas.DrawRect(1.0000000, 1.0000000);
        BL = HUD.Canvas.Project(BL);
        HUD.Canvas.SetPos(BL.X, BL.Y);
        HUD.Canvas.DrawRect(1.0000000, 1.0000000);
        BR = HUD.Canvas.Project(BR);
        HUD.Canvas.SetPos(BR.X, BR.Y);
        HUD.Canvas.DrawRect(1.0000000, 1.0000000);
        TR = HUD.Canvas.Project(CamLoc + (Vector(CamRot) * 2000.0000000));
        TR.X -= 200.0000000;
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawTextClipped(((("Speed: (" $ string(m_vJoystickVel.X)) $ ",") $ string(m_vJoystickVel.Y)) $ ")");
        TR.Y += 10.0000000;
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawTextClipped("m_bReticleMaxed: " $ string(m_bReticleMaxed));
        TR.Y += 10.0000000;
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawTextClipped("m_rReticleRotation: " $ string(Normalize(m_rReticleRotation)));
        TR.Y += 10.0000000;
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawTextClipped("m_rReticleRotationDelta: " $ string(Normalize(m_rReticleRotationDelta)));
        TR.Y += 10.0000000;
        HUD.Canvas.SetPos(TR.X, TR.Y);
        HUD.Canvas.DrawTextClipped("rReticleRotOffset: " $ string(Normalize(rReticleRotOffset)));
        HUD.Canvas.SetPos(X, Y);
    }
    //return;    
}

function ShowCoverLabels(Canvas Canvas)
{
    local CoverSlotMarker CSM;
    local Vector DrawLoc, CamToNode;
    local Pawn Claimant;

    // End:0x1C7
    foreach WorldInfo.AllNavigationPoints(Class'Engine.CoverSlotMarker', CSM)
    {
        CamToNode = CSM.Location - PlayerCamera.Location;
        // End:0x1C6
        if(((PlayerCamera != none) && VSizeSq(CamToNode) < Square(3000.0000000)) && (Normal(Vector(PlayerCamera.Rotation)) Dot Normal(CamToNode)) > 0.4000000)
        {
            DrawLoc = Canvas.Project(CSM.Location);
            Canvas.SetPos(DrawLoc.X, DrawLoc.Y - float(10));
            Claimant = CSM.OwningSlot.Link.Slots[CSM.OwningSlot.SlotIdx].SlotOwner;
            // End:0x18A
            if(Claimant != none)
            {
                Canvas.SetDrawColor(255, 0, 0);
                DrawDebugLine(CSM.Location, Claimant.Location, 255, 0, 0);                
            }
            else
            {
                Canvas.SetDrawColor(255, 255, 255);
            }
            Canvas.DrawTextClipped(string(CSM.Name));
        }        
    }    
    //return;    
}

function ShowMoveTickets(Canvas Canvas, out float out_YL, out float out_YPos)
{
    local int I;

    Canvas.SetDrawColor(50, 255, 0);
    Canvas.SetPos(8.0000000, out_YPos);
    Canvas.DrawText(" ReachTickets In Use=" $ string(SkyGame(WorldInfo.Game).MovePermitList.Length));
    out_YPos += out_YL;
    I = 0;
    J0x92:

    // End:0x148 [Loop If]
    if(I < SkyGame(WorldInfo.Game).MovePermitList.Length)
    {
        Canvas.SetPos(8.0000000, out_YPos);
        Canvas.DrawText(((("   +Bot[" $ string(I)) $ "] = [") $ string(SkyGame(WorldInfo.Game).MovePermitList[I])) $ "]");
        out_YPos += out_YL;
        ++I;
        // [Loop Continue]
        goto J0x92;
    }
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.SetDrawColor(255, 255, 255);
    //return;    
}

function ShowSquads(Canvas Canvas, out float out_YL, out float out_YPos)
{
    local SkySquadInfo SQ;
    local int SquadCount;

    SquadCount = 0;
    SQ = SkyGame(WorldInfo.Game).SkySquadFirst;
    J0x2B:

    // End:0x55 [Loop If]
    if(SQ != none)
    {
        ++SquadCount;
        SQ = SQ.NextSquad;
        // [Loop Continue]
        goto J0x2B;
    }
    Canvas.SetDrawColor(0, 255, 0);
    Canvas.DrawTextClipped(" +SQUADS: Total Active=" $ string(SquadCount));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.SetDrawColor(255, 255, 255);
    SQ = SkyGame(WorldInfo.Game).SkySquadFirst;
    SquadCount = 0;
    J0x10A:

    // End:0x1E2 [Loop If]
    if(SQ != none)
    {
        SquadCount++;
        Canvas.DrawTextClipped((((((("[" $ string(SquadCount)) $ "] - Name:") $ string(SQ.SquadName)) @ "Total Members:") $ string(SQ.SquadMembers.Length)) @ "AOVolumes:") $ string(SQ.AreasOfOperation.Length));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        SQ = SQ.NextSquad;
        // [Loop Continue]
        goto J0x10A;
    }
    //return;    
}

exec function RateCover(name BotName, optional int SearchType)
{
    local SkyBot SB;
    local CoverInfo FoundCover;

    // End:0x14B
    foreach WorldInfo.AllControllers(Class'SkyBot', SB)
    {
        // End:0x14A
        if((SB.Name == BotName) || SB.Pawn.Name == BotName)
        {
            SB.bVisualDebugCoverSearch = true;
            // End:0xE7
            if(SB.FindCover(byte(SearchType), Pawn, FoundCover))
            {
                DrawDebugLine(SB.Pawn.Location, FoundCover.Link.GetSlotLocation(FoundCover.SlotIdx), 255, 255, 255, true);                
            }
            else
            {
                DrawDebugLine(SB.Pawn.Location, SB.Pawn.Location + vect(0.0000000, 0.0000000, 100.0000000), 255, 0, 0, true);
            }
            SB.bVisualDebugCoverSearch = false;            
            return;
        }        
    }    
    //return;    
}

exec function RateFlee(name BotName, float MinFlee, float MaxFlee)
{
    local SkyBot SB;
    local NavigationPoint FleeGoal;

    // End:0x15E
    foreach WorldInfo.AllControllers(Class'SkyBot', SB)
    {
        // End:0x15D
        if((SB.Name == BotName) || SB.Pawn.Name == BotName)
        {
            SB.bVisualDebugCoverSearch = true;
            SB.SetFleeDistances(MinFlee, MaxFlee, -1.0000000);
            FleeGoal = SB.FindFleeFrom(Pawn);
            // End:0xEA
            if(FleeGoal != none)
            {
                DrawDebugLine(SB.Pawn.Location, FleeGoal.Location, 255, 255, 255, true);                
            }
            else
            {
                DrawDebugLine(SB.Pawn.Location, SB.Pawn.Location + vect(0.0000000, 0.0000000, 100.0000000), 255, 0, 0, true);
            }
            SB.bVisualDebugCoverSearch = false;
            SB.RestoreDefaultFleeDistances();            
            return;
        }        
    }    
    //return;    
}

exec function ToggleInfoHud()
{
    local SkyHUD H;

    H = SkyHUD(myHUD);
    // End:0x2F
    if(H != none)
    {
        H.ToggleInfoHud();
    }
    //return;    
}

function CloseCallViewShakeTimer()
{
    //return;    
}

event ShakeCamera(ViewShakeInfo NewViewShake, optional float Scale = 1.0000000)
{
    // End:0xA2
    if(Scale != 1.0000000)
    {
        NewViewShake.OffsetMag *= Scale;
        NewViewShake.OffsetRate *= Scale;
        NewViewShake.OffsetTime *= Scale;
        NewViewShake.RotMag *= Scale;
        NewViewShake.RotRate *= Scale;
        NewViewShake.RotTime *= Scale;
    }
    ShakeView(NewViewShake);
    //return;    
}

event StopShakeCamera()
{
    StopViewShaking();
    //return;    
}

event StartRumble(ForceFeedbackWaveform FFeedback)
{
    // End:0x1A
    if(CinematicModeRefCount == 0)
    {
        ClientPlayForceFeedbackWaveform(FFeedback);
    }
    //return;    
}

event StopRumble(optional ForceFeedbackWaveform FFeedback)
{
    ClientStopForceFeedbackWaveform(FFeedback);
    //return;    
}

event RumbleByDistance(ForceFeedbackWaveform FFeedback, float Distance, float MaxDistance)
{
    local ForceFeedbackWaveform AdjustedFeedback;
    local int I;

    // End:0x25
    if((FFeedback == none) || FFeedback.Samples.Length == 0)
    {
        return;
    }
    AdjustedFeedback = new (Outer) Class'Engine.ForceFeedbackWaveform';
    AdjustedFeedback.Samples.Insert(0, FFeedback.Samples.Length);
    I = 0;
    J0x61:

    // End:0x164 [Loop If]
    if(I < FFeedback.Samples.Length)
    {
        AdjustedFeedback.Samples[I] = FFeedback.Samples[I];
        AdjustedFeedback.Samples[I].LeftAmplitude = byte(float(FFeedback.Samples[I].LeftAmplitude) * (1.0000000 - (Distance / MaxDistance)));
        AdjustedFeedback.Samples[I].RightAmplitude = byte(float(FFeedback.Samples[I].RightAmplitude) * (1.0000000 - (Distance / MaxDistance)));
        ++I;
        // [Loop Continue]
        goto J0x61;
    }
    ClientPlayForceFeedbackWaveform(AdjustedFeedback);
    //return;    
}

event CameraShakeByDistance(ViewShakeInfo CamShake, float Distance, float MaxDistance)
{
    local ViewShakeInfo AdjustedShake;
    local float DistVal;

    AdjustedShake = CamShake;
    DistVal = 1.0000000 - (Distance / MaxDistance);
    AdjustedShake.OffsetMag *= DistVal;
    AdjustedShake.OffsetRate *= DistVal;
    AdjustedShake.RotMag *= DistVal;
    AdjustedShake.RotRate *= DistVal;
    ShakeView(AdjustedShake);
    //return;    
}

exec function ToggleForceLockSec()
{
    // End:0x7A
    if(SkyPawn(Pawn) != none)
    {
        // End:0x7A
        if(SkyWeapon(SkyPawn(Pawn).SecondaryWeapon) != none)
        {
            SkyWeapon(SkyPawn(Pawn).SecondaryWeapon).bForceLock = !SkyWeapon(SkyPawn(Pawn).SecondaryWeapon).bForceLock;
        }
    }
    //return;    
}

reliable client simulated function ClientSetHUD(HUD newHUDType, class<ScoreBoard> newScoringType)
{
    super(PlayerController).ClientSetHUD(newHUDType, newScoringType);
    // End:0xA4
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).CacheButtonArray();
        SkyHUD(myHUD).CheckInteractionModifiers();
        // End:0x8D
        if(!WorldInfo.IsConsoleBuild())
        {
            SkyHUD(myHUD).SetTimer(0.5000000, true, 'CheckControllerTick');            
        }
        else
        {
            SkyHUD(myHUD).bControllerConnected = true;
        }
    }
    //return;    
}

exec event Start180()
{
    SkyPawn(Pawn).Start180();
    //return;    
}

simulated function Vector GetAimVector()
{
    local Vector FireDir;

    FireDir = Vector(AddRotators(m_rReticleRotation, CalcViewRotation));
    return FireDir;
    //return ReturnValue;    
}

// Export USkyPlayerController::execGetAdjustedAimFor(FFrame&, void* const)
native function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc);

unreliable client simulated function ClientMusicEvent(int EventIndex)
{
    //return;    
}

function CheckAutoTarget()
{
    // End:0x2D
    if(Vehicle(Pawn) != none)
    {
        DoCheckAutoTarget(bAutoTarget_PawnRelative_Vehicle, AutoTarget_LOSTolerance_Vehicle, AutoTarget_Radius_Vehicle);        
    }
    else
    {
        DoCheckAutoTarget(bAutoTarget_PawnRelative_Normal, AutoTarget_LOSTolerance_Normal, AutoTarget_Radius_Normal);
    }
    //return;    
}

function DoCheckAutoTarget(bool bPawnRelative, float losTolerance, float Radius)
{
    local Actor bestCandidate;
    local Pawn candidateActor;
    local Actor oldTarget, bestTarget;
    local float bestPoints, curPoints;
    local Vector inst2candV, instV;
    local float inst2candDot, inst2candDist, rotPoints, distPoints;
    local SkyPawn P;
    local float viewTolerance;

    P = SkyPawn(Pawn);
    // End:0x4A
    if(P == none)
    {
        // End:0x4A
        if(Vehicle(Pawn) != none)
        {
            P = SkyPawn(Vehicle(Pawn).Driver);
        }
    }
    // End:0x57
    if(P == none)
    {
        return;
    }
    bAutoTarget_PawnRelative = bPawnRelative;
    AutoTarget_LOSTolerance = losTolerance;
    AutoTarget_Radius = Radius;
    oldTarget = P.AutoTarget;
    rotPoints = 100.0000000;
    distPoints = 100.0000000;
    bestPoints = -10000000.0000000;
    // End:0xD3
    if(bPawnRelative)
    {
        instV = Vector(P.Rotation);        
    }
    else
    {
        instV = Vector(Rotation);
    }
    viewTolerance = Cos(losTolerance * 0.0174533);
    // End:0x2C4
    foreach P.VisibleCollidingActors(Class'Engine.Pawn', candidateActor, Radius, P.Location)
    {
        // End:0x153
        if(candidateActor.bDeleteMe || candidateActor.Health <= 0)
        {
            continue;            
        }
        // End:0x19E
        if(Vehicle(candidateActor) != none)
        {
            // End:0x19A
            if(Vehicle(candidateActor).Driver != none)
            {
                candidateActor = Vehicle(candidateActor).Driver;                
            }
            else
            {
                continue;                
            }
        }
        // End:0x1B1
        if(candidateActor == P)
        {
            continue;            
        }
        curPoints = 0.0000000;
        inst2candV = Normal(candidateActor.Location - P.Location);
        inst2candDot = instV Dot inst2candV;
        // End:0x209
        if(inst2candDot < viewTolerance)
        {
            continue;            
        }
        curPoints += (rotPoints * inst2candDot);
        inst2candDist = VSize(candidateActor.Location - P.Location);
        curPoints += ((distPoints * (Radius - inst2candDist)) / Radius);
        // End:0x28A
        if(curPoints > bestPoints)
        {
            bestCandidate = candidateActor;
            bestPoints = curPoints;
        }
        // End:0x2C3
        if((oldTarget == candidateActor) && inst2candDist < Radius)
        {
            bestCandidate = candidateActor;
            bestPoints = curPoints;
            // End:0x2C4
            break;
        }        
    }    
    // End:0x350
    if((bestCandidate == none) || !IsValidAutoTarget(bestCandidate))
    {
        bestTarget = none;
        // End:0x34D
        if(SkyGameReplicationInfo(WorldInfo.GRI) != none)
        {
            bestCandidate = SkyPlayerReplicationInfo(PlayerReplicationInfo).CurrentObjectives[0];
            // End:0x34D
            if((bestCandidate != none) && IsValidAutoTarget(bestCandidate))
            {
                bestTarget = bestCandidate;
            }
        }        
    }
    else
    {
        bestTarget = bestCandidate;
    }
    // End:0x37B
    if(bestTarget != none)
    {
        AutoTargetLastValidTargetTime = WorldInfo.TimeSeconds;
    }
    // End:0x3A9
    if(bestTarget == P.AutoTarget)
    {
        AutoTargetLastLockedOnTime = WorldInfo.TimeSeconds;
    }
    // End:0x459
    if((P.AutoTarget != none) && ((((WorldInfo.TimeSeconds - AutoTargetLastLockedOnTime) > AutoTargetLockTolerance) || P.AutoTarget.bDeleteMe) || (Pawn(P.AutoTarget) != none) && Pawn(P.AutoTarget).Health <= 0) || bestTarget == none)
    {
        SetAutoTarget(none);
    }
    // End:0x4A2
    if((PendingAutoTarget != none) && ((WorldInfo.TimeSeconds - AutoTargetLastValidTargetTime) > AutoTargetLockTolerance) || PendingAutoTarget.bDeleteMe)
    {
        PendingAutoTarget = none;
    }
    // End:0x587
    if(bestTarget != none)
    {
        // End:0x4E3
        if(PendingAutoTarget != bestTarget)
        {
            PendingAutoTarget = bestTarget;
            PendingAutoTargetTime = WorldInfo.TimeSeconds + AutoTargetLockAcquireTime;
        }
        // End:0x587
        if((PendingAutoTarget == bestTarget) && WorldInfo.TimeSeconds >= PendingAutoTargetTime)
        {
            SetAutoTarget(PendingAutoTarget);
            AutoTargetLastLockedOnTime = WorldInfo.TimeSeconds;
            PendingAutoTarget = none;
            PendingAutoTargetTime = 0.0000000;
            // End:0x587
            if(((AutoTargetLostSound != none) && P.IsHumanControlled()) && P.IsLocallyControlled())
            {
                ClientPlaySound(AutoTargetLostSound);
            }
        }
    }
    //return;    
}

function bool IsValidAutoTarget(out Actor TA)
{
    // End:0x12
    if(SkyPawn(TA) == none)
    {
        return false;
    }
    // End:0x82
    if((((!TA.bProjTarget || TA.bDeleteMe) || Pawn(TA) == none) || Pawn(TA) == Instigator) || Pawn(TA).Health <= 0)
    {
        return false;
    }
    // End:0xA3
    if(!WorldInfo.Game.bTeamGame)
    {
        return true;
    }
    return !WorldInfo.GRI.OnSameTeam(Instigator, TA);
    //return ReturnValue;    
}

function SetAutoTarget(Actor newAutoTarget)
{
    local bool bNewTarget;
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x4C
    if((SP == none) && Vehicle(Pawn) != none)
    {
        SP = SkyPawn(Vehicle(Pawn).Driver);
    }
    // End:0x59
    if(SP == none)
    {
        return;
    }
    bNewTarget = newAutoTarget != SP.AutoTarget;
    SP.SetAutoTarget(newAutoTarget);
    // End:0xBE
    if(bNewTarget)
    {
        // End:0xB2
        if(newAutoTarget != none)
        {
            IgnoreLookInput(true);            
        }
        else
        {
            IgnoreLookInput(false);
        }
    }
    //return;    
}

exec function StartAutoTarget()
{
    CheckAutoTarget();
    SetTimer(AutoTargetLockCheckTime, true, 'CheckAutoTarget');
    //return;    
}

exec function StopAutoTarget()
{
    SetAutoTarget(none);
    ClearTimer('CheckAutoTarget');
    //return;    
}

function StartInteraction(optional array< class<SkyInteraction> > ExceptionClasses, optional bool bExceptionOnly)
{
    local int I;
    local bool MatchesExceptionClasses;
    local Vehicle V;
    local Pawn P;

    V = Vehicle(Pawn);
    // End:0x42
    if((V == none) || V.Driver == none)
    {
        P = Pawn;        
    }
    else
    {
        P = V.Driver;
    }
    // End:0x75
    if(P.CachedInteractionIsA(Class'SkyAirHijackingEndInteraction'))
    {
        return;
    }
    // End:0xF7
    if((ExceptionClasses.Length > 0) && P != none)
    {
        MatchesExceptionClasses = false;
        I = 0;
        J0x9D:

        // End:0xE4 [Loop If]
        if(I < ExceptionClasses.Length)
        {
            // End:0xDA
            if(P.CachedInteractionIsA(ExceptionClasses[I]))
            {
                MatchesExceptionClasses = true;
                // [Explicit Break]
                goto J0xE4;
            }
            ++I;
            // [Loop Continue]
            goto J0x9D;
        }
        J0xE4:

        // End:0xF7
        if(MatchesExceptionClasses != bExceptionOnly)
        {
            return;
        }
    }
    // End:0x114
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartInteraction();        
    }
    else
    {
        // End:0x133
        if(P != none)
        {
            P.StartInteraction();
        }
    }
    //return;    
}

exec function StartXInteraction()
{
    local SkyPlayerInput SPI;

    SPI = SkyPlayerInput(PlayerInput);
    // End:0x39
    if((SPI == none) || int(SPI.bCheatButton) == int(1))
    {
        return;
    }
    // End:0x74
    if(Pawn.CachedInteractionIsA(Class'SkyAirHijackingEndInteraction'))
    {
        // End:0x74
        if(Pawn != none)
        {
            Pawn.StartInteraction();
        }
    }
    //return;    
}

exec function AllowSprint()
{
    bAllowSprint = true;
    // End:0x2F
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).SprintDisable = false;
    }
    //return;    
}

exec function PoolSnapShot()
{
    local float Discard1, Discard2;

    // End:0x5F
    if(SkyGameReplicationInfo(WorldInfo.GRI).SOP != none)
    {
        SkyGameReplicationInfo(WorldInfo.GRI).SOP.DisplayDebug(none, Discard1, Discard2);        
    }
    //return;    
}

reliable server function ServerStartInteraction()
{
    // End:0x1C
    if(int(Role) == int(ROLE_Authority))
    {
        StartInteraction();
    }
    //return;    
}

simulated function OnDisablePowercell(SkySeqAct_DisablePowercell inAction)
{
    local Actor PowerCell;

    PowerCell = inAction.PowerCell;
    // End:0x61
    if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).CanDisablePowercell())
    {
        SkyPawn(Pawn).DisablePowercell(PowerCell);
    }
    //return;    
}

simulated function OnSetCanHijack(SkySeqAct_SetCanHijack inAction)
{
    bCanHijack = inAction.bCanHijack;
    //return;    
}

unreliable server function ServerMove(float TimeStamp, Vector InAccel, Vector ClientLoc, byte MoveFlags, byte ClientRoll, int View)
{
    local Rotator ViewRot;
    local int ViewPitch, ViewYaw;
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x109
    if((SP != none) && SP.IsHijacking())
    {
        Pawn.SetLocation(ClientLoc);
        ViewPitch = View & 65535;
        ViewYaw = View >> 16;
        ViewRot.Pitch = ViewPitch;
        ViewRot.Yaw = ViewYaw;
        ViewRot.Roll = 0;
        Pawn.SetRotation(ViewRot);
        // End:0xE3
        if(SP.IsHijacking())
        {
            MoveFlags = byte(int(MoveFlags) | int(1));
        }
        Pawn.Acceleration = InAccel * Pawn.AccelRate;
    }
    super.ServerMove(TimeStamp, InAccel, ClientLoc, MoveFlags, ClientRoll, View);
    //return;    
}

function MoveAutonomous(float DeltaTime, byte CompressedFlags, Vector newAccel, Rotator DeltaRot)
{
    local SkyPawn SP;
    local SkyWeaponBase Weap;

    SP = SkyPawn(Pawn);
    // End:0x43
    if(((SP != none) && SP.bGoingIntervehicular) && !IsLocalPlayerController())
    {
        return;
    }
    super(PlayerController).MoveAutonomous(DeltaTime, CompressedFlags, newAccel, DeltaRot);
    // End:0x200
    if((SP != none) && SP.IsRocketPacking())
    {
        // End:0x1B2
        if(SP.IsGliding())
        {
            Weap = SkyWeaponBase(SP.Weapon);
            // End:0x143
            if(((Weap != none) && Weap.bIsLargeWeapon) && SP.Velocity.Z < SP.RocketPack.TerminalVelocityFastGlide)
            {
                SP.Velocity.Z = SP.RocketPack.TerminalVelocityFastGlide;                
            }
            else
            {
                // End:0x1AF
                if(SP.Velocity.Z < SP.RocketPack.TerminalVelocityGlide)
                {
                    SP.Velocity.Z = SP.RocketPack.TerminalVelocityGlide;
                }
            }            
        }
        else
        {
            // End:0x200
            if(int(SP.RocketPackState) == int(1))
            {
                SP.Velocity.Z = SP.RocketPack.UpwardBoost;
            }
        }
    }
    //return;    
}

unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    // End:0x43
    if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).IsHijacking())
    {
        newPhysics = Pawn.Physics;
    }
    super(SkyPlayerControllerBase).LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, NewFloorX, NewFloorY, NewFloorZ);
    //return;    
}

function ReplicateMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
{
    local SavedMove NewMove, OldMove, AlmostLastMove, LastMove;
    local byte ClientRoll;
    local float NetMoveDelta;
    local Rotator PawnRot;

    MaxResponseTime = default.MaxResponseTime * WorldInfo.TimeDilation;
    DeltaTime = FMin(DeltaTime, MaxResponseTime);
    // End:0xCF
    if(SavedMoves != none)
    {
        LastMove = SavedMoves;
        AlmostLastMove = LastMove;
        OldMove = none;
        J0x56:

        // End:0xCF [Loop If]
        if(LastMove.NextMove != none)
        {
            // End:0xAC
            if(((OldMove == none) && Pawn != none) && LastMove.IsImportantMove(LastAckedAccel))
            {
                OldMove = LastMove;
            }
            AlmostLastMove = LastMove;
            LastMove = LastMove.NextMove;
            // [Loop Continue]
            goto J0x56;
        }
    }
    NewMove = GetFreeMove();
    // End:0xE8
    if(NewMove == none)
    {
        return;
    }
    NewMove.SetMoveFor(self, DeltaTime, newAccel, DoubleClickMove);
    bDoubleJump = false;
    ProcessMove(NewMove.Delta, NewMove.Acceleration, NewMove.DoubleClickMove, DeltaRot);
    // End:0x307
    if((PendingMove != none) && PendingMove.CanCombineWith(NewMove, Pawn, MaxResponseTime))
    {
        Pawn.SetLocation(PendingMove.GetStartLocation());
        Pawn.Velocity = PendingMove.StartVelocity;
        // End:0x205
        if(PendingMove.StartBase != Pawn.Base)
        {
            Pawn.SetBase(PendingMove.StartBase);
        }
        Pawn.Floor = PendingMove.StartFloor;
        NewMove.Delta += PendingMove.Delta;
        NewMove.SetInitialPosition(Pawn);
        // End:0x300
        if(LastMove == PendingMove)
        {
            // End:0x2A5
            if(SavedMoves == PendingMove)
            {
                SavedMoves.NextMove = FreeMoves;
                FreeMoves = SavedMoves;
                SavedMoves = none;                
            }
            else
            {
                PendingMove.NextMove = FreeMoves;
                FreeMoves = PendingMove;
                // End:0x2EC
                if(AlmostLastMove != none)
                {
                    AlmostLastMove.NextMove = none;
                    LastMove = AlmostLastMove;
                }
            }
            FreeMoves.Clear();
        }
        PendingMove = none;
    }
    // End:0x331
    if(Pawn != none)
    {
        Pawn.AutonomousPhysics(NewMove.Delta);        
    }
    else
    {
        AutonomousPhysics(DeltaTime);
    }
    NewMove.PostUpdate(self);
    // End:0x367
    if(SavedMoves == none)
    {
        SavedMoves = NewMove;        
    }
    else
    {
        LastMove.NextMove = NewMove;
    }
    // End:0x45C
    if(PendingMove == none)
    {
        // End:0x3E8
        if(((Player.CurrentNetSpeed > 10000) && WorldInfo.GRI != none) && WorldInfo.GRI.PRIArray.Length <= 10)
        {
            NetMoveDelta = 0.0110000;            
        }
        else
        {
            NetMoveDelta = FMax(0.0222000, (2.0000000 * WorldInfo.MoveRepSize) / float(Player.CurrentNetSpeed));
        }
        // End:0x45C
        if(((WorldInfo.TimeSeconds - ClientUpdateTime) * WorldInfo.TimeDilation) < NetMoveDelta)
        {
            PendingMove = NewMove;
            return;
        }
    }
    ClientUpdateTime = WorldInfo.TimeSeconds;
    ClientRoll = byte((Rotation.Roll >> 8) & 255);
    PawnRot = ((Pawn == none) ? Rotation : Pawn.Rotation);
    CallServerMove(NewMove, ((Pawn == none) ? Location : Pawn.Location), ClientRoll, ((PawnRot.Yaw & 65535) << 16) + (PawnRot.Pitch & 65535), OldMove);
    PendingMove = none;
    //return;    
}

reliable server function ServerApplyDoubleJumpVelocity(float DeltaTime)
{
    // End:0x1F
    if(int(Role) == int(ROLE_Authority))
    {
        ApplyDoubleJumpVelocity(DeltaTime);
    }
    //return;    
}

simulated function ApplyDoubleJumpVelocity(float DeltaTime)
{
    local Vector X, Y, Z;

    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerApplyDoubleJumpVelocity(DeltaTime);
    }
    // End:0x3F
    if(!IsInState('PlayerDoubleJumping'))
    {
        GotoState('PlayerDoubleJumping');
    }
    GetAxes(Rotation, X, Y, Z);
    // End:0xA1
    if(PlayerInput != none)
    {
        Pawn.Acceleration = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);        
    }
    else
    {
        Pawn.Acceleration = (X + Y) + vect(0.0000000, 0.0000000, 1.0000000);
    }
    Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
    Pawn.Velocity.Z = SkyPawn(Pawn).RocketPack.UpwardBoost;
    // End:0x153
    if(IsLocalPlayerController())
    {
        UpdateRotation(DeltaTime);
    }
    // End:0x193
    if(int(Role) < int(ROLE_Authority))
    {
        ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));        
    }
    else
    {
        ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
    }
    //return;    
}

reliable server function SetGlide(bool Glide)
{
    // End:0x2C
    if(SkyPawn(Pawn) != none)
    {
        SkyPawn(Pawn).bGliding = Glide;
    }
    //return;    
}

exec function Spectate()
{
    // End:0x28
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        GotoState('Spectating');
    }
    //return;    
}

function DecayBounty()
{
    local SkyGame_Struggle Game;

    Game = SkyGame_Struggle(WorldInfo.Game);
    // End:0x27
    if(Game == none)
    {
        return;
    }
    PlayerReplicationInfo.Score -= float(Game.BountyDecayIncrement);
    // End:0x92
    if(PlayerReplicationInfo.Score <= float(Game.MinBounty))
    {
        PlayerReplicationInfo.Score = float(Game.MinBounty);        
    }
    else
    {
        SetTimer(Game.BountyDecayTime, false, 'DecayBounty');
    }
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local int iDam, I;
    local SkyPawn pPawn;
    local SkyVehicle pVeh;

    pPawn = SkyPawn(Pawn);
    // End:0x50
    if(pPawn == none)
    {
        pVeh = SkyVehicle(Pawn);
        // End:0x50
        if(pVeh != none)
        {
            pPawn = SkyPawn(pVeh.Driver);
        }
    }
    // End:0x108
    if(pPawn != none)
    {
        I = 0;
        J0x62:

        // End:0x108 [Loop If]
        if(I < pPawn.DamageShake.Length)
        {
            // End:0xFE
            if(DamageType == pPawn.DamageShake[I].DamageType)
            {
                ShakeCamera(pPawn.DamageShake[I].ViewShake);
                StartRumble(pPawn.DamageShake[I].Rumble);
                // [Explicit Break]
                goto J0x108;
            }
            ++I;
            // [Loop Continue]
            goto J0x62;
        }
    }
    J0x108:

    iDam = Clamp(Damage, 0, 250);
    // End:0x17B
    if((iDam > 0) || InGodMode())
    {
        ClientPlayTakeHitIB(HitLocation - Pawn.Location, byte(iDam), DamageType, ((InstigatedBy == none) ? none : InstigatedBy.Pawn));
    }
    //return;    
}

unreliable client simulated function ClientPlayTakeHitIB(Vector HitLoc, byte Damage, class<DamageType> DamageType, optional Pawn InstigatedBy)
{
    DamageShake(int(Damage));
    HitLoc += Pawn.Location;
    // End:0x78
    if((SkyHUD(myHUD) != none) && InstigatedBy != Pawn)
    {
        SkyHUD(myHUD).DisplayHit(HitLoc, int(Damage), DamageType, InstigatedBy);
    }
    //return;    
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    // End:0x52
    if(((int(WorldInfo.NetMode) != int(NM_Standalone)) && myHUD != none) && !myHUD.bShowScores)
    {
        myHUD.ShowScores();
    }
    super(SkyPlayerControllerBase).ClientGameEnded(EndGameFocus, bIsWinner);
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    // End:0x34
    if((myHUD != none) && myHUD.bShowScores)
    {
        myHUD.ShowScores();
    }
    // End:0x5E
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).HudIdleTime = 0.0000000;
    }
    super(SkyPlayerControllerBase).ClientRestart(NewPawn);
    //return;    
}

unreliable server function ServerThrustEject()
{
    local SkyAirVehicle CurrentSkyAirVehicle;
    local SkyAirVehicle_RocketPackThrust CurrentSkyAirVehicle_RPT;

    // End:0x1F
    if((LockoutExitRocketpackTimerAfterTurnAroundVolume > 0.0000000) || bLockedEject == true)
    {
        return;
    }
    CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
    CurrentSkyAirVehicle_RPT = SkyAirVehicle_RocketPackThrust(Pawn);
    // End:0x74
    if(CurrentSkyAirVehicle.IsPerformingSpecialManeuver() || int(CurrentSkyAirVehicle.AirVehicleState) != int(3))
    {
        return;
    }
    // End:0x81
    if(CurrentSkyAirVehicle_RPT == none)
    {
        return;
    }
    CurrentSkyAirVehicle_RPT.DriverLeave(false);
    bLockedEject = true;
    SetTimer(0.5000000, false, 'EndLockedEject');
    //return;    
}

exec event ThrustEject()
{
    local SkyPawn SP;

    // End:0x0D
    if(ForceThrustCount > 0)
    {
        return;
    }
    // End:0x75
    if(Vehicle(Pawn) != none)
    {
        SP = SkyPawn(Vehicle(Pawn).Driver);
        // End:0x75
        if(SP != none)
        {
            // End:0x75
            if((SP.HijackTarget != none) || SP.JumpVehicleTarget != none)
            {
                return;
            }
        }
    }
    // End:0xA5
    if((SkyAirVehicle(Pawn) != none) && SkyAirVehicle(Pawn).NoExitFromCollision > float(0))
    {
        return;
    }
    // End:0xE4
    if(!bAlreadyEjecting && !bLockedEject)
    {
        // End:0xDA
        if(SP != none)
        {
            SP.bHijackingFromVehicle = false;
        }
        ServerThrustEject();
    }
    //return;    
}

exec event ToggleHover()
{
    local SkyAirVehicle CurrentSkyAirVehicle;

    CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
    // End:0xBE
    if(((((CurrentSkyAirVehicle != none) && CurrentSkyAirVehicle.bCanHover == true) && SkyAirVehicle_RocketPackThrust(Pawn) == none) && CurrentSkyAirVehicle.IsPerformingSpecialManeuver() == false) && int(CurrentSkyAirVehicle.AirVehicleState) == int(3))
    {
        SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering = !SkyVehicleSim_CrimsonAircraft(CurrentSkyAirVehicle.SimObj).bIsHovering;
    }
    //return;    
}

function StartWantToLeave()
{
    bWantToLeave = true;
    bWantsThrustAfterExit = false;
    SetTimer(2.0000000, false, 'StopWantToLeave');
    //return;    
}

event StopWantToLeave()
{
    ClearTimer('StopWantToLeave');
    bWantToLeave = false;
    //return;    
}

event UnPossess()
{
    super(SkyPlayerControllerBase).UnPossess();
    StopWantToLeave();
    //return;    
}

exec function FOV(float F)
{
    // End:0x27
    if(SkyCamera(PlayerCamera) != none)
    {
        SkyCamera(PlayerCamera).bUseDebugFOV = true;
    }
    super(PlayerController).FOV(F);
    //return;    
}

exec function NearestTargetCamOn()
{
    local SkyPawn SP;
    local SkyAirVehicle SAV;

    SP = SkyPawn(Pawn);
    SAV = SkyAirVehicle(Pawn);
    // End:0x79
    if((SP == none) || SP.IsHijacking() == false)
    {
        // End:0x79
        if((SAV == none) || SAV.CurrentActiveSpecialManeuver == 'None')
        {
            bNearestTargetCam = true;
        }
    }
    //return;    
}

event TurnNearestTargetCamOff()
{
    NearestTargetCamOff();
    //return;    
}

exec function NearestTargetCamOff()
{
    local SkyAirVehicle pSAV;

    pSAV = SkyAirVehicle(Pawn);
    // End:0x50
    if((pSAV != none) && pSAV.CurrentActiveSpecialManeuver != 'None')
    {
        SetTimer(0.1500000, false, 'NearestTargetCamOff');        
    }
    else
    {
        bNearestTargetCam = false;
    }
    //return;    
}

// Export USkyPlayerController::execFindNearestTarget(FFrame&, void* const)
native function Pawn FindNearestTarget();

exec function FreeLookCamOn()
{
    local SkyPawn SP;
    local SkyAirVehicle SAV;

    SP = SkyPawn(Pawn);
    SAV = SkyAirVehicle(Pawn);
    // End:0x79
    if((SP == none) || SP.IsHijacking() == false)
    {
        // End:0x79
        if((SAV == none) || SAV.CurrentActiveSpecialManeuver == 'None')
        {
            bFreeLookCam = true;
        }
    }
    //return;    
}

exec function FreeLookCamOff()
{
    local SkyAirVehicle pSAV;

    pSAV = SkyAirVehicle(Pawn);
    // End:0x50
    if((pSAV != none) && pSAV.CurrentActiveSpecialManeuver != 'None')
    {
        SetTimer(0.1500000, false, 'FreeLookCamOff');        
    }
    else
    {
        bFreeLookCam = false;
    }
    //return;    
}

exec function QuickLookCamOn(int Dir)
{
    local SkyPawn SP;
    local SkyAirVehicle SAV;

    SP = SkyPawn(Pawn);
    SAV = SkyAirVehicle(Pawn);
    // End:0x32
    if(int(QuickLookCam) != int(0))
    {
        return;
    }
    // End:0x90
    if((SP == none) || SP.IsHijacking() == false)
    {
        // End:0x90
        if((SAV == none) || SAV.CurrentActiveSpecialManeuver == 'None')
        {
            QuickLookCam = byte(Dir);
        }
    }
    //return;    
}

exec function QuickLookCamOff(int Dir)
{
    local SkyAirVehicle pSAV;

    pSAV = SkyAirVehicle(Pawn);
    // End:0x30
    if((Dir != 0) && int(QuickLookCam) != Dir)
    {
        return;
    }
    // End:0x70
    if((pSAV != none) && pSAV.CurrentActiveSpecialManeuver != 'None')
    {
        SetTimer(0.1500000, false, 'QuickLookCamOff');        
    }
    else
    {
        QuickLookCam = 0;
    }
    //return;    
}

exec event SetSprint(int TurnOn, int Mode)
{
    local SkyPawn SP;

    bAttemptingSprint = TurnOn == 1;
    LastAttemptedSprintMode = Mode;
    SP = SkyPawn(Pawn);
    // End:0x37
    if(SP == none)
    {
        return;
    }
    // End:0x80
    if(Mode == 0)
    {
        // End:0x69
        if(TurnOn == 1)
        {
            SP.StartSprint(Mode);            
        }
        else
        {
            SP.StopSprint();
        }        
    }
    else
    {
        // End:0xD2
        if(TurnOn == 1)
        {
            // End:0xB9
            if(SP.IsSprinting())
            {
                SP.StopSprint();                
            }
            else
            {
                SP.StartSprint(Mode);
            }
        }
    }
    //return;    
}

exec function OrbitCamChangeDist(int Direction)
{
    local SkyCamera pCam;

    pCam = SkyCamera(PlayerCamera);
    // End:0x6E
    if(pCam != none)
    {
        // End:0x3B
        if(Direction == 1)
        {
            pCam.OrbitCamState = 2;            
        }
        else
        {
            // End:0x5C
            if(Direction == 2)
            {
                pCam.OrbitCamState = 1;                
            }
            else
            {
                pCam.OrbitCamState = 0;
            }
        }
    }
    //return;    
}

// Export USkyPlayerController::execToggleMusic(FFrame&, void* const)
native exec function ToggleMusic();

// Export USkyPlayerController::execToggleSound(FFrame&, void* const)
native exec function ToggleSound();

// Export USkyPlayerController::execEnableSound(FFrame&, void* const)
native exec function EnableSound(bool bEnable);

simulated function OnTeleport(SeqAct_Teleport Action)
{
    // End:0x4D
    if(SkyVehicle(Pawn) == none)
    {
        super(Controller).OnTeleport(Action);
        SetPhysics(0);
        Pawn.SetPhysics(1);
        SkyPawn(Pawn).SetFallState(5);        
    }
    else
    {
        // End:0x86
        if(MostRecentVehiclePossessed != none)
        {
            // End:0x86
            if(MostRecentVehiclePossessed.Driver != none)
            {
                MostRecentVehiclePossessed.OnTeleport(Action);
            }
        }
    }
    //return;    
}

function OnPossess(SeqAct_Possess inAction)
{
    local Pawn OldPawn;
    local Vehicle V;

    V = Vehicle(Pawn);
    // End:0x45
    if(inAction.bTryToLeaveVehicle && V != none)
    {
        V.DriverLeave(true);
    }
    // End:0x184
    if(inAction.PawnToPossess != none)
    {
        V = Vehicle(inAction.PawnToPossess);
        // End:0x128
        if((Pawn != none) && V != none)
        {
            // End:0xCB
            if((inAction.bSkipVehicleEnter == true) && SkyPawn(Pawn) != none)
            {
                SkyPawn(Pawn).OverrideVehicleEnter = true;
            }
            V.TryToDrive(Pawn);
            // End:0x125
            if((SkyPawn(Pawn) != none) && SkyPawn(Pawn).OverrideVehicleEnter)
            {
                SkyPawn(Pawn).OverrideVehicleEnter = false;
            }            
        }
        else
        {
            OldPawn = Pawn;
            UnPossess();
            Possess(inAction.PawnToPossess, false);
            // End:0x184
            if(inAction.bKillOldPawn && OldPawn != none)
            {
                OldPawn.Destroy();
            }
        }
    }
    //return;    
}

simulated function ShowCineDebug(Canvas pCanvas)
{
    local int I, LineSpacing;
    local SkyVehicle SV;

    LineSpacing = 13;
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((CinematicModeRefCount == 0) ? 255 : 0), ((CinematicModeRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("CinematicModeRefCount = " $ string(CinematicModeRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((PlayerHiddenRefCount == 0) ? 255 : 0), ((PlayerHiddenRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("HidePlayerRefCount = " $ string(PlayerHiddenRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((AllPawnsHiddenRefCount == 0) ? 255 : 0), ((AllPawnsHiddenRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("HideAllPawnsRefCount = " $ string(AllPawnsHiddenRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((GodModeGameplayRefCount == 0) ? 255 : 0), ((GodModeGameplayRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("EnableGodModeRefCount = " $ string(GodModeGameplayRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((Pawn.MatineeCharacterRefCount == 0) ? 255 : 0), ((Pawn.MatineeCharacterRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("MatineePlayerRefCount = " $ string(Pawn.MatineeCharacterRefCount));
    SV = SkyVehicle(Pawn);
    // End:0x437
    if(SV != none)
    {
        pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
        pCanvas.SetDrawColor(255, ((SV.IsDormentRefCount == 0) ? 255 : 0), ((SV.IsDormentRefCount == 0) ? 255 : 0));
        pCanvas.DrawTextClipped("MatineePlayerRefCount (Vehicle) = " $ string(SV.IsDormentRefCount));
    }
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((CinemaDisableInputMoveRefCount == 0) ? 255 : 0), ((CinemaDisableInputMoveRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("DisableMovementRefCount = " $ string(CinemaDisableInputMoveRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((CinemaDisableInputLookRefCount == 0) ? 255 : 0), ((CinemaDisableInputLookRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("DisableTurningRefCount = " $ string(CinemaDisableInputLookRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((WorldInfo.Game.CinematicPauseRefCount == 0) ? 255 : 0), ((WorldInfo.Game.CinematicPauseRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("PauseWorldRefCount = " $ string(WorldInfo.Game.CinematicPauseRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((WorldInfo.Game.CinematicDisableInputRefCount == 0) ? 255 : 0), ((WorldInfo.Game.CinematicDisableInputRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("DisableInputRefCount = " $ string(WorldInfo.Game.CinematicDisableInputRefCount));
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(LineSpacing));
    pCanvas.SetDrawColor(255, ((myHUD.HideHUDRefCount == 0) ? 255 : 0), ((myHUD.HideHUDRefCount == 0) ? 255 : 0));
    pCanvas.DrawTextClipped("HideHUDRefCount = " $ string(myHUD.HideHUDRefCount));
    I = 0;
    J0x7FC:

    // End:0x950 [Loop If]
    if(I < WorldInfo.Game.AllowedCinematicInputCommands.Length)
    {
        pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
        pCanvas.SetDrawColor(255, ((WorldInfo.Game.AllowedCinematicInputCommands[I].RefCount == 0) ? 255 : 0), ((WorldInfo.Game.AllowedCinematicInputCommands[I].RefCount == 0) ? 255 : 0));
        pCanvas.DrawTextClipped((WorldInfo.Game.AllowedCinematicInputCommands[I].CommandString $ " = ") $ string(WorldInfo.Game.AllowedCinematicInputCommands[I].RefCount));
        ++I;
        // [Loop Continue]
        goto J0x7FC;
    }
    I = 0;
    J0x957:

    // End:0xA47 [Loop If]
    if(I < AudioCategoryRefCounts.Length)
    {
        pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
        pCanvas.SetDrawColor(255, ((AudioCategoryRefCounts[I].RefCount == 0) ? 255 : 0), ((AudioCategoryRefCounts[I].RefCount == 0) ? 255 : 0));
        pCanvas.DrawTextClipped((AudioCategoryRefCounts[I].category $ " = ") $ string(AudioCategoryRefCounts[I].RefCount));
        ++I;
        // [Loop Continue]
        goto J0x957;
    }
    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
    //return;    
}

simulated function ShowCameraDebug(Canvas pCanvas)
{
    local SkyCamera pCam;
    local SkyCameraTree pCamTree;
    local array<SkyCameraNode> NodeList;

    // End:0x141
    if(PlayerCamera != none)
    {
        pCam = SkyCamera(PlayerCamera);
        // End:0x141
        if(pCam != none)
        {
            pCamTree = pCam.CamTreeRoot;
            // End:0x141
            if(pCamTree != none)
            {
                pCanvas.SetPos(400.0000000, 100.0000000);
                DrawCameraNode(pCamTree, pCanvas, NodeList);
                DrawDebugSphere(pCam.CameraInfo.CamSafeLoc, 3.0000000, 6, 255, 255, 255);
                DrawDebugSphere(pCam.CameraInfo.ConstraintPos, 2.9000000, 6, 0, 255, 0);
                // End:0x113
                if(pCamTree.bAlignController)
                {
                    DrawDebugCoordinateSystem(pCam.CameraInfo.ConstraintPos, Rotation, 50.0000000);
                }
                DrawDebugSphere(pCam.CameraInfo.SafeLocConstraintPos, 2.8000000, 6, 0, 0, 255);
            }
        }
    }
    //return;    
}

simulated function DrawCameraNode(SkyCameraNode pNode, Canvas pCanvas, out array<SkyCameraNode> NodeList)
{
    local SkyCameraNodeView pCamView;
    local SkyCameraNodeBlendListBase pBlendList;
    local SkyCameraTree pCamTree;
    local SkyCameraNodeBlendByYaw pBlendByYaw;
    local SkyCameraNodeBlendByPitch pBlendByPitch;
    local float fWidth, fHeight;
    local name NodeName;
    local int I;
    local string NodeWeightString;
    local int nDrawColor;
    local string BlendListText;
    local int nPrevX;
    local bool bIsFirstChild;

    I = NodeList.Length - 1;
    J0x0F:

    // End:0x3B [Loop If]
    if(I >= 0)
    {
        // End:0x31
        if(pNode == NodeList[I])
        {
            return;
        }
        --I;
        // [Loop Continue]
        goto J0x0F;
    }
    // End:0x8E
    if(pCanvas.CurY > float(pCanvas.SizeY - 35))
    {
        pCanvas.SetPos(pCanvas.CurX + float(80), 5.0000000);
    }
    NodeList.Insert(NodeList.Length, 1);
    NodeList[NodeList.Length - 1] = pNode;
    pCamView = SkyCameraNodeView(pNode);
    pBlendByYaw = SkyCameraNodeBlendByYaw(pNode);
    pBlendByPitch = SkyCameraNodeBlendByPitch(pNode);
    pBlendList = SkyCameraNodeBlendListBase(pNode);
    pCamTree = SkyCameraTree(pNode);
    // End:0x7A8
    if((pNode != none) && pNode.NodeTotalWeight > 0.0000100)
    {
        NodeWeightString = TruncateFraction(string(pNode.NodeTotalWeight), 2);
        NodeName = ((pNode.NodeName != 'None') ? pNode.NodeName : pNode.Class.Name);
        // End:0x2D8
        if(pCamTree != none)
        {
            pCanvas.SetDrawColor(255, 255, 255);
            pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
            pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
            pCanvas.SetPos(pCanvas.CurX + float(10), pCanvas.CurY);
            I = 0;
            J0x249:

            // End:0x2A1 [Loop If]
            if(I < pCamTree.Children.Length)
            {
                DrawCameraNode(pCamTree.Children[I].CameraNode, pCanvas, NodeList);
                ++I;
                // [Loop Continue]
                goto J0x249;
            }
            pCanvas.SetPos(pCanvas.CurX - float(10), pCanvas.CurY);            
        }
        else
        {
            // End:0x676
            if(pBlendList != none)
            {
                nDrawColor = int(Lerp(150.0000000, 255.0000000, pNode.NodeTotalWeight));
                pCanvas.SetDrawColor(byte(nDrawColor), byte(nDrawColor), byte(nDrawColor));
                pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
                // End:0x3CE
                if((pBlendByYaw != none) || pBlendByPitch != none)
                {
                    BlendListText = ("[" $ (TruncateFraction(string(pBlendList.fCurrentContinuousBlendValue), 0))) $ " deg] ";                    
                }
                else
                {
                    BlendListText = "";
                }
                bIsFirstChild = true;
                BlendListText = BlendListText $ "(";
                I = 0;
                J0x3F5:

                // End:0x4CC [Loop If]
                if(I < pBlendList.Children.Length)
                {
                    // End:0x4C2
                    if(pBlendList.Children[I].Weight > 0.0000100)
                    {
                        // End:0x455
                        if(!bIsFirstChild)
                        {
                            BlendListText = BlendListText $ ", ";
                        }
                        bIsFirstChild = false;
                        BlendListText = ((BlendListText $ string(pBlendList.Children[I].Name)) $ ": ") $ (TruncateFraction(string(pBlendList.Children[I].Weight), 2));
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x3F5;
                }
                BlendListText = BlendListText $ ")";
                nPrevX = int(pCanvas.CurX);
                pCanvas.StrLen(string(NodeName) @ NodeWeightString, fWidth, fHeight);
                pCanvas.SetPos((pCanvas.CurX + fWidth) + float(5), pCanvas.CurY);
                pCanvas.SetDrawColor(200, 200, 200);
                pCanvas.DrawTextClipped(BlendListText);
                pCanvas.SetPos(float(nPrevX), pCanvas.CurY);
                pCanvas.SetPos(pCanvas.CurX + float(10), pCanvas.CurY);
                I = 0;
                J0x5E7:

                // End:0x63F [Loop If]
                if(I < pBlendList.Children.Length)
                {
                    DrawCameraNode(pBlendList.Children[I].CameraNode, pCanvas, NodeList);
                    ++I;
                    // [Loop Continue]
                    goto J0x5E7;
                }
                pCanvas.SetPos(pCanvas.CurX - float(10), pCanvas.CurY);                
            }
            else
            {
                // End:0x7A8
                if(pCamView != none)
                {
                    nDrawColor = int(Lerp(170.0000000, 255.0000000, pNode.NodeTotalWeight));
                    pCanvas.SetDrawColor(byte(nDrawColor), 0, 0);
                    pCanvas.SetPos(pCanvas.CurX, pCanvas.CurY + float(15));
                    pCanvas.DrawTextClipped(string(NodeName) @ NodeWeightString);
                    pCanvas.StrLen(string(NodeName), fWidth, fHeight);
                    pCanvas.SetPos(pCanvas.CurX - float(2), pCanvas.CurY - float(2));
                    pCanvas.DrawBox((fWidth * pNode.NodeTotalWeight) + float(6), fHeight + float(4));
                }
            }
        }
    }
    //return;    
}

function string TruncateFraction(string Src, int nNumDecimalPlaces)
{
    local string Whole, Fraction, Result;
    local int nDecimalPlace;

    Result = Src;
    nDecimalPlace = InStr(Result, ".");
    // End:0x87
    if(nDecimalPlace != -1)
    {
        Whole = Left(Result, nDecimalPlace);
        // End:0x7C
        if(nNumDecimalPlaces != 0)
        {
            Fraction = Mid(Result, nDecimalPlace + 1, nNumDecimalPlaces);
            Result = (Whole $ ".") $ Fraction;            
        }
        else
        {
            Result = Whole;
        }
    }
    return Result;
    //return ReturnValue;    
}

function string TruncateString(string Src, int nNumLetters)
{
    local string Result;

    Result = Src;
    // End:0x39
    if(Len(Src) > (nNumLetters + 3))
    {
        Result = Left(Result, nNumLetters) $ "...";
    }
    return Result;
    //return ReturnValue;    
}

reliable server function ServerAFK()
{
    // End:0x3D
    if(SkyPawn_MP(Pawn) != none)
    {
        SkyPawn_MP(Pawn).bAFK = !SkyPawn_MP(Pawn).bAFK;
    }
    //return;    
}

simulated exec function God()
{
    // End:0x1D
    if(SkyPawn_MP(Pawn) != none)
    {
        ServerAFK();        
    }
    else
    {
        // End:0x3C
        if(CheatManager != none)
        {
            CheatManager.God();
        }
    }
    //return;    
}

simulated function OnSetDisableThrust(SkySeqAct_SetDisableThrust inAction)
{
    ChangeDisableThrustCount(inAction.bDisableThrust, inAction.bFullReset);
    //return;    
}

simulated function ChangeDisableThrustCount(bool bDisable, optional bool bReset)
{
    // End:0x14
    if(bReset)
    {
        DisableThrustCount = 0;        
    }
    else
    {
        // End:0x27
        if(bDisable)
        {
            DisableThrustCount++;            
        }
        else
        {
            DisableThrustCount--;
        }
    }
    // End:0x40
    if(DisableThrustCount < 0)
    {
        DisableThrustCount = 0;
    }
    // End:0x67
    if((DisableThrustCount > 0) && SkyAirVehicle_RocketPackThrust(Pawn) != none)
    {
        ThrustEject();
    }
    //return;    
}

simulated function OnSetForceThrust(SkySeqAct_SetForceThrust inAction)
{
    ChangeForceThrustCount(inAction.bForceThrust, inAction.bFullReset);
    //return;    
}

simulated function ChangeForceThrustCount(bool bForce, optional bool bReset)
{
    // End:0x14
    if(bReset)
    {
        ForceThrustCount = 0;        
    }
    else
    {
        // End:0x27
        if(bForce)
        {
            ForceThrustCount++;            
        }
        else
        {
            ForceThrustCount--;
        }
    }
    // End:0x40
    if(ForceThrustCount < 0)
    {
        ForceThrustCount = 0;
    }
    //return;    
}

event SpawnPlayerCamera()
{
    // End:0x58
    if((CameraClass != none) && IsLocalPlayerController())
    {
        PlayerCamera = Spawn(CameraClass, self,,,, CameraTemplate);
        // End:0x58
        if(PlayerCamera != none)
        {
            PlayerCamera.InitializeFor(self);            
        }
    }
    //return;    
}

exec function StartHandoff()
{
    ServerStartHandoff();
    //return;    
}

reliable server function ServerStartHandoff()
{
    // End:0x87
    if(((SkyPawn(Pawn) != none) && SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon) != none) && SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon).HandoffPRI != none)
    {
        SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon).OfferHandoff();        
    }
    else
    {
        // End:0x100
        if(((SkyPlayerReplicationInfo(PlayerReplicationInfo) != none) && SkyPlayerReplicationInfo(PlayerReplicationInfo).OfferedHandoff != none) && SkyPlayerReplicationInfo(PlayerReplicationInfo).OfferedHandoff.HandoffPRI == PlayerReplicationInfo)
        {
            SkyPlayerReplicationInfo(PlayerReplicationInfo).OfferedHandoff.Handoff();
        }
    }
    //return;    
}

exec function StopHandoff()
{
    ServerStopHandoff();
    //return;    
}

reliable server function ServerStopHandoff()
{
    // End:0x84
    if(((SkyPawn(Pawn) != none) && SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon) != none) && SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon).HandoffPRI != none)
    {
        SkyHandoffItem(SkyPawn(Pawn).SecondaryWeapon).CancelHandoff();
    }
    //return;    
}

exec function ForceDisableCinematicMode()
{
    local SkyPawn SP;
    local SkyVehicle SV;
    local Pawn P;
    local int I;

    SP = SkyPawn(Pawn);
    SV = SkyVehicle(Pawn);
    CinematicModeRefCount = 0;
    PlayerHiddenRefCount = 0;
    // End:0x4A
    if(SP != none)
    {
        SP.SetHidden(false);
    }
    // End:0x78
    if((SV != none) && SkyAirVehicle_RocketPackThrust(SV) == none)
    {
        SV.SetHidden(false);
    }
    AllPawnsHiddenRefCount = 0;
    // End:0x10F
    foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
    {
        // End:0xC4
        if(SkyPawn(P) != none)
        {
            SkyPawn(P).MatineeCharacterRefCount = 0;
        }
        // End:0x10E
        if((P != none) && (SkyPawn(P) == none) || SkyPawn(P).MatineeCharacterRefCount == 0)
        {
            P.SetHidden(false);
        }        
    }    
    GodModeGameplayRefCount = 0;
    // End:0x17A
    if(Pawn != none)
    {
        // End:0x149
        if(Pawn.MatineeCharacterRefCount > 0)
        {
            Pawn.SetPhysics(SavedMatineePhysics);
        }
        Pawn.MatineeCharacterRefCount = 0;
        // End:0x17A
        if(SV != none)
        {
            SV.SetDorment(false);
        }
    }
    CinemaDisableInputMoveRefCount = 0;
    IgnoreMoveInput(false, true);
    CinemaDisableInputLookRefCount = 0;
    IgnoreLookInput(false, true);
    // End:0x22D
    if((WorldInfo != none) && WorldInfo.Game != none)
    {
        WorldInfo.Game.CinematicPauseRefCount = 0;
        WorldInfo.Game.CinematicDisableInputRefCount = 0;
        WorldInfo.Game.AllowedCinematicInputCommands.Remove(0, WorldInfo.Game.AllowedCinematicInputCommands.Length);
    }
    SetDisableCheckpointForCinematic(false, true);
    // End:0x256
    if(myHUD != none)
    {
        myHUD.HideHUDRefCount = 0;
    }
    I = 0;
    J0x25D:

    // End:0x29C [Loop If]
    if(I < AudioCategoryRefCounts.Length)
    {
        ResetCinematicCategory(AudioCategoryRefCounts[I].category, 0.1000000);
        ++I;
        // [Loop Continue]
        goto J0x25D;
    }
    AudioCategoryRefCounts.Remove(0, AudioCategoryRefCounts.Length);
    //return;    
}

function OnToggleCinematicMode(SeqAct_ToggleCinematicMode Action)
{
    local bool bNewCinematicMode;
    local array<Object> objVars;
    local Actor destAct;
    local SkyAirVehicle SAV;
    local SkyCamera Cam;
    local SkyPawn SP;
    local SkyCameraTree CamTree;
    local int I;

    Cam = SkyCamera(PlayerCamera);
    // End:0x22
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x42
    if(Action.InputLinkIdx == 0)
    {
        bNewCinematicMode = true;        
    }
    else
    {
        // End:0x5F
        if(Action.InputLinkIdx == 1)
        {
            bNewCinematicMode = false;
        }
    }
    I = 0;
    J0x66:

    // End:0xEC [Loop If]
    if(I < Action.CategoryVolumes.Length)
    {
        // End:0xE2
        if(Caps(Action.CategoryVolumes[I].Name) == "MASTERFADER")
        {
            Action.CategoryVolumes[I].Name = "MASTERFADER";
        }
        ++I;
        // [Loop Continue]
        goto J0x66;
    }
    SetCinematicMode(bNewCinematicMode, Action);
    // End:0x2D5
    if(Action.bMatineePlayer)
    {
        Action.GetObjectVars(objVars, "Destination");
        // End:0x154
        if(objVars.Length > 0)
        {
            destAct = Actor(objVars[0]);
        }
        // End:0x2D5
        if(destAct != none)
        {
            SAV = SkyAirVehicle(Pawn);
            // End:0x1AF
            if(SAV != none)
            {
                SAV.SetVehicleLocationAndRotationRB(destAct.Location, destAct.Rotation);                
            }
            else
            {
                // End:0x1F2
                if(Pawn != none)
                {
                    Pawn.SetLocation(destAct.Location);
                    Pawn.SetRotation(destAct.Rotation);
                }
            }
            SetRotation(destAct.Rotation);
            DesiredRotation = destAct.Rotation;
            CalcViewRotation = destAct.Rotation;
            // End:0x2D5
            if(Cam != none)
            {
                Cam.bSmoothBlendDisable = true;
                Cam.bCollInitialized = false;
                Cam.SetRotation(destAct.Rotation);
                Cam.DesiredRotation = destAct.Rotation;
                CamTree = Cam.CamTreeRoot;
                // End:0x2D5
                if(CamTree != none)
                {
                    CamTree.AutoPitchInfo.CurrState = 0;
                }
            }
        }
    }
    SP = SkyPawn(Pawn);
    // End:0x321
    if((SP == none) && SkyAirVehicle(Pawn) != none)
    {
        SP = SkyPawn(SkyAirVehicle(Pawn).Driver);
    }
    // End:0x38D
    if(SP != none)
    {
        SP.ActiveMaterialInstanceConstant.SetScalarParameterValue('Wind', 0.0000000);
        // End:0x38D
        if(SP.RocketPack != none)
        {
            SP.RocketPack.RocketPackPlayTag(3);
        }
    }
    // End:0x3D0
    if(Action.bResetCameraShake)
    {
        StopViewShaking();
        ShakeOffset = vect(0.0000000, 0.0000000, 0.0000000);
        ShakeRot = rot(0, 0, 0);
    }
    //return;    
}

// Export USkyPlayerController::execSetCinematicCategory(FFrame&, void* const)
native function SetCinematicCategory(string CatName, float Volume, float FadeTime);

// Export USkyPlayerController::execResetCinematicCategory(FFrame&, void* const)
native function ResetCinematicCategory(string CatName, float FadeTime);

function SetCinematicMode(bool bInCinematicMode, SeqAct_ToggleCinematicMode Action)
{
    local Pawn P;
    local SkyVehicle SV;
    local SkyPawn SP;
    local SkyAirVehicle SAV;
    local int I, J;
    local bool bFound, bShowingDebug;

    bShowingDebug = ((myHUD != none) && myHUD.bShowDebugInfo) && myHUD.ShouldDisplayDebug('cine');
    SAV = SkyAirVehicle(Pawn);
    // End:0xCE
    if((SAV != none) && Action.bDisableMovement)
    {
        // End:0x93
        if(bInCinematicMode)
        {
            ++SAV.MovementDisabledRefCount;            
        }
        else
        {
            SAV.MovementDisabledRefCount = ((Action.bForceDisable) ? 0 : Max(0, SAV.MovementDisabledRefCount - 1));
        }
    }
    // End:0xF1
    if(SkyPawn(Pawn) != none)
    {
        SP = SkyPawn(Pawn);        
    }
    else
    {
        // End:0x145
        if(SkyVehicle(Pawn) != none)
        {
            SV = SkyVehicle(Pawn);
            // End:0x145
            if(SkyPawn(SV.Driver) != none)
            {
                SP = SkyPawn(SV.Driver);
            }
        }
    }
    // End:0x840
    if(bInCinematicMode)
    {
        // End:0x1FA
        if((((Action.bDisableMovement || Action.bDisableInput) || Action.bHidePlayer) || Action.bHideAllPawns) || Action.bMatineePlayer)
        {
            // End:0x1FA
            if(SkyPawn(Pawn) != none)
            {
                // End:0x1FA
                if(SkyPawn(Pawn).IsReacting())
                {
                    SkyPawn(Pawn).AbortReaction();
                }
            }
        }
        // End:0x214
        if(Action.bEnableCinematicMode)
        {
            ++CinematicModeRefCount;
        }
        // End:0x266
        if(Action.bHidePlayer)
        {
            ++PlayerHiddenRefCount;
            // End:0x24A
            if(SP != none)
            {
                SP.SetHidden(true);
            }
            // End:0x266
            if(SV != none)
            {
                SV.SetHidden(true);
            }
        }
        // End:0x2EB
        if(Action.bHideAllPawns)
        {
            ++AllPawnsHiddenRefCount;
            // End:0x2EA
            foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
            {
                // End:0x2E9
                if((P != none) && (SkyPawn(P) == none) || SkyPawn(P).MatineeCharacterRefCount == 0)
                {
                    P.SetHidden(true);
                }                
            }            
        }
        // End:0x305
        if(Action.bEnableGodMode)
        {
            ++GodModeGameplayRefCount;
        }
        // End:0x37D
        if(Action.bMatineePlayer && Pawn != none)
        {
            ++MatineePlayerRefCount;
            // End:0x34C
            if(MatineePlayerRefCount == 1)
            {
                SavedMatineePhysics = Pawn.Physics;
            }
            ++Pawn.MatineeCharacterRefCount;
            // End:0x37D
            if(SV != none)
            {
                SV.SetDorment(true);
            }
        }
        // End:0x3A3
        if(Action.bDisableMovement)
        {
            ++CinemaDisableInputMoveRefCount;
            IgnoreMoveInput(true);
        }
        // End:0x3C9
        if(Action.bDisableTurning)
        {
            ++CinemaDisableInputLookRefCount;
            IgnoreLookInput(true);
        }
        // End:0x3FB
        if(Action.bDisableInput)
        {
            // End:0x3FB
            if(PlayerInput != none)
            {
                PlayerInput.ResetInputFromUC();
            }
        }
        // End:0x612
        if((WorldInfo != none) && WorldInfo.Game != none)
        {
            // End:0x44B
            if(Action.bPauseWorld)
            {
                ++WorldInfo.Game.CinematicPauseRefCount;
            }
            // End:0x479
            if(Action.bDisableInput)
            {
                ++WorldInfo.Game.CinematicDisableInputRefCount;
            }
            I = 0;
            J0x480:

            // End:0x612 [Loop If]
            if(I < Action.AllowedCinematicInputCommands.Length)
            {
                bFound = false;
                J = 0;
                J0x4A9:

                // End:0x552 [Loop If]
                if(J < WorldInfo.Game.AllowedCinematicInputCommands.Length)
                {
                    // End:0x548
                    if(WorldInfo.Game.AllowedCinematicInputCommands[J].CommandString == Action.AllowedCinematicInputCommands[I])
                    {
                        bFound = true;
                        ++WorldInfo.Game.AllowedCinematicInputCommands[J].RefCount;
                        // [Explicit Break]
                        goto J0x552;
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0x4A9;
                }
                J0x552:

                // End:0x608
                if(!bFound && Action.AllowedCinematicInputCommands[I] != "")
                {
                    J = WorldInfo.Game.AllowedCinematicInputCommands.Add(1);
                    WorldInfo.Game.AllowedCinematicInputCommands[J].CommandString = Action.AllowedCinematicInputCommands[I];
                    WorldInfo.Game.AllowedCinematicInputCommands[J].RefCount = 1;
                }
                ++I;
                // [Loop Continue]
                goto J0x480;
            }
        }
        StopRumble();
        // End:0x641
        if(Action.bDisableCheckpointing)
        {
            SetDisableCheckpointForCinematic(true, false, Action);
        }
        // End:0x672
        if(Action.bHideHUD && myHUD != none)
        {
            ++myHUD.HideHUDRefCount;
        }
        I = 0;
        J0x679:

        // End:0x83D [Loop If]
        if(I < Action.CategoryVolumes.Length)
        {
            bFound = false;
            J = 0;
            J0x6A2:

            // End:0x773 [Loop If]
            if(J < AudioCategoryRefCounts.Length)
            {
                // End:0x769
                if(AudioCategoryRefCounts[J].category == Action.CategoryVolumes[I].Name)
                {
                    bFound = true;
                    ++AudioCategoryRefCounts[J].RefCount;
                    SetCinematicCategory(Action.CategoryVolumes[I].Name, Action.CategoryVolumes[I].Volume, Action.CategoryFadeTime);
                    // [Explicit Break]
                    goto J0x773;
                }
                ++J;
                // [Loop Continue]
                goto J0x6A2;
            }
            J0x773:

            // End:0x833
            if(!bFound)
            {
                J = AudioCategoryRefCounts.Add(1);
                AudioCategoryRefCounts[J].category = Action.CategoryVolumes[I].Name;
                AudioCategoryRefCounts[J].RefCount = 1;
                SetCinematicCategory(Action.CategoryVolumes[I].Name, Action.CategoryVolumes[I].Volume, Action.CategoryFadeTime);
            }
            ++I;
            // [Loop Continue]
            goto J0x679;
        }        
    }
    else
    {
        // End:0x87A
        if(Action.bEnableCinematicMode)
        {
            CinematicModeRefCount = ((Action.bForceDisable) ? 0 : Max(0, CinematicModeRefCount - 1));
        }
        // End:0x918
        if(Action.bHidePlayer)
        {
            PlayerHiddenRefCount = ((Action.bForceDisable) ? 0 : Max(0, PlayerHiddenRefCount - 1));
            // End:0x8DD
            if((PlayerHiddenRefCount == 0) && SP != none)
            {
                SP.SetHidden(false);
            }
            // End:0x918
            if(((PlayerHiddenRefCount == 0) && SV != none) && SkyAirVehicle_RocketPackThrust(SV) == none)
            {
                SV.SetHidden(false);
            }
        }
        // End:0x9C8
        if(Action.bHideAllPawns)
        {
            AllPawnsHiddenRefCount = ((Action.bForceDisable) ? 0 : Max(0, AllPawnsHiddenRefCount - 1));
            // End:0x9C8
            if(AllPawnsHiddenRefCount == 0)
            {
                // End:0x9C7
                foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
                {
                    // End:0x9C6
                    if((P != none) && (SkyPawn(P) == none) || SkyPawn(P).MatineeCharacterRefCount == 0)
                    {
                        P.SetHidden(false);
                    }                    
                }                
            }
        }
        // End:0xA02
        if(Action.bEnableGodMode)
        {
            GodModeGameplayRefCount = ((Action.bForceDisable) ? 0 : Max(0, GodModeGameplayRefCount - 1));
        }
        // End:0xAA4
        if(Action.bMatineePlayer && Pawn != none)
        {
            Pawn.MatineeCharacterRefCount = ((Action.bForceDisable) ? 0 : Max(0, Pawn.MatineeCharacterRefCount - 1));
            // End:0xA84
            if(Pawn.MatineeCharacterRefCount == 0)
            {
                Pawn.SetPhysics(SavedMatineePhysics);
            }
            // End:0xAA4
            if(SV != none)
            {
                SV.SetDorment(false);
            }
        }
        // End:0xAF9
        if(Action.bDisableMovement)
        {
            CinemaDisableInputMoveRefCount = ((Action.bForceDisable) ? 0 : Max(0, CinemaDisableInputMoveRefCount - 1));
            IgnoreMoveInput(false, Action.bForceDisable);
        }
        // End:0xB4E
        if(Action.bDisableTurning)
        {
            CinemaDisableInputLookRefCount = ((Action.bForceDisable) ? 0 : Max(0, CinemaDisableInputLookRefCount - 1));
            IgnoreLookInput(false, Action.bForceDisable);
        }
        // End:0xD9E
        if((WorldInfo != none) && WorldInfo.Game != none)
        {
            // End:0xBD2
            if(Action.bPauseWorld)
            {
                WorldInfo.Game.CinematicPauseRefCount = ((Action.bForceDisable) ? 0 : Max(0, WorldInfo.Game.CinematicPauseRefCount - 1));
            }
            // End:0xC34
            if(Action.bDisableInput)
            {
                WorldInfo.Game.CinematicDisableInputRefCount = ((Action.bForceDisable) ? 0 : Max(0, WorldInfo.Game.CinematicDisableInputRefCount - 1));
            }
            I = 0;
            J0xC3B:

            // End:0xD9E [Loop If]
            if(I < Action.AllowedCinematicInputCommands.Length)
            {
                J = 0;
                J0xC5C:

                // End:0xD94 [Loop If]
                if(J < WorldInfo.Game.AllowedCinematicInputCommands.Length)
                {
                    // End:0xD8A
                    if(WorldInfo.Game.AllowedCinematicInputCommands[J].CommandString == Action.AllowedCinematicInputCommands[I])
                    {
                        WorldInfo.Game.AllowedCinematicInputCommands[J].RefCount = ((Action.bForceDisable) ? 0 : Max(0, WorldInfo.Game.AllowedCinematicInputCommands[J].RefCount - 1));
                        // End:0xD87
                        if(WorldInfo.Game.AllowedCinematicInputCommands[J].RefCount == 0)
                        {
                            WorldInfo.Game.AllowedCinematicInputCommands.Remove(J--, 1);
                        }
                        // [Explicit Break]
                        goto J0xD94;
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0xC5C;
                }
                J0xD94:

                ++I;
                // [Loop Continue]
                goto J0xC3B;
            }
        }
        // End:0xDD1
        if(Action.bDisableCheckpointing)
        {
            SetDisableCheckpointForCinematic(false, Action.bForceDisable, Action);
        }
        // End:0xE2C
        if(Action.bHideHUD && myHUD != none)
        {
            myHUD.HideHUDRefCount = ((Action.bForceDisable) ? 0 : Max(0, myHUD.HideHUDRefCount - 1));
        }
        I = 0;
        J0xE33:

        // End:0xF58 [Loop If]
        if(I < Action.CategoryVolumes.Length)
        {
            J = 0;
            J0xE54:

            // End:0xF4E [Loop If]
            if(J < AudioCategoryRefCounts.Length)
            {
                // End:0xF44
                if(AudioCategoryRefCounts[J].category == Action.CategoryVolumes[I].Name)
                {
                    AudioCategoryRefCounts[J].RefCount = ((Action.bForceDisable) ? 0 : Max(0, AudioCategoryRefCounts[J].RefCount - 1));
                    // End:0xF41
                    if(AudioCategoryRefCounts[J].RefCount == 0)
                    {
                        ResetCinematicCategory(AudioCategoryRefCounts[J].category, Action.CategoryFadeTime);
                        AudioCategoryRefCounts.Remove(J--, 1);
                    }
                    // [Explicit Break]
                    goto J0xF4E;
                }
                ++J;
                // [Loop Continue]
                goto J0xE54;
            }
            J0xF4E:

            ++I;
            // [Loop Continue]
            goto J0xE33;
        }
    }
    // End:0xFB7
    if(bShowingDebug)
    {
        I = 0;
        J0xF68:

        // End:0xF96 [Loop If]
        if(I < WorldInfo.Game.AllowedCinematicInputCommands.Length)
        {
            ++I;
            // [Loop Continue]
            goto J0xF68;
        }
        I = 0;
        J0xF9D:

        // End:0xFB7 [Loop If]
        if(I < AudioCategoryRefCounts.Length)
        {
            ++I;
            // [Loop Continue]
            goto J0xF9D;
        }
    }
    //return;    
}

// Export USkyPlayerController::execSetDisableCheckpointForCinematic(FFrame&, void* const)
native function SetDisableCheckpointForCinematic(bool bDisabled, optional bool bForceZero, optional SeqAct_ToggleCinematicMode CineAction);

// Export USkyPlayerController::execGetDisableCheckpointForCinematicRefCount(FFrame&, void* const)
native function int GetDisableCheckpointForCinematicRefCount();

// Export USkyPlayerController::execProjectileRequest(FFrame&, void* const)
unreliable client native simulated function ProjectileRequest(Vector Position, Vector Direction, class<Projectile> ProjectileClass, Pawn Instig, Actor Archetype);

reliable server event ToggleReadyToPlay()
{
    // End:0x2E
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.bReadyToPlay = !PlayerReplicationInfo.bReadyToPlay;
    }
    //return;    
}

reliable server event SetReadyToPlay(bool bReady)
{
    // End:0x22
    if(PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo.bReadyToPlay = bReady;
    }
    //return;    
}

reliable client simulated event AllPlayersReadyEvent(bool bReady)
{
    WorldInfo.TriggerEventClass(((bReady) ? Class'SeqEvent_AllPlayersReady' : Class'SeqEvent_AllPlayersNotReady'), self);
    //return;    
}

exec function StartTracing(name BoneName, optional byte Red, optional byte Green, optional byte Blue)
{
    local SkyPawn SP;
    local DebugTracingEntry Entry;

    SP = SkyPawn(ViewTarget);
    // End:0xBC
    if(SP != none)
    {
        Entry.BoneName = BoneName;
        Entry.LastLocation = SP.Location;
        Entry.Red = Red;
        Entry.Green = Green;
        Entry.Blue = Blue;
        StopTracing(BoneName);
        SP.DebugTracingEntries.AddItem(Entry);
    }
    //return;    
}

exec function StopTracing(name BoneName)
{
    local SkyPawn SP;
    local int I;

    SP = SkyPawn(ViewTarget);
    // End:0x89
    if(SP != none)
    {
        I = 0;
        J0x22:

        // End:0x89 [Loop If]
        if(I < SP.DebugTracingEntries.Length)
        {
            // End:0x7F
            if(BoneName == SP.DebugTracingEntries[I].BoneName)
            {
                SP.DebugTracingEntries.Remove(I, 1);
                // [Explicit Break]
                goto J0x89;
            }
            I++;
            // [Loop Continue]
            goto J0x22;
        }
    }
    J0x89:

    //return;    
}

exec function FlushTracing()
{
    FlushPersistentDebugLines();
    //return;    
}

exec function ToggleAIError()
{
    local SkyGame Game;

    Game = SkyGame(WorldInfo.Game);
    // End:0x48
    if(Game != none)
    {
        Game.bShowBehTreeError = !Game.bShowBehTreeError;
    }
    //return;    
}

exec function StartReaction(name Reaction)
{
    local SkyPawn SP;

    SP = SkyPawn(ViewTarget);
    // End:0x34
    if(SP != none)
    {
        SP.StartReaction(Reaction);
    }
    //return;    
}

exec function CoverDangle(bool bEnable)
{
    local SkyPawnCoverUser SPCU;

    SPCU = SkyPawnCoverUser(ViewTarget);
    // End:0x35
    if(SPCU != none)
    {
        SPCU.CoverDangleToggle(bEnable);
    }
    //return;    
}

// Export USkyPlayerController::execLoadCheckpoint(FFrame&, void* const)
native exec function LoadCheckpoint(string Filename);

exec function CheatButton(byte Type)
{
    //return;    
}

exec function SetCameraSmoothPercent(float NewVal, float NewLedgeLeapVal, float NewMantleVal, float NewValIncTime)
{
    local SkyCamera Cam;

    Cam = SkyCamera(PlayerCamera);
    // End:0x6F
    if(Cam != none)
    {
        Cam.SmoothPercentInCover = NewVal;
        Cam.SmoothPercentForLedgeLeap = NewLedgeLeapVal;
        Cam.SmoothPercentForVerticalMantle = NewMantleVal;
        Cam.SmoothPercentIncreaseTime = NewValIncTime;
    }
    //return;    
}

exec function SetMagnetismStrength(float NewVal, float NewValCover, float NewMin, float NewMinCover)
{
    m_fMagnetismStrengthPercent = NewVal;
    m_fMagnetismStrengthPercentCover = NewValCover;
    m_fMagnetismStrengthPercentMin = NewMin;
    m_fMagnetismStrengthPercentCoverMin = NewMinCover;
    //return;    
}

exec function SetMagnetismHoverValues(float NewVal, float NewMin)
{
    m_fMagnetismStrengthPercentHover = NewVal;
    m_fMagnetismStrengthPercentHoverMin = NewMin;
    //return;    
}

// Export USkyPlayerController::execGetStreamingLevelFromMovingLevel(FFrame&, void* const)
native function LevelStreaming GetStreamingLevelFromMovingLevel();

event bool ShouldPlayOnGroundAudio()
{
    local SkyPawn SP;
    local LevelStreaming LS;

    // End:0x12
    if(SkyAirVehicle(Pawn) != none)
    {
        return false;
    }
    SP = SkyPawn(Pawn);
    // End:0x76
    if(SP != none)
    {
        // End:0x49
        if(SP.IsFreefalling())
        {
            return false;            
        }
        else
        {
            // End:0x61
            if(SP.bIsRocketPacking)
            {
                return false;                
            }
            else
            {
                // End:0x76
                if(SP.bGoingIntervehicular)
                {
                    return false;
                }
            }
        }
    }
    // End:0xA2
    if((SkyVehicle_AAGun_Gatling(Pawn) != none) && SkyVehicle_AAGun_Gatling(Pawn).bIsOnAirship)
    {
        return false;
    }
    LS = GetStreamingLevelFromMovingLevel();
    // End:0xD6
    if((LS != none) && !LS.bUseOnGroundAudio)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event float GetAudioSlowmo()
{
    local SkyPawn SP;

    SP = SkyPawn(Pawn);
    // End:0x40
    if((SP != none) && SP.bIsHindered)
    {
        return SP.HinderedAudioSlowmo;
    }
    return 0.0000000;
    //return ReturnValue;    
}

function HijackFadeToBlack(float TimeUntilFadeToBlack, float TimeOfFadeToBlack, float TimeOfBlack, float TimeOfFadeFromBlack)
{
    FtB_TimeOfFadeToBlack = TimeOfFadeToBlack;
    FtB_TimeOfBlack = TimeOfBlack;
    FtB_TimeOfFadeFromBlack = TimeOfFadeFromBlack;
    FtB_InteractionOrVehicleExit = false;
    FtB_Hijack = true;
    FtB_SwappingAAGun = false;
    FtB_bActionOnFadeToBlackComplete = true;
    FtB_bInProgress = true;
    // End:0x6C
    if(TimeUntilFadeToBlack > float(0))
    {
        SetTimer(TimeUntilFadeToBlack, false, 'FadeToBlackStart');        
    }
    else
    {
        FadeToBlackStart();
    }
    //return;    
}

event InteractionFadeToBlack(float TimeUntilFadeToBlack, float TimeOfFadeToBlack, float TimeOfBlack, float TimeOfFadeFromBlack, bool bEndOnFadeToBlackComplete)
{
    FtB_TimeOfFadeToBlack = TimeOfFadeToBlack;
    FtB_TimeOfBlack = TimeOfBlack;
    FtB_TimeOfFadeFromBlack = TimeOfFadeFromBlack;
    FtB_InteractionOrVehicleExit = false;
    FtB_Hijack = false;
    FtB_SwappingAAGun = false;
    FtB_bActionOnFadeToBlackComplete = bEndOnFadeToBlackComplete;
    FtB_bInProgress = true;
    // End:0x71
    if(TimeUntilFadeToBlack > float(0))
    {
        SetTimer(TimeUntilFadeToBlack, false, 'FadeToBlackStart');        
    }
    else
    {
        FadeToBlackStart();
    }
    //return;    
}

function ExitVehicleFadeToBlack(float TimeUntilFadeToBlack, float TimeOfFadeToBlack, float TimeOfBlack, float TimeOfFadeFromBlack, bool bEndOnFadeToBlackComplete)
{
    FtB_TimeOfFadeToBlack = TimeOfFadeToBlack;
    FtB_TimeOfBlack = TimeOfBlack;
    FtB_TimeOfFadeFromBlack = TimeOfFadeFromBlack;
    FtB_InteractionOrVehicleExit = true;
    FtB_Hijack = false;
    FtB_SwappingAAGun = false;
    FtB_bActionOnFadeToBlackComplete = bEndOnFadeToBlackComplete;
    FtB_bInProgress = true;
    // End:0x71
    if(TimeUntilFadeToBlack > float(0))
    {
        SetTimer(TimeUntilFadeToBlack, false, 'FadeToBlackStart');        
    }
    else
    {
        FadeToBlackStart();
    }
    //return;    
}

function SwapAAGunFadeToBlack(float TimeUntilFadeToBlack, float TimeOfFadeToBlack, float TimeOfBlack, float TimeOfFadeFromBlack)
{
    FtB_TimeOfFadeToBlack = TimeOfFadeToBlack;
    FtB_TimeOfBlack = TimeOfBlack;
    FtB_TimeOfFadeFromBlack = TimeOfFadeFromBlack;
    FtB_InteractionOrVehicleExit = false;
    FtB_Hijack = false;
    FtB_SwappingAAGun = true;
    FtB_bActionOnFadeToBlackComplete = true;
    FtB_bInProgress = true;
    // End:0x6C
    if(TimeUntilFadeToBlack > float(0))
    {
        SetTimer(TimeUntilFadeToBlack, false, 'FadeToBlackStart');        
    }
    else
    {
        FadeToBlackStart();
    }
    //return;    
}

function OnFadeToBlack(SkySeqAct_FadeToBlack Action)
{
    // End:0x80
    if(Action.InputLinks[0].bHasImpulse)
    {
        FtB_TimeOfFadeToBlack = Action.FadeToBlackTime;
        FtB_TimeOfBlack = 100000.0000000;
        FtB_TimeOfFadeFromBlack = 0.0000000;
        FtB_InteractionOrVehicleExit = false;
        FtB_Hijack = false;
        FtB_SwappingAAGun = false;
        FtB_bActionOnFadeToBlackComplete = false;
        FtB_bInProgress = true;
        FadeToBlackStart();        
    }
    else
    {
        FtB_TimeOfFadeFromBlack = Action.FadeFromBlackTime;
        ClearTimer('FadeToBlackStartsFading');
        FadeToBlackStartsFading();
    }
    //return;    
}

function FadeToBlackStart()
{
    local Color FadeColor;

    // End:0x3A
    if(SkyCamera(PlayerCamera) != none)
    {
        SkyCamera(PlayerCamera).SetFadeToBlack(FadeColor, 0.0000000, FtB_TimeOfFadeToBlack, false, true);
    }
    // End:0x5D
    if(FtB_TimeOfFadeToBlack > float(0))
    {
        SetTimer(FtB_TimeOfFadeToBlack, false, 'FadeToBlackIsBlack');        
    }
    else
    {
        FadeToBlackIsBlack();
    }
    //return;    
}

function FadeToBlackIsBlack()
{
    local SkyPawn InteractingPawn;
    local SkyAirVehicle HijackTarget;
    local editinline SkeletalMeshComponent SkelMesh;
    local SkelControlBase curskelcontrol;

    FtB_TimeOfFadeToBlack = 0.0000000;
    // End:0x208
    if(FtB_bActionOnFadeToBlackComplete)
    {
        // End:0x138
        if(FtB_Hijack)
        {
            InteractingPawn = SkyPawn(Pawn);
            HijackTarget = SkyPawn(Pawn).HijackTarget;
            SkelMesh = SkeletalMeshComponent(InteractingPawn.CurrWeaponAttachment.Mesh);
            // End:0xAF
            if(SkelMesh != none)
            {
                curskelcontrol = SkelMesh.FindSkelControl('Scale');
                curskelcontrol.SetSkelControlStrength(0.0000000, 0.2000000);
            }
            InteractingPawn.OverrideVehicleEnter = true;
            HijackTarget.TryToDrive(InteractingPawn);
            InteractingPawn.OverrideVehicleEnter = false;
            HijackTarget.SavedAIController = none;
            InteractingPawn.EndHijacking(true);
            InteractingPawn.SetPhysics(0);
            HijackTarget.ForceFlying();            
        }
        else
        {
            // End:0x14E
            if(FtB_SwappingAAGun)
            {
                SwapAAGuns();                
            }
            else
            {
                // End:0x1EE
                if(!FtB_InteractionOrVehicleExit)
                {
                    // End:0x18B
                    if(SkyVehicle(Pawn) != none)
                    {
                        InteractingPawn = SkyPawn(SkyVehicle(Pawn).Driver);                        
                    }
                    else
                    {
                        InteractingPawn = SkyPawn(Pawn);
                    }
                    // End:0x1EB
                    if(InteractingPawn.IsInteracting() && InteractingPawn.bInstigatedInteraction)
                    {
                        SkyInteraction_VehicleInteraction(InteractingPawn.GetInteraction()).FadeFinished();
                    }                    
                }
                else
                {
                    SkyVehicle(Pawn).DriverLeave(true);
                }
            }
        }
    }
    // End:0x22B
    if(FtB_TimeOfBlack > float(0))
    {
        SetTimer(FtB_TimeOfBlack, false, 'FadeToBlackStartsFading');        
    }
    else
    {
        FadeToBlackStartsFading();
    }
    //return;    
}

function FadeToBlackStartsFading()
{
    local Color FadeColor;

    // End:0x3A
    if(SkyCamera(PlayerCamera) != none)
    {
        SkyCamera(PlayerCamera).SetFadeToBlack(FadeColor, 0.0000000, FtB_TimeOfFadeFromBlack, false, false);
    }
    // End:0x5D
    if(FtB_TimeOfFadeFromBlack > float(0))
    {
        SetTimer(FtB_TimeOfFadeFromBlack, false, 'FadeComplete');        
    }
    else
    {
        FadeComplete();
    }
    //return;    
}

function FadeComplete()
{
    FtB_bInProgress = false;
    // End:0x23
    if(bAudioLevelsLoweredOnDeath)
    {
        bAudioLevelsLoweredOnDeath = false;
        ResetAudioLevels();
    }
    //return;    
}

function OnSetObjectiveHealth(SkySeqAct_SetObjectiveHealth inAction)
{
    // End:0x96
    if(SkyHUD(myHUD) != none)
    {
        // End:0x5F
        if(inAction.Pawn != none)
        {
            SkyHUD(myHUD).SetHealthTrackPawn(inAction.Label, inAction.Pawn);            
        }
        else
        {
            SkyHUD(myHUD).SetHealthTrack(inAction.Label, inAction.Health);
        }
    }
    //return;    
}

function OnClearObjectiveHealth(SkySeqAct_ClearObjectiveHealth inAction)
{
    // End:0x38
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).ClearHealthTrack(inAction.Label);
    }
    //return;    
}

// Export USkyPlayerController::execPauseStepNative(FFrame&, void* const)
native function PauseStepNative(bool bStart);

exec function PauseStep(bool bStart)
{
    PauseStepNative(bStart);
    //return;    
}

// Export USkyPlayerController::execXeGammaGraphAddPoint(FFrame&, void* const)
native exec function XeGammaGraphAddPoint();

// Export USkyPlayerController::execXeGammaGraphRemovePoint(FFrame&, void* const)
native exec function XeGammaGraphRemovePoint();

// Export USkyPlayerController::execXeGammaPrevPoint(FFrame&, void* const)
native exec function XeGammaPrevPoint();

// Export USkyPlayerController::execXeGammaNextPoint(FFrame&, void* const)
native exec function XeGammaNextPoint();

// Export USkyPlayerController::execXeGammaUpdateStickInput(FFrame&, void* const)
native exec function XeGammaUpdateStickInput(float X, float Y);

exec event OpenTutorialScene(name tutorialID)
{
    Class'SkyHUD'.static.OpenPickupTutorial(tutorialID, self);
    //return;    
}

exec function TestTriggerTrophy(int trophyindex)
{
    Class'Engine.SkySeqAct_TrophyBookkeeping'.static.ExecTriggerTrophyEvent(trophyindex);
    //return;    
}

auto state PlayerWaiting
{Begin:

    PlayerReplicationInfo.bOnlySpectator = false;
    WorldInfo.Game.bRestartLevel = false;
    WorldInfo.Game.RestartPlayer(self);
    WorldInfo.Game.bRestartLevel = true;
    stop;            
}

state Dead
{
    reliable server function ServerRestartPlayer()
    {
        // End:0x3A
        if(bResettingPlayer)
        {
            super.ServerRestartPlayer();
            FtB_bInProgress = false;
            FtB_TimeOfFadeToBlack = 0.0000000;
            FtB_TimeOfBlack = 0.0000000;
            FtB_TimeOfFadeFromBlack = 0.0000000;
            return;
        }
        TriggerDeathLoadingScreen();
        // End:0xC5
        if(!WorldInfo.LoadCurrentCheckpoint())
        {
            // End:0xA9
            if(IsEditor() || int(WorldInfo.NetMode) != int(NM_Standalone))
            {
                super.ServerRestartPlayer();
                // End:0xA6
                if(Pawn == none)
                {
                    SetTimer(1.0000000, false, 'ServerRestartPlayer');
                }                
            }
            else
            {                
                ConsoleCommand("open " $ GetURLMap());
            }
        }
        FtB_bInProgress = false;
        FtB_TimeOfFadeToBlack = 0.0000000;
        FtB_TimeOfBlack = 0.0000000;
        FtB_TimeOfFadeFromBlack = 0.0000000;
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x34
        if((myHUD != none) && myHUD.bShowScores)
        {
            myHUD.ShowScores();
        }
        SetPhysics(0);
        super.EndState(NextStateName);
        SetBehindView(true);
        StopViewShaking();
        StopRumble();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local float RespawnTime;
        local SkyCamera sc;

        ClearTimer('FadeComplete');
        ClearTimer('FadeToBlackStartsFading');
        ClearTimer('FadeToBlackIsBlack');
        ClearTimer('FadeToBlackStart');
        sc = SkyCamera(PlayerCamera);
        RespawnTime = ((int(WorldInfo.NetMode) == int(NM_Standalone)) ? SP_RespawnTime : MP_RespawnTime);
        // End:0xE7
        if(sc != none)
        {
            RespawnTime += ((0.0100000 + FMax(0.0000000, sc.FadeToBlackDeathDelayTime + sc.FadeToBlackDeathDelayTimer)) + FMax(-RespawnTime, sc.CurFadeToBlackTime - sc.FadeToBlackTimer));
        }
        // End:0x120
        if((int(WorldInfo.NetMode) != int(NM_Standalone)) && myHUD != none)
        {
            myHUD.bShowScores = true;
        }
        // End:0x153
        if((Pawn != none) && Pawn.Controller == self)
        {
            Pawn.Controller = none;
        }
        Pawn = none;
        FOVAngle = DesiredFOV;
        Enemy = none;
        bFrozen = true;
        bPressedJump = false;
        bAlreadyEjecting = false;
        SkyPawn(Pawn).bWasShooting = false;
        SkyPawn(Pawn).StandShootRotToleranceCurrent = SkyPawn(Pawn).StandShootRotTolerance;
        FindGoodView();
        SetTimer(1.0000000, false);
        CleanOutSavedMoves();
        // End:0x24B
        if(!bResettingPlayer)
        {
            SetCinematicCategory("MASTERFADER", 0.0000000, 0.5000000);
            SetCinematicCategory("UI", 0.0000000, 0.5000000);
            SetCinematicCategory("ingame", 0.0000000, 0.5000000);
            bAudioLevelsLoweredOnDeath = true;
        }
        SetTimer(RespawnTime, false, 'ServerRestartPlayer');
        //return;        
    }
    stop;    
}

state PlayerWalking
{
    function UpdateSpeed()
    {
        local SkyPawn SP;
        local SkyPlayerInput SPI;
        local float curGroundSpeed, stickDZ;

        SP = SkyPawn(Pawn);
        // End:0x1D
        if(SP == none)
        {
            return;
        }
        SPI = SkyPlayerInput(PlayerInput);
        // End:0x3A
        if(SPI == none)
        {
            return;
        }
        // End:0x159
        if(!SP.IsParachuting() && SP.IsFreefalling())
        {
            // End:0x11E
            if(SP.PhysicsVolume != none)
            {
                // End:0xBE
                if(SPI.aFFSpeed < float(0))
                {
                    SP.SetTerminalVelocity(SP.TerminalVelocityBrake);                    
                }
                else
                {
                    // End:0xFB
                    if(SPI.aFFSpeed > float(0))
                    {
                        SP.SetTerminalVelocity(SP.TerminalVelocityDive);                        
                    }
                    else
                    {
                        SP.SetTerminalVelocity(SP.TerminalVelocity);
                    }
                }
            }
            curGroundSpeed = SP.FreefallSpeed;
            SP.SetAccelRate(SP.FreefallAccelRate);            
        }
        else
        {
            // End:0x1B0
            if(SP.IsFalling())
            {
                curGroundSpeed = SP.GetPawnGroundSpeed();
                SP.SetAccelRate(SP.JumpAccelRate);                
            }
            else
            {
                // End:0x271
                if(SP.IsSprinting())
                {
                    curGroundSpeed = SP.SprintSpeed;
                    // End:0x24B
                    if(VSizeSq(SP.Velocity) < Square(SkyPawn(SP.ObjectArchetype).GroundSpeed))
                    {
                        SP.SetAccelRate(SkyPawn(SP.ObjectArchetype).AccelRate);                        
                    }
                    else
                    {
                        SP.SetAccelRate(SP.SprintAccelRate);
                    }                    
                }
                else
                {
                    // End:0x2D2
                    if(SP.IsMelee())
                    {
                        curGroundSpeed = SP.MeleeSpeed;
                        SP.SetAccelRate(SkyPawn(SP.ObjectArchetype).AccelRate);                        
                    }
                    else
                    {
                        curGroundSpeed = SP.GetPawnGroundSpeed();
                        // End:0x333
                        if(!SP.bForceAccelRate)
                        {
                            SP.SetAccelRate(SkyPawn(SP.ObjectArchetype).AccelRate);
                        }
                    }
                }
            }
        }
        // End:0x469
        if(!SP.IsSprinting() && !SP.IsFalling())
        {
            stickDZ = Sqrt(Square(SPI.RawJoyRight) + Square(SPI.RawJoyUp));
            // End:0x3B0
            if(stickDZ >= StickDeadZoneMax)
            {
                stickDZ = 1.0000000;                
            }
            else
            {
                // End:0x3CD
                if(stickDZ <= StickDeadZoneMin)
                {
                    stickDZ = 0.0000000;                    
                }
                else
                {
                    stickDZ = stickDZ / StickDeadZoneMax;
                }
            }
            stickDZ = FClamp(stickDZ, StickDeadZoneMin, 1.0000000);
            // DebugMode: 0
            assert(stickDZ != 0.0000000);
            // DebugMode: 0
            assert(curGroundSpeed != 0.0000000);
            curGroundSpeed = stickDZ * curGroundSpeed;
            SP.GroundSpeed = curGroundSpeed;
            // End:0x466
            if(int(Role) < int(ROLE_Authority))
            {
                SetSPGroundSpeed(SP.GroundSpeed);
            }            
        }
        else
        {
            SP.GroundSpeed = curGroundSpeed;
            // End:0x4A7
            if(int(Role) < int(ROLE_Authority))
            {
                SetSPGroundSpeed(SP.GroundSpeed);
            }
        }
        // End:0x4D3
        if(SP.LastLevelCollisionDotProduct < float(0))
        {
            SP.LastLevelCollisionDotProduct = 0.0000000;
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z, newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;

        // End:0x1C
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            UpdateSpeed();
            GetAxes(Rotation, X, Y, Z);
            // End:0x90
            if(Pawn.IsSprinting() && SkyPlayerInput(PlayerInput) != none)
            {
                newAccel = X + (SkyPlayerInput(PlayerInput).aSprintSteering * Y);                
            }
            else
            {
                newAccel = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
            }
            newAccel = Normal(newAccel) * Pawn.AccelRate;
            // End:0x115
            if(PlayerInput != none)
            {
                SendStickInputToServer(PlayerInput.RawJoyUp, PlayerInput.RawJoyRight);
            }
            newAccel.Z = 0.0000000;
            // End:0x14F
            if(VSize(newAccel) < 1.0000000)
            {
                newAccel = vect(0.0000000, 0.0000000, 0.0000000);
            }
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            // End:0x1CB
            if(bPressedJump && Pawn.CannotJumpNow())
            {
                bPressedJump = false;
            }
            // End:0x204
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = false;
        }
        //return;        
    }
    stop;    
}

state PlayerBoosting extends PlayerWalking
{
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local SkyPawn SP;

        GetAxes(Rotation, X, Y, Z);
        Pawn.Acceleration = ((PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y)) + (PlayerInput.aUp * vect(0.0000000, 0.0000000, 1.0000000));
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
        // End:0xE8
        if(Pawn.Velocity.Z < float(0))
        {
            Pawn.Velocity.Z = 0.0000000;
        }
        // End:0x104
        if(DelayBeforeBoost > float(0))
        {
            DelayBeforeBoost -= DeltaTime;            
        }
        else
        {
            SP = SkyPawn(Pawn);
            // End:0x1F9
            if((SP != none) && SP.RocketPack != none)
            {
                Pawn.Velocity.Z = Pawn.Velocity.Z + (SP.RocketPack.UpwardBoostAccel * DeltaTime);
                // End:0x1F9
                if(Pawn.Velocity.Z > SP.RocketPack.UpwardBoost)
                {
                    Pawn.Velocity.Z = SP.RocketPack.UpwardBoost;
                }
            }
        }
        UpdateRotation(DeltaTime);
        // End:0x248
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        local SkyPawn SP;

        SP = SkyPawn(Pawn);
        // End:0xEA
        if((SP != none) && SP.RocketPack != none)
        {
            Pawn.AirControl = SP.RocketPack.BoostAirControl;
            Pawn.GroundSpeed = SP.RocketPack.BoostAirSpeed;
            // End:0xCB
            if(SP.RocketPack.bHasDoubleJump)
            {
                SP.RocketPack.bHasDoubleJump = false;
                DelayBeforeBoost = 0.0000000;                
            }
            else
            {
                DelayBeforeBoost = SP.RocketPack.DelayBeforeBoost;
            }
        }
        Pawn.SetPhysics(2);
        //return;        
    }

    event EndState(name NextStateName)
    {
        Pawn.AirControl = SkyPawn(Pawn.ObjectArchetype).AirControl;
        Pawn.GroundSpeed = SkyPawn(Pawn.ObjectArchetype).GroundSpeed;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state PlayerDoubleJumping extends PlayerWalking
{
    function PlayerMove(float DeltaTime)
    {
        // End:0x40
        if(!SkyPawn(Pawn).RocketPack.bHasDoubleJump)
        {
            SkyPawn(Pawn).GotoRocketPackGlide();            
        }
        else
        {
            ApplyDoubleJumpVelocity(DeltaTime);
            SkyPawn(Pawn).RocketPack.bHasDoubleJump = false;
        }
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        Pawn.AirControl = SkyPawn(Pawn).RocketPack.BoostAirControl;
        Pawn.GroundSpeed = SkyPawn(Pawn).RocketPack.BoostAirSpeed;
        Pawn.SetPhysics(2);
        //return;        
    }

    event EndState(name NextStateName)
    {
        Pawn.AirControl = SkyPawn(Pawn.ObjectArchetype).AirControl;
        Pawn.GroundSpeed = SkyPawn(Pawn.ObjectArchetype).GroundSpeed;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state PlayerGliding extends PlayerWalking
{
    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;

        GetAxes(Rotation, X, Y, Z);
        Pawn.Acceleration = (PlayerInput.aForward * X) + (PlayerInput.aStrafe * Y);
        Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
        UpdateRotation(DeltaTime);
        // End:0xD5
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));            
        }
        else
        {
            ProcessMove(DeltaTime, Pawn.Acceleration, 0, rot(0, 0, 0));
        }
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        local SkyPawn SP;

        SP = SkyPawn(Pawn);
        // End:0x66
        if(SP != none)
        {
            // End:0x66
            if((SP.HijackTarget == none) && SP.JumpVehicleTarget == none)
            {
                SP.PrimaryWSM.TryDraw();
            }
        }
        Pawn.AirControl = SkyPawn(Pawn).RocketPack.GlideAirControl;
        Pawn.GroundSpeed = SkyPawn(Pawn).RocketPack.GlideAirSpeed;
        Pawn.SetPhysics(2);
        SetGlide(true);
        //return;        
    }

    event EndState(name NextStateName)
    {
        // End:0x9A
        if(((Pawn != none) && Pawn.ObjectArchetype != none) && SkyPawn(Pawn.ObjectArchetype) != none)
        {
            Pawn.AirControl = SkyPawn(Pawn.ObjectArchetype).AirControl;
            Pawn.GroundSpeed = SkyPawn(Pawn.ObjectArchetype).GroundSpeed;
        }
        SetGlide(false);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state PlayerDriving
{
    function PlayerMove(float DeltaTime)
    {
        UpdateRotation(DeltaTime);
        ProcessDrive(PlayerInput.aUp, PlayerInput.RawJoyRight, PlayerInput.RawJoyUp, bPressedJump);
        // End:0xCD
        if(int(Role) < int(ROLE_Authority))
        {
            ServerDrive(PlayerInput.aUp, PlayerInput.RawJoyRight, PlayerInput.RawJoyUp, bPressedJump, ((Rotation.Yaw & 65535) << 16) + (Rotation.Pitch & 65535));
        }
        bPressedJump = false;
        //return;        
    }

    unreliable server function ServerUse()
    {
        local SkyVehicle CurrentSkyVehicle;
        local SkyAirVehicle CurrentSkyAirVehicle;
        local SkyPawn CurrentDriver;

        CurrentSkyVehicle = SkyVehicle(Pawn);
        // End:0x22
        if(SkyAirVehicle_RocketPackThrust(CurrentSkyVehicle) != none)
        {
            return;
        }
        // End:0x48
        if((Pawn != none) && Pawn.IsInteracting())
        {
            return;
        }
        // End:0x56
        if(bDisableVehicleExit == true)
        {
            return;
        }
        // End:0x1AA
        if(CurrentSkyVehicle != none)
        {
            CurrentSkyAirVehicle = SkyAirVehicle(Pawn);
            CurrentDriver = SkyPawn(CurrentSkyVehicle.Driver);
            // End:0xE9
            if((CurrentSkyAirVehicle != none) && CurrentSkyAirVehicle.IsPerformingSpecialManeuver() || (int(CurrentSkyAirVehicle.AirVehicleState) != int(3)) && int(CurrentSkyAirVehicle.AirVehicleState) != int(1))
            {
                return;
            }
            // End:0x17B
            if((CurrentSkyAirVehicle == none) || bWantToLeave || !CurrentSkyAirVehicle.bFlying)
            {
                // End:0x125
                if(FtB_TimeOfFadeToBlack > float(0))
                {
                    return;
                }
                StopWantToLeave();
                CurrentSkyVehicle.DriverLeave(false);
                TriggerEventClass(Class'SkySeqEvent_PlayerBailFromAnyAirplane', self);
                CurrentSkyVehicle.TriggerEventClass(Class'SkySeqEvent_PlayerBailFromAnyAirplane', Pawn);                
            }
            else
            {
                // End:0x1A7
                if((CurrentDriver == none) || CurrentDriver.ExitingVehicle == none)
                {
                    StartWantToLeave();
                }
            }            
        }
        else
        {
            super.ServerUse();
        }
        //return;        
    }
    stop;    
}
