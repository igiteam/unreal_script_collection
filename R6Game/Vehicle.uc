class Vehicle extends Pawn
    abstract
    native
    nativereplication
    config(Game)
    placeable
    hidecategories(lighting);

var Pawn Driver;
var repnotify bool bDriving;
var bool bDriverIsVisible;
var bool bAttachDriver;
var bool bTurnInPlace;
var bool bSeparateTurretFocus;
var bool bFollowLookDir;
var bool bHasHandbrake;
var bool bScriptedRise;
var() array<Vector> ExitPositions;
var float ExitRadius;
var Vector ExitOffset;
var() float Steering;
var() float Throttle;
var() float Rise;
var float DriverDamageMult;
var float MomentumMult;
var class<DamageType> CrushedDamageType;
var byte StuckCount;
var float ThrottleTime;
var float StuckTime;
var float OldSteering;
var const float AIMoveCheckTime;
var float VehicleMovingTime;
var float TurnTime;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        Driver, bDriving;
}

function PreBeginPlay()
{
    // End:0x2F
    if(!WorldInfo.Game.bAllowVehicles && !bDeleteMe)
    {
        Destroy();
        return;
    }
    PreBeginPlay();
    return;
}

simulated function NotifyTeamChanged()
{
    // End:0x28
    if((PlayerReplicationInfo != none) && Driver != none)
    {
        Driver.NotifyTeamChanged();
    }
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string DriverText;

    DisplayDebug(HUD, out_YL, out_YPos);
    HUD.Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    HUD.Canvas.__NFUN_465__((((("Steering " $ string(Steering)) $ " throttle ") $ string(Throttle)) $ " rise ") $ string(Rise));
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    HUD.Canvas.SetDrawColor(byte(255), 0, 0);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    // End:0x12B
    if(Driver == none)
    {
        DriverText = "NO DRIVER";        
    }
    else
    {
        DriverText = (("Driver Mesh " $ string(Driver.Mesh)) $ " hidden ") $ string(Driver.bHidden);
    }
    HUD.Canvas.__NFUN_465__(DriverText);
    out_YPos += out_YL;
    HUD.Canvas.SetPos(4.0000000, out_YPos);
    return;
}

function Suicide()
{
    // End:0x23
    if(Driver != none)
    {
        Driver.KilledBy(Driver);        
    }
    else
    {
        KilledBy(self);
    }
    return;
}

function DriverRadiusDamage(float DamageAmount, float DamageRadius, Controller EventInstigator, class<DamageType> DamageType, float Momentum, Vector HitLocation)
{
    // End:0x83
    if(((((EventInstigator != none) && Driver != none) && bAttachDriver) && !Driver.bCollideActors) && !Driver.bBlockActors)
    {
        Driver.TakeRadiusDamage(EventInstigator, DamageAmount, DamageAmount, DamageRadius, DamageType, Momentum, HitLocation, false);
    }
    return;
}

function PlayerChangedTeam()
{
    // End:0x23
    if(Driver != none)
    {
        Driver.KilledBy(Driver);        
    }
    else
    {
        PlayerChangedTeam();
    }
    return;
}

simulated function SetBaseEyeheight()
{
    BaseEyeHeight = default.BaseEyeHeight;
    EyeHeight = BaseEyeHeight;
    return;
}

function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x19
    if(!bDeleteMe)
    {
        AddDefaultInventory();
    }
    return;
}

function bool CheatWalk()
{
    return false;
    return;
}

function bool CheatGhost()
{
    return false;
    return;
}

function bool CheatFly()
{
    return false;
    return;
}

simulated function Destroyed()
{
    // End:0x12
    if(Driver != none)
    {
        Destroyed_HandleDriver();
    }
    Destroyed();
    return;
}

simulated function Destroyed_HandleDriver()
{
    local Pawn OldDriver;

    Driver.LastRenderTime = LastRenderTime;
    // End:0x55
    if(int(Role) == int(ROLE_Authority))
    {
        OldDriver = Driver;
        Driver = none;
        OldDriver.DrivenVehicle = none;
        OldDriver.Destroy();        
    }
    else
    {
        // End:0x7A
        if(Driver.DrivenVehicle == self)
        {
            Driver.StopDriving(self);
        }
    }
    return;
}

function bool CanEnterVehicle(Pawn P)
{
    // End:0x8F
    if((((((!AnySeatAvailable() || P.bIsCrouched) || P.DrivenVehicle != none) || P.Controller == none) || !P.Controller.bIsPlayer) || P.IsA('Vehicle')) || Health <= 0)
    {
        return false;
    }
    return WorldInfo.Game.CanEnterVehicle(self, P);
    return;
}

function bool AnySeatAvailable()
{
    return Driver == none;
    return;
}

function bool TryToDrive(Pawn P)
{
    // End:0x13
    if(!CanEnterVehicle(P))
    {
        return false;
    }
    DriverEnter(P);
    return true;
    return;
}

