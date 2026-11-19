class SkyAirVehicle_UFO extends SkyAirVehicle
    native
    config(Game);

var const deprecated MaterialInterface ChargeMaterial;
var() int ChargeMaterialIndex;
var transient MaterialInstanceConstant ChargeMaterialInstance;
var transient float ChargeEffectStartTime;
var const float InvalidStartTime;
var() name ChargeMaterialName;
var() float TurretResetSpeed;
var() float TurretIdleTimeMin;
var() float TurretIdleTimeMax;
var() float TurretIdleSpeedMin;
var() float TurretIdleSpeedMax;
var Rotator TurretIdleBaseRot;
var() Rotator TurretIdleDeltaRotMin;
var() Rotator TurretIdleDeltaRotMax;
var() float TurretStartSeekingTimeMin;
var() float TurretStartSeekingTimeMax;
var() float TurretSeekingSpeed;
var() float TurretChargeUpTime;
var() float TurretChargeDownTime;
var() float TurretFiringInterval;
var() int TurretFiringNumShots;
var transient int TurretFiringShotsFired;
var() ParticleSystem TurretFiringParticleSystem;
var() SoundCue TurretFiringSoundCue;
var() name TurretFiringSocket;
var(Sounds) SoundCue TurretChargingSoundCue;
var export editinline AudioComponent TurretChargingSoundComp;
var() ParticleSystem TurretChargingParticleSystem;
var() editconst export editinline AudioComponent TurretRotatingSound;
var() SkyProjectile TurretProjectileArchetype;
var() name TurretTargetSocket;
var() name TurretBone;
var() name TurretBoneParent;
var() int TurretFacingTolerance;
var transient Rotator TurretPreviousRotation;

// Export USkyAirVehicle_UFO::execSetCurrentActiveSpecialManeuver(FFrame&, void* const)
native function SetCurrentActiveSpecialManeuver(name NewMove);

// Export USkyAirVehicle_UFO::execGetTurretRotation(FFrame&, void* const)
native function bool GetTurretRotation(out Rotator TurretRotation);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(0.2000000, true, 'CheckHijacking');
    ChargeMaterialInstance = new (Outer) Class'Engine.MaterialInstanceConstant';
    ChargeMaterialInstance.SetParent(Mesh.GetMaterial(ChargeMaterialIndex));
    Mesh.SetMaterial(ChargeMaterialIndex, ChargeMaterialInstance);
    ChargeMaterialInstance.SetScalarParameterValue(ChargeMaterialName, 0.0000000);
    TurretChargingSoundComp.SoundCue = TurretChargingSoundCue;
    //return;    
}

function CheckHijacking()
{
    //return;    
}

function bool HijackCheck()
{
    local SkyBotControllerPilot pBot;

    pBot = SkyBotControllerPilot(Controller);
    return ((((IsBeingHijacked()) && !IsStalled()) && !IsPerformingSpecialManeuver()) && pBot != none) && (PotentialHijacker == none) || !PotentialHijacker.IsEndingHijack();
    //return ReturnValue;    
}

function TriggerTurretFiringFX()
{
    local Vector FXLocation;
    local Rotator FXRotation;
    local Emitter visualFX;
    local editinline AudioComponent audioFX;
    local SkyGameReplicationInfo GRI;

    // End:0x21
    if(TurretFiringSocket == 'None')
    {
        FXLocation = Location;        
    }
    else
    {
        Mesh.GetSocketWorldLocationAndRotation(TurretFiringSocket, FXLocation, FXRotation);
    }
    // End:0x120
    if(EffectIsRelevant(FXLocation, false))
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        // End:0xB6
        if(GRI.SOP != none)
        {
            visualFX = GRI.SOP.CreateEmitter(TurretFiringParticleSystem, self, FXLocation, FXRotation);            
        }
        else
        {
            visualFX = Spawn(Class'SkyEmitter', self,, FXLocation, FXRotation);
            // End:0x107
            if((visualFX != none) && TurretFiringParticleSystem != none)
            {
                visualFX.SetTemplate(TurretFiringParticleSystem, true);
            }
        }
        visualFX.SetBase(self,, Mesh, TurretBone);
    }
    audioFX = CreateAudioComponent(TurretFiringSoundCue, false, false);
    // End:0x19C
    if(audioFX != none)
    {
        audioFX.bUseOwnerLocation = false;
        audioFX.Location = FXLocation;
        audioFX.bAutoDestroy = true;
        audioFX.bStopWhenOwnerDestroyed = false;
        audioFX.Play();
    }
    //return;    
}

