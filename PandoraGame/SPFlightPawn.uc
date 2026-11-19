class SPFlightPawn extends SPPawn
    abstract
    native
    config(Game);

enum EFlightPathingType
{
    egptDefault,                    // 0
    egptDive,                       // 1
    EFlightPathingType_MAX          // 2
};

enum EFlightOrienation
{
    eFlyFaceDirection,              // 0
    eFlyLevel,                      // 1
    EFlightOrienation_MAX           // 2
};

enum EFlightRollMode
{
    eFlyRollModeNormal,             // 0
    eFlyRollModeNoRoll,             // 1
    eFlyRollModeAggressive,         // 2
    EFlightRollMode_MAX             // 3
};

struct native FlightPhysicsVars
{
    var Vector Velocity;
    var Vector Acceleration;
    var Vector Location;
    var Quat Orientation;
    var Vector OldVelocity;
    var Vector OldLocation;
    var Quat OldOrientation;

    structdefaultproperties
    {
        Velocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Acceleration=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Orientation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        OldVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OldLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        OldOrientation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
    }
};

struct native FlightPhysicsParams
{
    var bool bChanged;
    var SPPawn Owner;
    var float Mass;
    var float topSpeed;
    var float timeToTopSpeed;
    var float directionalStability;
    var Vector angularInertia;
    var Vector timeForFullRotation;
    var float timeToReduceSpeedByHalf;
    var float timeToReduceAngularSpeedByHalf;
    var SPFlightPawn.EFlightRollMode rollMode;
    var float angularFriction;
    var float oneDivMass;
    var float maxAccel;
    var float oneDivMaxAccel;
    var float thrust;
    var float frictionConst;
    var float frictionReducer;
    var Vector maxAVelocity;
    var Vector angularThrust;
    var Vector driftCounterVelocity;
    var Matrix WorldTransform;
    var Vector Velocity;
    var Vector AngularVelocity;
    var float DesiredSpeed;
    var Vector angularMomentum;
    var Vector deltahpr;
    var float deltaThrust;
    var Vector appliedForce;
    var Vector desiredDirection;
    var Vector desiredUp;
    var Vector thrustDirection;
    var SPFlightPawn.EFlightOrienation FlightOrientation;

    structdefaultproperties
    {
        bChanged=true
        Owner=none
        Mass=100.0000000
        topSpeed=480.0000000
        timeToTopSpeed=2.0000000
        directionalStability=16.0000000
        angularInertia=(X=80.0000000,Y=100.0000000,Z=50.0000000)
        timeForFullRotation=(X=1.0000000,Y=1.0000000,Z=0.5000000)
        timeToReduceSpeedByHalf=0.0500000
        timeToReduceAngularSpeedByHalf=0.5000000
        rollMode=eFlyRollModeNormal
        angularFriction=2.0000000
        oneDivMass=0.0000000
        maxAccel=0.0000000
        oneDivMaxAccel=0.0000000
        thrust=0.0000000
        frictionConst=0.0000000
        frictionReducer=0.0000000
        maxAVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        angularThrust=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        driftCounterVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        WorldTransform=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        Velocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        AngularVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DesiredSpeed=0.0000000
        angularMomentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        deltahpr=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        deltaThrust=0.0000000
        appliedForce=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        desiredDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        desiredUp=(X=0.0000000,Y=0.0000000,Z=1.0000000)
        thrustDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        FlightOrientation=eFlyLevel
    }
};

var FlightPhysicsParams FPhys;
var() Box m_inFlightBounds;
var export editinline SPDirectFlightPlanner m_flightPlanner;
var(AI) bool m_bIsWindTunnelDebugOn;
var bool m_isLanding;
var bool m_isTakingoff;
var Vector m_vWindTunnelOffset;
var() Vector m_vWindTunnelGridSize;
var() int m_iWindTunnelDivisions;
var Vector m_vMoveDeltaDebug;
var transient SPFlightGuidance m_flightPathGuidance;
var Vector m_landingStart;
var Vector m_landingPoint;
var Vector m_takeOffTarget;
var FlightPhysicsVars m_normalFlightPhysVars;
var FlightPhysicsVars m_onRailFlightPhysVars;
var FlightPhysicsVars m_FlightPhysVars;
var float m_physFlyingBlend;
var SPDFPathUpdateInfo m_flightPathUpdateInfo;
var transient float m_lastFlightGuidanceTime;
var transient float m_lastMoveTime;
var transient SeqAct_SpSetAirGroundMode.AirGroundMode m_AirGroundMode;

event DBG_Msg(string Str)
{
    local PlayerController PC;

    // End:0x7A
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x79
        if(PC.Pawn != none)
        {
            // End:0x79
            if(PC.myHUD != none)
            {
                PC.myHUD.Message(PC.PlayerReplicationInfo, Str, 'None');
            }
        }        
    }    
    //return;    
}

event FlightStartTakeoff(int vertexUID)
{
    local SPFlightManager Manager;

    Manager = Class'SPFlightManager'.static.Get();
    m_takeOffTarget = Manager.GetVertexPosition(vertexUID);
    m_isLanding = false;
    m_isTakingoff = true;
    SetPhysics(7);
    //return;    
}

event FlightStartLanding(int vertexUID, Vector landingPos)
{
    local SPFlightManager Manager;

    Manager = Class'SPFlightManager'.static.Get();
    m_landingStart = Manager.GetVertexPosition(vertexUID);
    m_landingPoint = landingPos;
    m_isLanding = true;
    m_isTakingoff = false;
    SetPhysics(7);
    //return;    
}

event UsePhysWalking()
{
    //return;    
}

event UsePhysFlying()
{
    //return;    
}

function SetNormalizedFlightSpeed(float Speed)
{
    FPhys.deltaThrust = Speed;
    //return;    
}

function SetRollMode(SPFlightPawn.EFlightRollMode Mode)
{
    FPhys.rollMode = Mode;
    //return;    
}

event BlowUp()
{
    SetHidden(true);
    TakeDamageAndProcEffects(float(Health + 1000), none, Location, Velocity, Class'SPDamageTypeExplosionAny');
    //return;    
}

simulated function bool IsPhysFlying()
{
    // End:0x15
    if(int(m_AirGroundMode) == int(0))
    {
        return true;        
    }
    else
    {
        return super.IsPhysFlying();
    }
    //return ReturnValue;    
}

function SwoopConnected(SPPawn EnemyPawn)
{
    local SPFlightAIController flightController;

    flightController = SPFlightAIController(Controller);
    // End:0x34
    if(flightController != none)
    {
        flightController.SwoopConnected(EnemyPawn);
    }
    //return;    
}

simulated function BlendFlyingAnimations(SPAnimGenericFunctionBlendNode Node)
{
    BlendFlyingAnimationsNative(Node);
    //return;    
}

// Export USPFlightPawn::execBlendFlyingAnimationsNative(FFrame&, void* const)
native function BlendFlyingAnimationsNative(SPAnimGenericFunctionBlendNode Node);