function DriverEnter(Pawn P)
{
    local Controller C;

    SetDriving(true);
    C = P.Controller;
    Driver = P;
    Driver.StartDriving(self);
    C.UnPossess();
    Driver.SetOwner(self);
    C.Possess(self, true);
    // End:0x8F
    if(PlayerController(C) != none)
    {
        PlayerController(C).GotoState(LandMovementState);
    }
    WorldInfo.Game.DriverEnteredVehicle(self, P);
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    PossessedBy(C, bVehicleTransition);
    EntryAnnouncement(C);
    NetPriority = 3.0000000;
    NetUpdateFrequency = 100.0000000;
    ThrottleTime = WorldInfo.TimeSeconds;
    return;
}

function EntryAnnouncement(Controller C)
{
    return;
}

simulated function AttachDriver(Pawn P)
{
    // End:0x0D
    if(!bAttachDriver)
    {
        return;
    }
    P.SetCollision(false, false);
    P.bCollideWorld = false;
    P.bHardAttach = true;
    P.SetPhysics(0);
    P.SetBase(self);
    // End:0x89
    if(!bDriverIsVisible)
    {
        P.bHidden = true;
        P.SetLocation(Location);
    }
    P.SetPhysics(0);
    return;
}

simulated function DetachDriver(Pawn P)
{
    return;
}

event bool ContinueOnFoot()
{
    return DriverLeave(false);
    return;
}

event bool DriverLeave(bool bForceLeave)
{
    local Controller C;
    local PlayerController PC;
    local Rotator ExitRotation;

    // End:0x33
    if(!bForceLeave && !WorldInfo.Game.CanLeaveVehicle(self, Driver))
    {
        return false;
    }
    // End:0x40
    if(Controller == none)
    {
        return false;
    }
    // End:0xDC
    if(Driver != none)
    {
        Driver.bHardAttach = false;
        Driver.bCollideWorld = true;
        Driver.SetCollision(true, true);
        // End:0xDC
        if(!PlaceExitingDriver())
        {
            // End:0xC8
            if(!bForceLeave)
            {
                Driver.bHardAttach = true;
                Driver.bCollideWorld = false;
                Driver.SetCollision(false, false);
                return false;                
            }
            else
            {
                Driver.SetLocation(GetTargetLocation());
            }
        }
    }
    ExitRotation.Yaw = Controller.Rotation.Yaw;
    SetDriving(false);
    C = Controller;
    // End:0x131
    if(C.RouteGoal == self)
    {
        C.RouteGoal = none;
    }
    // End:0x155
    if(C.MoveTarget == self)
    {
        C.MoveTarget = none;
    }
    Controller.UnPossess();
    // End:0x202
    if((Driver != none) && Driver.Health > 0)
    {
        Driver.SetRotation(ExitRotation);
        Driver.SetOwner(C);
        C.Possess(Driver, true);
        PC = PlayerController(C);
        // End:0x1F1
        if(PC != none)
        {
            PC.ClientSetViewTarget(Driver);
        }
        Driver.StopDriving(self);
    }
    // End:0x218
    if(C == Controller)
    {
        Controller = none;
    }
    WorldInfo.Game.DriverLeftVehicle(self, Driver);
    DriverLeft();
    return true;
    return;
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    Throttle = InForward;
    Steering = InStrafe;
    Rise = InUp;
    return;
}

simulated function DriverLeft()
{
    Driver = none;
    SetDriving(false);
    Throttle = 0.0000000;
    Steering = 0.0000000;
    Rise = 0.0000000;
    return;
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    local int I;
    local Vector tryPlace, Extent, HitLocation, HitNormal, ZOffset;

    // End:0x17
    if(ExitingDriver == none)
    {
        ExitingDriver = Driver;
    }
    // End:0x24
    if(ExitingDriver == none)
    {
        return false;
    }
    Extent = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
    Extent.Z = ExitingDriver.GetCollisionHeight();
    ZOffset = Extent.Z * vect(0.0000000, 0.0000000, 1.0000000);
    // End:0x190
    if(ExitPositions.Length > 0)
    {
        I = 0;
        J0x96:

        // End:0x18D [Loop If]
        if(I < ExitPositions.Length)
        {
            // End:0xDE
            if(ExitPositions[0].Z != float(0))
            {
                ZOffset = vect(0.0000000, 0.0000000, 1.0000000) * ExitPositions[0].Z;                
            }
            else
            {
                ZOffset = ExitingDriver.CylinderComponent.default.CollisionHeight * vect(0.0000000, 0.0000000, 2.0000000);
            }
            tryPlace = (Location + ((ExitPositions[I] - ZOffset) >> Rotation)) + ZOffset;
            // End:0x167
            if(Trace(HitLocation, HitNormal, tryPlace, Location + ZOffset, false, Extent) != none)
            {
                // [Explicit Continue]
                goto J0x183;
            }
            // End:0x181
            if(!ExitingDriver.SetLocation(tryPlace))
            {
                // [Explicit Continue]
                goto J0x183;
            }
            return true;
            J0x183:

            I++;
            // [Loop Continue]
            goto J0x96;
        }        
    }
    else
    {
        return FindAutoExit(ExitingDriver);
    }
    return false;
    return;
}