function TriggerTurretChargingFX()
{
    local Vector FXLocation;
    local Rotator FXRotation;
    local Emitter visualFX;
    local SkyGameReplicationInfo GRI;

    // End:0x21
    if(TurretFiringSocket == 'None')
    {
        FXLocation = Location;        
    }
    else
    {
        Mesh.GetSocketWorldLocationAndRotation(TurretFiringSocket, FXLocation, FXRotation);
    }
    // End:0x120
    if(EffectIsRelevant(FXLocation, false))
    {
        GRI = SkyGameReplicationInfo(WorldInfo.GRI);
        // End:0xB6
        if(GRI.SOP != none)
        {
            visualFX = GRI.SOP.CreateEmitter(TurretChargingParticleSystem, self, FXLocation, FXRotation);            
        }
        else
        {
            visualFX = Spawn(Class'SkyEmitter', self,, FXLocation, FXRotation);
            // End:0x107
            if((visualFX != none) && TurretChargingParticleSystem != none)
            {
                visualFX.SetTemplate(TurretChargingParticleSystem, true);
            }
        }
        visualFX.SetBase(self,, Mesh, TurretBone);
    }
    TurretChargingSoundComp.Play();
    //return;    
}

simulated function FireTurretProjectile()
{
    local SkyGameReplicationInfo GRI;
    local Projectile Shot;
    local Vector FiringLocation;
    local Rotator FiringRotation;

    FiringLocation = Location;
    FiringRotation = Rotation;
    // End:0x48
    if(TurretFiringSocket != 'None')
    {
        Mesh.GetSocketWorldLocationAndRotation(TurretFiringSocket, FiringLocation, FiringRotation);
    }
    GRI = SkyGameReplicationInfo(WorldInfo.GRI);
    // End:0xBA
    if(GRI.SOP != none)
    {
        Shot = GRI.SOP.CreateProjectile(self, TurretProjectileArchetype.Class, self, FiringLocation, FiringRotation, TurretProjectileArchetype);        
    }
    else
    {
        Shot = Spawn(TurretProjectileArchetype.Class,,, FiringLocation, FiringRotation, TurretProjectileArchetype);
    }
    // End:0x126
    if(Shot != none)
    {
        Shot.Init(Vector(FiringRotation));
        Shot.SetBase(self,, Mesh, TurretBoneParent);
    }
    //return;    
}

function bool AllTurretsFacingLastTargetLocation(optional int Tolerance)
{
    local int I;

    // End:0x1C
    if(Seats[1].TurretControllers.Length == 0)
    {
        return false;
    }
    I = 0;
    J0x23:

    // End:0x7D [Loop If]
    if(I < Seats[1].TurretControllers.Length)
    {
        // End:0x73
        if(!Seats[1].TurretControllers[I].IsFacingDesiredRotation(Tolerance))
        {
            return false;
        }
        ++I;
        // [Loop Continue]
        goto J0x23;
    }
    return true;
    //return ReturnValue;    
}

event bool AllTurretsFacing(Rotator Rot, optional int Tolerance)
{
    local int I;

    // End:0x1C
    if(Seats[1].TurretControllers.Length == 0)
    {
        return false;
    }
    I = 0;
    J0x23:

    // End:0x82 [Loop If]
    if(I < Seats[1].TurretControllers.Length)
    {
        // End:0x78
        if(!Seats[1].TurretControllers[I].IsFacingRotation(Rot, Tolerance))
        {
            return false;
        }
        ++I;
        // [Loop Continue]
        goto J0x23;
    }
    return true;
    //return ReturnValue;    
}

// Export USkyAirVehicle_UFO::execGetTurretTargetLocation(FFrame&, void* const)
native function bool GetTurretTargetLocation(out Vector TargetLoc);

// Export USkyAirVehicle_UFO::execGetTurretFiringSolution(FFrame&, void* const)
native function bool GetTurretFiringSolution(out Rotator targetRot);

// Export USkyAirVehicle_UFO::execSetDesiredTurretRotation(FFrame&, void* const)
native function SetDesiredTurretRotation(Rotator NewRot);

// Export USkyAirVehicle_UFO::execSetTurretRotationSpeed(FFrame&, void* const)
native function SetTurretRotationSpeed(float NewSpeed);

// Export USkyAirVehicle_UFO::execSetTurretRotationAndSpeed(FFrame&, void* const)
native function SetTurretRotationAndSpeed(Rotator NewRot, float NewSpeed);

