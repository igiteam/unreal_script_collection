class TurokVehicleTurretBaseNative extends TurokVehicle
    native
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: TurokVehicleSoundController'Default__TurokVehicleTurretBaseNative.TurokVehicleSoundControllerComponent'
    begin object name=TurokVehicleSoundControllerComponent
    end object
    mSoundController=TurokVehicleSoundControllerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokVehicleTurretBaseNative.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_StayUprightSetup'Default__TurokVehicleTurretBaseNative.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__TurokVehicleTurretBaseNative.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: SkeletalMeshComponent'Default__TurokVehicleTurretBaseNative.SVehicleMesh'
    begin object name=SVehicleMesh
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokVehicleTurretBaseNative.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__TurokVehicleTurretBaseNative.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    Components[3]=TurokVehicleSoundControllerComponent
    CollisionComponent=SVehicleMesh
}