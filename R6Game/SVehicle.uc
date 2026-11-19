class SVehicle extends Vehicle
    abstract
    native
    config(Game)
    placeable
    hidecategories(lighting);

struct VehicleState
{
    var RigidBodyState RBState;
    var byte ServerBrake;
    var byte ServerGas;
    var byte ServerGear;
    var byte ServerSteering;
    var byte ServerRise;
    var bool bServerHandbrake;
    var int ServerViewPitch;
    var int ServerViewYaw;

    structdefaultproperties
    {
        RBState=(Position=(X=0.0000000,Y=0.0000000,Z=0.0000000),Quaternion=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000),LinVel=(X=0.0000000,Y=0.0000000,Z=0.0000000),AngVel=(X=0.0000000,Y=0.0000000,Z=0.0000000),bNewData=0)
        ServerBrake=0
        ServerGas=0
        ServerGear=0
        ServerSteering=0
        ServerRise=0
        bServerHandbrake=false
        ServerViewPitch=0
        ServerViewYaw=0
    }
};

var() noclear const export editinline SVehicleSimBase SimObj;
var() export editinline array<export editinline SVehicleWheel> Wheels;
var() Vector COMOffset;
var() Vector InertiaTensorMultiplier;
var(UprightConstraint) bool bStayUpright;
var const bool bVehicleOnGround;
var const bool bIsInverted;
var const bool bChassisTouchingGround;
var const bool bWasChassisTouchingGroundLastTick;
var bool bCanFlip;
var bool bFlipRight;
var bool bIsUprighting;
var bool bOutputHandbrake;
var(UprightConstraint) float StayUprightRollResistAngle;
var(UprightConstraint) float StayUprightPitchResistAngle;
var(UprightConstraint) float StayUprightStiffness;
var(UprightConstraint) float StayUprightDamping;
var export editinline RB_StayUprightSetup StayUprightConstraintSetup;
var export editinline RB_ConstraintInstance StayUprightConstraintInstance;
var() float MaxSpeed;
var(Uprighting) float UprightLiftStrength;
var(Uprighting) float UprightTorqueStrength;
var(Uprighting) float UprightTime;
var float UprightStartTime;
var(Sounds) const editconst export editinline AudioComponent EngineSound;
var(Sounds) const editconst export editinline AudioComponent SquealSound;
var(Sounds) const editconst export editinline AudioComponent CollideSound;
var(Sounds) const editconst export editinline AudioComponent EnterVehicleSound;
var(Sounds) const editconst export editinline AudioComponent ExitVehicleSound;
var float PrevForwardVel;
var(Sounds) const float CollisionAccel;
var(Sounds) const float CollisionIntervalSecs;
var(Sounds) const float SquealThreshold;
var(Sounds) const float EngineStartOffsetSecs;
var(Sounds) const float EngineStopOffsetSecs;
var float LastCollisionSoundTime;
var float OutputBrake;
var float OutputGas;
var int OutputGear;
var float OutputSteering;
var float OutputRise;
var float ForwardVel;
var int NumPoweredWheels;
var() Vector BaseOffset;
var() float CamDist;
var int DriverViewPitch;
var int DriverViewYaw;
var native const VehicleState VState;
var native const float AngErrorAccumulator;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        VState;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x23
    if(EngineSound != none)
    {
        EngineSound.bShouldRemainActiveIfDropped = true;
    }
    return;
}

simulated function Destroyed()
{
    Destroyed();
    StopVehicleSounds();
    return;
}

simulated function StopVehicleSounds()
{
    // End:0x1B
    if(EngineSound != none)
    {
        EngineSound.Stop();
    }
    // End:0x36
    if(SquealSound != none)
    {
        SquealSound.Stop();
    }
    return;
}

// Export USVehicle::execInitVehicleRagdoll(FFrame&, void* const)
native function InitVehicleRagdoll(SkeletalMesh RagdollMesh, PhysicsAsset RagdollPhysAsset, Vector ActorMove);

