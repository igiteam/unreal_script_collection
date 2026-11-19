class UTWeaponPawn extends UDKWeaponPawn
    config(Game)
    hidecategories(Navigation);

function name GetVehicleDrivingStatName()
{
    local name VehicleStatName;

    VehicleStatName = name(string('DRIVING_') $ string(MyVehicle.Class.Name));
    return VehicleStatName;
    //return ReturnValue;    
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
    // End:0x29F
    if(MyVehicle != none)
    {
        MyVehicle.DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x12C
    if(((VarName == 'MyVehicle') || VarName == 'MyVehicleWeapon') || VarName == 'MySeatIndex')
    {
        // End:0x129
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

simulated function bool CalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    local Vector out_CamStart;

    // End:0xAA
    if(((MyVehicle != none) && MySeatIndex > 0) && MySeatIndex < MyVehicle.Seats.Length)
    {
        EvilVehicle_Base(MyVehicle).VehicleCalcCamera(fDeltaTime, MySeatIndex, out_CamLoc, out_CamRot, out_CamStart);
        return true;        
    }
    else
    {
        return super(SVehicle).CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
    }
    //return ReturnValue;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    local int I, MaxDelta;
    local float MaxDeltaDegrees;

    // End:0x2F2
    if(WorldInfo.bUseConsoleInput && MyVehicle != none)
    {
        I = 0;
        J0x3E:

        // End:0x105 [Loop If]
        if(I < MyVehicle.Seats[MySeatIndex].TurretControllers.Length)
        {
            MaxDeltaDegrees = FMax(MaxDeltaDegrees, MyVehicle.Seats[MySeatIndex].TurretControllers[I].LagDegreesPerSecond);
            I++;
            // [Loop Continue]
            goto J0x3E;
        }
        // End:0x2F2
        if(MaxDeltaDegrees > 0.0000000)
        {
            MaxDelta = int((MaxDeltaDegrees * 182.0444000) * DeltaTime);
            out_DeltaRot.Pitch = ((out_DeltaRot.Pitch >= 0) ? Min(out_DeltaRot.Pitch, MaxDelta) : Max(out_DeltaRot.Pitch, -MaxDelta));
            out_DeltaRot.Yaw = ((out_DeltaRot.Yaw >= 0) ? Min(out_DeltaRot.Yaw, MaxDelta) : Max(out_DeltaRot.Yaw, -MaxDelta));
            out_DeltaRot.Roll = ((out_DeltaRot.Roll >= 0) ? Min(out_DeltaRot.Roll, MaxDelta) : Max(out_DeltaRot.Roll, -MaxDelta));
        }
    }
    super(Pawn).ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    //return;    
}

simulated function SetFiringMode(Weapon Weap, byte FiringModeNum)
{
    // End:0x8A
    if(((MyVehicle != none) && MySeatIndex > 0) && MySeatIndex < MyVehicle.Seats.Length)
    {
        EvilVehicle_Base(MyVehicle).SeatFiringMode(MySeatIndex, FiringModeNum, false);
    }
    //return;    
}

simulated function IncrementFlashCount(Weapon Who, byte FireModeNum)
{
    // End:0x11
    if(MyVehicle == none)
    {
        return;
    }
    MyVehicle.IncrementFlashCount(Who, FireModeNum);
    //return;    
}

simulated function ClearFlashCount(Weapon Who)
{
    // End:0x11
    if(MyVehicle == none)
    {
        return;
    }
    MyVehicle.ClearFlashCount(Who);
    //return;    
}

simulated function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc)
{
    // End:0x11
    if(MyVehicle == none)
    {
        return;
    }
    MyVehicle.SetFlashLocation(Who, FireModeNum, NewLoc);
    //return;    
}

simulated function ClearFlashLocation(Weapon Who)
{
    // End:0x11
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

function DriverLeft()
{
    local EvilPlayerReplicationInfo DriverPRI;

    DriverPRI = EvilPlayerReplicationInfo(Driver.PlayerReplicationInfo);
    // End:0xC5
    if(((DriverPRI != none) && DriverPRI.bHasFlag) && UDKPawn(Driver) != none)
    {
        UDKPawn(Driver).HoldGameObject(DriverPRI.GetFlag());
    }
    super(UDKVehicleBase).DriverLeft();
    EvilVehicle_Base(MyVehicle).PassengerLeave(MySeatIndex);
    //return;    
}

reliable server function ServerAdjacentSeat(int Direction, Controller C)
{
    MyVehicle.ServerAdjacentSeat(Direction, C);
    //return;    
}

reliable server function ServerChangeSeat(int RequestedSeat)
{
    // End:0x49
    if(MyVehicle != none)
    {
        EvilVehicle_Base(MyVehicle).ChangeSeat(Controller, RequestedSeat);
    }
    //return;    
}

simulated function AdjustCameraScale(bool bIn)
{
    // End:0x4A
    if(EvilVehicle_Base(MyVehicle) != none)
    {
        EvilVehicle_Base(MyVehicle).AdjustCameraScale(bIn);
    }
    //return;    
}

function bool PlaceExitingDriver(optional Pawn ExitingDriver)
{
    // End:0x23
    if(ExitingDriver == none)
    {
        ExitingDriver = Driver;
    }
    // End:0x5B
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

function AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo)
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
    // End:0x66
    if((MyVehicle != none) && EvilVehicle_Base(MyVehicle).bAcceptTurretJump)
    {
        return MyVehicle.DoJump(bUpdating);
    }
    return false;
    //return ReturnValue;    
}

simulated function float GetCollisionRadius()
{
    // End:0x32
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
    local EvilPawn UTP;

    UTP = EvilPawn(P);
    // End:0x13E
    if(UTP != none)
    {
        UTP.SetWeaponAttachmentVisibility(false);
        // End:0x13E
        if(MyVehicle.bAttachDriver)
        {
            UTP.SetCollision(false, false);
            UTP.bCollideWorld = false;
            UTP.SetHardAttach(true);
            UTP.SetLocation(Location);
            UTP.SetPhysics(0);
            EvilVehicle_Base(MyVehicle).SitDriver(UTP, MySeatIndex);
        }
    }
    //return;    
}

simulated event HoldGameObject(UDKCarriedObject GameObj)
{
    // End:0x37
    if(MyVehicle != none)
    {
        MyVehicle.HoldGameObject(GameObj);
    }
    //return;    
}

simulated function FaceRotation(Rotator NewRotation, float DeltaTime)
{
    SetRotation(NewRotation);
    //return;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    local PlayerController OldPC;

    OldPC = PlayerController(Controller);
    // End:0xAD
    if(super(SVehicle).Died(Killer, DamageType, HitLocation))
    {
        GotoState('Dying');
        HandleDeadVehicleDriver();
        // End:0xA5
        if((OldPC != none) && MyVehicle != none)
        {
            OldPC.SetViewTarget(MyVehicle);
        }
        Destroy();
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool TooCloseToAttack(Actor Other)
{
    local int NeededPitch;

    // End:0x6E
    if(((MyVehicle == none) || Weapon == none) || VSize(MyVehicle.Location - Other.Location) > 2500.0000000)
    {
        return false;
    }
    NeededPitch = Rotator(Other.GetTargetLocation(self) - Weapon.GetPhysicalFireStartLoc()).Pitch & 65535;
    return EvilVehicle_Base(MyVehicle).CheckTurretPitchLimit(NeededPitch, MySeatIndex);
    //return ReturnValue;    
}

function DisplayHud(UTHUD HUD, Canvas Canvas, Vector2D HudPOS, optional int SIndex)
{
    // End:0x5C
    if(MyVehicle != none)
    {
        EvilVehicle_Base(MyVehicle).DisplayHud(HUD, Canvas, HudPOS, MySeatIndex);
    }
    //return;    
}

simulated function ApplyWeaponEffects(int OverlayFlags, optional int SeatIndex)
{
    // End:0x41
    if(MyVehicle != none)
    {
        MyVehicle.ApplyWeaponEffects(OverlayFlags, MySeatIndex);
    }
    //return;    
}

defaultproperties
{
    MySeatIndex=-1
    // Reference: RB_StayUprightSetup'Default__UTWeaponPawn.MyStayUprightSetup'
    // Archetype: RB_StayUprightSetup'UDKBase.Default__UDKWeaponPawn.MyStayUprightSetup'
    begin object name="MyStayUprightSetup"
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__UTWeaponPawn.MyStayUprightConstraintInstance'
    // Archetype: RB_ConstraintInstance'UDKBase.Default__UDKWeaponPawn.MyStayUprightConstraintInstance'
    begin object name="MyStayUprightConstraintInstance"
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    bTurnInPlace=true
    bFollowLookDir=true
    bStationary=true
    BaseEyeHeight=180.0000000
    EyeHeight=180.0000000
    // Reference: SkeletalMeshComponent'Default__UTWeaponPawn.SVehicleMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SVehicleMesh'
    // Archetype: SkeletalMeshComponent'UDKBase.Default__UDKWeaponPawn.SVehicleMesh'
    begin object name="SVehicleMesh"
        ReplacementPrimitive=none
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__UTWeaponPawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'UDKBase.Default__UDKWeaponPawn.CollisionCylinder'
    begin object name="CollisionCylinder"
        CollisionHeight=0.0000000
        CollisionRadius=0.0000000
        ReplacementPrimitive=none
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'EvilInventoryManager'
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Physics=EPhysics.PHYS_None
    bOnlyRelevantToOwner=true
    bIgnoreBaseRotation=true
    bCollideActors=false
    bCollideWorld=false
    bProjTarget=false
    CollisionComponent=SVehicleMesh
}