class AdvTurret_MG34_Base extends AdvTurret_Base
    abstract
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    // Reference: EvilCaptionComponent'Default__AdvTurret_MG34_Base.CaptionComp'
    begin object name=CaptionComp
    end object
    CaptionComponent=CaptionComp
    ViewYawLimit=9000
    bInvincible=true
    bEnableIK=true
    b3rdPersonView=true
    // Reference: DynamicLightEnvironmentComponent'Default__AdvTurret_MG34_Base.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: SVehicleSimBase'Default__AdvTurret_MG34_Base.SimObject'
    begin object name=SimObject
    end object
    SimObj=SimObject
    // Reference: RB_StayUprightSetup'Default__AdvTurret_MG34_Base.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__AdvTurret_MG34_Base.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    // Reference: SkeletalMeshComponent'Default__AdvTurret_MG34_Base.SVehicleMesh'
    begin object name=SVehicleMesh
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__AdvTurret_MG34_Base.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__AdvTurret_MG34_Base.CollisionCylinder'
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