function int GetClosestSeat(Pawn P)
{
    // End:0x15
    if(Seats.Length == 0)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

function SetStalled(bool bOn)
{
    super.SetStalled(bOn);
    // End:0x23
    if(bOn)
    {
        GotoState('Inactive');
    }
    // End:0x46
    if(StabilizerSkel != none)
    {
        StabilizerSkel.SetSkelControlActive(!bOn);
    }
    //return;    
}

// Export USkyAirVehicle_UFO::execVehicleSecondaryWeaponFired(FFrame&, void* const)
native simulated function VehicleSecondaryWeaponFired(bool bViaReplication, Vector HitLocation, int SeatIndex);

auto state Inactive
{
    function BeginState(name PrevStateName)
    {
        local Rotator zeroRot;

        SetTimer(0.2000000, true, 'CheckHijacking');
        // End:0x60
        if(!IsPerformingSpecialManeuver() && !IsBeingHijacked() || PotentialHijacker.IsEndingHijack())
        {
            SetTurretRotationAndSpeed(zeroRot, TurretResetSpeed);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('CheckHijacking');
        //return;        
    }

    function CheckHijacking()
    {
        // End:0x51
        if(((HijackCheck()) && Seats[1].TurretControllers.Length > 0) && !PotentialHijacker.GripDangleIsActive())
        {
            GotoState('Idle');
        }
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PrevStateName)
    {
        SetTimer(RandRange(TurretIdleTimeMin, TurretIdleTimeMax), false, 'LookAround');
        SetTimer(RandRange(TurretStartSeekingTimeMin, TurretStartSeekingTimeMax), false, 'StartSeeking');
        LookAround();
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetTurretRotationSpeed(TurretSeekingSpeed);
        ClearTimer('LookAround');
        ClearTimer('StartSeeking');
        //return;        
    }

    function LookAround()
    {
        SetTimer(RandRange(TurretIdleTimeMin, TurretIdleTimeMax), false, 'LookAround');
        //return;        
    }

    function StartSeeking()
    {
        GotoState('Seeking');
        //return;        
    }

    function CheckHijacking()
    {
        // End:0x1D
        if(!HijackCheck())
        {
            GotoState('Inactive');
        }
        //return;        
    }
    stop;    
}

state Seeking
{
    function BeginState(name PrevStateName)
    {
        local Rotator desiredRot;

        // End:0x49
        if(HijackCheck())
        {
            // End:0x33
            if(GetTurretFiringSolution(desiredRot))
            {
                SetTurretRotationAndSpeed(desiredRot, TurretSeekingSpeed);
            }
            SetTimer(0.2000000, true, 'CheckFacingTarget');            
        }
        else
        {
            GotoState('Inactive');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('CheckFacingTarget');
        //return;        
    }

    function CheckFacingTarget()
    {
        local Rotator desiredRot;

        // End:0x36
        if(!HijackCheck() || !GetTurretFiringSolution(desiredRot))
        {
            GotoState('Inactive');            
        }
        else
        {
            // End:0x94
            if(((AllTurretsFacing(desiredRot, TurretFacingTolerance)) && !PotentialHijacker.IsBeginningHijack()) && !PotentialHijacker.GripDangleIsActive())
            {
                GotoState('Charging');                
            }
            else
            {
                SetDesiredTurretRotation(desiredRot);
                SetTimer(0.2000000, true, 'CheckFacingTarget');
            }
        }
        //return;        
    }

    function CheckHijacking()
    {
        // End:0x1D
        if(!HijackCheck())
        {
            GotoState('Inactive');
        }
        //return;        
    }
    stop;    
}

state Charging
{
    function BeginState(name PrevStateName)
    {
        local Rotator desiredRot;

        // End:0x36
        if(!HijackCheck() || !GetTurretFiringSolution(desiredRot))
        {
            GotoState('Inactive');            
        }
        else
        {
            // End:0xB8
            if(((AllTurretsFacing(desiredRot, TurretFacingTolerance)) && !PotentialHijacker.IsBeginningHijack()) && !PotentialHijacker.GripDangleIsActive())
            {
                SetTimer(TurretChargeUpTime, false, 'StartFiring');
                TriggerTurretChargingFX();
                ChargeEffectStartTime = WorldInfo.TimeSeconds;                
            }
            else
            {
                GotoState('Seeking');
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('StartFiring');
        ChargeEffectStartTime = InvalidStartTime;
        // End:0x3E
        if(TurretChargingSoundComp.bWasPlaying)
        {
            TurretChargingSoundComp.Stop();
        }
        //return;        
    }

    function StartFiring()
    {
        GotoState('Firing');
        //return;        
    }

    function CheckHijacking()
    {
        // End:0x1D
        if(!HijackCheck())
        {
            GotoState('Inactive');
        }
        //return;        
    }
    stop;    
}

state Firing
{
    function BeginState(name PrevStateName)
    {
        TurretFiringShotsFired = 0;
        SetTimer(TurretFiringInterval, false, 'FireShot');
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('FireShot');
        //return;        
    }

    function FireShot()
    {
        CheckHijacking();
        ++TurretFiringShotsFired;
        FireTurretProjectile();
        TriggerTurretFiringFX();
        // End:0x45
        if(TurretFiringShotsFired == TurretFiringNumShots)
        {
            GotoState('Seeking');            
        }
        else
        {
            SetTimer(TurretFiringInterval, false, 'FireShot');
        }
        //return;        
    }

    function CheckHijacking()
    {
        // End:0x1D
        if(!HijackCheck())
        {
            GotoState('Inactive');
        }
        //return;        
    }
    stop;    
}
