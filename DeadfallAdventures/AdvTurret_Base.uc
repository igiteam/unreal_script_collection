class AdvTurret_Base extends EvilVehicle_Base
    native
    config(Game)
    hidecategories(Navigation);

var(Caption) export editinline EvilCaptionComponent CaptionComponent;
var() int ViewYawLimit;
var transient SkelControlLookAt Pivot_Latitude;
var transient SkelControlLookAt Pivot_Longitude;
var() bool bInvincible;
var() bool bEnableIK;
var() bool b3rdPersonView;

simulated function PostBeginPlay()
{
    local PlayerController PC;

    super.PostBeginPlay();
    // End:0xD3
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x8C
        if(!PC.bIsPlayer || PC.myHUD == none)
        {
            continue;            
        }
        EvilGFxHudWrapper(PC.myHUD).AddPostRenderedComponent(CaptionComponent);        
    }    
    //return;    
}

simulated event CacheAnimNodes()
{
    super(Pawn).CacheAnimNodes();
    Pivot_Latitude = SkelControlLookAt(Mesh.FindSkelControl('Pivot_Latitude'));
    Pivot_Longitude = SkelControlLookAt(Mesh.FindSkelControl('Pivot_Longitude'));
    //return;    
}

simulated function ClearAnimNodes()
{
    Pivot_Latitude = none;
    Pivot_Longitude = none;
    //return;    
}

