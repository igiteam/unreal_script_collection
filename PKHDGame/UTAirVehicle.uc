class UTAirVehicle extends EvilVehicle_Base
    abstract
    config(Game)
    hidecategories(Navigation);

var bool bAutoLand;
var float PushForce;
var const localized string RadarLockMessage;
var float LastRadarLockWarnTime;

simulated event LockOnWarning(UDKProjectile IncomingMissile)
{
    SendLockOnMessage(1);
    //return;    
}

simulated function SetDriving(bool bNewDriving)
{
    // End:0x65
    if(((bAutoLand && !bNewDriving) && !bChassisTouchingGround) && Health > 0)
    {
        // End:0x62
        if(int(Role) == int(ROLE_Authority))
        {
            GotoState('AutoLanding');
        }        
    }
    else
    {
        super(Vehicle).SetDriving(bNewDriving);
    }
    //return;    
}

function bool RecommendLongRangedAttack()
{
    return true;
    //return ReturnValue;    
}

function bool Dodge(Actor.EDoubleClickDir DoubleClickMove)
{
    // End:0x48
    if(FRand() < 0.7000000)
    {
        VehicleMovingTime = WorldInfo.TimeSeconds + float(1);
        Rise = 1.0000000;
    }
    return false;
    //return ReturnValue;    
}

state AutoLanding
{
    simulated function SetDriving(bool bNewDriving)
    {
        // End:0x2F
        if(bNewDriving)
        {
            GotoState('Auto');
            global.SetDriving(bNewDriving);
        }
        //return;        
    }

    function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation)
    {
        // End:0x38
        if(global.Died(Killer, DamageType, HitLocation))
        {
            SetDriving(false);
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    function Tick(float DeltaTime)
    {
        local Actor HitActor;
        local Vector HitNormal, HitLocation;

        // End:0x29
        if(bChassisTouchingGround)
        {
            GotoState('Auto');
            SetDriving(false);            
        }
        else
        {
            HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0000000, 0.0000000, 2500.0000000), Location, false);
            // End:0xA7
            if(Velocity.Z < float(-1200))
            {
                OutputRise = 1.0000000;                
            }
            else
            {
                // End:0xC8
                if(HitActor == none)
                {
                    OutputRise = -1.0000000;                    
                }
                else
                {
                    // End:0x154
                    if(VSize(HitLocation - Location) < (float(-2) * Velocity.Z))
                    {
                        // End:0x142
                        if(Velocity.Z > float(-100))
                        {
                            OutputRise = 0.0000000;                            
                        }
                        else
                        {
                            OutputRise = 1.0000000;
                        }                        
                    }
                    else
                    {
                        // End:0x18E
                        if(Velocity.Z > float(-500))
                        {
                            OutputRise = -0.4000000;                            
                        }
                        else
                        {
                            OutputRise = -0.1000000;
                        }
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bAutoLand=true
    bMustBeUpright=false
    bDropDetailWhenDriving=true
    bFindGroundExit=false
    bReducedFallingCollisionDamage=true
    // Reference: DynamicLightEnvironmentComponent'Default__UTAirVehicle.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__EvilVehicle_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    IconCoords=(U=989.0000000,V=24.0000000,UL=43.0000000,VL=48.0000000)
    LookForwardDist=100.0000000
    bHomingTarget=true
    bNoZDampingInAir=false
    bEjectPassengersWhenFlipped=false
    bJostleWhileDriving=true
    bFloatWhenDriven=true
    bUseAlternatePaths=false
    UpsideDownDamagePerSec=0.0000000
    ContrailColorParameterName="ContrailColor"
    // Reference: RB_StayUprightSetup'Default__UTAirVehicle.MyStayUprightSetup'
    // Archetype: RB_StayUprightSetup'Default__EvilVehicle_Base.MyStayUprightSetup'
    begin object name="MyStayUprightSetup"
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__UTAirVehicle.MyStayUprightConstraintInstance'
    // Archetype: RB_ConstraintInstance'Default__EvilVehicle_Base.MyStayUprightConstraintInstance'
    begin object name="MyStayUprightConstraintInstance"
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    bTurnInPlace=true
    bFollowLookDir=true
    bCanFly=true
    bCanStrafe=true
    // Reference: SkeletalMeshComponent'Default__UTAirVehicle.SVehicleMesh'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'SVehicleMesh'
    // Archetype: SkeletalMeshComponent'Default__EvilVehicle_Base.SVehicleMesh'
    begin object name="SVehicleMesh"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__UTAirVehicle.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__UTAirVehicle.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__EvilVehicle_Base.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    CollisionComponent=SVehicleMesh
}