event Collision(float DeltaForwardSpeed)
{
    CollideSound.Play();
    return;
}

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector pos, HitLocation, HitNormal;

    GetActorEyesViewPoint(out_CamLoc, out_CamRot);
    out_CamLoc += BaseOffset;
    pos = out_CamLoc - (Vector(out_CamRot) * CamDist);
    // End:0x80
    if(Trace(HitLocation, HitNormal, pos, out_CamLoc, false, vect(0.0000000, 0.0000000, 0.0000000)) != none)
    {
        out_CamLoc = HitLocation + (HitNormal * float(2));        
    }
    else
    {
        out_CamLoc = pos;
    }
    return true;
    return;
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    return 'Default';
    return;
}

function bool TryToDrive(Pawn P)
{
    // End:0x3B
    if(bIsInverted && bWasChassisTouchingGroundLastTick)
    {
        // End:0x39
        if(bCanFlip)
        {
            bIsUprighting = true;
            UprightStartTime = WorldInfo.TimeSeconds;
        }
        return false;
    }
    return TryToDrive(P);
    return;
}

simulated function NotifyTeamChanged()
{
    NotifyTeamChanged();
    // End:0x1D
    if(PlayerReplicationInfo != none)
    {
        EntryAnnouncement(none);        
    }
    else
    {
        DriverLeft();
    }
    return;
}

simulated function StartEngineSound()
{
    // End:0x1B
    if(EngineSound != none)
    {
        EngineSound.Play();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    return;
}

simulated function StartEngineSoundTimed()
{
    // End:0x2B
    if(EngineStartOffsetSecs > 0.0000000)
    {
        ClearTimer('StopEngineSound');
        SetTimer(EngineStartOffsetSecs, false, 'StartEngineSound');        
    }
    else
    {
        StartEngineSound();
    }
    return;
}

simulated function StopEngineSound()
{
    // End:0x1B
    if(EngineSound != none)
    {
        EngineSound.Stop();
    }
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    return;
}

simulated function StopEngineSoundTimed()
{
    // End:0x2B
    if(EngineStopOffsetSecs > 0.0000000)
    {
        ClearTimer('StartEngineSound');
        SetTimer(EngineStopOffsetSecs, false, 'StopEngineSound');        
    }
    else
    {
        StopEngineSound();
    }
    return;
}

simulated function DrivingStatusChanged()
{
    // End:0x49
    if(bDriving)
    {
        // End:0x24
        if(ExitVehicleSound != none)
        {
            ExitVehicleSound.Stop();
        }
        // End:0x3F
        if(EnterVehicleSound != none)
        {
            EnterVehicleSound.Play();
        }
        StartEngineSoundTimed();        
    }
    else
    {
        // End:0x64
        if(EnterVehicleSound != none)
        {
            EnterVehicleSound.Stop();
        }
        // End:0x7F
        if(ExitVehicleSound != none)
        {
            ExitVehicleSound.Play();
        }
        StopEngineSoundTimed();
    }
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int I;

    DisplayDebug(HUD, out_YL, out_YPos);
    GetSVehicleDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, byte(255), 0);
    I = 0;
    J0x4A:

    // End:0xB9 [Loop If]
    if(I < DebugInfo.Length)
    {
        HUD.Canvas.__NFUN_465__("  " @ DebugInfo[I]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        I++;
        // [Loop Continue]
        goto J0x4A;
    }
    DisplayWheelsDebug(HUD, out_YL);
    return;
}

simulated function DisplayWheelsDebug(HUD HUD, float YL)
{
    local int I;
    local Vector WorldLoc, ScreenLoc, X, Y, Z, EndPoint,
	    ScreenEndPoint;

    local Color SaveColor;

    SaveColor = HUD.Canvas.DrawColor;
    I = 0;
    J0x24:

    // End:0x549 [Loop If]
    if(I < Wheels.Length)
    {
        GetAxes(Rotation, X, Y, Z);
        WorldLoc = Location + (Wheels[I].WheelPosition >> Rotation);
        ScreenLoc = HUD.Canvas.Project(WorldLoc);
        // End:0x53F
        if((((ScreenLoc.X >= float(0)) && ScreenLoc.X < HUD.Canvas.ClipX) && ScreenLoc.Y >= float(0)) && ScreenLoc.Y < HUD.Canvas.ClipY)
        {
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y);
            HUD.Canvas.__NFUN_465__("Force " $ string(Wheels[I].ContactForce));
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - (float(1) * YL));
            HUD.Canvas.__NFUN_465__("SR " $ string(Wheels[I].LongSlipRatio));
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - (float(2) * YL));
            HUD.Canvas.__NFUN_465__(((("SA " $ string(Wheels[I].LatSlipAngle * 57.2957800)) $ " (") $ string(Wheels[I].LatSlipAngle)) $ ")");
            HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - (float(3) * YL));
            HUD.Canvas.__NFUN_465__("Torque " $ string(Wheels[I].MotorTorque));
            HUD.Canvas.DrawColor = HUD.RedColor;
            EndPoint = (WorldLoc + ((Wheels[I].LongImpulse * float(100)) * Wheels[I].LongDirection)) - (Wheels[I].WheelRadius * Z);
            ScreenEndPoint = HUD.Canvas.Project(EndPoint);
            DrawDebugLine(WorldLoc - (Wheels[I].WheelRadius * Z), EndPoint, byte(255), 0, 0);
            HUD.Canvas.SetPos(ScreenEndPoint.X, ScreenEndPoint.Y);
            HUD.Canvas.__NFUN_465__(string(Wheels[I].LongImpulse));
            HUD.Canvas.DrawColor = HUD.GreenColor;
            EndPoint = (WorldLoc + ((Wheels[I].LatImpulse * float(100)) * Wheels[I].LatDirection)) - (Wheels[I].WheelRadius * Z);
            ScreenEndPoint = HUD.Canvas.Project(EndPoint);
            DrawDebugLine(WorldLoc - (Wheels[I].WheelRadius * Z), EndPoint, 0, byte(255), 0);
            HUD.Canvas.SetPos(ScreenEndPoint.X, ScreenEndPoint.Y);
            HUD.Canvas.__NFUN_465__(string(Wheels[I].LatImpulse));
        }
        I++;
        // [Loop Continue]
        goto J0x24;
    }
    HUD.Canvas.DrawColor = SaveColor;
    return;
}

