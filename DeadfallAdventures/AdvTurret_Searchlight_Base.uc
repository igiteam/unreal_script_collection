class AdvTurret_Searchlight_Base extends AdvTurret_Base
    config(Game)
    hidecategories(Navigation);

var() AdvInventoryItem_Torch MyTorch;

function InitializeSeats()
{
    super(EvilVehicle_Base).InitializeSeats();
    MyTorch = AdvInventoryItem_Torch(Seats[0].SeatPawn.InvManager.CreateInventory(Class'AdvInventoryItem_Torch'));
    MyTorch.AttachToWeapon(EvilWeap_Base(Seats[0].Gun));
    //return;    
}

function bool DriverEnter(Pawn P)
{
    // End:0x38
    if(super.DriverEnter(P))
    {
        MyTorch.TurnFlashlightOn();
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool DriverLeave(bool bForceLeave)
{
    // End:0x39
    if(super.DriverLeave(bForceLeave))
    {
        MyTorch.TurnFlashlightOff();
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    // End:0x32
    if(MyTorch != none)
    {
        MyTorch.Destroy();
        MyTorch = none;
    }
    super(EvilVehicle_Base).Destroyed();
    //return;    
}

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvTurret_Searchlight_Base.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    ViewYawLimit=9000
    bInvincible=true
    bEnableIK=true
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTurret_Searchlight_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: SVehicleSimBase'Default__AdvTurret_Searchlight_Base.SimObject'
    begin object name=SimObject
    end object
    SimObj=SimObject
    // Reference: RB_StayUprightSetup'Default__AdvTurret_Searchlight_Base.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__AdvTurret_Searchlight_Base.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: SkeletalMeshComponent'Default__AdvTurret_Searchlight_Base.SVehicleMesh'
    begin object name=SVehicleMesh
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvTurret_Searchlight_Base.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__AdvTurret_Searchlight_Base.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    ViewPitchMin=-5000.0000000
    ViewPitchMax=5000.0000000
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    Components[3]=CaptionComp
    Components[4]=SimObject
    CollisionComponent=SVehicleMesh
}