function bool DriverEnter(Pawn P)
{
    // End:0x76
    if(((AdvRailCar_Base(Base) != none) && AdvRailCar_Base(Base).bForceManTurret) && !EvilRailCar_Base(Base).bClampedBaseEnabled)
    {
        return false;
    }
    // End:0xAD
    if(super.DriverEnter(P))
    {
        CaptionComponent.Hide();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DriverLeft()
{
    CaptionComponent.Show();
    super.DriverLeft();
    //return;    
}

simulated function ProcessViewRotation(float DeltaTime, out Rotator out_ViewRotation, out Rotator out_DeltaRot)
{
    // End:0x70
    if(EvilRailCar_Base(Base) != none)
    {
        out_ViewRotation.Yaw += EvilRailCar_Base(Base).RotDelta.Yaw;
    }
    super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
    out_ViewRotation.Yaw = ClampRotAxisFromBase(out_ViewRotation.Yaw, Rotation.Yaw, ViewYawLimit);
    //return;    
}

simulated function SitDriver(EvilPawn UTP, int SeatIndex)
{
    // End:0x80
    if(Seats[SeatIndex].SeatBone != 'None')
    {
        UTP.SetBase(self,, Mesh, Seats[SeatIndex].SeatBone);        
    }
    else
    {
        UTP.SetBase(self);
    }
    SetMovementEffect(SeatIndex, true, UTP);
    // End:0x13C
    if(UTP.Mesh.PhysicsAssetInstance != none)
    {
        UTP.Mesh.PhysicsAssetInstance.SetAllBodiesFixed(true);
    }
    UTP.Mesh.bUpdateKinematicBonesFromAnimation = false;
    UTP.Mesh.PhysicsWeight = 0.0000000;
    // End:0x43F
    if(Seats[SeatIndex].bSeatVisible)
    {
        // End:0x284
        if((UTP.Mesh != none) && Mesh != none)
        {
            UTP.Mesh.SetShadowParent(Mesh);
            UTP.Mesh.SetLightEnvironment(LightEnvironment);
        }
        UTP.SetMeshVisibility(b3rdPersonView);
        // End:0x382
        if(Mesh.GetSocketByName(Seats[SeatIndex].SeatBone) == none)
        {
            UTP.SetRelativeLocation(Seats[SeatIndex].SeatOffset);
            UTP.SetRelativeRotation(Seats[SeatIndex].SeatRotation);
        }
        UTP.Mesh.SetCullDistance(5000.0000000);
        UTP.Mesh.SetTranslation(vect(0.0000000, 0.0000000, 1.0000000) * UTP.BaseTranslationOffset);
        UTP.SetHidden(false);        
    }
    else
    {
        UTP.Mesh.SetHidden(true);
    }
    //return;    
}

event bool DriverLeave(bool bForceLeave)
{
    local Pawn P;
    local Controller C;
    local bool Retval;

    // End:0x2B
    if(!bForceLeave && EvilRailCar_Base(Base) != none)
    {
        return false;
    }
    P = Driver;
    C = Controller;
    Retval = super.DriverLeave(bForceLeave);
    // End:0x138
    if((P.Health <= 0) && C != none)
    {
        C.Possess(P, true);
        // End:0x118
        if(PlayerController(C) != none)
        {
            PlayerController(C).ClientSetViewTarget(P);
        }
        P.StopDriving(self);
    }
    return Retval;
    //return ReturnValue;    
}

simulated event PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    //return;    
}

simulated function byte GetTeamNum()
{
    return ((Driver != none) ? Driver.GetTeamNum() : super(UDKVehicle).GetTeamNum());
    //return ReturnValue;    
}

simulated function TeamInfo GetTeam()
{
    return ((Driver != none) ? Driver.GetTeam() : super(Pawn).GetTeam());
    //return ReturnValue;    
}

function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    // End:0x0F
    if(bInvincible)
    {
        return false;
    }
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    // End:0x11
    if(bInvincible)
    {
        return;
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

simulated event Rotator GetDriverIdealRotation()
{
    // End:0x6D
    if(((Seats.Length < 1) || Seats[0].TurretControllers.Length < 1) || Seats[0].TurretControllers[0] != none)
    {
        return SeatWeaponRotation(0,, true);
    }
    return MakeRotator(0, 0, 0);
    //return ReturnValue;    
}

simulated function UpdateDriver(float DeltaTime)
{
    local EvilPawn P;

    P = EvilPawn(Driver);
    // End:0xAC
    if(((((P == none) || P.Mesh == none) || P.bDeleteMe) || P.bPlayedDeath) || !bDriving)
    {
        return;
    }
    // End:0xDA
    if(Mesh != none)
    {
        Mesh.ForceSkelUpdate();
    }
    P.Velocity = vect(0.0000000, 0.0000000, 1.0000000) * P.Velocity.Z;
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    UpdateTurret(DeltaTime);
    // End:0x48
    if(Driver != none)
    {
        UpdateDriver(DeltaTime);
    }
    //return;    
}

simulated function WeaponRotationChanged(int SeatIndex)
{
    // End:0x33
    if((Pivot_Latitude == none) && Pivot_Longitude == none)
    {
        super.WeaponRotationChanged(SeatIndex);
    }
    //return;    
}

simulated function UpdateTurret(float DeltaTime)
{
    local Rotator AimDir;
    local Vector PivotLatLoc, AimTargetWorld, AimTargetLoc;

    AimDir = SeatWeaponRotation(0,, true);
    PivotLatLoc = Mesh.GetBoneLocation(Seats[0].GunPivotPoints[0]);
    AimTargetWorld = PivotLatLoc + (Vector(AimDir) * float(16384));
    AimTargetLoc = (AimTargetWorld - Location) << Rotation;
    // End:0xEB
    if(Pivot_Latitude != none)
    {
        Pivot_Latitude.TargetLocation = AimTargetLoc;
    }
    // End:0x122
    if(Pivot_Longitude != none)
    {
        Pivot_Longitude.TargetLocation = AimTargetLoc;
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvTurret_Base.CaptionComp'
    begin object name=CaptionComp class=Class'EvilGame.EvilCaptionComponent'
    end object
    CaptionComponent=CaptionComp
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTurret_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: SVehicleSimBase'Default__AdvTurret_Base.SimObject'
    begin object name=SimObject class=Class'Engine.SVehicleSimBase'
    end object
    SimObj=SimObject
    // Reference: RB_StayUprightSetup'Default__AdvTurret_Base.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__AdvTurret_Base.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: SkeletalMeshComponent'Default__AdvTurret_Base.SVehicleMesh'
    begin object name=SVehicleMesh
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvTurret_Base.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__AdvTurret_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=SimObject
    CollisionComponent=SVehicleMesh
}