class SPSwoopPoint extends Info
    native;

struct native SP_SwoopGoToInfo
{
    var Vector EntryLocation;
    var Vector EntryDirection;
    var Vector ExitLocation;
    var Vector ExitDirection;
    var SPSwoopPoint SwoopPointActor;

    structdefaultproperties
    {
        EntryLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        EntryDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ExitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ExitDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SwoopPointActor=none
    }
};

struct native SP_SwoopNav
{
    var array<Vector> m_diveStart;
    var array<Vector> m_climbFinish;
    var Vector m_diveDirection;
    var Vector m_divePerpendicular;

    structdefaultproperties
    {
        m_diveStart=none
        m_climbFinish=none
        m_diveDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_divePerpendicular=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SP_SwoopSetup
{
    var() float DiveDist;
    var() float DiveHeight;
    var() float WidthExtension;

    structdefaultproperties
    {
        DiveDist=0.0000000
        DiveHeight=0.0000000
        WidthExtension=0.0000000
    }
};

struct native SP_SwoopEntryPoint
{
    var Vector Location;
    var Vector Direction;
    var Vector Perpendicular;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Perpendicular=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var array<SP_SwoopGoToInfo> SwoopEndPoints;
var SP_SwoopNav m_swoopNav[2];
var export editinline SPSwoopPointRenderComponent debugRenderComponent;
var(TargetArea) Vector targetAreaSize;
var(TargetArea) Vector targetAreaPositionOffset;
var(TargetArea) Vector swoopAreaSize[2];
var(TargetArea) SP_SwoopSetup swoopEntryExit[2];
var(TargetArea) array<Route> routesValidFor;

// Export USPSwoopPoint::execDoesEnclosePoint(FFrame&, void* const)
native function bool DoesEnclosePoint(Vector testPoint);