simulated function GetSVehicleDebug(out array<string> DebugInfo)
{
    DebugInfo[DebugInfo.Length] = "----Vehicle----: ";
    DebugInfo[DebugInfo.Length] = ((("Speed: " $ string(VSize(Velocity))) $ " Unreal -- ") $ string(VSize(Velocity) * 0.0426125)) $ " MPH";
    DebugInfo[DebugInfo.Length] = "RPM: " $ string(SVehicleSimCar(SimObj).EngineRPM);
    DebugInfo[DebugInfo.Length] = "Gear: " $ string(OutputGear);
    DebugInfo[DebugInfo.Length] = "Throttle: " $ string(OutputGas);
    return;
}

defaultproperties
{
    InertiaTensorMultiplier=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    bCanFlip=true
    // Reference: RB_StayUprightSetup'Default__SVehicle.MyStayUprightSetup'
    begin object name="MyStayUprightSetup" class=Class'RB_StayUprightSetup'
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__SVehicle.MyStayUprightConstraintInstance'
    begin object name="MyStayUprightConstraintInstance" class=Class'RB_ConstraintInstance'
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    MaxSpeed=2500.0000000
    UprightLiftStrength=225.0000000
    UprightTorqueStrength=50.0000000
    UprightTime=1.5000000
    CollisionAccel=800.0000000
    CollisionIntervalSecs=1.0000000
    SquealThreshold=250.0000000
    EngineStartOffsetSecs=2.0000000
    EngineStopOffsetSecs=1.0000000
    BaseOffset=(X=0.0000000,Y=0.0000000,Z=128.0000000)
    CamDist=512.0000000
    // Reference: SkeletalMeshComponent'Default__SVehicle.SVehicleMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="SVehicleMesh" class=Class'SkeletalMeshComponent'
        bUseSingleBodyPhysics=1
        bForceDiscardRootMotion=true
        BlockActors=true
        BlockNonZeroExtent=true
        bNotifyRigidBodyCollision=true
    end object
    Mesh=SVehicleMesh
    bNetInitialRotation=true
    bCollideWorld=false
    bEdShouldSnap=true
    // Reference: CylinderComponent'Default__SVehicle.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__Vehicle.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Physics=10
    TickGroup=2
    CollisionComponent=SVehicleMesh
}