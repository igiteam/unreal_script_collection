class SkyVehicle_AAGun_Gatling extends SkyVehicle
    native
    config(Game);

var SkelControlSingleBone TurretControl_Horizontal;
var SkelControlSingleBone TurretControl_FPHorizontal;
var deprecated SkelControlSingleBone TurretControl_Vertical;
var deprecated SkelControlSingleBone TurretControl_Barrel;
var SkelControlSingleBone TurretControl_UpsideDown;
var SkelControlSingleBone TurretControl_FPUpsideDown;
var repnotify Rotator TurretRotation;
var float ReturnSpeed;
var Rotator DeltaTurretRot;
var export editinline AudioComponent RotateHorizSound;
var export editinline AudioComponent RotateVertSound;
var(TurretController) SkyAITurret TurretControllerArchetype;
var(Health) bool bDriverProtectedByAAGun;
var(Hijack) bool bFadeToBlackAAGunSwap;
var() bool bUpsideDown;
var bool bSwappingAAGuns;
var() bool bIsOnAirship;
var() bool bUseGroundRadarRanges;
var(Effects) bool bUseFirstPersonMeshForMuzzleFlashPlacement;
var(Hijack) float AAGunSwap_TimeUntilFadeToBlack;
var(Hijack) float AAGunSwap_TimeOfFadeToBlack;
var(Hijack) float AAGunSwap_TimeOfBlack;
var(Hijack) float AAGunSwap_TimeOfFadeFromBlack;
var SkySeqAct_CapitalShipGunBattery GunBattery;
var() Actor RadarActor;
var array<Actor> AssociatedSoundActors;
var() Surface HUDImage;
var(Health) SoundCue LowHealthSoundCue;
var export editinline AudioComponent LowHealthAudioComponent;
var(Health) float LowHealthWarningThreshold;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner
        TurretRotation;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x1D
    if(VarName == 'TurretRotation')
    {
        UpdateRotation();
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated function PostBeginPlay()
{
    local Controller NewController;

    super.PostBeginPlay();
    SetPhysics(0);
    TurretControl_Horizontal = SkelControlSingleBone(Mesh.FindSkelControl('sc_horiz_pivot'));
    TurretControl_UpsideDown = SkelControlSingleBone(Mesh.FindSkelControl('upside_down'));
    // End:0xA4
    if(bIsFirstPersonVehicle)
    {
        TurretControl_FPHorizontal = SkelControlSingleBone(FirstPersonMesh.FindSkelControl('sc_horiz_pivot'));
        TurretControl_FPUpsideDown = SkelControlSingleBone(FirstPersonMesh.FindSkelControl('upside_down'));
    }
    // End:0xFD
    if(TurretControllerArchetype != none)
    {
        NewController = Spawn(TurretControllerArchetype.Class, self,, Location, Rotation, TurretControllerArchetype);
        // End:0xFD
        if(NewController != none)
        {
            NewController.Possess(self, true);
        }
    }
    //return;    
}

simulated function DrivingStatusChanged()
{
    super.DrivingStatusChanged();
    bBlocksNavigation = bDriving;
    //return;    
}

simulated function bool CanEnterVehicle(Pawn P)
{
    // End:0x12
    if(SkyPlayerController(Controller) != none)
    {
        return false;
    }
    return super.CanEnterVehicle(P);
    //return ReturnValue;    
}

simulated function bool DriverEnter(Pawn P)
{
    local Weapon Inv;
    local int I;
    local AmbientSound AmbSound;
    local SkyAmbientSoundPointToPoint AmbPoint;

    // End:0x281
    if(super.DriverEnter(P))
    {
        // End:0xF1
        if(PlayerController(Controller) != none)
        {
            // End:0x65
            if(SkyHUD(PlayerController(Controller).myHUD) != none)
            {
                SkyHUD(PlayerController(Controller).myHUD).UpdateAAGunHUD();
            }
            // End:0xF1
            if(((Seats.Length > 0) && Seats[0].Gun != none) && Seats[0].Gun.MaterialEffectManager != none)
            {
                Seats[0].Gun.CauseHeatingEffect();
                Seats[0].Gun.StopHeatingEffect();
            }
        }
        // End:0x123
        foreach InvManager.InventoryActors(Class'Engine.Weapon', Inv)
        {
            Inv.Activate();            
        }        
        // End:0x23B
        if(SkyPlayerController(Controller) != none)
        {
            P.SetHidden(true);
            // End:0x162
            if(TurretControl_UpsideDown != none)
            {
                TurretControl_UpsideDown.BoneRotationSpace = 0;
            }
            // End:0x17F
            if(TurretControl_FPUpsideDown != none)
            {
                TurretControl_FPUpsideDown.BoneRotationSpace = 0;
            }
            I = 0;
            J0x186:

            // End:0x238 [Loop If]
            if(I < AssociatedSoundActors.Length)
            {
                AmbSound = AmbientSound(AssociatedSoundActors[I]);
                // End:0x1E2
                if(AmbSound != none)
                {
                    AmbSound.AudioComponent.SetFloatParameter('InVehicle', 1.0000000);
                    // [Explicit Continue]
                    goto J0x22E;
                }
                AmbPoint = SkyAmbientSoundPointToPoint(AssociatedSoundActors[I]);
                // End:0x22E
                if(AmbPoint != none)
                {
                    AmbPoint.Sound.SetFloatParameter('InVehicle', 1.0000000);
                    // [Explicit Continue]
                }
                J0x22E:

                ++I;
                // [Loop Continue]
                goto J0x186;
            }            
        }
        else
        {
            // End:0x258
            if(TurretControl_UpsideDown != none)
            {
                TurretControl_UpsideDown.BoneRotationSpace = 4;
            }
            // End:0x275
            if(TurretControl_FPUpsideDown != none)
            {
                TurretControl_FPUpsideDown.BoneRotationSpace = 4;
            }
        }
        FillForcedFirstPersonMeshTextures();
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event bool DriverLeave(bool bForceLeave)
{
    local bool Result;
    local Pawn OldDriver;
    local int I;
    local AmbientSound AmbSound;
    local SkyAmbientSoundPointToPoint AmbPoint;

    ClearForcedFirstPersonMeshTextures();
    // End:0x38
    if(LowHealthAudioComponent.bWasPlaying && bForceLeave)
    {
        LowHealthAudioComponent.Stop();
    }
    // End:0x91
    if((PlayerController(Controller) != none) && SkyHUD(PlayerController(Controller).myHUD) != none)
    {
        SkyHUD(PlayerController(Controller).myHUD).HideAAGunHUD();
    }
    OldDriver = Driver;
    Result = super.DriverLeave(bForceLeave);
    // End:0x176
    if(((bForceLeave && AirToAAGunInteractor != none) && AirToAAGunInteractor.DockedVehicle != none) && !bSwappingAAGuns)
    {
        AirToAAGunInteractor.DockedVehicle.TryToDrive(OldDriver);
        AirToAAGunInteractor.DockedVehicle.bFlying = true;
        AirToAAGunInteractor.DockedVehicle.CloseCockpit(true);
        AirToAAGunInteractor.DockedVehicle.Takeoff();
        AirToAAGunInteractor.DockedVehicle = none;
    }
    bSwappingAAGuns = false;
    I = 0;
    J0x185:

    // End:0x237 [Loop If]
    if(I < AssociatedSoundActors.Length)
    {
        AmbSound = AmbientSound(AssociatedSoundActors[I]);
        // End:0x1E1
        if(AmbSound != none)
        {
            AmbSound.AudioComponent.SetFloatParameter('InVehicle', 0.0000000);
            // [Explicit Continue]
            goto J0x22D;
        }
        AmbPoint = SkyAmbientSoundPointToPoint(AssociatedSoundActors[I]);
        // End:0x22D
        if(AmbPoint != none)
        {
            AmbPoint.Sound.SetFloatParameter('InVehicle', 0.0000000);
            // [Explicit Continue]
        }
        J0x22D:

        ++I;
        // [Loop Continue]
        goto J0x185;
    }
    // End:0x28B
    if(Result)
    {
        // End:0x25D
        if(TurretControl_UpsideDown != none)
        {
            TurretControl_UpsideDown.BoneRotationSpace = 4;
        }
        // End:0x27A
        if(TurretControl_FPUpsideDown != none)
        {
            TurretControl_FPUpsideDown.BoneRotationSpace = 4;
        }
        OldDriver.SetHidden(false);
    }
    return Result;
    //return ReturnValue;    
}

simulated event bool FinishedReturning()
{
    return DriverLeave(false);
    //return ReturnValue;    
}

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

simulated function EntryAnnouncement(Controller C)
{
    //return;    
}

// Export USkyVehicle_AAGun_Gatling::execGetAdjustedAimFor(FFrame&, void* const)
native simulated function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc);

reliable server function ServerUpdateRotation(Rotator TurretRot)
{
    TurretRotation = TurretRot;
    UpdateRotation();
    //return;    
}

event AIUpdateRotation()
{
    UpdateRotation();
    //return;    
}

// Export USkyVehicle_AAGun_Gatling::execUpdateTurretSkelControls(FFrame&, void* const)
native function UpdateTurretSkelControls();

simulated function UpdateRotation()
{
    local SkySkelControl_TurretConstrained TurretControl, FPTurretControl;

    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerUpdateRotation(TurretRotation);
    }
    TurretControl = SkySkelControl_TurretConstrained(TurretControl_Horizontal);
    FPTurretControl = SkySkelControl_TurretConstrained(TurretControl_FPHorizontal);
    // End:0x121
    if(TurretControl_Horizontal != none)
    {
        // End:0xAC
        if((TurretControl != none) && TurretControl.bInvertYaw)
        {
            TurretControl_Horizontal.BoneRotation.Yaw = -TurretRotation.Yaw - Rotation.Yaw;            
        }
        else
        {
            TurretControl_Horizontal.BoneRotation.Yaw = TurretRotation.Yaw - Rotation.Yaw;
        }
        TurretControl_Horizontal.BoneRotation.Pitch = 0;
        TurretControl_Horizontal.BoneRotation.Roll = 0;
    }
    // End:0x1CB
    if(TurretControl_FPHorizontal != none)
    {
        // End:0x18E
        if((FPTurretControl != none) && FPTurretControl.bInvertYaw)
        {
            TurretControl_FPHorizontal.BoneRotation.Yaw = -TurretRotation.Yaw - Rotation.Yaw;            
        }
        else
        {
            TurretControl_FPHorizontal.BoneRotation.Yaw = TurretRotation.Yaw - Rotation.Yaw;
        }
    }
    ForceWeaponRotation(0, TurretRotation);
    UpdateTurretSkelControls();
    //return;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    DeltaTurretRot = out_ViewRotation - TurretRotation;
    TurretRotation = out_ViewRotation;
    // End:0x90
    if((((MovingLevel != none) || DeltaTurretRot.Yaw != 0) || DeltaTurretRot.Pitch != 0) || DeltaTurretRot.Roll != 0)
    {
        UpdateRotation();
    }
    // End:0xFC
    if(RotateHorizSound != none)
    {
        // End:0xD9
        if(DeltaTurretRot.Yaw != 0)
        {
            // End:0xD6
            if(!RotateHorizSound.bWasPlaying)
            {
                RotateHorizSound.Play();
            }            
        }
        else
        {
            // End:0xFC
            if(RotateHorizSound.bWasPlaying)
            {
                RotateHorizSound.Stop();
            }
        }
    }
    // End:0x168
    if(RotateVertSound != none)
    {
        // End:0x145
        if(DeltaTurretRot.Pitch != 0)
        {
            // End:0x142
            if(!RotateVertSound.bWasPlaying)
            {
                RotateVertSound.Play();
            }            
        }
        else
        {
            // End:0x168
            if(RotateVertSound.bWasPlaying)
            {
                RotateVertSound.Stop();
            }
        }
    }
    //return;    
}

event Rotator GetWeaponRotation()
{
    return TurretRotation;
    //return ReturnValue;    
}

// Export USkyVehicle_AAGun_Gatling::execTakeDamage(FFrame&, void* const)
native simulated function TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

// Export USkyVehicle_AAGun_Gatling::execGetWeaponAim(FFrame&, void* const)
native function Rotator GetWeaponAim(SkyVehicleWeapon VWeapon);

simulated function OnSetRadarActor(SkySeqAct_SetRadarActor inAction)
{
    RadarActor = inAction.RadarActor;
    //return;    
}

// Export USkyVehicle_AAGun_Gatling::execReducedDamageByDifficulty(FFrame&, void* const)
native function int ReducedDamageByDifficulty(int Damage);

// Export USkyVehicle_AAGun_Gatling::execFillForcedFirstPersonMeshTextures(FFrame&, void* const)
native function FillForcedFirstPersonMeshTextures();

// Export USkyVehicle_AAGun_Gatling::execClearForcedFirstPersonMeshTextures(FFrame&, void* const)
native function ClearForcedFirstPersonMeshTextures();

function NotifyVehicleFactoryOfDeath()
{
    //return;    
}

simulated event bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x23
    if(LowHealthAudioComponent.bWasPlaying)
    {
        LowHealthAudioComponent.Stop();
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}