function bool FindAutoExit(Pawn ExitingDriver)
{
    local Vector FacingDir, CrossProduct;
    local float PlaceDist;

    FacingDir = Vector(Rotation);
    CrossProduct = Normal(FacingDir Cross vect(0.0000000, 0.0000000, 1.0000000));
    // End:0x53
    if(ExitRadius == float(0))
    {
        ExitRadius = (GetCollisionRadius()) + ExitingDriver.VehicleCheckRadius;
    }
    PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
    return (((TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * CrossProduct))) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * CrossProduct))) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * FacingDir))) || TryExitPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * FacingDir));
    return;
}

function bool TryExitPos(Pawn ExitingDriver, Vector ExitPos)
{
    local Vector Slice, HitLocation, HitNormal, StartLocation;
    local Actor HitActor;

    Slice = ExitingDriver.GetCollisionRadius() * vect(1.0000000, 1.0000000, 0.0000000);
    Slice.Z = 2.0000000;
    StartLocation = Location;
    // End:0x60
    if(Mesh != none)
    {
        StartLocation = Mesh.GetPosition();
    }
    // End:0x87
    if(Trace(HitLocation, HitNormal, ExitPos, StartLocation, false, Slice) != none)
    {
        return false;
    }
    HitActor = Trace(HitLocation, HitNormal, ExitPos - (ExitingDriver.GetCollisionHeight() * vect(0.0000000, 0.0000000, 3.0000000)), ExitPos, true, Slice);
    // End:0xE3
    if(HitActor == none)
    {
        HitLocation = ExitPos;
    }
    return ExitingDriver.SetLocation(HitLocation + ((ExitingDriver.GetCollisionHeight() + ExitingDriver.MaxStepHeight) * vect(0.0000000, 0.0000000, 1.0000000)));
    return;
}

function UnPossessed()
{
    NetPriority = default.NetPriority;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    NetUpdateFrequency = 8.0000000;
    UnPossessed();
    return;
}

function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    // End:0x13
    if(InGodMode())
    {
        Damage = 0;        
    }
    else
    {
        Damage *= DriverDamageMult;
    }
    return;
}

function TossWeapon(Vector TossVel)
{
    return;
}

function DriverDied()
{
    local Controller C;

    WorldInfo.Game.DiscardInventory(Driver);
    // End:0x2B
    if(Driver == none)
    {
        return;
    }
    C = Controller;
    Driver.StopDriving(self);
    Driver.Controller = C;
    Driver.DrivenVehicle = self;
    // End:0x78
    if(Controller == none)
    {
        return;
    }
    // End:0xD2
    if(PlayerController(Controller) != none)
    {
        Controller.SetLocation(Location);
        PlayerController(Controller).SetViewTarget(Driver);
        PlayerController(Controller).ClientSetViewTarget(Driver);
    }
    Controller.UnPossess();
    // End:0xF8
    if(Controller == C)
    {
        Controller = none;
    }
    C.Pawn = Driver;
    WorldInfo.Game.DriverLeftVehicle(self, Driver);
    DriverLeft();
    return;
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    // End:0x4A
    if(((RequestedBy != none) && RequestedBy.PlayerCamera != none) && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'ThirdPerson';
    return;
}

event UpdateEyeHeight(float DeltaTime)
{
    return;
}

event EncroachedBy(Actor other)
{
    return;
}

function bool EncroachingOn(Actor other)
{
    local Controller InstigatorController;

    // End:0x8E
    if((((((Pawn(other) == none) || other == Instigator) || Vehicle(other) != none) || int(other.Role) != int(ROLE_Authority)) || !other.bCollideActors && !other.bBlockActors) || VSize(Velocity) < float(10))
    {
        return false;
    }
    InstigatorController = Controller;
    // End:0xC5
    if((InstigatorController == none) && Instigator != none)
    {
        InstigatorController = Instigator.Controller;
    }
    other.TakeDamage(10000, 10000, InstigatorController, Location, other.Location, Velocity * other.Mass, CrushedDamageType);
    return false;
    return;
}

simulated function Vector GetEntryLocation()
{
    return Location;
    return;
}

simulated function SetDriving(bool B)
{
    // End:0x25
    if(bDriving != B)
    {
        bDriving = B;
        DrivingStatusChanged();
    }
    return;
}

function KillDriver()
{
    return;
}

simulated function DrivingStatusChanged()
{
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x19
    if(VarName == 'bDriving')
    {
        DrivingStatusChanged();        
    }
    else
    {
        ReplicatedEvent(VarName);
    }
    return;
}

defaultproperties
{
    bAttachDriver=true
    MomentumMult=1.0000000
    CrushedDamageType=Class'DmgType_Crushed'
    TurnTime=2.0000000
    bCanBeBaseForPawns=true
    bDontPossess=true
    LandMovementState="PlayerDriving"
    // Reference: CylinderComponent'Default__Vehicle.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Default__Pawn.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[0]=CollisionCylinder
}