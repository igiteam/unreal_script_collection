class SkyWeaponPawn extends SkyVehicleBase
    native
    nativereplication
    config(Game);

var repnotify SkyVehicleWeapon MyVehicleWeapon;
var repnotify SkyGameVehicle MyVehicle;
var repnotify int MySeatIndex;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        MySeatIndex, MyVehicle, 
        MyVehicleWeapon;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    super(SVehicle).DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("[WeaponPawn]");
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText("Owner:" @ string(Owner));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText(("Vehicle:" @ string(MyVehicleWeapon)) @ string(MyVehicle));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    Canvas.DrawText(("Rotation/Location:" @ string(Rotation)) @ string(Location));
    out_YPos += out_YL;
    // End:0x1A1
    if(MyVehicle != none)
    {
        MyVehicle.DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xC7
    if(((VarName == 'MyVehicle') || VarName == 'MyVehicleWeapon') || VarName == 'MySeatIndex')
    {
        // End:0xC4
        if(((MySeatIndex > 0) && MyVehicle != none) && MySeatIndex < MyVehicle.Seats.Length)
        {
            MyVehicle.Seats[MySeatIndex].SeatPawn = self;
            MyVehicle.Seats[MySeatIndex].Gun = MyVehicleWeapon;
            SetBase(MyVehicle);
        }        
    }
    else
    {
        super(Vehicle).ReplicatedEvent(VarName);
    }
    //return;    
}

exec function FixedView(string VisibleMeshes)
{
    //return;    
}

// Export USkyWeaponPawn::execSetFiringMode(FFrame&, void* const)
native simulated function SetFiringMode(byte FiringModeNum);

// Export USkyWeaponPawn::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount(Weapon Who, byte FireModeNum);

simulated function ClearFlashCount(Weapon Who)
{
    // End:0x0D
    if(MyVehicle == none)
    {
        return;
    }
    MyVehicle.ClearFlashCount(Who);
    //return;    
}

// Export USkyWeaponPawn::execSetFlashLocation(FFrame&, void* const)
native function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc);

simulated function ClearFlashLocation(Weapon Who)
{
    // End:0x0D
    if(MyVehicle == none)
    {
        return;
    }
    MyVehicle.ClearFlashLocation(Who);
    //return;    
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    super(Vehicle).PossessedBy(C, bVehicleTransition);
    MyVehicleWeapon.ClientWeaponSet(false);
    SetBaseEyeheight();
    EyeHeight = BaseEyeHeight;
    //return;    
}

simulated function DriverLeft()
{
    super(Vehicle).DriverLeft();
    MyVehicle.PassengerLeave(MySeatIndex);
    //return;    
}

function AdjacentSeat(int Direction, Controller C)
{
    local int NewSeat;

    NewSeat = MyVehicle.GetSeatIndexForController(C) + Direction;
    // End:0x4D
    if(NewSeat < 0)
    {
        NewSeat = MyVehicle.Seats.Length - 1;        
    }
    else
    {
        // End:0x6E
        if(NewSeat == MyVehicle.Seats.Length)
        {
            NewSeat = 0;
        }
    }
    ServerChangeSeat(NewSeat);
    //return;    
}

reliable server function ServerChangeSeat(int RequestedSeat)
{
    // End:0x29
    if(MyVehicle != none)
    {
        MyVehicle.ChangeSeat(Controller, RequestedSeat);
    }
    //return;    
}

function KillDriver()
{
    local Pawn OldDriver;

    // End:0x1A
    if((Driver == none) || MyVehicle == none)
    {
        return;
    }
    // End:0x11B
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xE8
        if(MyVehicle.bEjectKilledBodies)
        {
            // End:0x7E
            if(!bDriverIsVisible && PlaceExitingDriver())
            {
                Driver.StopDriving(self);
                Driver.DrivenVehicle = self;
            }
            Driver.TearOffMomentum = MyVehicle.Velocity * 0.2500000;
            Driver.SetOwner(none);
            Driver.Died(none, MyVehicle.RanOverDamageType, Driver.Location);            
        }
        else
        {
            OldDriver = Driver;
            Driver = none;
            OldDriver.DrivenVehicle = none;
            OldDriver.Destroy();
        }        
    }
    else
    {
        // End:0x145
        if(Driver.DrivenVehicle == self)
        {
            Driver.StopDriving(self);
        }
    }
    //return;    
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    // End:0x17
    if(ExitingDriver == none)
    {
        ExitingDriver = Driver;
    }
    // End:0x3C
    if(MyVehicle != none)
    {
        return MyVehicle.PlaceExitingDriver(ExitingDriver);
    }
    return false;
    //return ReturnValue;    
}

function DropToGround()
{
    //return;    
}

event AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
{
    //return;    
}

function JumpOffPawn()
{
    //return;    
}

singular event BaseChange()
{
    //return;    
}

function SetMovementPhysics()
{
    //return;    
}

function bool DoJump(bool bUpdating)
{
    return false;
    //return ReturnValue;    
}

simulated function float GetCollisionRadius()
{
    // End:0x23
    if(MyVehicle != none)
    {
        return MyVehicle.GetCollisionRadius();        
    }
    else
    {
        return super(Pawn).GetCollisionRadius();
    }
    //return ReturnValue;    
}

simulated function SetBaseEyeheight()
{
    BaseEyeHeight = MyVehicle.Seats[MySeatIndex].CameraEyeHeight;
    //return;    
}

simulated function AttachDriver(Pawn P)
{
    local SkyPawnBase UTP;

    UTP = SkyPawnBase(P);
    // End:0xB6
    if(UTP != none)
    {
        UTP.SetWeaponAttachmentVisibility(false);
        // End:0xB6
        if(MyVehicle.bAttachDriver)
        {
            UTP.SetCollision(false, false);
            UTP.bCollideWorld = false;
            UTP.SetHardAttach(true);
            UTP.SetLocation(Location);
            UTP.SetPhysics(0);
            MyVehicle.SitDriver(UTP, MySeatIndex);
        }
    }
    //return;    
}

simulated event HoldGameObject(SkyCarriedObject GameObj)
{
    // End:0x24
    if(MyVehicle != none)
    {
        MyVehicle.HoldGameObject(GameObj);
    }
    //return;    
}

// Export USkyWeaponPawn::execFaceRotation(FFrame&, void* const)
native function FaceRotation(Rotator NewRotation, float DeltaTime);
